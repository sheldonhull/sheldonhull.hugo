---
title: go
date: 2020-10-30T00:00:00.000Z
toc: true
summary: >-
  A cheatsheet to update with what I pickup with Go that I likely need to
  reference again as a new gopher.
slug: go
permalink: /docs/go
comments: true
tags:

- development
- golang
typora-root-url: ../../static
typora-copy-images-to:  ../../static/images

---

## Top Reference Material

Here's the reference material I use to help guide me on basic style, design, and general idiomatic Go practices.

| Resource                                                                                                            | Description                                                                 |
| ------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [Go Style Guide](https://golang.org/doc/style.html)                                                                 | A guide to writing Go code.                                                 |
| [Uber Go Styleguide](https://github.com/uber-go/guide/blob/master/style.md)                                         | A thorough stylistic guide (opinionated, but great explanations on why)     |
| [Practical Go - Dave Cheney](https://dave.cheney.net/practical-go/presentations/qcon-china.html#_identifier_length) | A great practical guide from a well-respected authority in the Go community |

## Starter Template

I saved this as a snippet for vscode to get up and running quickly with something better than the defaults for handling `func main` isolation. I've been working on modifying this a bit as I don't really like using args, but am trying not to overcomplicate things as a new gopher.

I tend to like better flag parsing than using args, but it's still a better pattern to get functions isolated from main to easily test.

The gist that I've taken from this and discussions in the community is ensure that `main` is where program termination is dedicated instead of handling this in your functions. This isolation of logic from main ensures you can more easily setup your tests as well, since `func main()` isn't testable.

```go
package main

// package template from:
import (
    "errors"
    "fmt"
    "io"
    "os"
)

const (
    // exitFail is the exit code if the program
    // fails.
    exitFail = 1
)

func main() {
    if err := run(os.Args, os.Stdout); err != nil {
        fmt.Fprintf(os.Stderr, "%s\n", err)
        os.Exit(exitFail)
    }
}

func run(args []string, stdout io.Writer) error {
    if len(args) == 0 {
        return errors.New("no arguments")
    }
    for _, value := range args[1:] {
        fmt.Fprintf(stdout, "Running %s", value)
    }
    return nil
}
```

## Using Go for Task Running & Automation

My preferred tool at this time is Mage.

Mage replaces the need for Bash or PowerShell scripts in your repo for core automation tasks, and provides the benefits of Go (cross-platform, error handling paradigm, readability, performance, etc).

### Getting Started With Mage

#### Use Go

- Run `go install github.com/magefile/mage@latest`
- Run `go install github.com/iwittkau/mage-select@latest`
- asdf: `asdf plugin-add mage && asdf install mage latest && asdf local mage latest`

#### Intialize a New Project

- [Scripts-To-Rule-Them-All-Go](github.com/sheldonhull/scripts-to-rule-them-all-go): A repo I've setup as quick start template for a Mage enabled repository with linting and core structure already in place.
- [Magetools](github.com/sheldonhull/magetools): Reusable packages that can be pulled in to jump start common tasks or utilities.
    - Examples:
        - Enhanced go formatter with `mage go:wrap`.
        - Preinstall common Go tools such as the language server, dlv, gofumpt, golangci-lint, and more with `mage go:init`.
        - Provide a github repo for a go binary and use in tasks. If the binary isn't found, it will automatically grab it when invoked.
        - Pre-commit registration and tooling.
        - Install Git Town, Bit, and other cool git helpers with `mage gittools:init`.
        - Chain together all your core tasks with `mage init` to allow for a fully automated dev setup.

### Why Should I Care About Mage?

- I've never felt my automation was as robust, stable, and easy to debug as when I've used Mage.
- I've done a lot of experimenting with others, and had primarily relied on `InvokeBuild` (powershell based) in the past.
- Mage takes the prize for ease of use.
- You can migrate a make file relatively easily if you want to just call tools directly.
- You can benefit from using Go packages directly as you up your game.
    - Example: instead of calling kubectl directly, I've used a helm Go library that does actions like validation, linting, and templating directly from the same core code that kubectl itself uses.

### Mage Basics

- Mage is just Go code.
- It does a little "magic" by simplying matching some functions that match basic signature such as `error` output, like `func RunTests(dir string) error {...}`.
- You can get around needing mage by creating Go files, but you'd have to add basic args handling for the `main()` entry point, and help generation.
- Mage basically tries to simplify the cli invocation by auto-discovering all the matched functions in your `magefiles` directory and providing as tasks.
- Mage does not currently support flags, though this is actively being looked at.
    - This means you are best served by keeping tasks very very simple. Ie `mage deploy project dev` is about as complex as I'd recommend.
    - Normally, you'd invoke with `mytool -project ProjectName -env dev` and positions wouldn't matter. With mage, it's positional for simplicity so best to keep simple!

### My Mage Tips

- Use the pattern shown in my template repo above.
    - Use `magefiles` directory.
    - Provide a single `magefile.go` that does your imports and basic commands. If it's a big project then just have it import and put all your tasks in subdirectories that it imports.
- Provide a `magefiles/constants/constants.go && vars.go` rather than being worried about globals.
This is for build automation, and having a configured file with standards that shouldn't change or global variables is a nice alternative to needing more yaml files.
- Use Pterm for enchanced logging experience, provides some beautiful output for users.
- For extra benefit, standardize with a `mage doctor` command in your project that validates issues experienced and gets added to over time.
This can help troubleshooting any environment or project issues if you maintain and add a list of checks being run.
Using Pterm you can make this into a nice table output like this:

![Mage Doctor Output](/images/2022-06-11-16.52.33-mage-doctor.png "Mage Doctor Output")

## Testing

- Go test will automatically ignore directories and files starting with `.` or `_`, see [go command - cmd/go - pkg.go.dev](https://pkg.go.dev/cmd/go#hdr-Package_lists_and_patterns).

## Modules

### What are Go Modules?

Go Modules are primarily a dependency management solution.

A module:

- Is primarily a dependency management tool, not a project organization tool.
- Is imported to get access to public exported members in your own project.
- One module can have `n` binaries produced.
- A module can be used in a monorepo or single CLI tool.

A module doesn't:

- Handle build or binary path metadata.
- Have any relationship to the produced artifacts.

### Module Tips

- Use canconical import path (aka) `github.com/sheldonhull/mygomod` if you want to support `go install` commands.
- Use `mymod.local` if no need to support remote imports or installs.
    - This allows `gofumpt` and tooling to correctly sort the imports from standard library apart from your own imports, without requiring canonical name format.
- Stick with one module in the repo if possible, to simplify tooling, linting, and testing. This is important in monorepos as much of the tooling that uses paths like `go test ./...` will not work with multi-module repos in a project.

### Project & Build Tooling

- Use `devtools.go` to create a list of cli tools that should be installed with Mage.
- Use `tools.go` to put `_ "remotemodulename"` in, and identify clearly that a tool such as Stringer or linters are not dependencies for the primary module, but instead are tooling dependencies.

## Pre-Commit

## Using Pre-Commit Tooling

Here's how to setup [pre-commit](https://bit.ly/3szdwNf) for Go projects.

1. Install [pre-commit](https://bit.ly/2O9urag) for macOS: `brew install pre-commit` or see directions for curl/other options for WSL, Windows, Linux, etc.
1. Use the template from [TekWizely/pre-commit-golang: Pre-Commit hooks for Golang with support for Modules](https://bit.ly/31w3gtk)
    1. Several options are provided for `fmt` oriented commands.
    Comment out any duplicates that don't apply.
1. Finally initialize the pre-commit hooks in your repo by running: `pre-commit install`

Validate everything is working by running: `pre-commit run --all-files`

Periodically, you can run `pre-commit autoupdate` to ensure the latest version of the pre-commit hooks are upgraded.

## Logging

At this stage, I'm using [zerolog](https://github.com/rs/zerolog) as I found it very easy to get moving with structured logs.

The output of this demo looks pretty good!

![Output from Zerolog](/images/r1-d014-structured-console-output.png)

Here's a functional demo that can be used to bootstrap a new project with this.

{{< gist sheldonhull  "9e608da09f84fac600d921e3f0867226" >}}

## Code Coverage Report

original post: [^go-r1-day-41]

Use gopherbadge[^gopherbadge]

```shell
go install github.com/jpoles1/gopherbadger@master
```

- Set `![gopherbadger-tag-do-not-edit]()` in the readme, and then this gets replaced with a code coverage percentage badge.
- Generate the required code coverage reports using:

```shell
go test ./... -coverprofile ./artifacts/cover.out
go tool cover -html=./artifacts/cover.out -o ./artifacts/coverage.html
gopherbadger -md="README.md,coverage.md" -tags 'unit'
```

## VSCode

### Custom Tasks

#### Default Shells

This can ensure default behavior is processed on each OS, customizing the shell to use.

```json
{
  "version": "2.0.0",
  "presentation": {
    "echo": false,
    "reveal": "always",
    "focus": false,
    "panel": "dedicated",
    "showReuseMessage": true
  },
  "linux": {
    "options": {
      "shell": {
        "executable": "/usr/local/bin/zsh",
        "args": [
          "-l",
          "-c"
        ],
      }
    },
    "type": "shell"
  },
  "windows": {
    "options": {
      "shell": {
        "executable": "pwsh"
      }
    },
    "type": "shell"
  },
  "osx": {
    "options": {
      "shell": {
        "executable": "/usr/local/bin/zsh",
        "args": [
          "-l",
          "-c"
        ]
      }
    },
    "type": "shell"
  },
  "tasks": []
}
```

#### Run Lint

Add this to your `.vscode/tasks.json` file and you'll get the full linting output in your problems pane.

By default, the `golangci-lint` config should include `--fast` to avoid impact to your editing.

This will ensure all tasks that a pre-commit check or CI check will be run and provided in the problems panel.

```json
"tasks": [
    {
      "label": "go-lint-all",
      "detail": "This runs the full range of checks and the VSCode problem matcher will pull all of them in. Without this, the default behavior of VSCode is to run with --fast to reduce impact to IDE.",
      "type": "shell",
      "command": "golangci-lint",
      "args": [
        "run",
        "--out-format",
        "colored-line-number"
      ],
      "problemMatcher": [
        "$go"
      ],
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": true,
        "panel": "dedicated",
        "showReuseMessage": true,
        "clear": true
      }
    },
```

## Run Nicely Formatted Test Output

### Tparse

While the testing extension is great, sometimes I just want to see a console summary.
This task uses [Tparse](https://github.com/mfridman/tparse) and provides a nicely formatted summary (including coverage numbers, cached tests, and more).

Install tparse with: `go install github.com/mfridman/tparse@latest`.

Run manually like this: `GOTESTS='slow' go test ./... -v -cover -json | tparse -all`

```json
{
  "label": "go-test-formatted-output",
  "type": "shell",
  "command": "go",
  "options": {
    "env": {
      "GOTEST": "slow integration",
    }
  },
  "args": [
    "test",
    "./...",
    "-v",
    "-cover",
    "-json",
    "|",
    "tparse",
    "-all"
  ],
  "problemMatcher": []
},
```

### Gotestsum

Install with: `go install gotest.tools/gotestsum@latest`.

Then run like this: `gotestsum` or try the alternative formats like: `gotestsum --format dots-v2` or `--format pkgname`, or `--format testname`.

## Effective Go

Principles I've gleaned over-time and am quoting or bookmarking.

### Don't hide the cost

> Source: Bill Kennedy in Ultimate Go [^readability]

If we are doing construction to a variable, we use value construction.
Avoid pointer semantic construction if not in the return.

Example:

```go
// clear visible cost of the allocation by value construction and passing of pointer back up the call stack
func createSomething() *something {
  u := something{
    name: "example",
  }
  return &u // <--- This makes clear the cost and allocation back up the callstack.
}
// cost is obscured by construction being a pointer
// and returning a value that is not clear to reader if value or pointer
func createSomething()*something {
  u := &something{
    name: "example",
  }
  return u // <--- Not good. Hides the cost, and require reading function further to find that this is a pointer.
}
```

Making cost obvious and visible is a big priority for readable maintainable code with a team.

## Running External Commands

## Repos

<div class="github-card" data-github="sheldonhull/algorithmswithgo.com" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

<div class="github-card" data-github="sheldonhull/web-development-with-go" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

<div class="github-card" data-github="sheldonhull/go-aws-ami-metrics" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

[^go-r1-day-41]: [go-r1-day-41](/go-r1-day-41)
[^gopherbadge]: [GitHub - jpoles1/gopherbadger: Generate coverage badge images using Go!](https://github.com/jpoles1/gopherbadger)
[^readability]: [Readability - Ultimate Go]((<https://github.com/ardanlabs/gotraining/tree/master/topics/go#readability>)
