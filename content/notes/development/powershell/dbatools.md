---
title: 'dbatools'
slug: 'dbatools'
date: '2019-03-11 12:00'
toc: true
summary: A cheatsheet and quick start reference for working with dbatools
permalink: /notes/dbatools/
tags:
  - sql-server
  - development
  - powershell
  - dbatools
comments: true
typora-root-url: ../../static
typora-copy-images-to: ../../static/images
---

{{< admonition type="info" title="Requests or Suggestions" open=true >}}

If you have any requests or improvements for this content, please comment below. It will open a GitHub issue for chatting further.
I'd be glad to improve with any additional quick help and in general like to know if anything here in particular was helpful to someone.
Cheers! 👍

{{< /admonition >}}

## Setup

```powershell
install-module 'dbatools' -Scope CurrentUser
```

## Database Corruption

<script src="https://gist.github.com/sheldonhull/92fb73704acfd0c7c1e67308e2dca1f4.js"></script>

## Configure the Database Default Path

<script src="https://gist.github.com/sheldonhull/c1869e4a67e5721f6e9807e94cc727da.js"></script>

## Install Dbatools And Restore A Directory of Backups

<script src="https://gist.github.com/sheldonhull/f9972f12d4348d754d2659921ffc9b5b.js"></script>
