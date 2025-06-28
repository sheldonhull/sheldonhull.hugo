# goroutines

## Resources

| Resource                                                                | Notes                                                      |
| ----------------------------------------------------------------------- | ---------------------------------------------------------- |
| [Goroutines &amp; Closures](https://go.dev/doc/faq#closures_and_goroutines) | Important caveat on shadowing variable in loops included   |
| [Using uiprogress](https://www.sheldonhull.com/go-r1-day-70/)           | Notes I wrote about trying threadsafe progress bar package |

## Using Goroutines with CLI Tools

Running CLI tools via goroutines can speed up slow actions like code generation.
I prefer to run these types of actions with a buffered channel to throttle the requests and avoid overloading my laptop. 🔥

Here&#39;s an example using Pterm output for reporting progress (no progress bar)[^race-conditions].

[Playground - Go :fontawesome-solid-link:](https://go.dev/play/p/1-XLUoLpBy4)

```go title=&#34;Invoking CLI With Buffered Channels&#34;
package main

import (
 &#34;sync&#34;

 &#34;github.com/bitfield/script&#34;
 &#34;github.com/pterm/pterm&#34;
)

func main() {
 pterm.DisableColor()
 concurrentLimit := 4
 type runMe struct {
  title   string
  command string
 }
 runCommands := []runMe{
  {title: &#34;commandtitle&#34;, command: &#34;echo &#39;foo&#39;&#34;},
 }
 var wg sync.WaitGroup
 buffChan := make(chan struct{}, concurrentLimit)
 wg.Add(len(runCommands))
 pterm.Info.Printfln(&#34;running cli [%d]&#34;, len(runCommands))
 for _, r := range runCommands {
  r := r
  go func(r runMe) {
   buffChan &lt;- struct{}{}
   defer wg.Done()
   if _, err := script.Exec(r.command).Stdout(); err != nil {
    pterm.Error.Printfln(&#34;[%s] unable to run: %s, err: %s&#34;, r.title, r.command, err)
   } else {
    pterm.Success.Printfln(&#34;[%s]&#34;, r.title)
   }
   &lt;-buffChan
  }(r)
 }
 wg.Wait()
}

```

[^race-conditions]: Since things are running concurrently, a single bar isn&#39;t quite accurate. There are libraries that report correctly with goroutines, but as of 2023-03, pterm isn&#39;t one of them. However, it&#39;s under development.

