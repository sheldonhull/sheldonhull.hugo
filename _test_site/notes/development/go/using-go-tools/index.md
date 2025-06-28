# Using Go Tools


This is primarily focused on folks who don&#39;t use Go tooling everyday, but want to use the Go tools.
Maybe you need help getting up and running?

## Go Binaries

Tools that can compile to a Go binary, such as CLI tools or a web server, can be installed from source easily by running `go install`.

However, you require a few things to do this.

- Go installed 😀
  - Using aqua makes this easy.
- Although the binaries are dropped into a path, it&#39;s not in your `PATH` by default. Hence, you need to ensure that your shell of choice has this path added for global discovery of the binaries.
  - Ensure binaries can be found. `export PATH=&#34;$(go env GOPATH)/bin:${PATH}&#34;`
- Knowledge of the correct invocation method.

## Setup Path Variables So Go Tooling Can Be Found

=== &#34;linux/darwin&#34;

    ```shell title=&#34;linux (.zshenv, .bashrc, etc)&#34;
    # If using private, then you can set something like this: export GOPRIVATE=dev.azure.com
    export GOPATH=&#34;${HOME}/go&#34;
    export GOBIN=&#34;${HOME}/go/bin&#34;
    export PATH=&#34;${GOBIN}:${PATH}&#34;
    ```

{{&lt; admonition type=&#34;example&#34; title=&#34;windows&#34; open=false &gt;}}

```pwsh title=&#34;windows&#34;
  if ($PSVersionTable.PSEdition -ne &#39;Core&#39;) {
    Write-Warning &#34;Please use PowerShell Core 7&#43; for this to work&#34;
    return
  }
  # If using private, then you can set something like this: [Environment]::SetEnvironmentVariable(&#39;GOPRIVATE&#39;, &#39;dev.azure.com&#39;, &#39;Machine&#39;)
  [Environment]::SetEnvironmentVariable(&#39;GOPATH&#39;, (Join-Path $Home &#39;go&#39;), &#39;Machine&#39;)
  [Environment]::SetEnvironmentVariable(&#39;GOBIN&#39;, (Join-Path $Home &#39;go&#39; &#39;bin&#39;), &#39;Machine&#39;)
  [Environment]::SetEnvironmentVariable(&#39;PATH&#39;, ((Join-Path $Home &#39;go&#39; &#39;bin&#39;), $ENV:PATH -join [IO.Path]::PathSeparator), &#39;Machine&#39;)
  New-Item -Path (Join-Path $Home &#39;go&#39;) -ItemType Directory -Force -EA 0
  Write-Host &#34;Shutdown Terminal and reopen for this to take effect 🙏&#34; -ForegroundColor Green
```

{{&lt; /admonition &gt;}}

