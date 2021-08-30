//+build mage

package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"

	// mg contains helpful utility functions, like Deps.
	"github.com/gobeam/stringy"
	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
	"github.com/manifoldco/promptui"
	"github.com/pelletier/go-toml/v2"
	"github.com/pterm/pterm"
	"github.com/sheldonhull/magetools/ci"
	"github.com/sheldonhull/magetools/tooling"
)

// codeConfigFile is the file that contains the code config.
const (
	codeConfigFile      = "100daysofcode.toml"
	permissionReadWrite = 0666
)

// CodeConfig contains the values for 100 days of code progress.
type CodeConfig struct {
	Language string `toml:"language"`
	Counter  int    `toml:"counter"`
	Round    int    `toml:"round"`
}

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

// bumpCounter increments the counter in the code config.
func bumpCounter() error {
	cfg, err := loadCodeConfig()
	if err != nil {
		return err
	}
	originalCount := cfg.Counter
	cfg.Counter++
	c, err := toml.Marshal(&cfg)
	if err != nil {
		pterm.Error.Printf("Failed to marshal code config file: %v\n", err)

		return err
	}

	if err := ioutil.WriteFile(codeConfigFile, c, os.ModeDevice); err != nil {
		pterm.Error.Printf("Failed to write code config file: %v\n", err)

		return err
	}

	pterm.Success.Printf("Bumped 100DaysOfCode: [%d] to [%d]\n", originalCount, cfg.Counter)

	return nil
}

// loadCodeConfig loads the code config file.
func loadCodeConfig() (*CodeConfig, error) {
	codeCfg := CodeConfig{}
	b, err := ioutil.ReadFile(codeConfigFile)
	if err != nil {
		pterm.Error.Printf("Error reading code config file: %v\n", err)
		// not the best practice, should just exit, but not sure how to do with Mage yet, so just passing stuff back up
		return nil, err
	}
	err = toml.Unmarshal(b, &codeCfg)
	if err != nil {
		pterm.Error.Printf("Failed to marshal code config file: %v\n", err)

		// not the best practice, should just exit, but not sure how to do with Mage yet, so just passing stuff back up
		return nil, err
	}

	pterm.Info.Printf("Code Config: %+v\n", codeCfg)

	return &codeCfg, nil

	// codeCfg.Counter++
	// c, err := toml.Marshal(&codeCfg)
	// if err != nil {
	// 	pterm.Error.Printf("Failed to marshal code config file: %v\n", err)

	// 	return err
	// }

	// if err := ioutil.WriteFile(codeConfigFile, c, os.ModeDevice); err != nil {
	// 	pterm.Error.Printf("Failed to write code config file: %v\n", err)

	// 	return err
	// }
	// }
}

// calculatePostDir calculates the post directory based on the post title and the date.
func calculatePostDir(title string, kind string) (string, error) {
	if kind == "code" { //nolint:goconst
		cfg, err := loadCodeConfig()
		if err != nil {
			return "", err
		}
		cfg.Counter++
		title = fmt.Sprintf("%s-R%d-day-%02d", cfg.Language, cfg.Round, cfg.Counter)
	} else {
		// since I only lowercase the normal titles, and not 100 days of code, conditionally lower here
		title = strings.ToLower(title)
	}

	year, month, day := time.Now().Date()
	dateString := fmt.Sprintf("%d-%02d-%02d", year, month, day)
	str := stringy.New(title)
	kebabTitle := str.KebabCase().Get()
	slugTitle := strings.Join([]string{dateString, kebabTitle}, "-") ///stringy.ToKebabCase(title)

	pterm.Success.Printf("Slugify Title: %s\n", slugTitle)
	filepath := filepath.Join(contentDir, fmt.Sprintf("%d", year), slugTitle+".md")
	pterm.Success.Printf("calculatePostDir: %s\n", slugTitle)

	return filepath, nil
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

// replaceCodeVariables replaces the variables in the generated file based on values in the code config toml file.
func replaceCodeVariables(file string) error {
	cfg, err := loadCodeConfig()
	if err != nil {
		return err
	}

	input, err := ioutil.ReadFile(file)
	if err != nil {
		pterm.Error.Printf("ReadFile %v\n", err)

		return err
	}

	output := bytes.Replace(input, []byte("VAR_LANGUAGE"), []byte(cfg.Language), -1)
	output = bytes.Replace(output, []byte("VAR_DAYCOUNTER"), []byte((fmt.Sprintf("%d", cfg.Counter))), -1)
	output = bytes.Replace(output, []byte("VAR_ROUND"), []byte((fmt.Sprintf("%d", cfg.Round))), -1)

	if err := ioutil.WriteFile(file, output, permissionReadWrite); err != nil {
		pterm.Error.Printf("WriteFile %v\n", err)

		return err
	}
	pterm.Success.Printf("Replaced variables in %s\n", file)
	return nil
}

// NewPost creates a new post in the Hugo format.
func (New) Post() error {
	var title string

	prompt := promptui.Select{
		Label: "Select Type of Post j/k to navigate",
		Items: []string{"100DaysOfCode", "microblog", "blog"},
	}
	_, result, err := prompt.Run()
	if err != nil {
		pterm.Error.Printf("Prompt failed %v\n", err)

		return err
	}
	pterm.Success.Printf("New Post: [%s]", result)

	// the archetype in archtytpes directory to use
	var kind string

	switch result {
	case "100DaysOfCode":
		kind = "code"
		title = ""
	default:
		kind = result
	}

	if kind != "code" {
		promptTitle := promptui.Prompt{
			Label: "Enter Title",
		}
		title, err = promptTitle.Run()
	}
	if err != nil {
		pterm.Error.Printf("Prompt failed %v\n", err)

		return err
	}
	fileName, err := calculatePostDir(title, kind)
	if err != nil {
		pterm.Error.Printf("calculatePostDir %v\n", err)

		return err
	}
	if err := sh.RunV("hugo", "new", fileName, "--kind", kind); err != nil {
		return err
	}
	if kind == "code" {
		bumpCounter()
		if err := replaceCodeVariables(fileName); err != nil {
			return err
		}
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

// Serve site using Caddy.
func Serve() error {
	pterm.DefaultSection.Printf("Serve site")
	if err := sh.RunV("caddy", "run", "--config", "Caddyfile"); err != nil {
		pterm.Error.Printf("caddy run %q", err)
		return err
	}
	return nil
}
