---
date: "2016-01-13T00:00:00Z"
tags:
- sql-server
title: Verifying Instant File Initialization
---

Ran into a few issues verifying instant file initialization. I was trying to ensure that file initialization was enabled, but found out that running the xp_cmd to execute whoami /priv could be inaccurate when I'm not running it from the account that has the privileges. This means that if my sql service account has different permissions than I do, I could get the incorrect reading on if it is enabled.

Paul Randal covers a [second approach](http://www.sqlskills.com/blogs/paul/follow-on-from-instant-initialization-privilege-checking/) using the sysinternals tool Accesschk, which seems promising. However, in my case, I didn't have permissions to run in the environment was I was trying to check. I found a way to do this by rereading [original article](http://www.sqlskills.com/blogs/paul/how-to-tell-if-you-have-instant-initialization-enabled/) in which Paul Randal demonstrates the usage of trace flags 3004,3605. This provided a very simple way to quickly ensure I was getting the correct results back. For even more detail on this, I highly recommend his Logging, Recovery, and Transaction Log course. I adapted pieces of his script for my quick error check on this issue.

## Successfully Verifying

Successfully added instant file initialization should mean when you review the log you will not have any MDF showing up in the error log for zeroing. I adapted the sql script for reading the error log in a more filtered manner from this post: [SQL Internals Useful Parameters for XP Reader (2014)](http://sqlserver-help.com/2014/12/10/sql-internals-useful-parameters-for-xp_readerrorlog/)

{{% gist f2dddfc8187f6676cd76 %}}


![successfully-verifying_v1khio](/assets/img/successfully-verifying_v1khio.png)
