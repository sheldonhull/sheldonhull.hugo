---
title: git
date: 2021-04-09
toc: true
summary:
  A cheatsheet for some git workflow oriented commands, things I often forget, useful shortcuts and more.
slug: git
permalink: /docs/git
comments: true
tags:
  - development
  - git
  - tech
---

:(fas fa-info-circle fa-fw): This is a mix of git, github, azure devops repos, and other workflow tips that help me work more quickly.
Comments are welcome with any corrections or suggestions.

## Install Homebrew

Works on Linux and macOS now 👏.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

Many commands expect powershell, which runs on macOS and Linux as well.
Just run `brew install powershell` to grab it and most of this will work without any further changes unless specified.

## Tools I've Relied On

### CLI

- [Git-Town](https://bit.ly/2OR6zIf)
- [Bit](https://bit.ly/37F8vu1)

### VSCode

- [Git Graph](https://bit.ly/3pEu8AJ)
- [Git Lens](https://bit.ly/3dBaUcZ)
- [vivaxy/vscode-conventional-commits: 💬Conventional Commits for VSCode.](https://bit.ly/3uI5PoH)

### GitHub

- [GitHub CLI](https://bit.ly/3boywik)

## Git Aliases

Everyone has there own brand of craziness with git aliases.

Here's a few I've found helpful.

### Azure DevOps Boards

This one will create an autocompleted ready to go pull request in azure repos using the last commit title and description.
If you create your commit correctly for the last one, this will ensure no extra rework required to generate the title and body of the PR, as well as the cleaned up squash message on approval.

Install the Azure CLI and the `devops` extension will be installed automatically upon using: `brew install az`

```shell
az devops configure --defaults organization=https://dev.azure.com/MyOrganization/ project=my-project-name
az devops configure --use-git-aliases
```

```config
# Azure DevOps Repos
new-pr = !pwsh -noprofile -nologo -c '&az repos pr create --title \"$(git log  -1 --pretty=format:\"%s\")\" --description \"$(git log -1  --pretty=format:\"%b\")\" --auto-complete true --delete-source-branch true --squash --merge-commit-message \"$(git log  -1 --pretty=format:\"%s\")\" --output table --open --detect'
```

### General Commit

You only live once...rebase and sync from origin, commit all your changes, and generate a commit message using PowerShell NameIt module.

Install module via: `Install-Module Nameit -Scope CurrentUser`

Install gitversion via: `dotnet tool install --global GitVersion.Tool`

```config
yolo  = !pwsh -noprofile -nologo -c 'Import-Module Nameit && git add . && git commit -am\"[wip] $(dotnet-gitversion /showvariable FullSemVer) - $((NameIt\\Invoke-Generate '[adjective]-[noun]' -Culture EN).ToLower())\" --no-verify && git town sync && git log --oneline -1'
```

For quickly ammending the last commit on your own private branch, you can combine these two commands to overwrite your branch with the latest changes instead of versioning.

```config
pushf = !git push --force-with-lease
fixup = !git commit -a --amend --no-edit
```