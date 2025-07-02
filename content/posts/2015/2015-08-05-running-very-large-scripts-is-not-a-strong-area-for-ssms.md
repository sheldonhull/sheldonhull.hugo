---
date: "2015-08-05T00:00:00Z"
tags:
- sql-server
title: "Running very large scripts is not a strong area for SSMS"
slug: "running-very-large-scripts-is-not-a-strong-area-for-ssms"
---

## out of memory, argggh!

Am I the only one that has experienced the various out of memory issues with SSMS? Not according to google!

## lovingly crafted in the forges of.. well ... dbforge

I've a huge fan of Devarts products. I've done a review in the past on their SQL Complete addin, which is the single most used tool in my SQL arsenal. It vanquishes nasty unformatted code into a standard lined up format I can easily read. The 100's of options to customize the formatting make it the most customizable formatter I've found for SQL code.
This SQL Complete however, is a plugin for SSMS. It is native in their alternative to Sql Server Management Studio, dbForge Studio. Highly recommend checking this out. It's affordable, especially if you compare against other products that offer less.... and they have a _dark theme_ muaaah!

## execute script that is far too large

I'll post up more detail when time permits on some of the other features, but one noticeably cool feature is the "execute large script" option.

![MyDescription](images/2015.08.05_11h38m13s_016__f6xet0.jpg)

![MyDescription](images/2015.08.05_11h38m43s_022__w7anoj.jpg)
You can see the progress and the update in the output log, but the entire script isn't slowing down your GUI. In fact, you can just putter along and keep coding.

![MyDescription](images/2015.08.05_11h41m18s_000_Collage_cpwuis.jpg)
Other options to accomplish the same thing include executing via SQLCMD, powershell, or breaking things up into smaller files. This just happened to be a pretty convenient option!

## Have I switched?

I haven't switched to using it as my primary development environment because of 2 reasons. Extensions... I do have quite a few that work in SSMS like SSMS Tools, SSMS Toolpack, and some Red Gate functionality. I lose that by switching over to dbForge Studio. Also, some of the keyboard shortcuts like delete line and others I'm so used to aren't in there. Regretably, they don't support importing a color scheme from visual studio, so you lose out on sites like [https://studiostyl.es/](https://studiostyl.es/)
Other than a few minor quibbles like that I'm pretty happy with it. They've done a great job and the skinning of the app is great, giving you the option of dark or light themes.

_Devart apps provided to me for my evaluation, but are not biasing my recommendation._
