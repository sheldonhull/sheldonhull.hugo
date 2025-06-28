# Go R1 Day 80


## progress

Built a Mage task to handle creation of Azure DevOps pull requests.
Since the tooling out there is primarily around Github, this was useful to help standardize PR creation with autocomplete, conventional commit naming, and other properties that typically require manual changes.
I found a great little TUI components library that simplified using Bubbletea components: [Promptkit](https://github.com/erikgeiser/promptkit).

In addition, noticed some new linting help from golangci-lint for `varnamelen`.

This was useful as it analyzes the brevity of variable names and if the variable name is too short, say 1-3 characters, but the usage extends 20 lines away, it will flag it.
This is good as short variable names are designed for local context, while longer descriptive names provide better readability further away in the code.

[Practical Go: Real world advice for writing maintainable Go programs - Identifier Length](https://dave.cheney.net/practical-go/presentations/qcon-china.html#_identifier_length)

Golangci-lint tool includes this linter: [Varnamelen](https://github.com/blizzy78/varnamelen)

