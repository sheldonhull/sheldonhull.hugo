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

Ran across this app, and thought was kinda cool.
I've had some issues with Chrome apps showing up correctly in certain macOS windows managers to switch context quickly.

Using this tool, you can generate a standalone electron app bundle to run a webpage in as it's own dedicated window.

It's cross-platform.

For a site like Azure DevOps, you can run:

```powershell
$MYORG = 'foo'
$MYPROJECT = 'bar'
$BOARDNAME = 'bored'
nativefier https://dev.azure.com/$MYORG/$MYPROJECT/_boards/board/t/$BOARDNAME/Backlog%20items/?fullScreen=true ~/$BOARDNAME
```

If redirects for permissions occur due to external links opening, you might have to open the application bundle and edit the url mapping. [GitHub Issue #706](https://github.com/jiahaog/nativefier/issues/706)

```text
 `/Users/$(whoami)/$BOARDNAME/APP-darwin-x64/$BOARDNAME.app/Contents/Resources/app/nativefier.json`.
```

Ensure your external urls match the redirect paths that you need such as below.
I included the standard oauth redirect locations that Google, Azure DevOps, and Microsoft uses.
Add your own such as github to this to have those links open inside the app and not in a new window that fails to recieve the postback.

```json
"internalUrls": "(._?contacts\.google\.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)",
```
