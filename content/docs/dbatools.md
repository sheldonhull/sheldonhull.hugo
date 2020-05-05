---
title: "dbatools"
slug: "dbatools"
date: '2019-03-11'
last_modified_at: '2019-03-11'
toc: true
excerpt: A cheatsheet and quick start reference for working with dbatools
permalink: /docs/dbatools/
tags:
  - sql-server
  - development
  - powershell
comments: true
---

{{< premonition type="info" title="Requests or Suggestions" >}}
If you have any requests or improvements for this content, please comment below. It will open a GitHub issue for chatting further.
I'd be glad to improve with any additional quick help and in general like to know if anything here in particular was helpful to someone.
Cheers! 👍
{{< /premonition >}}

## Setup

```powershell
install-module 'dbatools' -Scope CurrentUser
```

## Database Corruption

{{{< gist 92fb73704acfd0c7c1e67308e2dca1f4 >}}}
