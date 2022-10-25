//go:build mage
// +build mage

package main

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	// mg contains helpful utility functions, like Deps.
	"github.com/bitfield/script"
	"github.com/gobeam/stringy"
	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
	"github.com/manifoldco/promptui"
	toml "github.com/pelletier/go-toml/v2"
	"github.com/pterm/pterm"
	"github.com/sheldonhull/magetools/ci"

	"github.com/sheldonhull/magetools/pkg/req"
	"github.com/sheldonhull/magetools/tooling"
)

// nodeCommand defaults to yarn, but if npm only is being used then this can be replaced with npm.
const nodeCommand = "yarn"

var (
	yarn   = sh.RunCmd(nodeCommand) //nolint:gochecknoglobals // build helper ok to be global
	gitcmd = sh.RunCmd("git")       //nolint:gochecknoglobals // build helper ok to be global
)

// codeConfigFile is the file that contains the code config.
const (
	codeConfigFile        = "100daysofcode.toml"
	permissionReadWrite   = 0o666
	hugoPublicDestination = "public"
	// datadir contains datafiles that are used for generating pages, webmentions json exports, and more.
	datadir = "data"
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

// Git namespace groups all the Git actions.
type Git mg.Namespace

// Ci contains specific trimmed actions for running in CI system such as netlify.
type Ci mg.Namespace

// Js contains yarn oriented tasks.
type Js mg.Namespace

// hugo alias is a shortcut for calling hugo binary
// var hugobin = sh.RunV("hugo") // go is a keyword :(

// buildUrl is the localhost default to allow. This is better than localhost when working with macOS as localhost doesn't work the same.
const buildUrl = `http://127.0.0.1:1313`

const contentDir = "content/posts"

// tools is a list of Go tools to install to avoid polluting global modules.
var toolList = []string{ //nolint:gochecknoglobals // ok to be global for tooling setup
	"github.com/nekr0z/webmention.io-backup@latest",
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

	if err := os.WriteFile(codeConfigFile, c, os.ModeDevice); err != nil {
		pterm.Error.Printf("Failed to write code config file: %v\n", err)

		return err
	}

	pterm.Success.Printf("Bumped 100DaysOfCode: [%d] to [%d]\n", originalCount, cfg.Counter)

	return nil
}

// loadCodeConfig loads the code config file.
func loadCodeConfig() (*CodeConfig, error) {
	codeCfg := CodeConfig{}
	b, err := os.ReadFile(codeConfigFile)
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

	// if err := os.WriteFile(codeConfigFile, c, os.ModeDevice); err != nil {
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
	hugoargs := []string{"serve", "-b", url, "--verbose", "--enableGitInfo", "-d", "_site", "--buildFuture", "--buildDrafts", "--gc", "--cleanDestinationDir", "--disableFastRender"}
	// "--disableFastRender"
	pterm.Info.Printf("hugo: %v", hugoargs)
	pterm.Info.Println("Open Posts with", url+"/posts")
	if err := sh.RunV("hugo", hugoargs...); err != nil {
		return err
	}

	return nil
}

// Run Hugo Build.
func (Hugo) Build() error {
	pterm.DefaultSection.Printf("Hugo Build")
	url := getBuildUrl()
	hugoargs := []string{"-b", url, "--quiet", "--enableGitInfo", "-d", "_site", "--buildFuture", "--buildDrafts", "--destination", hugoPublicDestination}
	// "--disableFastRender"
	pterm.Info.Printf("hugo: %v\n", hugoargs)
	pterm.Info.Println("Open Posts with", url+"/posts")
	if err := sh.RunV("hugo", hugoargs...); err != nil {
		return err
	}

	return nil
}

// Output relevant detail on build environment.
func hugoEnvInfo() {
	pterm.DefaultSection.Printf("Hugo Env Info")
	primary := pterm.NewStyle(pterm.FgLightWhite, pterm.BgGray, pterm.Bold)
	tbl := pterm.TableData{
		{"Setting", os.Getenv("Value")},
		{"HUGO_ENABLEGITINFO", os.Getenv("HUGO_ENABLEGITINFO")},
		{"HUGO_BASEURL", os.Getenv("HUGO_BASEURL")},
		{"HUGO_MINIFY", os.Getenv("HUGO_MINIFY")},
		{"HUGO_DESTINATION", os.Getenv("HUGO_DESTINATION")},
	}
	if err := pterm.DefaultTable.WithHasHeader().
		WithBoxed(true).
		WithHeaderStyle(primary).
		WithData(tbl).Render(); err != nil {
		pterm.Error.Printf("pterm.DefaultTable.WithHasHeader of variable information failed. Continuing...\n%v", err)
	}
}

// Run Hugo Build for Public
func (Hugo) BuildPublic() error {
	hugoEnvInfo()
	pterm.DefaultSection.Printf("Hugo Build for Public")
	url := getBuildUrl()
	hugoargs := []string{"-b", url, "--quiet", "--enableGitInfo", "-d", os.Getenv("HUGO_DESTINATION"), "--destination", hugoPublicDestination, "-b", url}
	pterm.Info.Printf("hugo: %v\n", hugoargs)
	pterm.Info.Println("Open Posts with", url+"/posts")
	if err := sh.RunV("hugo", hugoargs...); err != nil {
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

	input, err := os.ReadFile(file)
	if err != nil {
		pterm.Error.Printf("ReadFile %v\n", err)

		return err
	}

	output := bytes.Replace(input, []byte("VAR_LANGUAGE"), []byte(cfg.Language), -1)
	output = bytes.Replace(output, []byte("VAR_DAYCOUNTER"), []byte((fmt.Sprintf("%d", cfg.Counter))), -1)
	output = bytes.Replace(output, []byte("VAR_ROUND"), []byte((fmt.Sprintf("%d", cfg.Round))), -1)

	if err := os.WriteFile(file, output, permissionReadWrite); err != nil {
		pterm.Error.Printf("WriteFile %v\n", err)

		return err
	}
	pterm.Success.Printf("Replaced variables in %s\n", file)
	return nil
}

// Post creates a new post in the Hugo format.
func Post() error {
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
func Webmentions() error {
	pterm.DefaultSection.Printf("Webmentions refresh")
	if os.Getenv("WEBMENTION_IO_TOKEN") == "" {
		pterm.Error.Println("WEBMENTION_IO_TOKEN is required to refresh webmentions and was not detected")
		return fmt.Errorf("WEBMENTION_IO_TOKEN is required to refresh webmentions and was not detected")
	}
	webMentionFile := filepath.Join(datadir, "webmentions.json")

	binary, err := req.ResolveBinaryByInstall("webmention.io-backup", "github.com/nekr0z/webmention.io-backup@latest")
	if err != nil {
		return err
	}
	return sh.RunV(binary, "-f", webMentionFile, "-t", os.Getenv("WEBMENTION_IO_TOKEN"))
}

func Algolia() error {
	return sh.RunV("yarn", "run", "algolia")
}

func Init() error {
	if ci.IsCI() {
		pterm.DisableStyling()
		pterm.DefaultSection.Println("[CI SYSTEM] Initialize setup")
	}
	pterm.DefaultSection.Println("Init()")
	actioncounter := 4

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
	ver, err := sh.Output("hugo", "version")
	if err != nil {
		return err
	}
	pterm.Info.Printfln("hugo version: %s", ver)

	p.Title = "hugo mod tidy"
	if err := tooling.SpinnerStdOut("hugo", []string{"mod", "tidy"}, nil); err != nil {
		pterm.Error.Printf("hugo mod tidy %q", err)

		return err
	}
	pterm.Success.Println("✅ hugo mod tidy")
	p.Increment()

	if !ci.IsCI() {
		pterm.DefaultSection.Printfln("Local Dev Tools")
		mg.Deps(
			(InstallTrunk),
		)
	}

	if err := (Js{}.Init()); err != nil {
		return err
	}
	p.Increment()

	return nil
}

func (Js) Init() error {
	if err := sh.Run("npm", "install", "--global", "yarn", "--force"); err != nil {
		return err
	}
	// if err := sh.Run("yarn", "set", "version", "berry"); err != nil {
	// 	return err
	// }
	if err := yarn("install", "--silent", "--immutable"); err != nil {
		pterm.Error.Println(err)
		return err
	}
	pterm.Success.Println("✅ yarn install")

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

// 🧹 Fmt runs code formatting for project mostly against Go templates.
func (Hugo) Fmt() error {
	pterm.DefaultSection.Printf("prettier go-templates")
	if err := sh.RunV("yarn", "prettier",
		"--write",
		"--loglevel",
		"log",
		"--no-error-on-unmatched-pattern",
		"--write \"{.html,.htm}\"",
		"."); err != nil {
		pterm.Error.Printf("prettier go-templates %q", err)
		return err
	}
	return nil
}

// Devcontainer runs devcontainer commands for codespaces or local dev builds.
type Devcontainer mg.Namespace

// Build the devcontainer.
func (Devcontainer) Build() error {
	pterm.Info.Println("build devcontainer")
	c := []string{
		"build", "--pull", "--rm", "-f", ".devcontainer/Dockerfile", "-t", "sheldonhullhugo:latest", ".devcontainer",
	}
	if err := sh.Run("docker", c...); err != nil {
		pterm.Error.Println(err)
		return err
	}
	pterm.Success.Println("DevContainer")
	return nil
}

// Build builds a docker container for the hugo project.
func Build() error {
	if err := sh.Run("docker", "buildx", "build", "-f", ".devcontainer/Dockerfile", "-t", "sheldonhullhugo:latest", ".devcontainer"); err != nil {
		pterm.Error.Printfln("🚫 docker devcontainer %q", err)
		return err
	}
	if err := sh.Run("docker", "run", "--rm", "-it", "sheldonhullhugo:latest"); err != nil {
		pterm.Error.Printfln("🚫 docker run %q", err)
		return err
	}
	return nil
}

// // 💾 Commit will run git-cz to guide through commit prompt with -A.
// func (Git) Commit() error {
// 	pterm.DefaultSection.Printf("git commit")
// 	if err := gitcmd("add", "-A"); err != nil {
// 		pterm.Error.Printf("git commit %q", err)
// 		return err
// 	}
// 	if err := sh.RunV("yarn", "commit"); err != nil {
// 		pterm.Error.Printf("yarn commit %q", err)
// 		return err
// 	}
// 	pterm.Success.Println("✅ git commit")
// 	return nil
// }

func (Hugo) Clean() error {
	pterm.DefaultSection.Println("hugo mod clean")

	if err := sh.Run("hugo", "mod", "clean"); err != nil {
		pterm.Error.Printf("hugo mod clean %q", err)
		return err
	}
	pterm.Success.Println("✅ hugo mod clean")
	return nil
}

// InstallTrunk installs trunk.io tooling.
func InstallTrunk() error {
	_, err := script.Exec("curl https://get.trunk.io -fsSL").Exec("bash -s -- -y").Stdout()
	if err != nil {
		return err
	}
	return nil
}
