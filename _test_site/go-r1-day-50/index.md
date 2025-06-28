# Go R1 Day 50


## progress

- evaluate package level logging variables and how to properly use them.
- tested best way to abstract the common logging to avoid run time dependency with package level variables and impact to tests.
- read through [Effective Go - The Go Programming Language - embedding](https://golang.org/doc/effective_go#embedding)

At this point, I&#39;m still struggling with the proper way to abstract a logging wrapper that calls a logging library.
There&#39;s enough boilerplate for setup of my preferred defaults in zerolog that I want to include a wrapper to organize this and return the logger.

This tends to look like:

```go
type Logger struct {
  Logger *zerolog.Logger
}
```

This results in a pretty lengthy call with `logger.Logger.Info().Str(&#34;key&#34;, &#34;value&#34;).Msg(&#34;message&#34;)`.
I&#39;m also having issues with the embedded logger not returning the correct methods transparently back to the caller.

I&#39;ve tested with `internal/logger` and `pkg/logger` with similar issues.
This one I&#39;ll have to come back round to.

- Also worked a little on [GitHub - sheldonhull/go-semantic-sentences: Use semantic line breaks with markdown files.](https://github.com/sheldonhull/go-semantic-sentences)
- This resulted in learning a bit of regex with Go.
I found it a bit confusing intially setting up my tests, since it seems to be matching more than I&#39;d expect.
Will come back around to this soon.

