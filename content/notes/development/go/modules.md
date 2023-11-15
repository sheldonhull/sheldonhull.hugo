---
title: Go Modules
date: 2023-03-06 14:49
---

## What are Go Modules?

Go Modules are primarily a dependency management solution.

A module:

- Is primarily a dependency management tool, not a project organization tool.
- Is imported to get access to public exported members in your own project.
- One module can have `n` binaries produced.
- A module can be used in a monorepo or single CLI tool.

A module doesn't:

- Handle build or binary path metadata.
- Have any relationship to the produced artifacts.

## Module Tips

- Use canconical import path (aka) `github.com/sheldonhull/mygomod` if you want to support `go install` commands.
- Use `mymod.local` if no need to support remote imports or installs.
  - This allows `gofumpt` and tooling to correctly sort the imports from standard library apart from your own imports, without requiring canonical name format.
- Stick with one module in the repo if possible, to simplify tooling, linting, and testing. This is important in monorepos as much of the tooling that uses paths like `go test ./...` will not work with multi-module repos in a project.

## Project & Build Tooling

- Use `devtools.go` to create a list of cli tools that should be installed with Mage.
- Use `tools.go` to put `_ "remotemodulename"` in, and identify clearly that a tool such as Stringer or linters are not dependencies for the primary module, but instead are tooling dependencies.
