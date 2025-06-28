# Go R1 Day 61


## progress

It was a dark and stormy night.
The world was bleak.
A command was sent to The Compiler.

The assumptions were flawed.
The command was rejected.

&gt; You have given me an invalid command with `-argument-that-shall-not-work 5` being invalid.

But I&#39;ve provided `--argument-that-shall-not-work`, the indomitable wizard said.

&gt; Your command is unworthy.

Digging into esoteric tomes of knowledge, the wizard discovered others have had similar issues when calling external processes using the legendary wizardry of `os/exec`.
However, none could shine light into the darkness of his failure.

Running in `pwsh` worked fine.

Next, the wizard tried a variety of escaping commands.

- Using `shellescape` package.
- Using back-ticks with the arguments to escape.
- Using partially quoted arguments in the slice of the strings.
- Using no quotes.
- Went down the path of ancient texts describing similar issues.[^similar-issues]

To the wizards dismay, copying the printed debug output worked fine in the terminal, but alas would not be executed by The Compiler.

It began to feel like the curse of dynamic SQL queries that had long plagued the wizard until PowerShell had been discovered.

The wizard ruminated on his plight.
He thought:

&gt; At the end of the day, all things seem to come down to strings and the cursed interpretation of my textual commands to The Compiler.
How many a day have I wasteth upon the fault of a single character.
The root of all evil must be a string.&#34;

The wizard connected to a new remote instance, using the power of the Remote SSH plugin and began debugging in VSCode.

The debug breakpoint config that worked was set in stone.

```json
  {
      &#34;name&#34;: &#34;Run frustrating-test&#34;,
      &#34;type&#34;: &#34;go&#34;,
      &#34;request&#34;: &#34;launch&#34;,
      &#34;mode&#34;: &#34;debug&#34;,
      &#34;program&#34;: &#34;${workspaceFolder}/MyTestApp/test.go&#34;,
      &#34;args&#34;: [
        &#34;-count&#34;,
        &#34;100&#34;,
        &#34;-batch&#34;,
        &#34;10&#34;,
        &#34;-delay&#34;,
        &#34;1&#34;,
        &#34;-server&#34;,
        &#34;MyCustomIPAddress&#34;,
        &#34;-debug&#34;,
      ],
      &#34;debugAdapter&#34;: &#34;legacy&#34; // newer version wouldn&#39;t work remote
    },
```

Consulting The Sage (aka Debugger), it advised the wizard of the message sent to The Compiler.

![Debug Variables](/images/2021-08-03-14.52.18-debug-variables.png &#34;Debug Variables&#34;)

The wizard had a revelation.
A fellow wizard advised to break the appending into individual statements instead of trying to do so much in one step.

The incantation changed from:

```go
command = append(command, fmt.Sprintf(`--header &#34;user-id: %s&#34;`, petname.Generate(petNameLength, &#34;-&#34;))
```

to the following:

```go
command = append(command, &#34;--header&#34;)
command = append(command, fmt.Sprintf(`user-id: %s`, petname.Generate(petNameLength, &#34;-&#34;)))
command = append(command, &#34;--max-retry-count&#34;, &#34;5&#34;)
```

The foe vanquished, the _The Blight of Strings_ was cast aside with malice.
The wizard swore to never fall prey to this again.

{{&lt; admonition type=&#34;Note&#34; title=&#34;Further Detail ({{&lt; fa-icon solid  external-link-alt &gt;}} expand to read)&#34; open=false &gt;}}

Josesh[^similar-issues] pointed towards: [EscapeArgs](https://github.com/golang/go/blob/8a7ee4c51e992174d432ce0f40d9387a32d6ee4a/src/syscall/exec_windows.go#L26).
I did not find any equivalent for Darwin.
The closest thing I could find was [execveDarwin](https://github.com/golang/go/blob/8a7ee4c51e992174d432ce0f40d9387a32d6ee4a/src/syscall/exec_unix.go#L303) which I believe is the execution line, which gets the argument list from: [SlicePtrFromStrings](https://github.com/golang/go/blob/8a7ee4c51e992174d432ce0f40d9387a32d6ee4a/src/syscall/exec_unix.go#L284) which is defined at [here](https://github.com/golang/go/blob/8a7ee4c51e992174d432ce0f40d9387a32d6ee4a/src/syscall/exec_unix.go#L86)

I&#39;ll have to re-examine in the future when I have more experience with Go, as it&#39;s not a simple chain to follow. {{&lt; fa-icon solid  brain &gt;}}

```text
[test --param 1]
strings.Join(a)... &#34;test --param 1&#34;
os.Command: [&#34;test&#34; &#34;--param 1&#34;]
echo &#34;test --param 1\n&#34;
```

This pointed towards a similar issue with the `\n` showing up.

{{&lt; fa-icon solid  play &gt;}} [Playground](https://play.golang.org/p/2iNCcDX0dWi)

{{&lt; /admonition &gt;}}

The Compiler&#39;s heartless gaze felt nothing.
In the shadows, _The String Balrock_ bid its time, knowing that the wizard would suffer once again.

![It Works](/images/2021-08-03-goroutine.gif &#34;It Works And Has Pterm Magic&#34;)

&lt;!-- {{&lt; goplay url=&#34;rm9evIsgecS&#34; &gt;}} --&gt;
&lt;!-- https://play.golang.org/p/rm9evIsgecS --&gt;

[^similar-issues]: [2016 // Prevent Escaping exec.Command Arguments in Go | Joseph Spurrier](https://www.josephspurrier.com/prevent-escaping-exec-command-arguments-in-go)

