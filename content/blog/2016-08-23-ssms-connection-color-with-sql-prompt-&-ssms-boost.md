---
date: "2016-08-23T00:00:00Z"
tags:
- cool-tools
- redgate
- sql-server
title: "SSMS - Connection Color with SQL Prompt & SSMSBoost"
slug: "SSMS - Connection Color with SQL Prompt & SSMSBoost"
---

If you haven't explored the visual color coding of tabs based on pattern matches with SQL Prompt, I'd suggest you check this out. Earlier iterations of Red Gate's SQL Prompt did not change tab color immediately when the connection was changed. Red Gate's tab color could get out of sync occasionally, so I stopped depending on it.

Apparently this has been improved on and my testing now shows that the tab recoloring for connections is changing when the connection is updated immediately. This is a great visual indicator of what your query window is connected to.

![Recolor Tab with SQL Prompt](/images/2016-05-04_12-06-49.png)

![Manage connections tab color matching](/images/2016-05-04_12-07-34.png)

I'm still a fan of SSMSBoost combined with SQLPrompt, but I'm finding myself needing less addins as SQLPrompt has been enhanced. The ease of configuration and setup is a major factor as well.
SSMSboost Preferred connections are great for when needing to quickly context switch between different connections in the same window (and sync with object explorer)

![SSMSBoost Edit preferred connections](/images/2016-05-04_12-10-31.png)

Resulting textbox overlay

![ssmsboost textbox overlay](/images/2016-05-04_12-12-54.png)

### possible improvements for SQLPrompt

1.  I think that SQLPrompt would have some great productivity enhancements by implementing something similar to SSMSBoost preferred connections. [Here is a UserVoice item on it. Add your vote](http://bit.ly/2bisJyr)
2.  SQLPrompt enhancements to synchronize object explorer connections based on the current query window would be another great option. [I created a user voice item on this here.](http://bit.ly/2birZJZ)

Overall, I'm finding myself depending on SQLPrompt more. As a member in the Friend of Redgate program, I've had access to try some of the new beta versions and find the team extremely responsive.

_Disclaimer: as a Friend of Redgate, I'm provided with app for usage, this doesn't impact my review process._

> ####
> [
> SSMSBoost add-in - productivity tools for SSMS 2008 / 2012 / 2014 (Sql Server Management Studio)](http://www.ssmsboost.com/)
>
> Productivity SSMS add-in packed with useful tolls: scripting, sessions, connection management. Plug-in works with SSMS 2008 and SSMS 2012 SQL Server Management Studio: SSMS add-in with useful tools for SQL Server developers
<script data-preserve-html-node="true" async=" src="platform.js" charset="UTF-8"></script>

> ####
> [Code Completion And SQL Formatting In SSMS ' SQL Prompt](http://www.red-gate.com/products/sql-development/sql-prompt/)
>
> Write and format SQL with SQL Prompt's IntelliSense-style code completion, customizable code formatting, snippets, and tab history for SSMS. Try it free
<script data-preserve-html-node="true" async=" src="platform.js" charset="UTF-8"></script>
