---
date: "2016-09-21T00:00:00Z"
tags: ["sql-server"]
title: "SQL 2016 - Configuration Manager Not Showing in Start Menu"
slug: "sql-2016-configuration-manager-not-showing-in-start-menu"
---

> [!info] update+
> 2020-04-29 broken image links removed

Didn't see SQL 2016 Configuration manager in the start menu. Ran a quick search to see if this was a common issue and found an article: [Quick Trick Where is SQL Server](http://thoughtsonopsmgr.blogspot.com/2014/01/quick-trick-where-is-sql-server.html) for SQL 2012I looked and found the SQL Configuration Manager for 2016 in the same location: `C:\Windows\System32\SQLServerManager13.msc`

As I'm running windows 10, the location for the start menu entries were located here: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft SQL Server 2016`

Create a shortcut for SQLServerManager13.msc in the start menu folder and you'll be good to go!

Thanks to @marnixwolf for providing that previous walkthrough that helped me resolve this so quickly.
