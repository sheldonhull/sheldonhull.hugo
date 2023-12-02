---
title: VSCode Configuration for Go
slug: vscode-configuration-for-go
date: 2023-03-06 14:49
---

## VSCode

### Custom Tasks

#### Default Shells

This ensures that default behavior is processed on each OS by customizing the shell to use.

```json
{
  "version": "2.0.0",
  "presentation": {
    "echo": false,
    "reveal": "always",
    "focus": false,
    "panel": "dedicated",
    "showReuseMessage": true
  },
  "linux": {
    "options": {
      "shell": {
        "executable": "/usr/local/bin/zsh",
        "args": ["-l", "-c"]
      }
    },
    "type": "shell"
  },
  "windows": {
    "options": {
      "shell": {
        "executable": "pwsh"
      }
    },
    "type": "shell"
  },
  "osx": {
    "options": {
      "shell": {
        "executable": "/usr/local/bin/zsh",
        "args": ["-l", "-c"]
      }
    },
    "type": "shell"
  },
  "tasks": []
}
```

#### Run Lint

Add this to your `.vscode/tasks.json` file to get the full linting output in your problems pane.

By default, the `golangci-lint` config includes `--fast` to avoid impacting your editing.

This ensures all tasks that a pre-commit check or CI check will run and provided in the problems panel.

```json
"tasks": [
    {
      "label": "go-lint-all",
      "detail": "This runs the full range of checks and the VSCode problem matcher will pull all of them in. Without this, the default behavior of VSCode is to run with --fast to reduce impact to IDE.",
      "type": "shell",
      "command": "golangci-lint",
      "args": [
        "run",
        "--out-format",
        "colored-line-number"
      ],
      "problemMatcher": [
        "$go"
      ],
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": true,
        "panel": "dedicated",
        "showReuseMessage": true,
        "clear": true
      }
    },
```

## Run Nicely Formatted Test Output

### Tparse

While the testing extension is great, sometimes you might want to see a console summary.
This task uses [Tparse](https://github.com/mfridman/tparse) and provides a nicely formatted summary (including coverage numbers, cached tests, and more).

Install tparse with: `go install github.com/mfridman/tparse@latest`.

To run manually: `GOTESTS='slow' go test ./... -v -cover -json | tparse -all`

```json
{
  "label": "go-test-formatted-output",
  "type": "shell",
  "command": "go",
  "options": {
    "env": {
      "GOTEST": "slow integration",
    }
  },
  "args": [
    "test",
    "./...",
    "-v",
    "-cover",
    "-json",
    "|",
    "tparse",
    "-all"
  ],
  "problemMatcher": []
},
```
