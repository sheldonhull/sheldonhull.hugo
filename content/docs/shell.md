---
title: shell
date: 2020-10-30
toc: true
summary:
  A cheatsheet for some bash stuff. I really ♥️ pwsh... but acknowledge it's not everyone's cup of tea.
  This page helps me get by with being a terrible basher
slug: shell
permalink: /docs/shell
comments: true
tags:
  - development
  - shell
---

:(fas fa-info-circle fa-fw): This is a mix of shell, linux, and macOS commands.
Comments are welcome with any corrections or suggestions.

## Install Homebrew

Works on Linux and macOS now 👏.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

## Ansible Initialization

I use this to bootstrap my macOS system for development.
I also plan on using for more docker configuration.

For my mac

```shell
#!/usr/bin/env bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install python3 ansible
```

For docker/linux

```shell
sudo python3 -m pip install --upgrade pip
CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments python3 -m pip install --user ansible
echo "======== Ansible Version Info ======== "
ansible-galaxy --version
```

### A Few More Ansible Commands

:(fas fa-code fa-fw): Run ansible playbook against a specific tag `ansible-playbook main.yml --inventory inventory --ask-become-pass -t 'ui'`

:(fas fa-code fa-fw): Install requirements `ansible-galaxy collection install community.general && ansible-galaxy install --role-file requirements.yml --force --ignore-errors`

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

## Installing go-task

This tool is great for cross-platform shell scripting as it runs all the commands in the `Taskfile.yml` using a built in go shell library that supports bash syntax (and others).

Quickly get up and running using the directions here: [Install Task](https://github.com/go-task/task/blob/master/docs/installation.md)

```shell
# For Default Installion to ./bin with debug logging
sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d
# For Installation To /usr/local/bin for userwide access with debug logging
# May require sudo sh
sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
```

## Installing Brew Packages

This eliminates any attempt to install if the package already exists.
For quick adhoc installs, this is useful.
I still prefer Ansible for installs.

```shell
#!/usr/bin/env bash

brew update

# Minimize Homebrew updates for each run, speeding things up
export HOMEBREW_NO_AUTO_UPDATE=1
# if linux install script, might want to include this: export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Example of installing with a tap
brew tap lucagrulla/tap
package=cw
brew list $package &>/dev/null || brew install $package

# git-delta needs an updated version, so make sure it's available
package=less
brew list $package &>/dev/null || brew install $package

package=git-delta
brew list $package &>/dev/null || brew install $package

```

## Conditional Pipeline

Only Proceed If First Condition Returns Nothing

```shell
package=cw
brew list $package &>/dev/null || brew install $package
```

## Fetch A GitHub Release

This contains a few things, including curl, jq parsing, and movement commands.

This provides a shell script example of using those to get the latest release from GitHub, parse the json, then move this to target path.
This release doesn't wrap in a tar file; it's just a binary.

This might fail due to anonymous API hits on GitHub api are rate limited heavily.

```shell
#!/usr/bin/env bash

echo "Grabbing latest release of fetch (a github cli for release downloads)"
USER=gruntwork-io
REPO=fetch
TAG=latest
ASSET=fetch_linux_amd64
FILE=fetch
curl --silent "https://api.github.com/repos/$USER/$REPO/releases/latest" \
| jq -r ".assets[] | select(.name | test(\"${ASSET}\")) | .browser_download_url" \
| wget -qi - --output-document=$FILE --progress=bar:force

echo "setting as executable and moving to /usr/local/bin"
chmod +x $FILE
sudo mv fetch /usr/local/bin
echo "Downloaded $(fetch --version) successfully"
```

## Fetch a GitHub Release That Requires Extraction

This is more of a Linux focused shell script example for grabbing a release and extracting the tar file.

```shell
#!/usr/bin/env bash
sudo apt -qqy update
sudo apt -qqy -o Dpkg::Progress-Fancy=true install wget

curl -s https://api.github.com/repos/GitTools/GitVersion/releases/latest \
| grep "browser_download_url.*gitversion\-debian.*\-x64.*\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \" \
| wget -qi -

tarball="$(find . -name "gitversion-debian*.tar.gz")"
tar -xzf $tarball

sudo chmod +x gitversion
sudo mv gitversion /usr/local/bin

sudo rm $tarball
echo ">>>> gitversion version: $(~/gitversion /version)"
echo "Trying to install dotnet tools version"
dotnet tool update --global GitVersion.Tool
# https://github.com/GitTools/GitVersion/releases/download/5.3.6/gitversion-debian.9-x64-5.3.6.tar.gz
```
