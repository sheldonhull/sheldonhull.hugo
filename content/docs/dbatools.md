---
title: "dbatools"
slug: "dbatools"
date: '2019-03-11'
toc: true
summary: A cheatsheet and quick start reference for working with dbatools
permalink: /docs/dbatools/
tags:
  - sql-server
  - development
  - powershell
  - dbatools
comments: true
typora-root-url: ../../static
typora-copy-images-to:  ../../static/images
---

{{< admonition type="info" title="Requests or Suggestions" >}}
If you have any requests or improvements for this content, please comment below. It will open a GitHub issue for chatting further.
I'd be glad to improve with any additional quick help and in general like to know if anything here in particular was helpful to someone.
Cheers! 👍
{{< /admonition >}}

## Setup

```powershell
install-module 'dbatools' -Scope CurrentUser
```

## Database Corruption

{{< gist sheldonhull  92fb73704acfd0c7c1e67308e2dca1f4 >}}

## Configure the Database Default Path

{{< gist sheldonhull  c1869e4a67e5721f6e9807e94cc727da >}}

## Install Dbatools And Restore A Directory of Backups

{{< gist sheldonhull  "f9972f12d4348d754d2659921ffc9b5b" >}}
