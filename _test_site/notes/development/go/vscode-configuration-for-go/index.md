# VSCode Configuration for Go


## VSCode

### Custom Tasks

#### Default Shells

This ensures that default behavior is processed on each OS by customizing the shell to use.

```json
{
  &#34;version&#34;: &#34;2.0.0&#34;,
  &#34;presentation&#34;: {
    &#34;echo&#34;: false,
    &#34;reveal&#34;: &#34;always&#34;,
    &#34;focus&#34;: false,
    &#34;panel&#34;: &#34;dedicated&#34;,
    &#34;showReuseMessage&#34;: true
  },
  &#34;linux&#34;: {
    &#34;options&#34;: {
      &#34;shell&#34;: {
        &#34;executable&#34;: &#34;/usr/local/bin/zsh&#34;,
        &#34;args&#34;: [&#34;-l&#34;, &#34;-c&#34;]
      }
    },
    &#34;type&#34;: &#34;shell&#34;
  },
  &#34;windows&#34;: {
    &#34;options&#34;: {
      &#34;shell&#34;: {
        &#34;executable&#34;: &#34;pwsh&#34;
      }
    },
    &#34;type&#34;: &#34;shell&#34;
  },
  &#34;osx&#34;: {
    &#34;options&#34;: {
      &#34;shell&#34;: {
        &#34;executable&#34;: &#34;/usr/local/bin/zsh&#34;,
        &#34;args&#34;: [&#34;-l&#34;, &#34;-c&#34;]
      }
    },
    &#34;type&#34;: &#34;shell&#34;
  },
  &#34;tasks&#34;: []
}
```

#### Run Lint

Add this to your `.vscode/tasks.json` file to get the full linting output in your problems pane.

By default, the `golangci-lint` config includes `--fast` to avoid impacting your editing.

This ensures all tasks that a pre-commit check or CI check will run and provided in the problems panel.

```json
&#34;tasks&#34;: [
    {
      &#34;label&#34;: &#34;go-lint-all&#34;,
      &#34;detail&#34;: &#34;This runs the full range of checks and the VSCode problem matcher will pull all of them in. Without this, the default behavior of VSCode is to run with --fast to reduce impact to IDE.&#34;,
      &#34;type&#34;: &#34;shell&#34;,
      &#34;command&#34;: &#34;golangci-lint&#34;,
      &#34;args&#34;: [
        &#34;run&#34;,
        &#34;--out-format&#34;,
        &#34;colored-line-number&#34;
      ],
      &#34;problemMatcher&#34;: [
        &#34;$go&#34;
      ],
      &#34;presentation&#34;: {
        &#34;echo&#34;: true,
        &#34;reveal&#34;: &#34;always&#34;,
        &#34;focus&#34;: true,
        &#34;panel&#34;: &#34;dedicated&#34;,
        &#34;showReuseMessage&#34;: true,
        &#34;clear&#34;: true
      }
    },
```

## Run Nicely Formatted Test Output

### Tparse

While the testing extension is great, sometimes you might want to see a console summary.
This task uses [Tparse](https://github.com/mfridman/tparse) and provides a nicely formatted summary (including coverage numbers, cached tests, and more).

Install tparse with: `go install github.com/mfridman/tparse@latest`.

To run manually: `GOTESTS=&#39;slow&#39; go test ./... -v -cover -json | tparse -all`

```json
{
  &#34;label&#34;: &#34;go-test-formatted-output&#34;,
  &#34;type&#34;: &#34;shell&#34;,
  &#34;command&#34;: &#34;go&#34;,
  &#34;options&#34;: {
    &#34;env&#34;: {
      &#34;GOTEST&#34;: &#34;slow integration&#34;,
    }
  },
  &#34;args&#34;: [
    &#34;test&#34;,
    &#34;./...&#34;,
    &#34;-v&#34;,
    &#34;-cover&#34;,
    &#34;-json&#34;,
    &#34;|&#34;,
    &#34;tparse&#34;,
    &#34;-all&#34;
  ],
  &#34;problemMatcher&#34;: []
},
```

