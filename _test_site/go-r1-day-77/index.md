# Go R1 Day 77


## progress

### More Fun With Golangci-lint

Been doing a ton the last month with `golangci-lint` tooling.
I think this has been one of the most educational tools for learning Go I&#39;ve come across.
It has forced me to evaluate why issues are flagged, if they are opinionated preferences or best practices.

For example, wsl ensures that statements are not cuddled.
This follows Dave Cheney&#39;s writing about having an empty line seperate phrases of thought.

It&#39;s a bit annoying to implement as a linter though, and can&#39;t be applied programaticaly so I&#39;m not using that.

## Linting - Shadowing Package Names

Another one that I caught from Goland linting today, that `golangci-lint` didn&#39;t seem to catch, was the shadowing of a package name.

In this scenario I found code where:

```go
package taco


func main() {
 taco := taco.Method()
}
```

While this is legal, it&#39;s a confusing practice, and thereafter prohibits the usage of the `taco` package as it&#39;s been overshadowed by the variable.

To me this is a clear violation of Go&#39;s preference for &#34;no magic&#34; and readability.

In this scenario, the fix is simple.
Change the variable name used or alias the package (my preference).

```go
package (
  pkgtaco &#34;taco&#34;
)


func main() {
 taco := pkgtaco.Method()
}
```

## Linting - Handling Errors

Also did some investigation on `errcheck` and flagging of handling file close and response body closing for http.
This is one of those areas that linters flag and it&#39;s a &#34;it depends&#34; and not very consistent.

Basically the gist is ignore, except if file writing is occuring then it&#39;s probably needing an explicit handle.

## links

- [go - Should shadowing Package Namespace with Local Variables be strictly avoided? - Stack Overflow](https://stackoverflow.com/q/69683758/68698)

