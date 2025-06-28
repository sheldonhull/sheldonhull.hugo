# aqua


## Aqua Overview

A CLI version manager for the discriminating CLI connoisseur, this tool is great to install binaries both at a global level and a project level.
If you are using `asdf`, I highly recommend this as an alternative, with the caveat of it not managing python, ruby, or other runtimes.
It&#39;s focused on CLI development tools, and providing a global or project-level version configuration that automatically installs on demand.

Aqua runs as a proxy for the invoked CLIs, which means it [automatically handles installing the called tool](https://aquaproj.github.io/docs/tutorial/lazy-install) if it&#39;s missing, on demand, further cutting down initial setup time.

You can even use it in [docker images](https://aquaproj.github.io/docs/guides/build-container-image) or CI and have a single version pinned file helping the local and CI tools be similar.

It&#39;s more secure than `asdf` by [default](https://aquaproj.github.io/docs/reference/restriction/#aqua-doesnt-support-running-any-external-commands-to-install-tools).

## Quick Start

[Quick Start](https://aquaproj.github.io/docs/tutorial) includes install commands to setup.

I use curl-based install mostly: [Install](https://aquaproj.github.io/docs/tutorial/#install-aqua)

### &#34;install with brew&#34;

```shell
brew install aquaproj/aqua/aqua
```

### &#34;install with go&#34;

```shell
pwsh -NoLogo -Command &#34;go install github.com/aquaproj/aqua/v2/cmd/aqua@latest&#34;
```

## Update Your Path

### &#34;macOS/Linux&#34;

```shell
export PATH=&#34;${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH&#34;
```

The options below are one for max flexibility in honoring the XDG_Directory standard; the other just assumes `.local`.

```powershell
$ENV:XDG_CONFIG_HOME = $ENV:XDG_CONFIG_HOME ? $ENV:XDG_CONFIG_HOME : (Join-Path $HOME &#39;.config&#39;)
$ENV:XDG_CACHE_HOME = $ENV:XDG_CACHE_HOME ? $ENV:XDG_CACHE_HOME : (Join-Path $HOME &#39;.cache&#39;)
$ENV:XDG_DATA_HOME = $ENV:XDG_DATA_HOME ? $ENV:XDG_DATA_HOME : (Join-Path $HOME &#39;.local&#39; &#39;share&#39;)

$ENV:PATH = ([io.path]::Combine($HOME,&#39;.local&#39;,&#39;share&#39;,&#39;aquaproj-aqua&#39;, &#39;bin&#39;)), $ENV:PATH -join [IO.Path]::PathSeparator
# OR FOR MAX FLEXIBILITY
$ENV:PATH = ([io.path]::Combine($ENV:XDG_DATA_HOME, &#39;aquaproj-aqua&#39;, &#39;bin&#39;)), $ENV:PATH -join [IO.Path]::PathSeparator
```

### &#34;windows&#34;

```powershell
[Environment]::SetEnvironmentVariable(&#39;PATH&#39;, ((Join-Path $ENV:LOCALAPPDATA &#39;aquaproj-aqua&#39; &#39;bin&#39;) , $ENV:PATH -join [IO.Path]::PathSeparator), &#39;Machine&#39;)
```

```powershell
$ENV:PATH = ((Join-Path $ENV:LOCALAPPDATA &#39;aquaproj-aqua&#39; &#39;bin&#39;) , $ENV:PATH -join [IO.Path]::PathSeparator)
```

## Global Tooling Setup

To create these files, navigate to the directory and run `aqua init &amp;&amp; aqua init-policy`.

Run `aqua policy allow &#34;${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua-policy.yaml&#34;` to allow global tooling that&#39;s customized.

### &#34;linux/darwin&#34;

```shell
export PATH=&#34;${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH&#34;
export AQUA_GLOBAL_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua.yaml
# export AQUA_POLICY_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua-policy.yaml
```

### &#34;windows&#34;

```powershell
  $RootLocation = $ENV:AQUA_ROOT_DIR ?? (Join-Path $ENV:XDG_DATA_HOME  &#39;aquaproj-aqua&#39; &#39;bin&#39;) ?? (Join-Path &#34;$HOME/.local/share&#34;  &#39;aquaproj-aqua&#39; &#39;bin&#39;)
  $RootLocationWithBin = Join-Path $RootLocation &#39;bin&#39;
  $ENV:PATH = $RootLocationWithBin, $ENV:PATH -join [IO.Path]::PathSeparator
```

## Example Global Config

Here&#39;s an example of what I drop into the global config for managing my global default for Go and other common CLI tools.

### &#34;aqua.yaml&#34;

```yaml
---
# aqua - Declarative CLI Version Manager
# https://aquaproj.github.io/
checksum:
  enabled: true
  require_checksum: false
registries:
  - type: standard
    ref: v4.15.0 # renovate: depName=aquaproj/aqua-registry
  - name: local
    type: local
    path: registry.yaml
packages:
  - name: golang/go@go1.20.4
    tags: [&#39;first&#39;]
  - name: git-town/git-town@v7.9.0
  - name: golangci/golangci-lint@v1.52.2
  - name: itchyny/gojq@v0.12.12
  - name: dandavison/delta@0.15.1
  - name: junegunn/fzf@0.40.0
  - name: sharkdp/bat@v0.23.0
  - name: magefile/mage@v1.15.0
  - name: starship/starship@v1.14.2
  - name: BurntSushi/ripgrep@13.0.0
  - name: sharkdp/fd@v8.7.0
  - name: x-motemen/ghq@v1.4.2
  - name: helm/helm@v3.12.0
  - name: kubernetes-sigs/kind@v0.19.0
  - name: kubernetes/kubectl
    version: v1.25.2
  - name: Schniz/fnm@v1.33.1
  - name: ajeetdsouza/zoxide@v0.9.1
  - name: miniscruff/changie@v1.12.0
  - name: direnv/direnv@v2.32.3
  # ... more packages here like minikube, charm tooling like gum, etc. All lazy installed `--only-link` or pre-installed with normal `aqua i`.
```

### &#34;registry.yaml&#34;

This is the custom location for packages not in the standard registry.
While I recommend contributing upstream (it&#39;s really simple), sometimes less shareable tools for specific needs make sense to include here.

```yaml
---
packages:
- type: go_install
  name: mage-select
  path: github.com/iwittkau/mage-select
  description: CLI frontend for mage based on promptui.
  search_words:
    - mage
    - module
    - go
- type: github_release
  repo_owner: alihanyalcin
  repo_name: gomup
  link: https://github.com/alihanyalcin/gomup/releases/
  asset: &#39;gomup_{{trimV .Version}}_{{.OS}}_{{.Arch}}.tar.gz&#39;
  description: gomUP is a tool to keep track of outdated dependencies and upgrade them to the latest version. Designed for monorepo Go projects and Go projects that contain multiple modules.
  search_words:
    - gomod
    - module
  replacements:
    darwin: Darwin
    linux: Linux
    windows: Windows
    386: i386
    amd64: x86_64
```

### &#34;aqua-policy.yaml&#34;

Used to allow the custom tooling that aqua can handle outside the standard packages.
For example, custom `cargo install` or `go install` packages.

```yaml
---
# aqua Policy
# https://aquaproj.github.io/docs/tutorial-extras/policy-as-code
registries:
  - type: standard
    ref: semver(&#34;&gt;= 3.0.0&#34;)
  - name: local
    type: local
    path: registry.yaml
packages:
  - registry: standard
  - registry: local
```

## Using With CI

### &#34;azure pipelines&#34;

This is focused on `ubuntu-latest` as the windows agent has some quirks not addressed in this format.
This still uses `pwsh` on the ubuntu agent to avoid me having to rework logic for 2 platforms.

```yaml
- bash: |
    echo &#34;##vso[task.prependpath]${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin&#34;
    export PATH=&#34;${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH&#34;
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.3.0/aqua-installer | bash -s
  displayName: install-aqua
```

```yaml
- pwsh: |
    &amp;curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.1.1/aqua-installer | bash -s -- -v v2.3.6
    try {
      $ENV:PATH = ([io.path]::Combine($HOME,&#39;.local&#39;,&#39;share&#39;,&#39;aquaproj-aqua&#39;, &#39;bin&#39;)), $ENV:PATH -join [IO.Path]::PathSeparator
    }
    catch {
      Write-Warning &#34;Unable to load aqua: $($_.Exception.Message)&#34;
    }
    Write-Host &#34;aqua version: $(&amp; aqua version)&#34;
    &amp;aqua update-aqua
    Write-Host &#34;aqua version (after update): $(&amp; aqua version)&#34;
    $env:PATH = (Join-Path $(aqua root-dir) &#39;bin&#39;), $env:PATH -join [IO.Path]::PathSeparator
    Write-Host &#34;run aqua install --tags first&#34;
    &amp;aqua install --tags first
    Write-Host &#34;install remaining aqua tools&#34;
    aqua install --tags MYCUSTOM TAG # 👈 narrow down what you invoke
    $ENV:PATH = (Join-Path $HOME &#39;.config&#39; @(&#39;aquaproj-aqua&#39;,&#39;bin&#39;)), $ENV:PATH -join [IO.Path]::PathSeparator
    mage # ..... 👈 invoke commands now that things are installed
```

