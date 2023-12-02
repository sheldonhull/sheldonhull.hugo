---
title: Pre-Commit
tags:
  - go
date: 2023-03-06 14:49
---

## Using Pre-Commit Tooling

Here's how to set up [pre-commit](https://bit.ly/3szdwNf) for Go projects.

1. Install [pre-commit](https://bit.ly/2O9urag) for macOS: `brew install pre-commit` or see directions for curl/other options for WSL, Windows, Linux, etc.
1. Use the template from [TekWizely/pre-commit-golang: Pre-Commit hooks for Golang with support for Modules](https://bit.ly/31w3gtk)
   1. Several options are provided for `fmt` oriented commands.
      Comment out any duplicates that do not apply.
1. Finally, initialize the pre-commit hooks in your repo by running: `pre-commit install`

Validate that everything is working by running: `pre-commit run --all-files`

Periodically, you can run `pre-commit autoupdate` to ensure that the latest version of the pre-commit hooks is upgraded.
