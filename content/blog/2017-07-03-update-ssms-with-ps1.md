---
date: "2017-07-03T00:00:00Z"
excerpt: Installing and Updating SSMS with a simple PowerShell script can be a nice
  little timesaver...
last_modified_at: "2019-02-21"
tags:
- sql-server
- powershell
- cool-tools
- tech
title: Update SSMS With PS1
---

> Update "Updated: 2018-03-29"
> Use Chocolatey. This page keeps changing it's structure, so the regex to parse for Ketarin and this PS1 script keep breaking. Updated to latest version as of 2018-03-29, but recommend checking out the [Chocolately Package created for SSMS](https://chocolatey.org/packages/sql-server-management-studio) for this by [flcdrg](https://chocolatey.org/profiles/flcdrg) as chocolately is a much nicer way to keep up to date and more likely long-term to succeed than my gist :-) To use chocolatey (after setup), you only have to use `choco upgrade sql-server-management-studio` which is much easier to remember than using this gist. Still a nice light-weight tool.
> Also, for less overhead, investigate SQL Operations Studio instead of SSMS for those situations you need to run some queries on a machine. Less overhead, size, and complexity for some nice basic SQL Server management functionality (even if it is missing my precious SQL Prompt)


With how many updates are coming out I threw together a script to parse the latest version from the webpage, and then provide a silent update and install if the installed version is out of date with the available version. To adapt for future changes, the script is easy to update. Right now it's coded to check for version 17 (SSMS 2017). I personally use Ketarin, which I wrote about before if you want a more robust solution here: [Automating SSMS 2016 Updates & Install]({% post_url 2016-04-27-automating-ssms-2016-updates-&-install %})

The bat file is a simple way for someone to execute as admin.

Hope this saves you some time. I found it helpful to keep a bunch of developers up to date with minimal effort on their part, since SSMS doesn't have auto updating capability, and thus seems to never get touched by many devs. :-) Better yet adapt to drop the SSMS Installer into a shared drive and have it check that version, so you just download from a central location.

{{% gist 8f2bbd2455fe2f2ba8d41af33525464e %}}
