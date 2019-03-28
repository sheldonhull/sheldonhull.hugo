---
date: "2016-07-12T00:00:00Z"
excerpt: Improves to SSMS (Sql Server Management Studio) continue. Use the latest
  version instead of using the version bundled in older versions of SQL Server Installation
  media to ensure the latest features are available.
last_modified_at: "2018-03-30"
tags:
- sql-server
title: Improvements with SSMS 2016
---

> info "Updated: 2019-01-24"
> Improved options to install through [Chocolatey package](http://bit.ly/2FYyNdS). Use command `choco upgrade sql-server-management-studio` and you'll simplify the installation process greatly.
> Also for servers, consider Azure Data Studio as much smaller download and might provide what you need to do basic management without a length install and download.

> info "Updated: 2018-03-30"
> Use SSMS 2017 when possible now. It has continued to be improved. [Current download page for SSMS 2017](http://bit.ly/2uvpSMG)
> If you want a shortcut to install, check out this post: [Update SSMS With PS1]({% post_url 2017-07-03-update-ssms-with-ps1 %})

The staple of every SQL Server developer's world, SSMS has been impossible to usurp for the majority of us. However, it's also been behind the development cycle of visual studio, and didn't have continual updates. That changed recently, as I've previously posted on. SSMS (Sql Server Management Studio) now being decoupled from the SQL Server database releases.I've been enjoying some of the improvements, especially as relatest to the built in execution plan viewer. I use SQL Sentry Pro, but for a quick review, any improvements to the default viewer is a welcome addition!

## Live Statistics View

You can see the statistics update as it's running.

![Live Statistics View](/images/live-statistics-view.png)

## Side by Side Comparison of Plans

This is something that is fantastic. A good step in the right direction for helping compare plans quickly. This is a feature I'd love to see added to other tools like SQL Sentry Plan Explorer.  When plans don't vary significantly in their structure, this type of view is great for quickly viewing variances.

![Side by Side Comparison of Plans](/images/side-by-side-comparison-of-plans.png)

## Usability

You can actually drag your mouse to pan a plan... enough said. This should have been there a long time ago.

## comparison of properties

The properties pane also has an overhaul with some really useful comparison information, helping you identify what is now different.

![comparison of properties](/images/comparison-of-properties.png)

## overall

Really liking the improvements I've seen. There are a lot of things about SSMS I'd like to see improved, and with a regular release cycle the future for SSMS looks promising!
I'll be really happy once the Visual Studio dark theme has made it's way over... I swear everything just runs faster with a dark theme ;-)
