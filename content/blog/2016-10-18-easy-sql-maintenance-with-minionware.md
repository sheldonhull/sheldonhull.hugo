---
date: "2016-10-18T00:00:00Z"
excerpt: Review of using Minionware sql maintenance solution
last_modified_at: "2019-02-21"
tags:
- powershell
- sql-server
title: Easy SQL Maintenance with Minionware
---

> info "Updated 2017-01-25"
> While I think the minionware solution is pretty awesome, I think it takes more work for the value, and can be a bit confusing to correctly setup, vs the Ola Hallengren solution, esp since you can install this quickly with dbatools now. I'd lean towards Ola Hallengren for simple implementations, and consider MinionWare's option if you are looking at the their flexibility in the table based configuration. The learning curve seems higher to me, but more for those looking to tweak options a lot. Both are great solutions, just be aware MinionWare will require a little more digging to leverage it fully.


Here's my personal tweaked settings for deploying [Minionware's fantastic Reindex & Backup jobs.](http://bit.ly/2e8aE8g) In the development environment, I wanted to have some scheduled jobs running to provide a safety net, as well ensure updated statistics, but there were a few default settings I wanted to adjust. In particular, I tweaked the default fill factor back to 0/100. I also installed all the objects to a new "minion" database instead of in master, as I'm beginning to be a fan of isolating these type of maintenance jobs with logging to their own isolated database to easy portability. I also adjusted the default retain days on backups to 30.

![powershell setup of backup](/assets/img/2016-10-10_10-02-32.png)

You can use this template as a guide to help you adjust the default backup settings to fit your environment a little better.
There has been various forms of discussion on the adjustments of Fill Factor for example on the defaults. For more detailed explanation, see Brentozar.com post [An Introduction to Fillfactor in SQL Server](http://bit.ly/2e8c2rq). For my usage, I wanted to leave the fill factors as default, so the install scripts flips these back to my desired settings. I also run the sp_config command to ensure backup compression is enabled to save some space.

Maybe this will help you get up to speed if you want to try out this great solution, but tweak a few defaults.
The ease of installation across multiple instances makes this my current favorite solution, followed by the [fantastic Ola Hallengren solution](http://bit.ly/2e8d9qW).

{{% gist 2fee8ab97c0210918e8fb10719fca3f5 %}}
