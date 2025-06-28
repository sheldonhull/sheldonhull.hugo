# Go R1 Day 70


## progress

- Concurrency section wrap-up with Learn Go With Tests.
- Reviewed material learned from: [Go R1 Day 61]({{&lt; relref &#34;2021-08-02-go-R1-day-60.md&#34; &gt;}} &#34;Go R1 Day 61&#34;)
- Read material, but didn&#39;t do a lot of tests on this, per mostly concept oriented.
Used concurrent progressbar example from `uiprogress` project to test concurrent UI updates.
- My last concurrency test case was to launch many concurrent processes for a load test.
This didn&#39;t leverage goroutinues as typically used, since it was calling to an executable on the host machine.
However, this provided a great use case for something I&#39;ve done before with DevOps oriented work and showed how to use concurrency as a blocking operation.
Once the user was done with the test, `ctrl&#43;c` was used to kill the active requests and the program exited.
- I need more practice with channels.
I was only wanting error stdout content, and so didn&#39;t have any need for receiving channel output back in a structured way.
This is probably an atypical usage of concurrency, fitting for an external load test, but not internal Go code.
- Still found it pretty cool that I could spin up 500 processes at once, with far less overhead than doing in PowerShell.

{{&lt; admonition type=&#34;Note&#34; title=&#34;Example Of Doing In PowerShell&#34; open=true &gt;}}
Doing this in PowerShell is far more compact, but not as performant.

This is a good example of the different in using Go for adhoc tasks.
It will require more code, error handling care, but pays off in something that is likely more stable and easier to run across multiple systems with a single binary.

```powershell
#!/usr/bin/env pwsh
$Server = &#39;IPADDRESS&#39;
$ServerPort = &#39;3000&#39;
Write-Host &#39;Load Test Start&#39;
$RandomPort = &#39;4000&#39;

$j = @(4000..4100)| ForEach-Object {
    $c = $_
    Start-ThreadJob -ThrottleLimit 1000 -StreamingHost $Host -InputObject $c -ScriptBlock {
    $RandomPort = $input
    &amp;mybinary serve --max-retry-count 5 --header &#34;user-id: $(petname)&#34; --header &#34;session-id: $(uuidgen)&#34; &#34;${using:Server}:${using:ServerPort}&#34;
}
}
$j | Wait-Job | Receive-Job
$j | Stop-Job
```

I didn&#39;t benchmark total load difference between this and Go, but I&#39;m sure the pwsh threads were a bit more costly, though for this test case might not have been a large enough value to make much difference.

{{&lt; /admonition &gt;}}

## Code Examples

This first section is the startup.
Key points:

- main() is the entry point for the program, but doesn&#39;t contain the main logic flow.
Inspired by Matt Ryer&#39;s posts, I now try to ensure main is as minimal as possible to encourage easier automation in testing.
Since `run` contains the main logic flow, the actual CLI itself can be called via integration test by flipping to `Run()` and calling from `testing` file using a blackbox testing approach.

```go
package main

import (
	&#34;bytes&#34;
	&#34;errors&#34;
	&#34;flag&#34;
	&#34;fmt&#34;
	&#34;io&#34;
	&#34;math&#34;
	&#34;os&#34;
	&#34;os/exec&#34;
	&#34;strings&#34;
	&#34;sync&#34;
	&#34;time&#34;

	shellescape &#34;github.com/alessio/shellescape&#34;
	petname &#34;github.com/dustinkirkland/golang-petname&#34;
	&#34;github.com/google/uuid&#34;
	&#34;github.com/pterm/pterm&#34;
	&#34;github.com/rs/zerolog&#34;
	&#34;github.com/rs/zerolog/log&#34;
)

const (
	// exitFail is the exit code if the program
	// fails.
	exitFail = 1

	// desiredPort is the port that the app forwards traffic to.
	desiredPort = 22

	// petnameLength is the length of the petname in words to generate.
	petNameLength = 2

	// startingPort is the starting port for a new connection, and will increment up from there so each connection is unique.
	startingPort = 4000

	// maxRetryCount is the number of times to retry a connection.
	maxRetryCount = 5
)

func main() {
	if err := run(os.Args, os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, &#34;%s\n&#34;, err)
		os.Exit(exitFail)
	}
}
```

Next `run` contains the main logic flow.
The goal is that all main program logic for exiting and terminating is handled in this single location.

```go

// Run handles the arguments being passed in from main, and allows us to run tests against the loading of the code much more easily than embedding all the startup logic in main().
// This is based on Matt Ryers post: https://pace.dev/blog/2020/02/12/why-you-shouldnt-use-func-main-in-golang-by-mat-ryer.html
func run(args []string, stdout io.Writer) error {
	if len(args) == 0 {
		return errors.New(&#34;no arguments&#34;)
	}
	InitLogger()
	zerolog.SetGlobalLevel(zerolog.InfoLevel)

	debug := flag.Bool(&#34;debug&#34;, false, &#34;sets log level to debug&#34;)
	Count := flag.Int(&#34;count&#34;, 0, &#34;number of processes to open&#34;)
	delaySec := flag.Int(&#34;delay&#34;, 0, &#34;delay between process creation. Default is 0&#34;)
	batchSize := flag.Int(&#34;batch&#34;, 0, &#34;number of processes to create in each batch. Default is 0 to create all at once&#34;)
	Server := flag.String(&#34;server&#34;, &#34;&#34;, &#34;server IP address&#34;)
	ServerPort := flag.Int(&#34;port&#34;, 3000, &#34;server port&#34;) //nolint:gomnd

	flag.Parse()
	log.Logger.Info().Int(&#34;Count&#34;, *Count).
		Int(&#34;delaySec&#34;, *delaySec).
		Int(&#34;batchSize&#34;, *batchSize).
		Str(&#34;Server&#34;, *Server).
		Msg(&#34;input parsed&#34;)

	log.Logger.Info().
		Int(&#34;desiredPort&#34;, desiredPort).
		Int(&#34;petNameLength&#34;, petNameLength).
		Int(&#34;startingPort&#34;, startingPort).
		Msg(&#34;default constants&#34;)

	if *debug {
		zerolog.SetGlobalLevel(zerolog.DebugLevel)
	}

	RunTest(*Count, *delaySec, *batchSize, *Server, *ServerPort)
	return nil
}
```

Next, `InitLogger` is used to initialize the logger for zerolog.
I don&#39;t need multiple configurations right now so this is just stdout.

```go
// InitLogger sets up the logger magic
// By default this is only configured to do pretty console output.
// JSON structured logs are also possible, but not in my default template layout at this time.
func InitLogger() {
	output := zerolog.ConsoleWriter{Out: os.Stdout, TimeFormat: time.RFC3339}
	log.Logger = log.With().Caller().Logger().Output(zerolog.ConsoleWriter{Out: os.Stderr})

	output.FormatLevel = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf(&#34;| %-6s|&#34;, i))
	}
	output.FormatMessage = func(i interface{}) string {
		return fmt.Sprintf(&#34;%s&#34;, i)
	}
	output.FormatFieldName = func(i interface{}) string {
		return fmt.Sprintf(&#34;%s:&#34;, i)
	}
	output.FormatFieldValue = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf(&#34;%s&#34;, i))
	}
	log.Info().Msg(&#34;logger initialized&#34;)
}
```

Test the existence of the binary being run in a load test, and exit if it doesn&#39;t exist.
This should more likely be handled in the run fuction, but I just did it here for simplicity in this adhoc tool.

```go
// TestBinaryExists checks to see if the binary is found in PATH and exits with failure if can&#39;t find it.
func TestBinaryExists(binary string) string {
	p, err := exec.LookPath(binary)
	if err != nil {
		log.Logger.Error().Err(err).Str(&#34;binary&#34;,binary).Msg(&#34;binary not found&#34;)
		os.Exit(exitFail)
	}

	return p
}
```

Next, `buildCLIArgs` handles the argument string slice construction.
I learned from this to keep each line and argument independent as escaping has some strange behavior if you try to combine too much in a single statement, especially with spaces.
Best practice is to keep this very simple.

```go
// buildCliArgs is an example function of building arguments via string slices
func buildCliArgs(Server string, ServerPort int, port int) (command []string) {
	command = append(command, &#34;server&#34;)
	command = append(command, &#34;--header&#34;)
	command = append(command, fmt.Sprintf(`user-id: %s`, petname.Generate(petNameLength, &#34;-&#34;)))
	command = append(command, &#34;--header&#34;)
	command = append(command, fmt.Sprintf(`session-id: %s`, uuid.Must(uuid.NewRandom()).String()))
	command = append(command, &#34;--max-retry-count&#34;, &#34;5&#34;)
	command = append(command, Server&#43;&#34;:&#34;&#43;fmt.Sprintf(&#34;%d&#34;, ServerPort))
	return command
}
```

Finally, a function that run the tests with some pretty output using pterm.
This would be probably better to break-up for testing, but again, adhoc project, so this ended up working decently as I was learning concurrency.

```go
// RunTest is the main test function that calculates the batch size and then launches the  creation using a routinue.
func RunTest(Count int, delaySec int, batchSize int, Server string, ServerPort int) {
	log.Logger.Info().Msg(&#34;RunTest startings&#34;)
	totalBatches := math.Ceil(float64(Count) / float64(batchSize))
	log.Logger.Info().Float64(&#34;totalBatches&#34;, totalBatches).Msg(&#34;batches to run&#34;)
	myBinary := TestBinaryExists(&#34;binaryname&#34;)
	port := startingPort
	var wg sync.WaitGroup

	totals := 0
	p, _ := pterm.DefaultProgressbar.WithTotal(Count).WithTitle(&#34;run s&#34;).Start()

	for i := 0; i &lt; int(totalBatches); i&#43;&#43; {
		log.Debug().Int(&#34;i&#34;, i).Int(&#34;port&#34;, port).Msg(&#34;batch number&#34;)

		for j := 0; j &lt; batchSize; j&#43;&#43; {
			if totals == Count {
				log.Debug().Msg(&#34;totals == Count, breaking out of loop&#34;)

				break
			}

			totals&#43;&#43;
			log.Debug().Int(&#34;i&#34;, i).Int(&#34;&#34;, totals).Msg(&#34;&#34;)
			cmdargs := buildCliArgs(Server, ServerPort, port)
			wg.Add(1)
			go func() {
				defer wg.Done()
				buf := &amp;bytes.Buffer{}
				cmd := exec.Command(, cmdargs...)
				cmd.Stdout = buf
				cmd.Stderr = buf
				if err := cmd.Run(); err != nil {
					log.Logger.Error().Err(err).Bytes(&#34;output&#34;, buf.Bytes()).Msg(&#34; failed&#34;)
					os.Exit(exitFail)
				}
				log.Logger.Debug().Msgf(&#34; %v&#34;, shellescape.QuoteCommand(cmdargs))
				log.Logger.Debug().Bytes(&#34;output&#34;, buf.Bytes()).Msg(&#34;&#34;)
			}()

			p.Title = &#34;port: &#34; &#43; fmt.Sprintf(&#34;%d&#34;, port)
			p.Increment()
			port&#43;&#43;
		}
		time.Sleep(time.Second * time.Duration(delaySec))
	}
	p.Title = &#34;s finished&#34;
	_, _ = p.Stop()
	wg.Wait()
}
```

## links

- [GitHub - gosuri/uiprogress: A go library to render progress bars in terminal applications](https://github.com/gosuri/uiprogress)

