---
title: Easy SQL Maintenance with Minionware
slug: easy-sql-maintenance-with-minionware
date: 2016-10-18T00:00:00Z
toc: true
excerpt: Review of using Minionware sql maintenance solution
tags:
  - powershell
  - sql-server
  - dbatools
---

{{< premonition type="info" title="Updated 2020-07-06" >}}
After a great chat with Sean today (creator), I did see some pretty cool benefits that for those looking for more scalability, will find pretty interesting.

* Backup tuning: based on the size or specific database, use striped backups to enhance performance of backup jobs
* Enterprise edition, centrally manage and report on all backups across all servers.
* Override defaults by just including additional sql files in the InitialLoad configuration. Review the docs for the specifics. This means no need to loop and override like I did below now. Just deploy and your final steps can be setting up your default configuration options.

Overall, great conversation and found out some really cool things about postcode commands that could be PowerShell driven. Definitely worth a further look if you want an alternative to the commonly used Ola Hallengren solution, and especially if you are wanting more table driven configuration options over the need to customize the commands in the agent steps.
{{< /premonition >}}

{{< premonition type="info" title="Updated 2017-01-25" >}}
While I think the minionware solution is pretty awesome, I think it takes more work for the value, and can be a bit confusing to correctly setup, vs the Ola Hallengren solution, esp since you can install this quickly with dbatools now.
I'd lean towards Ola Hallengren for simple implementations, and consider MinionWare's option if you are looking at their flexibility in the table based configuration.
The learning curve seems higher to me, but more for those looking to tweak options a lot. Both are great solutions, just be aware MinionWare will require a little more digging to leverage it fully.
{{< /premonition >}}

Here's my personal tweaked settings for deploying [Minionware's fantastic Reindex & Backup jobs.](http://bit.ly/2e8aE8g) In the development environment, I wanted to have some scheduled jobs running to provide a safety net, as well ensure updated statistics, but there were a few default settings I wanted to adjust.
In particular, I tweaked the default fill factor back to 0/100. I also installed all the objects to a new "minion" database instead of in master, as I'm beginning to be a fan of isolating these type of maintenance jobs with logging to their own isolated database to easy portability.
I also adjusted the default retain days on backups to 30.

![powershell setup of backup](/images/2016-10-10_10-02-32.png)

You can use this template as a guide to help you adjust the default backup settings to fit your environment a little better.
There has been various forms of discussion on the adjustments of Fill Factor for example on the defaults.
For more detailed explanation, see Brentozar.com post [An Introduction to Fillfactor in SQL Server](http://bit.ly/2e8c2rq).
For my usage, I wanted to leave the fill factors as default, so the install scripts flips these back to my desired settings.
I also run the sp_config command to ensure backup compression is enabled to save some space.

Maybe this will help you get up to speed if you want to try out this great solution, but tweak a few defaults.
The ease of installation across multiple instances makes this my current favorite solution, followed by the [fantastic Ola Hallengren solution](http://bit.ly/2e8d9qW).

{{< gist 2fee8ab97c0210918e8fb10719fca3f5 >}}
