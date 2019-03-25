---
date: "2016-11-16T00:00:00Z"
tags:
- powershell
- sql-server
title: Parallel Powershell for Running SQL
---

This is just a quick look. I plan on diving into this in the future more, as I'm still working through some of the changes being made in the main parallel modules I utilize for SQL server. In the meantime, if you are looking for a quick way to leverage some parallel query running, take a look at [PSParallel](http://bit.ly/2gcXl7H). I've avoided Powershell Jobs/Workflow due to limitations they have and the performance penalty I've seen is associated with them.For my choice, I've explored PSParallel & PoshRSJob.
I've found them helpful for running some longer running queries, as I can have multiple threads running across server/database of my choice, with no query windows open in SSMS.
Another great option that is under more active development is [PoshRsJob](http://bit.ly/2gd0aW2). Be clear that this will have a higher learning curve to deal with as it doesn't handle some of the implicit import of external variables that PSParallel does. You'll have to work through more issues initially to understand correctly passing parameters and how the differents scope of runspaces impact updating shared variables (ie, things get deeper with synchronized hashtables and more :-) )
Hope this helps get you started if you want to give parallel query execution a shot. Here's a function using PSParallel to get you started. Let me know if it helps

{{% gist 5bb1a8adea09276c4fd274b5b2900b6a %}}
