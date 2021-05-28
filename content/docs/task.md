---
title: task
date: 2020-10-30
toc: true
summary:
  A cheatsheet with snippets for Task a cross-platform task runner alternative to Make.
slug: task
comments: true
tags:
  - development
  - shell
  - task
  - devops
---

## Prerequisites

[Install go-task](https://github.com/go-task/task/blob/master/docs/installation.md)

[Install brew (if not already installed)](https://brew.sh/)

[Install Pre-commit](https://pre-commit.com/#install)



## Common Config Setup

````yaml
version: '3'
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
````



## Common Variable Setup

The following are console escape sequences to provide some nice formatting for the output

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

This is stuff I'd normally paste to get me started on a task file.

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
        echo -e "{{.light_gray}}=== ℹ {{ .reversed }} Variable Info from Task {{ .nocolor }} === "
        echo -e "{{.light_gray}}ARTIFACT_DIRECTORY          {{.nocolor}}: {{ .orange}}{{ .ARTIFACT_DIRECTORY }} {{ .nocolor }}"
        echo -e "{{.light_gray}}DOCKER_BUILDKIT             {{.nocolor}}: {{ .orange}}{{ .DOCKER_BUILDKIT }} {{ .nocolor }}"
        echo -e "{{.light_gray}}AWS_SDK_LOAD_CONFIG         {{.nocolor}}: {{ .orange}}{{ .AWS_SDK_LOAD_CONFIG }} {{ .nocolor }}"
        echo -e "{{.light_gray}}AWS_REGION                  {{.nocolor}}: {{ .orange}}{{ .AWS_REGION }} {{ .nocolor }}"
  test:
    desc: run basic tests against compose projects
    prefix: 🧪
    cmds:
      - |
        echo "todo"
```

## console logging

```yaml
test -f nonexistentfile ||         echo -e "{{.red}}file does not exist: [{{ .NONEXISTENTFILE }}]  {{.nocolor}}"
```

## Pre-Commit

I use this framework to simplify my project linting and checks.

You can load this as a seperate base file by creating it in the same root directory of your project with the name: `Taskfile.precommit.yml` and include it as the base config shows.

```yaml
---
version: '3'
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
        {{if eq OS "windows"}}
        pip install pre-commit || echo -e "{{.light_cyan}} 🔥 you need python installed to run this  {{.nocolor}}"
        {{else}}
        echo "setting up precommit. This requires brew (works on Linux & macOS)"
        echo "if fails install linux brew with following command"
        if brew --version &>/dev/null ; then
          echo -e  "{{.green}} ✅ Command succeeded, validated homebrew installed {{.nocolor}}"
        else
          echo -e "{{.red}} ❗ Command failed. Homebrew not detected {{.nocolor}}"
          echo -e "{{.red}}❗ install homebrew on Linux or macOS (not root) using the following command and try again: {{.nocolor}}"
          echo -e "{{.orange}} /bin/bash -c ""\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"" {{.nocolor}}"
        fi
        export HOMEBREW_NO_AUTO_UPDATE=1
        package=pre-commit
        brew list $package &>/dev/null || brew install $package
        {{end}}

```

