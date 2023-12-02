---
title: Using Go Tools
date: 2023-04-19 18:12
lastmod: 2023-04-19 18:12
---

This is primarily focused on folks who don't use Go tooling everyday, but want to use the Go tools.
Maybe you need help getting up and running?

## Go Binaries

Tools that can compile to a Go binary, such as CLI tools or a web server, can be installed from source easily by running `go install`.

However, you require a few things to do this.

- Go installed 😀
  - Using aqua makes this easy.
- Although the binaries are dropped into a path, it's not in your `PATH` by default. Hence, you need to ensure that your shell of choice has this path added for global discovery of the binaries.
  - Ensure binaries can be found. `export PATH="$(go env GOPATH)/bin:${PATH}"`
- Knowledge of the correct invocation method.

## Setup Path Variables So Go Tooling Can Be Found

=== "linux/darwin"

    ```shell title="linux (.zshenv, .bashrc, etc)"
    # If using private, then you can set something like this: export GOPRIVATE=dev.azure.com
    export GOPATH="${HOME}/go"
    export GOBIN="${HOME}/go/bin"
    export PATH="${GOBIN}:${PATH}"
    ```

{{< admonition type="example" title="windows" open=false >}}

```pwsh title="windows"
  if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Warning "Please use PowerShell Core 7+ for this to work"
    return
  }
  # If using private, then you can set something like this: [Environment]::SetEnvironmentVariable('GOPRIVATE', 'dev.azure.com', 'Machine')
  [Environment]::SetEnvironmentVariable('GOPATH', (Join-Path $Home 'go'), 'Machine')
  [Environment]::SetEnvironmentVariable('GOBIN', (Join-Path $Home 'go' 'bin'), 'Machine')
  [Environment]::SetEnvironmentVariable('PATH', ((Join-Path $Home 'go' 'bin'), $ENV:PATH -join [IO.Path]::PathSeparator), 'Machine')
  New-Item -Path (Join-Path $Home 'go') -ItemType Directory -Force -EA 0
  Write-Host "Shutdown Terminal and reopen for this to take effect 🙏" -ForegroundColor Green
```

{{< /admonition >}}
