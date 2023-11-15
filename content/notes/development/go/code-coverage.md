---
title: Code Coverage
---

## Code Coverage Report

### Codecov

Using codecov works great for Github repos.

### Use gopherbadge

```shell
go install github.com/jpoles1/gopherbadger@master
```

- Set `![gopherbadger-tag-do-not-edit]()` in the readme, and then this gets replaced with a code coverage percentage badge.
- Generate the required code coverage reports using:

```shell
go test ./... -coverprofile ./artifacts/cover.out
go tool cover -html=./artifacts/cover.out -o ./artifacts/coverage.html
gopherbadger -md="README.md,coverage.md" -tags 'unit'
```
