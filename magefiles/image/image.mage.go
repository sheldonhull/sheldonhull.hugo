package image

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/pterm/pterm"
)

const (
	maxWidth = 1920
	quality  = 85
)

// selectdDirectory returns a directory path, and provides a filtered interactive list to select from.

func selectDirectory() (string, error) {
	var validDirs []string
	err := filepath.Walk("content", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() && filepath.Base(path) == "images" {
			parentDir := filepath.Dir(path)
			if _, err := os.Stat(filepath.Join(parentDir, "index.md")); err == nil {
				validDirs = append(validDirs, parentDir)
			}
		}
		return nil
	})
	if err != nil {
		return "", err
	}
	// TODO: adjust later to quote each string

	result, err := pterm.DefaultInteractiveSelect.
		WithDefaultOption("cancel").
		WithOptions(validDirs).
		WithFilter(true).
		WithDefaultText("select directory").Show()
	if err != nil {
		return "", fmt.Errorf("unable to process selection command: %w", err)
	}
	if result == "cancel" {
		return "", fmt.Errorf("no directory selected")
	}
	return result, nil
}

// Convert converts a directoryof images to optimized, resized, jpegs, primarily for usage with page bundles.
func Convert() error {
	// Use gum to select the directory through shell command
	dir, err := selectDirectory()
	if err != nil {
		return err
	}
	if dir == "cancel" {
		return fmt.Errorf("no directory selected")
	}
	pterm.DefaultSection.Printf("Converting images to JPEG...")

	return filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() {
			return nil
		}

		ext := strings.ToLower(filepath.Ext(path))

		if ext == ".gitkeep" || ext == ".md" {
			return nil // Skip invalid files
		}

		baseNameNoExt := strings.TrimSuffix(filepath.Base(path), ext)
		jpegFile := filepath.Join(dir, baseNameNoExt+".jpg")
		cmd := exec.Command("convert",
			fmt.Sprintf("JPEG:%s", path),
			"-resize", fmt.Sprintf("%dx%d>", maxWidth, maxWidth),
			"-strip",
			"-interlace", "Plane",
			"-quality", fmt.Sprint(quality),
			"-colorspace", "sRGB",
			jpegFile,
		)

		out, err := cmd.CombinedOutput()
		if err != nil {
			pterm.Warning.Printfln("fail to convert '%s': %v", path, err)
			pterm.Warning.Println(string(out))
		} else {

			pterm.Success.Printf("convert '%s' to JPEG.", path)
			// Optionally, delete the original file
			if err := os.Remove(path); err != nil {
				pterm.Error.Printfln("Failed to delete original file '%s': %v", path, err)
				return err
			}
			pterm.Info.Printfln("deleted original file '%s'.", path)

		}
		return nil
	})
}
