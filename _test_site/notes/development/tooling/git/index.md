# git


{{&lt; admonition type=&#34;note&#34; title=&#34;Note&#34; open=true &gt;}}

This is a mix of git, github, azure devops repos, and other workflow tips that help me work more quickly.
Comments are welcome with any corrections or suggestions.

{{&lt; /admonition &gt;}}

## Install Homebrew

Works on Linux and macOS now 👏.

```shell
/bin/bash -c &#34;$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)&#34;
```

Many commands expect powershell, which runs on macOS and Linux as well. Just run `brew install powershell` to grab it and most of this will work without any further changes unless specified.

## Tools I&#39;ve Relied On

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

Everyone has their own brand of craziness with git aliases.

Here&#39;s a few I&#39;ve found helpful.

### Azure DevOps Boards

This one will create an autocompleted ready to go pull request in azure repos using the last commit title and description. If you create your commit correctly for the last one, this will ensure no extra rework required to generate the title and body of the PR, as well as the cleaned up squash message on approval.

Install the Azure CLI and the `devops` extension will be installed automatically upon using: `brew install az`

```shell
az devops configure --defaults organization=https://dev.azure.com/MyOrganization/ project=my-project-name
az devops configure --use-git-aliases
```

```config
# Azure DevOps Repos
new-pr = !pwsh -noprofile -nologo -c &#39;&amp;az repos pr create --title \&#34;$(git log  -1 --pretty=format:\&#34;%s\&#34;)\&#34; --description \&#34;$(git log -1  --pretty=format:\&#34;%b\&#34;)\&#34; --auto-complete true --delete-source-branch true --squash --merge-commit-message \&#34;$(git log  -1 --pretty=format:\&#34;%s\&#34;)\&#34; --output table --open --detect&#39;
```

### General Commit

You only live once...rebase and sync from origin, commit all your changes, and generate a commit message using PowerShell NameIt module.

Install module via: `Install-Module Nameit -Scope CurrentUser`

Install gitversion via: `dotnet tool install --global GitVersion.Tool`

```config
yolo  = !pwsh -noprofile -nologo -c &#39;Import-Module Nameit &amp;&amp; git add . &amp;&amp; git commit -am\&#34;[wip] $(dotnet-gitversion /showvariable FullSemVer) - $((NameIt\\Invoke-Generate &#39;[adjective]-[noun]&#39; -Culture EN).ToLower())\&#34; --no-verify &amp;&amp; git town sync &amp;&amp; git log --oneline -1&#39;
```

For quickly amending the last commit on your own private branch, you can combine these two commands to overwrite your branch with the latest changes instead of versioning.

```config
pushf = !git push --force-with-lease
fixup = !git commit -a --amend --no-edit
```

## Cleanup

| Command                                    | Code                               |
| ------------------------------------------ | ---------------------------------- |
| remove file from git without deleting      | `git rm --cached ./filepath.txt`   |
| remove directory from git without deleting | `git rm --cached -r ./mydirectory` |

### Remove files already committed

```shell
git rm --cached $File
```

## Renaming Branch

If you want to align with GitHub recommended naming of changing `master` to `main`, then this command will help you fix the local branches to correctly point `master` to the remote `main` branch.

```shell
git branch -m master main
git fetch origin
git branch -u origin/main main
```

You can configure this as a VSCode snippet for quick access by including this:

```json
    ,&#34;rename-master-to-main&#34;: {
        &#34;prefix&#34;: &#34;rename-master-to-main&#34;,
        &#34;body&#34;: [
            &#34;git branch -m master main&#34;,
            &#34;git fetch origin&#34;,
            &#34;git branch -u origin/main main&#34;
        ],
        &#34;description&#34;: &#34;rename-master-to-main&#34;
    }
```

## Working With Changes

All the commits the branch has that the master doesn&#39;t. [^first-commit]

```shell
git log master..$(git branch --show-current) --oneline
```

## Cleanup Tags

1. Remove tags on remote first: `git push --no-verify --delete MyTagName`
1. Remove every local tag in your repo: `git tag -d $(git tag)`
1. Pull latest tags: `git fetch origin --prune --prune-tags`

## Forks

- Add remote for fork, typically covered with the `upstream` name: `git remote add upstream {repolink}.
- Reset a forked branch to match the remote upstream resource: `git reset --hard upstream/master`

## Resources

| Source               | Description          |
| -------------------- | -------------------- |
| GitFixUm [^gitfixum] | FlowChart Style Help |

[^first-commit]: [git-how-to-find-first-commit-of-specific-branch](https://stackoverflow.com/questions/18407526/git-how-to-find-first-commit-of-specific-branch)
[^gitfixum]: [GitFixUm](https://sethrobertson.github.io/GitFixUm)

