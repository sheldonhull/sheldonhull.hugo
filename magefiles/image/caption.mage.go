package image

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/pterm/pterm"
)

// Caption handles the captioning of images.
func Caption() error {
	dir, err := selectDirectory()
	if err != nil {
		return err
	}
	if dir == "cancel" {
		return fmt.Errorf("no directory selected")
	}

	return filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() || !isImageFile(path) {
			return nil // Skip non-image files and directories
		}

		metaFilePath := getMetaFilePath(path)
		if _, err := os.Stat(metaFilePath); os.IsNotExist(err) {
			if err := openFileForCaptioning(path); err != nil {
				return err
			}
			caption, err := promptForCaption(path)
			if err != nil {
				return err
			}
			if err := saveCaption(metaFilePath, caption); err != nil {
				return err
			}
		}

		return nil
	})
}

func isImageFile(filePath string) bool {
	ext := strings.ToLower(filepath.Ext(filePath))
	return ext == ".jpg" || ext == ".jpeg" || ext == ".png"
}

func getMetaFilePath(imageFilePath string) string {
	return strings.TrimSuffix(imageFilePath, filepath.Ext(imageFilePath)) + ".meta"
}

func openFileForCaptioning(filePath string) error {
	cmd := exec.Command("code", filePath)
	return cmd.Start()
}

func promptForCaption(filePath string) (string, error) {
	pterm.DefaultSection.Printf("Enter caption for %s", filePath)
	return pterm.DefaultInteractiveTextInput.WithMultiLine(true).Show()
}

func saveCaption(filePath, caption string) error {
	return os.WriteFile(filePath, []byte(caption), 0o644)
}
