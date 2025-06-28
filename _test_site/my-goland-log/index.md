# My Goland Log


## Purpose

This is a log of my second journey in using Goland from Jetbrains for Go development.

I&#39;ve got VSCode in a great state.
It&#39;s flexible, powerful, and I&#39;ve highly customized it to my workflow.

However, doing Go development, I&#39;d like to better explore Jetbrains Goland and see if the experience proves positive.

I&#39;ll log updates and issues here as I work through it in the hope that it might provide you better information if you are considering Goland as well.

| Emoji | Definition                                                        |
| ----- | ----------------------------------------------------------------- |
| 🔴     | Not solved yet                                                    |
| 🟠     | Issue or behavior unclear                                         |
| 🚩     | It&#39;s an issue I believe I understand but don&#39;t like the answer to |
| ✅     | Understand and no issues with behavior                            |

## Goland Log

{{&lt; admonition type=&#34;Question&#34; title=&#34;{{&lt; fa-icon solid  vials &gt;}} Testing&#34; open=false &gt;}}

🔴 Not certain yet how to run multi-module repo based tests through project (VSCode supports with experimental flag).

✅ Run individual directory test.
This also generates a run configuration (ephemeral) that can be persisted as a test configuration for the project.

![test output](/images/2021-07-19-goland-test-coverage.png &#34;Test output view is very polished&#34;)

![test coverage on file list](/images/2021-07-19-goland-test-coverage-explorer.png &#34;Test Coverage on file list&#34;)

✅ Toggle auto-run for testing is possible, so upon save, it will run after a 1 second delay.
The built in test renderer is better than VSCode&#39;s Go test output.
Not only does it render the test with color[^vscode-go-testoutput] but also organizes into a nice test explorer view.

Overall, the test output is polished, able to be undocked and run in a separate window.
Works well for a TDD workflow.

![Goland Test Coverage](/images/2021-07-19-goland-test-coverage.png &#34;test coverage&#34;)

@s0xzwasd provided some great insight on the different approach in the comments on this page.
Compound configurations work well to run multiple sets of test when using multiple modules in the same repo.
I tried this, and while tedious to click through the first time, It&#39;s easier to configure from a UI standpoint than trying to work through the VSCode `tasks.json` schema and build tasks by hand.

![Goland Compound Test Coverage Explorer Output](/images/2021-07-21-18.16.07-goland-run-all-tests.png &#34;Compound test coverage&#34;)

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;Question&#34; title=&#34;{{&lt; fa-icon solid  running &gt;}} Run Configurations&#34; open=false &gt;}}

🔴 Not able to set dynamic `$FileDir$` in the run configurations it seems.

🟠 Project configuration resolves path to relative once saved, but displays with absolute.
This is confusing.

✅ Can include configuration in project so anyone that opens in Goland can run the same prebuilt tasks.

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;Question&#34; title=&#34;{{&lt; fa-icon solid  search &gt;}} Linting&#34; open=false &gt;}}

🟠 Working on `golangci-lint` integration.
There is an extension and I&#39;ve also configured the FileWatcher to run on save, but neither is working as seamlessly as VSCode setting as the `gopls` linter tool.

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;Question&#34; title=&#34;{{&lt; fa-icon solid  fas fa-tools &gt;}} Refactoring &amp; Fixes&#34; open=false &gt;}}

🟠 Can&#39;t find a way to assign intentions to a keyboard shortcut.
For example, `Add a Go Comment header` requires a click on a lightbulb icon, and can&#39;t find a way to allow this to be triggered by a keyboard shortcut.

{{&lt; /admonition &gt;}}

[^vscode-go-testoutput]: vscode is requires `-nocolor` type argument to avoid console escaping if using a library that uses color.

