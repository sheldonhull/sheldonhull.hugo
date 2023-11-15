---
title: aqua
description: A cli version manager for the discriminating cli connoisseur.
date: 2023-04-04 12:56
tags:
  - cli
  - tooling
categories: []
lastmod: 2023-04-04 13:10
---

## Aqua Overview

A cli version manager for the discriminating cli connoisseur, this tool is great to install binaries both at global level and project level.
If you are using `asdf`, I highly recommend this as an alternative, with the caveat of it not managing python, ruby, or other runtimes.
It's focused on cli development tools, and providing a global or project level version configuration that automatically installs on demand.

Aqua runs as a proxy for the invoked cli's, which means it [automatically handles installing the called tool](https://aquaproj.github.io/docs/tutorial/lazy-install) if it's missing on demand, further cutting down initial setup time.

You can even use in [docker images](https://aquaproj.github.io/docs/guides/build-container-image) or CI and have a single version pinned file helping the local and CI tools be similar.

It's more secure than `asdf` by [default](https://aquaproj.github.io/docs/reference/restriction/#aqua-doesnt-support-running-any-external-commands-to-install-tools).

## Quick Start

[Quick Start](https://aquaproj.github.io/docs/tutorial) includes install commands to setup.

I use curl based install mostly: [Install](https://aquaproj.github.io/docs/tutorial/#install-aqua)

=== "install with brew"

      ```shell title="brew install"
      brew install aquaproj/aqua/aqua
      ```
=== "install with go"

      ```shell title="pwsh go install"
      pwsh -NoLogo -Command "go install github.com/aquaproj/aqua/v2/cmd/aqua@latest"
      ```

## Update Your Path

=== "macOS/Linux"

      ```shell title="$HOME/.zshenv"
      export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
      ```

      The options below are one for max flexibility in honoring the XDG_Directory standard, the other just assumes `.local`.

      ```powershell title="$PROFILE"
      $ENV:XDG_CONFIG_HOME = $ENV:XDG_CONFIG_HOME ? $ENV:XDG_CONFIG_HOME : (Join-Path $HOME '.config')
      $ENV:XDG_CACHE_HOME = $ENV:XDG_CACHE_HOME ? $ENV:XDG_CACHE_HOME : (Join-Path $HOME '.cache')
      $ENV:XDG_DATA_HOME = $ENV:XDG_DATA_HOME ? $ENV:XDG_DATA_HOME : ($HOME, '.local', 'share' -join [IO.Path]::DirectorySeparatorChar)

      $ENV:PATH = ([io.path]::Combine($HOME,'.local','share','aquaproj-aqua', 'bin')), $ENV:PATH -join [IO.Path]::PathSeparator
      # OR FOR MAX FLEXIBILITY
      $ENV:PATH = ([io.path]::Combine($ENV:XDG_DATA_HOME, 'aquaproj-aqua', 'bin')), $ENV:PATH -join [IO.Path]::PathSeparator
      ```

=== "windows"

      ```powershell title="Windows: System Environment Variables (Outside Process Scope)"
      [Environment]::SetEnvironmentVariable('PATH', ((Join-Path $ENV:LOCALAPPDATA 'aquaproj-aqua' 'bin') , $ENV:PATH -join [IO.Path]::PathSeparator), 'Machine')
      ```

      ```powershell title="$PROFILE.CurrentUserAllHosts"
      $ENV:PATH = ((Join-Path $ENV:LOCALAPPDATA 'aquaproj-aqua' 'bin') , $ENV:PATH -join [IO.Path]::PathSeparator)
      ```

## Global Tooling Setup

To create these files, navigate to the directory and run `aqua init && aqua init-policy`.

Run `aqua policy allow "${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua-policy.yaml"` to allow global tooling that's customized.

=== "linux/darwin"

    ```shell title="$HOME/.zshenv"
    export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
    export AQUA_GLOBAL_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua.yaml
    # export AQUA_POLICY_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua-policy.yaml
    ```

=== "windows"

    ```powershell title="$PROFILE"
      $RootLocation = $ENV:AQUA_ROOT_DIR ?? (Join-Path $ENV:XDG_DATA_HOME  'aquaproj-aqua' 'bin') ?? (Join-Path "$HOME/.local/share"  'aquaproj-aqua' 'bin')
      $RootLocationWithBin = Join-Path $RootLocation 'bin'
      $ENV:PATH = $RootLocationWithBin, $ENV:PATH -join [IO.Path]::PathSeparator
    ```

## Example Global Config

Here's an example of what I drop into the global config for managing my global default for Go and other common cli tools.

=== "aqua.yaml"

    ```yaml title="${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua.yaml"
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
        tags: ['first']
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

=== "registry.yaml"

    This is the custom location for packages not in the standard registry.
    While I recommend contributing upstream (it's really simple), sometimes less shareable tools for specific needs make sense to include here.

    ```yaml title="${XDG_CONFIG_HOME:-$HOME/.config}/aqua/registry.yaml"
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
      asset: 'gomup_{{trimV .Version}}_{{.OS}}_{{.Arch}}.tar.gz'
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

=== "aqua-policy.yaml"

    Used to allow the custom tooling that aqua can handle outside the standard packages.
    For example, custom `cargo install` or `go install` packages.

    ```yaml title="${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua-policy.yaml"
    ---
    # aqua Policy
    # https://aquaproj.github.io/docs/tutorial-extras/policy-as-code
    registries:
      - type: standard
        ref: semver(">= 3.0.0")
      - name: local
        type: local
        path: registry.yaml
    packages:
      - registry: standard
      - registry: local
    ```

## Using With CI

=== "azure pipelines"

    This is focused on `ubuntu-latest` as the windows agent has some quirks not addressed in this format.
    This still uses `pwsh` on the ubuntu agent to avoid me having to rework logic for 2 platforms.

    ```yaml title="...azure-pipelines.yaml"
    - pwsh: |
        &curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.1.1/aqua-installer | bash -s -- -v v2.3.6
        try {
          $ENV:PATH = ([io.path]::Combine($HOME,'.local','share','aquaproj-aqua', 'bin')), $ENV:PATH -join [IO.Path]::PathSeparator
        }
        catch {
          Write-Warning "unable to load aqua: $($_.Exception.Message)"
        }
        Write-Host "aqua version: $(& aqua version)"
        &aqua update-aqua
        Write-Host "aqua version (after update): $(& aqua version)"
        $env:PATH = (Join-Path $(aqua root-dir) 'bin'), $env:PATH -join [IO.Path]::PathSeparator
        Write-Host "run aqua install --tags first"
        &aqua install --tags first
        Write-Host "install remaining aqua tools"
        aqua install --tags MYCUSTOM TAG # 👈 narrow down what you invoke
        $ENV:PATH = (Join-Path $HOME '.config' @('aquaproj-aqua','bin')), $ENV:PATH -join [IO.Path]::PathSeparator
        mage # ..... 👈 invoke commands now that things are installed
    ```
