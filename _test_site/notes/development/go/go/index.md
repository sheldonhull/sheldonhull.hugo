# go


## Starter Template

I saved this as a snippet for vscode to get up and running quickly with something better than the defaults for handling `func main` isolation. I&#39;ve been working on modifying this a bit as I don&#39;t really like using args, but am trying not to overcomplicate things as a new gopher.

I prefer better flag parsing rather than using args. This pattern isolates functions from the main function to make them easily testable.

The gist is to ensure that `main` is where program termination happens, instead of handling this in your functions. This isolation of logic from main ensures you can more easily set up your tests since `func main()` isn&#39;t testable.

```go
package main

// package template from:
import (
    &#34;errors&#34;
    &#34;fmt&#34;
    &#34;io&#34;
    &#34;os&#34;
)

const (
    // exitFail is the exit code if the program
    // fails.
    exitFail = 1
)

func main() {
    if err := run(os.Args, os.Stdout); err != nil {
        fmt.Fprintf(os.Stderr, &#34;%s\n&#34;, err)
        os.Exit(exitFail)
    }
}

func run(args []string, stdout io.Writer) error {
    if len(args) == 0 {
        return errors.New(&#34;no arguments&#34;)
    }
    for _, value := range args[1:] {
        fmt.Fprintf(stdout, &#34;Running %s&#34;, value)
    }
    return nil
}
```

## Running External Commands

## Repos

&lt;div class=&#34;github-card&#34; data-github=&#34;sheldonhull/algorithmswithgo.com&#34; data-width=&#34;400&#34; data-height=&#34;&#34; data-theme=&#34;default&#34;&gt;&lt;/div&gt;
&lt;script src=&#34;//cdn.jsdelivr.net/github-cards/latest/widget.js&#34;&gt;&lt;/script&gt;

&lt;div class=&#34;github-card&#34; data-github=&#34;sheldonhull/web-development-with-go&#34; data-width=&#34;400&#34; data-height=&#34;&#34; data-theme=&#34;default&#34;&gt;&lt;/div&gt;
&lt;script src=&#34;//cdn.jsdelivr.net/github-cards/latest/widget.js&#34;&gt;&lt;/script&gt;

&lt;div class=&#34;github-card&#34; data-github=&#34;sheldonhull/go-aws-ami-metrics&#34; data-width=&#34;400&#34; data-height=&#34;&#34; data-theme=&#34;default&#34;&gt;&lt;/div&gt;
&lt;script src=&#34;//cdn.jsdelivr.net/github-cards/latest/widget.js&#34;&gt;&lt;/script&gt;

