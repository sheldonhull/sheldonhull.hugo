---
date: 2021-01-25T22:19:41Z
title: Nativefier
slug: nativefier
tags:
- tech
- development
- microblog
- cool-tools
---
> [!info] Update 2021-09-20+
> Updated with improved handling using public docker image.
> [!info] Update 2021-05-10+
> Added additional context for setting `internal-urls` via command line.

> [!info] Update 2021-05-13+
> Added docker run commands to simplify local build and run without global install.

Ran across this app, and thought was kinda cool.
I've had some issues with Chrome apps showing up correctly in certain macOS windows managers to switch context quickly.

Using this tool, you can generate a standalone electron app bundle to run a webpage in as it's own dedicated window.

It's cross-platform.

If you are using an app like Azure Boards that doesn't offer a native app, then this can provide a slightly improved experience over Chrome shortcut apps.
You can pin this to your tray and treat it like a native app.

## Docker Setup

> [!note] Optional - Build Locally-
> This step is no longer required per public docker image.
>
> ```powershell
> cd ~/git
> gh repo clone nativefier/nativefier
> cd nativefier
> docker build -t local/nativefier .
> ```

## Docker Build

Highly recommend using docker for the build as it was by far the less complicated.

```powershell
docker run --rm -v ~/nativefier-apps:/target/ local/nativefier:latest --help

$MYORG = 'foo'
$MYPROJECT = 'bar'
$AppName      = 'myappname'
$Platform = ''
switch -Wildcard ([System.Environment]::OSVersion.Platform)
{
    'Win32NT' { $Platform = 'windows' }
    'Unix'    {
                if ($PSVersionTable.OS -match 'Darwin')
                {
                    $Platform = 'darwin';
                    $DarkMode = '--darwin-dark-mode-support'
                }
                else
                {
                    $Platform = 'linux'
                }
            }
    default { Write-Warning 'No match found in switch' }
}
$InternalUrls = '(._?contacts\.google\.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)'
$Url          = "https://dev.azure.com/$MYORG/$MYPROJECT/_sprints/directory?fullScreen=true/"

$HomeDir = "${ENV:HOME}${ENV:USERPROFILE}" # cross platform support
$PublishDirectory = Join-Path "${ENV:HOME}${ENV:USERPROFILE}" 'nativefier-apps'
$PublishAppDirectory = Join-Path $PublishDirectory "$AppName-$Platform-x64"

Remove-Item -LiteralPath $PublishAppDirectory -Recurse -Force
docker run --rm -v  $HomeDir/nativefier-apps:/target/ nativefier/nativefier:latest --name $AppName --platform $Platform $DarkMode --internal-urls $InternalUrls $Url /target/
```

## Running The CLI

For a site like Azure DevOps, you can run:

```powershell
$MYORG = 'foo'
$MYPROJECT = 'bar'
$BOARDNAME = 'bored'
nativefier --name 'board' https://dev.azure.com/$MYORG/$MYPROJECT/_boards/board/t/$BOARDNAME/Backlog%20items/?fullScreen=true ~/$BOARDNAME
```

Here's another example using more custom options to enable internal url authentication and setup an app for a sprint board.

```powershell
nativefier --name "sprint-board" --darwin-dark-mode-support `
  --internal-urls '(._?contacts.google.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)' `
  "https://dev.azure.com/$MYORG/$MYPROJECT/_sprints/directory?fullScreen=true"
  ` ~/sprint-board
```

If redirects for permissions occur due to external links opening, you might have to open the application bundle and edit the url mapping. [GitHub Issue #706](https://github.com/jiahaog/nativefier/issues/706)
This can be done proactively in the `--internal-urls` command line argument shown earlier to bypass the need to do this later.

```text
/Users/$(whoami)/$BOARDNAME/APP-darwin-x64/$BOARDNAME.app/Contents/Resources/app/nativefier.json
```

Ensure your external urls match the redirect paths that you need such as below.
I included the standard oauth redirect locations that Google, Azure DevOps, and Microsoft uses.
Add your own such as github to this to have those links open inside the app and not in a new window that fails to recieve the postback.

```json
"internalUrls": "(._?contacts\.google\.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)",
```
