# task


## Prerequisites

[Install go-task](https://github.com/go-task/task/blob/master/docs/installation.md)

[Install brew (if not already installed)](https://brew.sh/)

[Install Pre-commit](https://pre-commit.com/#install)

{{&lt; admonition type=&#34;warning&#34; title=&#34;Gotchas&#34; open=true &gt;}}

OS-specific limitations exist for Windows.
For instance, without wrapping with a `pwsh -c` command, you might get a failure with `mkdir`.

See prior issue [Command can not be run in Windows · Issue #319 · go-task/task · GitHub](https://github.com/go-task/task/issues/319#issuecomment-626221222) for more information.

{{&lt; /admonition &gt;}}

## Common Config Setup

```yaml
version: &#39;3&#39;
silent: true
output: prefixed
dotenv: [.env]

includes:
  compose: ./Taskfile.compose.yml
  precommit: ./Taskfile.precommit.yml
env:
  AWS_SDK_LOAD_CONFIG: 1
  AWS_REGION: us-east-1
  DOCKER_BUILDKIT: 1
```

## Common Variable Setup

The following are console escape sequences to provide some nice formatting for the output.

```yaml
vars:
  black: \033[:0;30m
  red: \033[:0;31m
  green: \033[:0;32m
  orange: \033[:0;33m
  blue: \033[:0;34m
  purple: \033[:0;35m
  cyan: \033[:0;36m
  light_gray: \033[:0;37m
  dark_gray: \033[:1;30m
  light_red: \033[:1;31m
  light_green: \033[:1;32m
  yellow: \033[:1;33m
  light_blue: \033[:1;34m
  light_purple: \033[:1;35m
  light_cyan: \033[:1;36m
  white: \033[:1;37m
  nocolor: \u001b[0m
  reversed: \u001b[7m
  ARTIFACT_DIRECTORY: ./artifacts/
```

## Common Base Config

This is content I&#39;d typically paste to get started on a task file.

```yaml
tasks:
  default:
    cmds:
      - task: list
  list:
    desc: list tasks
    cmds:
      - task --list
  vars:
    desc: variable output
    cmds:
      - |
        echo -e &#34;{{.light_gray}}=== ℹ {{ .reversed }} Variable Info from Task {{ .nocolor }} === &#34;
        echo -e &#34;{{.light_gray}}ARTIFACT_DIRECTORY          {{.nocolor}}: {{ .orange}}{{ .ARTIFACT_DIRECTORY }} {{ .nocolor }}&#34;
        echo -e &#34;{{.light_gray}}DOCKER_BUILDKIT             {{.nocolor}}: {{ .orange}}{{ .DOCKER_BUILDKIT }} {{ .nocolor }}&#34;
        echo -e &#34;{{.light_gray}}AWS_SDK_LOAD_CONFIG         {{.nocolor}}: {{ .orange}}{{ .AWS_SDK_LOAD_CONFIG }} {{ .nocolor }}&#34;
        echo -e &#34;{{.light_gray}}AWS_REGION                  {{.nocolor}}: {{ .orange}}{{ .AWS_REGION }} {{ .nocolor }}&#34;
  test:
    desc: run basic tests against compose projects
    prefix: 🧪
    cmds:
      - |
        echo &#34;todo&#34;
```

## Console Logging

```yaml
test -f nonexistentfile ||         echo -e &#34;{{.red}}file does not exist: [{{ .NONEXISTENTFILE }}]  {{.nocolor}}&#34;
```

## Pre-Commit

I use this framework to simplify my project linting and checks.

You can load this as a separate base file by creating it in the same root directory of your project with the name: `Taskfile.precommit.yml` and include it as the base config shows.

```yaml
---
version: &#39;3&#39;
silent: true
output: prefixed

tasks:
  run:
    desc: run pre-commit against all files manually
    cmds:
      - pre-commit run --all-files
  autoupdate:
    desc: update the precommit file with latest
    cmds:
      - pre-commit autoupdate
  init:
    desc: ensure precommit tooling is available
    prefix: ⚙️
    cmds:
      - |
        {{if eq OS &#34;windows&#34;}}
        pip install pre-commit || echo -e &#34;{{.light_cyan}} 🔥 you need python installed to run this  {{.nocolor}}&#34;
        {{else}}
        echo &#34;setting up precommit. This requires brew (works on Linux &amp; macOS)&#34;
        echo &#34;if fails install Linux brew with the following command&#34;
        if brew --version &amp;&gt;/dev/null ; then
          echo -e  &#34;{{.green}} ✅ Command succeeded. Homebrew is installed {{.nocolor}}&#34;
        else
          echo -e &#34;{{.red}} ❗ Command failed. Homebrew not detected {{.nocolor}}&#34;
          echo -e &#34;{{.red}}❗ Install homebrew on Linux or macOS (not root) using the following command and try again: {{.nocolor}}&#34;
          echo -e &#34;{{.orange}} /bin/bash -c &#34;&#34;\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)&#34;&#34; {{.nocolor}}&#34;
        fi
        export HOMEBREW_NO_AUTO_UPDATE=1
        package=pre-commit
        brew list $package &amp;&gt;/dev/null || brew install $package
        {{end}}
```

## Install Tool From GitHub Release

Without using any external dependency tooling, here&#39;s a way to add a task that might need to grab a binary, using `jq` and `curl`.

```yaml
init:ci:
  desc: setup tooling for project and download dependencies
  cmds:
    - |
      go mod tidy &amp;&amp; echo -e &#34;{{.green}} ✅ go mod tidy completed{{.nocolor}}&#34;
      go install github.com/goreleaser/goreleaser@latest
      go get github.com/caarlos0/svu  # Semver versioning tool
      mkdir {{ .TOOLS_DIRECTORY }}
      {{if eq OS &#34;windows&#34;}}
      DOWNLOAD_URL=`curl -sL https://api.github.com/repos/restechnica/semverbot/releases/latest | jq -r &#39;.assets[].browser_download_url&#39; | grep &#34;windows&#34;`
      curl -qo tools/sbot -sL $DOWNLOAD_URL
      {{end}}
      {{if eq OS &#34;darwin&#34;}}
      DOWNLOAD_URL=`curl -sL https://api.github.com/repos/restechnica/semverbot/releases/latest | jq -r &#39;.assets[].browser_download_url&#39; | grep &#34;darwin&#34;`
      curl -qo tools/sbot -sL $DOWNLOAD_URL
      chmod &#43;rwx ./tools/sbot
      {{end}}
      {{if eq OS &#34;linux&#34;}}
      DOWNLOAD_URL=`curl -sL https://api.github.com/repos/restechnica/semverbot/releases/latest | jq -r &#39;.assets[].browser_download_url&#39; | grep &#34;linux&#34;`
      curl -qo tools/sbot -sL $DOWNLOAD_URL
      chmod &#43;rwx ./tools/sbot
      {{end}}
      echo -e &#34;{{.green}} ✅ go semverbot downloaded to tools{{.nocolor}}&#34;
```

## Initialize Project Tooling

All projects requiring non-standardized tooling should have this setup in a standard `init` style command that makes it easy to get up and running, assuming that the basic SDK tooling is installed of course. To solve SDK&#39;s and other lower-level tooling, you&#39;ll want to use Docker with Codespaces or other methods to ensure tooling setup is standardized and easy (Ansible, Docker, etc.).

```yaml
init:
  desc: initialize all tooling for ci and developer work locally
  cmds:
    - task: init:dev
    - task: init:ci
init:dev:
  desc: initialize tools for a developer, but not required for CI
  cmds:
    - |
      go install github.com/evilmartians/lefthook@master
      lefthook install
init:ci:
  desc: setup tooling for project and download dependencies
  cmds:
    - |
      go mod tidy &amp;&amp; echo -e &#34;{{.green}} ✅ go mod tidy completed{{.nocolor}}&#34;
      go install github.com/goreleaser/goreleaser@latest
```

This would be how I&#39;d set up a project.

Notice the separation of `ci` and `dev` tooling.

This is important if you don&#39;t want to needlessly add duration to your CI checks.

This will give flexibility to ensure tooling like Lefthook or others aren&#39;t installed by a CI build.

