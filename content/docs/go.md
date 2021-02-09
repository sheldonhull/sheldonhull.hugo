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

## Puzzles - FizzBuzz

I honestly had never done any algorithm or interview puzzles beyond sql-server, so I was really happy to knock this out relatively easily. At least I pass the basic Joel test 😁

{{< gist sheldonhull  "25309ea04d1646f26bc0f4a54e0f16af" >}}

## Logging

At this stage, I'm using [zerolog](https://github.com/rs/zerolog) as I found it very easy to get moving with structured logs.

The output of this demo looks pretty good!

![Output from Zerolog](/images/r1-d014-structured-console-output.png)

Here's a functional demo that can be used to bootstrap a new project with this.

{{< gist sheldonhull  "9e608da09f84fac600d921e3f0867226" >}}

## Algorithms & Challenges

I'll eventually put these in a repo most likely, and have test cases to make runnable, but for now, just snippets of solutions to reference.

### Sock Merchant

> Alex works at a clothing store. There is a large pile of socks that must be paired by color for sale. Given an array of integers representing the color of each sock, determine how many pairs of socks with matching colors there are. Return the total number of matching pairs of socks that Alex can sell.

{{< gist sheldonhull  "f7671b1d78705c329fe25b3c4af7c3ec" >}}

### Bubble Sort

> Given an array of integers, sort the array in ascending order using the Bubble Sort algorithm above. Once sorted, print the following three lines for example: Array is sorted in 3 swaps. First Element: 1 Last Element: 6

{{< gist sheldonhull  "4aae8e98dd228530d97ce7c6e8208444" >}}
