---
date: 2021-02-23T22:23:00Z
title: Git Workflow With Git Town
slug: git-workflow-with-git-town
summary:
  Improve your git workflow with a few cli tools.
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - tech
  - development
  - blog
  - git
  - devops
toc: true
series: ["Supercharge Your Git Workflow"]
---

## Resources

[Git-Town](https://bit.ly/2OR6zIf)

## Painful But Powerful

Let's get this out of the way.

Git isn't intuitive.

It has quite a bit of a learning curve.

However, with this flexibility comes great flexibility.
This tool has powered so much of modern open-source development.

## Optimize for the Pain

To improve the development experience some tools can help provide structure.

This won't be an attempt to compare every git GUI, or push any specific tooling.
It's more sharing my experience and what I've found helps accelerate my usage.

## Tools I've Relied On

- [Git-Town](https://bit.ly/2OR6zIf)
- [Bit](https://bit.ly/37F8vu1)
- [GitHub CLI](https://bit.ly/3boywik)
- [Git Graph](https://bit.ly/3pEu8AJ)
- [Git Lens](https://bit.ly/3dBaUcZ)

I'm not going to go into full detail on each, but check these out to help expedite your workflow.

## The Challenge In Keeping Up To Date With Main

I use what's normally called `trunk-based` development.
This entails regularly moving commits from branches into the main branch, often rebasing while maintaining it in a functional state.

I'll create a feature branch, bug fix, or refactor branch and then merge this to `main` as soon as functional.

I prefer a rebase approach on my branches, and when many ci/fix type commits, to squash this into a single unit of work as the results of the PR.
This can result in "merge hell" as you try rebase on a busy repo.

## Enter Git Town

This tool solves so many of the basic workflow issues, that it's become one of the most impactful tools to my daily work.

{{< admonition type="Tip" title="Enable Aliases" closed=false >}}
The examples that follow use `git sync`, `git hack feat/new-feature`, etc as examples because I've run the command `git-town alias true` which enables the alias configuration for git town, reducing verbosity.
Instead of `git town sync`, you can run `git sync`.
{{< /admonition >}}

### Example 1: Create a Branch for a New Unit of Work While You Are Already On Another Branch

Normally this would require:

1. Stash/Push current work
1. Checkout master
1. Fetch latest and pull with rebase
1. Resolve any conflicts from rebase
1. Create the new branch from main
1. Switch to the new branch

With Git Town

1. `git hack feat/new-feature`

### Example 2: Sync Main

The following steps would be performed by: `git sync`

```text
[master] git fetch --prune --tags
[master] git add -A
[master] git stash
[master] git rebase origin/master
[master] git push --tags
[master] git stash pop
```

### Example 3: New Branch From Main

Easy to quickly ensure you are up to date with remote and generate a new branch with your current uncommitted changes.

```powershell
git town hack fix/quick-fix
```

```text
[master] git fetch --prune --tags
[master] git add -A
[master] git stash
[master] git rebase origin/master
[master] git branch feat/demo-feature master
[master] git checkout feat/demo-feature
[feat/demo-feature] git stash pop
```

### Example 4: Quickly Create a PR While On A Branch for Seperate Set of Changes

This workflow is far too tedious to do without tooling like this.

Let's say I'm on a branch doing some work, and then I recognize that another bug, doc improvements, or other change unrelated to my current work would be good to submit.

With git town, it's as simple as:

```powershell
git town hack feat/improve-docs
```

I can stage individual lines using VSCode for this fix if I want to, and then after committing:

```text
[feat/demo-feature] git fetch --prune --tags
[feat/demo-feature] git add -A
[feat/demo-feature] git stash
[feat/demo-feature] git checkout master
[master] git rebase origin/master
[master] git branch feat/demo-feature-2 master
[master] git checkout feat/demo-feature-2
[feat/demo-feature-2] git stash pop
```

```powershell
git town new-pull-request
```

### Example 5: Ship It

When not using a PR-driven workflow, such as solo projects, then you can still branch and get your work over to main to keep a cleaner history with:

```powershell
git town ship
```

This command ensures all the sync features are run, while then initiating a squash of your branch, allow you to edit the squash message, rebase merge this onto main, and finally clean-up the stale branch.

### More Examples

Check out the documentation from the creators: [Git Town Tutorials](https://bit.ly/3kjgsKy)

## Other Cool Features

- Automatically prune stale branches after PR merge when syncing
- Handles perennial branches if you are using Git Flow methodology.
- Extensible for other git providers.
- Rename a local branch + remote branch in a single command
- Handles a lot of edge cases and failures


## Wrap-Up

When using git, leveraging some tooling like this can accelerate your workflow.
I don't think you need to be an expert in git to use this, as it helps simplify many workflows that are just too tedious to be diligent on when running manually.

You can also do much of this with git aliases, but Git Town has a pretty robust feature-set with a testing framework in place, edge condition handling, and it's fast.
Consider using it you'd like to improve your git workflow while simplifying all the effort to do it right.
