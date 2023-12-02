---
title: Code Coverage
---

## Code Coverage Report

### Codecov

Codecov works great for Github repositories.

### Use gopherbadge

```shell
go install github.com/jpoles1/gopherbadger@master
```

- Set `![gopherbadger-tag-do-not-edit]()` in the readme. This will be replaced with a code coverage percentage badge.
- Generate the required code coverage reports using:

```shell
go test ./... -coverprofile ./artifacts/cover.out
go tool cover -html=./artifacts/cover.out -o ./artifacts/coverage.html
gopherbadger -md="README.md,coverage.md" -tags 'unit'
```
