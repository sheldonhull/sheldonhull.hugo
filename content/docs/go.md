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

- Use  `mymod.local` if no need to support remote imports or installs.
    - This allows `gofumpt` and tooling to correctly sort the imports from standard library apart from your own imports, without requiring canonical name format.
- Stick with one module in the repo if possible, to simplify tooling, linting, and testing. This is important in monorepos as much of the tooling that uses paths like `go test ./...` will not work with multi-module repos in a project.

### Project & Build Tooling

- Use `devtools.go` to create a list of cli tools that should be installed with Mage.
- Use `tools.go` to put `_ "remotemodulename"` in, and identify clearly that a tool such as Stringer or linters are not dependencies for the primary module, but instead are tooling dependencies.

## Pre-Commit

## Using Lefthook


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
