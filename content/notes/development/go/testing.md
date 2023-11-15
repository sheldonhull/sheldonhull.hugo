---
title: Go Testing
date: 2023-03-06 14:49
---

## Testing

- Go test will automatically ignore directories and files starting with `.` or `_`, see [go command - cmd/go - pkg.go.dev](https://pkg.go.dev/cmd/go#hdr-Package_lists_and_patterns).

## Gotestsum

Install with: `go install gotest.tools/gotestsum@latest`.

Then run like this: `gotestsum` or try the alternative formats like: `gotestsum --format dots-v2` or `--format pkgname`, or `--format testname`.
