---
title: shell
date: 2020-10-30
toc: true
summary:
  A cheatsheet for some bash stuff. I really ♥️ pwsh... but acknowledge it's not everyone's cup of tea.
  This page helps me get by with being a terrible basher
slug: shell
permalink: /docs/shell
comments: true
tags:
  - development
  - shell
---


## Installing go-task

This tool is great for cross-platform shell scripting as it runs all the commands in the `Taskfile.yml` using a built in go shell library that supports bash syntax (and others).

Quickly get up and running using the directions here: [Install Task](https://github.com/go-task/task/blob/master/docs/installation.md)

```shell
# For Default Installion to ./bin with debug logging
sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d
# For Installation To /usr/local/bin for userwide access with debug logging
# May require sudo sh
sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
```
