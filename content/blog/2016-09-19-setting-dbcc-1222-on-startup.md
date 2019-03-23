---
date: "2016-09-19T00:00:00Z"
tags:
- sql-configuration
- sql-server
title: Setting DBCC 1222 on startup
---

The following command is run to gain details on deadlocks.

    DBCC TRACEON (1222,-1)

However, once the SQL instance is restarted this flag is set back to disabled.

![Where to setup the startup trace parameter](/assets/img/2016-08-30_09-57-20.png)
To enable it on the instance upon startup:

1.  Open SQL Configuration Manager
2.  Services > Sql Service Instance > Properties > Startup Parameters
3.  Add the following statement: `-T1222`
4.  Confirm the change by navigating to Advanced > Startup Parameters. This should be grayed out and display the new value that was added at the end with a delimited semicolon.

![Startup Properties Setting for Confirmation](/assets/img/2016-08-30_09-58-08.png)
