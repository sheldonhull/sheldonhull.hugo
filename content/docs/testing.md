---
title: testing
date: 2020-10-30
published: false
toc: false
summary:
  A cheatsheet test page, as I'm working on improving the formatting and presentation of my cheatsheets
slug: testing
permalink: /docs/testing
comments: true
tags:
  - development
---

:(fas fa-info-circle fa-fw): This is a mix of shell, linux, and macOS commands.
Comments are welcome with any corrections or suggestions.

{{< grid >}}

{{< grid-item >}}

## Install Homebrew

Works on Linux and macOS now 👏.

{{< /grid-item >}}

{{< grid-item >}}

## Ansible Initialization

I use this to bootstrap my macOS system for development. I also plan on using for more docker configuration.

For my mac

```shell
#!/usr/bin/env bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install python3 ansible
```

{{< /grid-item >}}


{{< grid-item >}}

## Shebang

A common pattern is just `#!/bin/bash`.

To make your script more portable, by respecting the users env preferences try:

- `#!/usr/bin/env bash`
- `#!/usr/bin/env zsh`
- `#!/usr/bin/env sh`

{{< admonition type="Abstract" title="bash.cyberciti.biz reference" >}}

Some good info on this from [Shebang](https://bash.cyberciti.biz/guide/Shebang#.2Fusr.2Fbin.2Fenv_bash)

:(fas fa-code fa-fw): If you do not specify an interpreter line, the default is usually the `/bin/sh`

:(fas fa-code fa-fw): For a system boot script, use `/bin/sh`

:(fas fa-code fa-fw): The `/usr/bin/env` run a program such as a bash in a modified environment. It makes your bash script portable. The advantage of #!/usr/bin/env bash is that it will use whatever bash executable appears first in the running user's `$PATH` variable.

{{< /admonition >}}

{{< /grid-item>}}

{{< /grid >}}
