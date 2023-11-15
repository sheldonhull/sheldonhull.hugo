---
title: goroutines
tags:
  - go
lastmod: 2023-03-17 18:00
---
## Resources

| Resource                                                                | Notes                                                      |
| ----------------------------------------------------------------------- | ---------------------------------------------------------- |
| [Goroutines & Closures](https://go.dev/doc/faq#closures_and_goroutines) | Important caveat on shadowing variable in loops included   |
| [Using uiprogress](https://www.sheldonhull.com/go-r1-day-70/)           | Notes I wrote about trying threadsafe progress bar package |

## Using Goroutines with CLI Tools

Running cli tools via goroutines can allow speeding up slow actions like code generation.
I prefer to run these type of actions with a buffered channel to allow throttling the requests to avoid my laptop from catching on fire. 🔥

Here's an example using Pterm output for reporting progress (no progress bar)[^race-conditions].

[Playground - Go :fontawesome-solid-link:](https://go.dev/play/p/1-XLUoLpBy4)

```go title="Invoking CLI With Buffered Channels"
package main

import (
	"sync"

	"github.com/bitfield/script"
	"github.com/pterm/pterm"
)

func main() {
	pterm.DisableColor()
	concurrentLimit := 4
	type runMe struct {
		title   string
		command string
	}
	runCommands := []runMe{
		{title: "commandtitle", command: "echo 'foo'"},
	}
	var wg sync.WaitGroup
	buffChan := make(chan struct{}, concurrentLimit)
	wg.Add(len(runCommands))
	pterm.Info.Printfln("running cli [%d]", len(runCommands))
	for _, r := range runCommands {
		r := r
		go func(r runMe) {
			buffChan <- struct{}{}
			defer wg.Done()
			if _, err := script.Exec(r.command).Stdout(); err != nil {
				pterm.Error.Printfln("[%s] unable to run: %s, err: %s", r.title, r.command, err)
			} else {
				pterm.Success.Printfln("[%s]", r.title)
			}
			<-buffChan
		}(r)
	}
	wg.Wait()
}

```

[^race-conditions]: Since things are running concurrently a single bar isn't quite accurate. There are libraries out there that report correctly with goroutines, but pterm as of 2023-03 isn't one of them yet. It's being worked on.
