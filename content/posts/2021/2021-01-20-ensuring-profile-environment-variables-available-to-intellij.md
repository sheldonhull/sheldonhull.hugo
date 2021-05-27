---
date: 2021-01-20T17:05:12-06:00
title: Ensuring Profile Environment Variables Available to Intellij
slug: ensuring-profile-environment-variables-available-to-intellij
tags:
  - tech
  - development
  - microblog
  - macOS
series: ["getting-started-on-macos"]
---

Open IntelliJ via terminal: ` open "/Users/$(whoami)/Applications/JetBrains Toolbox/IntelliJ IDEA Ultimate.app"`

This will ensure your `.profile`, `.bashrc`, and other profile settings that might be loading some default environment variables are available to your IDE.
For macOS, you'd have to set in the `environment.plist` otherwise to ensure they are available to a normal application.

ref: [OSX shell environment variables – IDEs Support (IntelliJ Platform) | JetBrains](http://bit.ly/3p3BgHy)
