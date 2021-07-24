// +build mage

package main

import (
	"github.com/magefile/mage/mg" // mg contains helpful utility functions, like Deps
	"github.com/magefile/mage/sh"
	"github.com/manifoldco/promptui"
	"github.com/pterm/pterm"
	"os"
	"os/exec"
	"time"

	"github.com/gobeam/stringy" // stringy is a string manipulation package for kebab and other case
	"path/filepath"
	"strings"
)

// Default target to run when none is specified
// If not set, running mage will list available targets

// Hugo namespace groups the hugo commands.
type Hugo mg.Namespace

// New namespace groups the new post generatation commands.
type New mg.Namespace

// hugo alias is a shortcut for calling hugo binary
//var hugobin = sh.RunV("hugo") // go is a keyword :(

// buildUrl is the localhost default to allow. This is better than localhost when working with macOS as localhost doesn't work the same.
const buildUrl = "http://127.0.0.1:1313"

const contentDir = "content"

// A build step that requires additional params, or platform specific steps for example
func Build() error {
	mg.Deps(InstallDeps)
	pterm.DefaultSection.Printf("Building...")
	cmd := exec.Command("go", "build", "-o", "MyApp", ".")
	return cmd.Run()
}

// A custom install step if you need your bin someplace other than go/bin
func Install() error {
	mg.Deps(Build)
	pterm.DefaultSection.Printf("Installing...")
	return os.Rename("./MyApp", "/usr/bin/MyApp")
}

// Manage your deps, or running package managers.
func InstallDeps() error {
	pterm.DefaultSection.Printf("Installing Deps...")
	cmd := exec.Command("go", "get", "github.com/stretchr/piglatin")
	return cmd.Run()
}

// Clean up after yourself
func Clean() {
	pterm.DefaultSection.Printf("Cleaning...")
	os.RemoveAll("MyApp")
}

func isCI() bool {
	return os.Getenv("CI") != ""
}

// getBuildUrl checks for DEPLOY_PRIME_URL from Netlify, otherwise returns the localhost url.
func getBuildUrl() string {
	u := os.Getenv("DEPLOY_PRIME_URL")
	if u == "" {
		return buildUrl
	}
	return u

}

// calculatePostDir calculates the post directory based on the post title and the date.
func calculatePostDir(title string) string {
	year, month, day := time.Now().Date()
	str := stringy.New(title)
	kebabTitle := str.KebabCase().ToLower()
	slugTitle := strings.Join(string(year), string(month), string(day),kebabTitle, "-") ///stringy.ToKebabCase(title)

	pterm.Success.Printf("Slugify Title: %s", slugTitle)
	filepath := filepath.Join(contentDir, string(year), slugTitle)
	pterm.Success.Printf("calculatePostDir: %s", slugTitle)
	return filepath
}


// Run Hugo Serve
func (Hugo) Serve() error {
	pterm.DefaultSection.Printf("Hugo Serve")
	//hugobin("serve", "-b ", getBuildUrl(), "--verbose", "--enableGitInfo", "-d _site", "--buildFuture", "--buildDrafts", "--gc", "--disableFastRender"); err != nil {
	if err := sh.RunV("hugo", "serve", "-b ", getBuildUrl(), "--verbose", "--enableGitInfo", "-d _site", "--buildFuture", "--buildDrafts", "--gc", "--disableFastRender"); err != nil {
		return err
	}
	return nil
}

// NewPost creates a new post in the Hugo format.
func (New) Post() error {
	prompt := promptui.Select{
		Label: "Select Type of Post j/k to navigate",
		Items: []string{"100DaysOfCode", "microblog", "blog"},
	}
	_, result, err := prompt.Run()
	if err != nil {
		pterm.Success.Printf("Prompt failed %v\n", err)
		return err
	}
	pterm.Success.Printf("New Post: [%s]", result)
	promptTitle := promptui.Prompt{
		Label: "Enter Title",
	}
	title, err := promptTitle.Run()
	if err != nil {
		pterm.Error.Printf("Prompt failed %v\n", err)
		return err
	}
	// the archetype in archtytpes directory to use
	var kind string

	switch result {
	case "100DaysOfCode":
		kind = "code"
	default:
		kind = result
	}
	fileName := calculatePostDir(title)
	if err := sh.RunV("hugo", "new", fileName, "--kind", kind); err != nil {
		return err
	}
	return nil
}
