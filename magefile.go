//+build mage

package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	// mg contains helpful utility functions, like Deps.
	"github.com/gobeam/stringy"
	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
	"github.com/manifoldco/promptui"
	"github.com/pterm/pterm"
	"github.com/sheldonhull/magetools/ci"
	"github.com/sheldonhull/magetools/tooling"
)

// mage:import tools
// "github.com/sheldonhull/magetools/tools"

// Default target to run when none is specified
// If not set, running mage will list available targets

// Hugo namespace groups the hugo commands.
type Hugo mg.Namespace

// New namespace groups the new post generatation commands.
type New mg.Namespace

// hugo alias is a shortcut for calling hugo binary
// var hugobin = sh.RunV("hugo") // go is a keyword :(

// buildUrl is the localhost default to allow. This is better than localhost when working with macOS as localhost doesn't work the same.
const buildUrl = `http://127.0.0.1:1313`

const contentDir = "content/posts"

// tools is a list of Go tools to install to avoid polluting global modules.
var toolList = []string{ //nolint:gochecknoglobals // ok to be global for tooling setup
	"github.com/goreleaser/goreleaser@v0.174.1",
	"golang.org/x/tools/cmd/goimports@master",
	"github.com/sqs/goreturns@master",
	"github.com/golangci/golangci-lint/cmd/golangci-lint@master",
	"github.com/dustinkirkland/golang-petname/cmd/petname@master",
	"github.com/nekr0z/webmention.io-backup@latest",
	"github.com/dnb-org/debug@latest",
	"github.com/sunt-programator/CodeIT@latest",
}

// 🧹 Cleanup artifacts.
func Cleanup() error {
	pterm.DefaultSection.Printf("Cleaning...")
	if err := os.RemoveAll("_site"); err != nil {
		pterm.Warning.Printf("remove _site failed: [%v]\n", err)

		return err
	}
	if err := os.RemoveAll("public"); err != nil {
		pterm.Warning.Printf("remove public failed: [%v]\n", err)

		return err
	}

	return nil
}

// calculatePostDir calculates the post directory based on the post title and the date.
func calculatePostDir(title string) string {
	year, month, day := time.Now().Date()
	dateString := fmt.Sprintf("%d-%02d-%02d", year, month, day)
	str := stringy.New(title)
	kebabTitle := str.KebabCase().ToLower()
	slugTitle := strings.Join([]string{dateString, kebabTitle}, "-") ///stringy.ToKebabCase(title)

	pterm.Success.Printf("Slugify Title: %s", slugTitle)
	filepath := filepath.Join(contentDir, fmt.Sprintf("%d", year), slugTitle+".md")
	pterm.Success.Printf("calculatePostDir: %s", slugTitle)

	return filepath
}

// getBuildUrl checks for DEPLOY_PRIME_URL from Netlify, otherwise returns the localhost url.
func getBuildUrl() string {
	u := os.Getenv("DEPLOY_PRIME_URL")
	if u == "" {
		pterm.Info.Println("DEPLOY_PRIME_URL not set")
		pterm.Info.Println("buildUrl ", buildUrl)

		return buildUrl
	}
	pterm.Info.Println("DEPLOY_PRIME_URL set to", u)

	return u
}

// Run Hugo Serve.
func (Hugo) Serve() error {
	pterm.DefaultSection.Printf("Hugo Serve")
	url := getBuildUrl()
	// hugobin("serve", "-b ", getBuildUrl(), "--verbose", "--enableGitInfo", "-d _site", "--buildFuture", "--buildDrafts", "--gc", "--disableFastRender"); err != nil {
	pterm.Info.Println("hugo", "serve", "-b", url, "--verbose", "--enableGitInfo", "-d", "_site", "--buildFuture", "--buildDrafts", "--gc", "--disableFastRender")
	pterm.Info.Println("Open Posts with", url+"/posts")
	if err := sh.RunV("hugo", "serve", "-b", url, "--verbose", "--enableGitInfo", "-d", "_site", "--buildFuture", "--buildDrafts", "--gc", "--disableFastRender"); err != nil {
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

// WebMentions refreshes the local webmentions json data file.
func WebMentions() error {
	return nil
}

func Init() error {
	if ci.IsCI() {
		pterm.DisableStyling()
	}
	pterm.DefaultSection.Printf("Initialize setup")
	actioncounter := 3

	p, _ := pterm.DefaultProgressbar.
		WithTotal(actioncounter).
		WithTitle("Init()").
		WithShowElapsedTime(true).
		WithRemoveWhenDone(true).
		Start()
	defer func() {
		p.Title = "init complete"
		_, _ = p.Stop()
		pterm.Success.Printf("init complete: %s\n", p.GetElapsedTime().String())
	}()

	// Tools(tools) // what great naming this is.
	// if err := tools.InstallTools(toolList); err != nil {
	// 	pterm.Error.Printf("InstallTools %q", err)
	// 	return err
	// }
	p.Title = "hugo mod clean"
	if err := sh.Run("hugo", "mod", "clean"); err != nil {
		pterm.Error.Printf("hugo mod clean %q", err)

		return err
	}
	pterm.Success.Println("✅ hugo mod clean")
	p.Increment()

	p.Title = "hugo mod tidy"
	if err := sh.Run("hugo", "mod", "tidy"); err != nil {
		pterm.Error.Printf("hugo mod tidy %q", err)

		return err
	}
	pterm.Success.Println("✅ hugo mod tidy")
	p.Increment()

	p.Title = "install webmentions"
	if err := tooling.InstallTools([]string{"github.com/nekr0z/webmention.io-backup@master"}); err != nil {
		pterm.Error.Printf("install webmentions tool %q", err)

		return err
	}
	pterm.Success.Println("✅ install webmentions")
	p.Increment()

	return nil
}

// // RunLinkCheck runs checks against local host to ensure links are valid.
// func RunLinkCheck() error {
// 	linkchecker, err := exec.LookPath("linkchecker")
// 	if err != nil {
// 		pterm.Error.Printf("linkchecker not found %q", err)
// 		return err
// 	}
// }
