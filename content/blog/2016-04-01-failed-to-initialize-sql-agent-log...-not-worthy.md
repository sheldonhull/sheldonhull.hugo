---
date: "2016-04-01T00:00:00Z"
tags:
- sql-server
title: "Failed to Initialize SQL Agent Log... not worthy"
slug: "failed-to-initialize-sql-agent-log-not-worthy"
---

Moving system databases in SQL Server takes a bit of practice. I got that again, along with a dose of SQL humility (so tasty!), today after messing up some cleanup with sql agent server log files.

```text
Failed to initialize SQL Agent log (reason: Access is denied).
```

I was creating a sql template when this came about. SQL Server Agent wouldn't start back up despite all the system databases having very little issues with my somewhat brilliant sql commands.
I had moved all my databases to the new drive location, and changed the advanced startup parameters for sql server and SQL Agent... or so I thought.

![Logging location not the same](/images/2016-04-01_18-20-41.png)

I apparently missed the order of operations with SQL Server Agent, and so it was unable to start. MSDN actually says to go into the SQL agent in SSMS to change this, and I thought I was smarter than msdn....

> [MSDN](https://msdn.microsoft.com/en-us/library/ms345408.aspx)
>
> *   Change the SQL Server Agent Log Path
> From SQL Server Management Studio, in Object Explorer, expand SQL Server Agent.
> *   Right-click Error Logs and click Configure.
> *   In the Configure SQL Server Agent Error Logs dialog box, specify the new location of the SQLAGENT.OUT file.
> *   The default location is C:\Program Files\Microsoft SQL Server\MSSQL
> <version data-preserve-html-node="true">.
> <instance_name data-preserve-html-node="true">\MSSQL\Log.
> Found the registry entry and changed here... all fixed!</instance_name></version>

![Fixing in the registry](/images/2016-04-01_18-16-31.png)
I also updated the WorkDirectoryEntry to ensure it matched new paths.

Thanks to this [article](https://blogs.msdn.microsoft.com/sqlserverfaq/2009/06/12/unable-to-start-sql-server-agent/) I was saved some headache. I also learned to read directions more carefully :-)

