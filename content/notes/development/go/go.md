---
title: go
date: 2020-10-30T00:00:00.000Z
toc: true
summary: >-
  A cheatsheet to update with what I pickup with Go that I likely need to
  reference again as a new gopher.
slug: go
permalink: /notes/go
comments: true
tags:
  - development
  - golang
---

## Starter Template

I saved this as a snippet for vscode to get up and running quickly with something better than the defaults for handling `func main` isolation. I've been working on modifying this a bit as I don't really like using args, but am trying not to overcomplicate things as a new gopher.

I prefer better flag parsing rather than using args. This pattern isolates functions from the main function to make them easily testable.

The gist is to ensure that `main` is where program termination happens, instead of handling this in your functions. This isolation of logic from main ensures you can more easily set up your tests since `func main()` isn't testable.

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

## Running External Commands

## Repos

<div class="github-card" data-github="sheldonhull/algorithmswithgo.com" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

<div class="github-card" data-github="sheldonhull/web-development-with-go" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

<div class="github-card" data-github="sheldonhull/go-aws-ami-metrics" data-width="400" data-height="" data-theme="default"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>
