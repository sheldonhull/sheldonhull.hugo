---
title: precommit
date: 2021-06-16
summary: A cheatsheet for various pre-commit hooks and things that help with linting, formatting, code scans and more. These all help "shift left" the review to eliminate more issues in the development workflow, rather than providing feedback only once the CI system is involved.
slug: precommit
permalink: /docs/precommit
comments: true
tags:
  - development
  - devops
  - linting
  - automation
toc:
  enable: true
  keepStatic: false
  auto: true
---

A cheatsheet for various pre-commit hooks and things that help with linting, formatting, code scans and more. These all help "shift left" the review to eliminate more issues in the development workflow, rather than providing feedback only once the CI system is involved.

## The Frameworks

- [GitHub - evilmartians/lefthook: Fast and powerful Git hooks manager for any type of projects.](https://github.com/evilmartians/lefthook/) is a newer project based in Go.
- [pre-commit](https://pre-commit.com/) is python based, very mature and supported.

## Precommit

### Install

A bit more complicated, depending on the Docker image used and the python tooling installed.
Assuming you have pip installed, then this should work.

```shell
pip install pre-commit
```

Here's some examples to get you started.

## Lefthook

This is a newer toolkit, but as it's written in Go and I'm working with Go, this is my current choice.

As long as you have the Go SDK installed, it's as simple as

### Install

```shell
go install github.com/evilmartians/lefthook@master
```

Other installation methods are located at the installation guide [^lefthook-fullguide]

[^lefthook-fullguide]: [lefthook/full_guide.md at master · evilmartians/lefthook · GitHub](https://github.com/evilmartians/lefthook/blob/master/docs/full_guide.md#installation)
