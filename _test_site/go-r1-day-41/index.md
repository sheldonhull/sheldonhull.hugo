# Go R1 Day 41


## progress

- Enabled Go code coverage for tests in VSCode
- `go install github.com/jpoles1/gopherbadger@master` to install tooling for generating code coverage badge for readme.
- Set `![gopherbadger-tag-do-not-edit]()` in the readme, and then this gets replaced with a code coverage percentage badge.
- Generate the required code coverage reports using: `go test -coverprofile cover.out` followed by `go tool cover -html=cover.out -o coverage.html` for a visual report.

## links

- [GitHub - jpoles1/gopherbadger: Generate coverage badge images using Go!](https://github.com/jpoles1/gopherbadger)

