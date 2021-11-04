---

date: 2021-07-19T17:23:30-05:00
title: My Goland Log
slug: my-goland-log
summary:
  A post I'll maintain with questions or problems I faced in adopting development in Goland
tags:

- tech
- development
- goland
- golang
toc: true
series: ['goland']

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

## Purpose

This is a log of my second journey in using Goland from Jetbrains for Go development.

I've got VSCode in a great state.
It's flexible, powerful, and I've highly customized it to my workflow.

However, doing Go development, I'd like to better explore Jetbrains Goland and see if the experience proves positive.

I'll log updates and issues here as I work through it in the hope that it might provide you better information if you are considering Goland as well.

| Emoji | Definition                                                        |
| ----- | ----------------------------------------------------------------- |
| 🔴     | Not solved yet                                                    |
| 🟠     | Issue or behavior unclear                                         |
| 🚩     | It's an issue I believe I understand but don't like the answer to |
| ✅     | Understand and no issues with behavior                            |

## Goland Log

{{< admonition type="Question" title=":(fas fa-vials): Testing" open=false >}}

🔴 Not certain yet how to run multi-module repo based tests through project (VSCode supports with experimental flag).

✅ Run individual directory test.
This also generates a run configuration (ephemeral) that can be persisted as a test configuration for the project.

![test output](/images/2021-07-19-goland-test-coverage.png "Test output view is very polished")

![test coverage on file list](/images/2021-07-19-goland-test-coverage-explorer.png "Test Coverage on file list")

✅ Toggle auto-run for testing is possible, so upon save, it will run after a 1 second delay.
The built in test renderer is better than VSCode's Go test output.
Not only does it render the test with color[^vscode-go-testoutput] but also organizes into a nice test explorer view.

Overall, the test output is polished, able to be undocked and run in a separate window.
Works well for a TDD workflow.

![Goland Test Coverage](/images/2021-07-19-goland-test-coverage.png "test coverage")

@s0xzwasd provided some great insight on the different approach in the comments on this page.
Compound configurations work well to run multiple sets of test when using multiple modules in the same repo.
I tried this, and while tedious to click through the first time, It's easier to configure from a UI standpoint than trying to work through the VSCode `tasks.json` schema and build tasks by hand.

![Goland Compound Test Coverage Explorer Output](/images/2021-07-21-18.16.07-goland-run-all-tests.png "Compound test coverage")

{{< /admonition >}}

{{< admonition type="Question" title=":(fas fa-running): Run Configurations" open=false >}}

🔴 Not able to set dynamic `$FileDir$` in the run configurations it seems.

🟠 Project configuration resolves path to relative once saved, but displays with absolute.
This is confusing.

✅ Can include configuration in project so anyone that opens in Goland can run the same prebuilt tasks.

{{< /admonition >}}

{{< admonition type="Question" title=":(fas fa-search): Linting" open=false >}}

🟠 Working on `golangci-lint` integration.
There is an extension and I've also configured the FileWatcher to run on save, but neither is working as seamlessly as VSCode setting as the `gopls` linter tool.

{{< /admonition >}}

{{< admonition type="Question" title=":(fas fas fa-tools): Refactoring & Fixes" open=false >}}

🟠 Can't find a way to assign intentions to a keyboard shortcut.
For example, `Add a Go Comment header` requires a click on a lightbulb icon, and can't find a way to allow this to be triggered by a keyboard shortcut.

{{< /admonition >}}

[^vscode-go-testoutput]: vscode is requires `-nocolor` type argument to avoid console escaping if using a library that uses color.
