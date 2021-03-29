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

## Pre-Commit

Here's how to setup [pre-commit](https://bit.ly/3szdwNf) for Go projects.

1. Install [pre-commit](https://bit.ly/2O9urag) for macOS: `brew install pre-commit` or see directions for curl/other options for WSL, Windows, Linux, etc.
1. Use the template from [dnephin/pre-commit-golang: Golang hooks for pre-commit](https://bit.ly/31HwJ3D)
1. Finally initialize the pre-commit hooks in your repo by running: `pre-commit install`


Validate everything is working by running: `pre-commit run --all-files`

Periodically, you can run `pre-commit autoupdate` to ensure the latest version of the pre-commit hooks are upgraded.


## Logging

At this stage, I'm using [zerolog](https://github.com/rs/zerolog) as I found it very easy to get moving with structured logs.

The output of this demo looks pretty good!

![Output from Zerolog](/images/r1-d014-structured-console-output.png)

Here's a functional demo that can be used to bootstrap a new project with this.

{{< gist sheldonhull  "9e608da09f84fac600d921e3f0867226" >}}


## Other

<div class="github-card" data-github="sheldonhull/algorithmswithgo.com" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

<div class="github-card" data-github="sheldonhull/web-development-with-go" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

<div class="github-card" data-github="sheldonhull/go-aws-ami-metrics" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>
