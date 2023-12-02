---
title: Go Testing
date: 2023-03-06 14:49
---

## Testing

- `Go test` will automatically ignore directories and files starting with `.` or `_`. See [go command - cmd/go - pkg.go.dev](https://pkg.go.dev/cmd/go#hdr-Package_lists_and_patterns) for more details.

## Gotestsum

To install `gotestsum`, use: `go install gotest.tools/gotestsum@latest`.

Then run it like this: `gotestsum`. Try the alternative formats like: `gotestsum --format dots-v2`, `--format pkgname`, or `--format testname`, based on your requirements.
