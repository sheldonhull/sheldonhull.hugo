# Go R1 Day 45


## progress

- Worked through merging flags and the &#34;run&#34; approach from Mat Ryer.
- Used ff for parsing.

The resulting logic seems correct with main being very simple with:

```go
package main
import(
    &#34;io&#34;
    &#34;flag&#34;
    &#34;os&#34;
    &#34;github.com/peterbourgon/ff/v3&#34;
    &#34;github.com/peterbourgon/ff/v3/ffcli&#34;
    &#34;github.com/peterbourgon/ff/v3/fftoml&#34;
)
const (
 // exitFail is the exit code if the program
 // fails.
 exitFail           = 1
)

// main configuration from Matt Ryer with minimal logic, passing to run, to allow easier CLI tests
func main() {
 if err := run(os.Args, os.Stdout); err != nil {
  fmt.Fprintf(os.Stderr, &#34;%s\n&#34;, err)
  os.Exit(exitFail)
 }
}
```

The run function then handles the actual parsing:

```go
func run(args []string, stdout io.Writer) error {
 if len(args) == 0 {
  return errors.New(&#34;no arguments&#34;)
 }
  flags := flag.NewFlagSet(args[0], flag.ExitOnError)
 flag.BoolVar(&amp;debug, &#34;debug&#34;, false, &#34;sets log level to debug&#34;)

if err := ff.Parse(flags, args,
  ff.WithEnvVarNoPrefix(),
  ff.WithConfigFileFlag(&#34;config&#34;),
  ff.WithConfigFileParser(fftoml.Parser),
 ); err != nil {
  return err
 }
 if debug {
  logLevel = &#34;debug&#34;
 }
  // proceed with initialization of logger and other tools
  return nil
```

I like this approach, as the examples by Mat show how you can end up testing the inputs and variations on flags as well.
The example from his blog post showed how easy it became with:

```go
err := run([]string{&#34;program&#34;, &#34;-v&#34;, &#34;-debug=true&#34;, &#34;-another=2&#34;})
```

## links

- [Why you shouldn&#39;t use func main in Go by Mat Ryer - PACE.](https://pace.dev/blog/2020/02/12/why-you-shouldnt-use-func-main-in-golang-by-mat-ryer.html)
- [ff · pkg.go.dev](https://pkg.go.dev/github.com/peterbourgon/ff)

