---
date: "2016-04-27T00:00:00Z"
excerpt: simplify your ssms install
tags:
- automation
- cool-tools
- sql-server
title: "Automating SSMS 2016 Updates & Install"
slug: "automating-ssms-2016-updates-&-install"
---

{{% premonition type="info" title="update 2016-04-27 11:20 - Red Gate SQL Toolkit" %}}
This also is a great help for folks using Red Gate SQL Toolkits. It can help ensure all items are up to date. When a new bundle installer is identified, it would download the new one and you could then trigger the updates of each of the apps you desire, without having to keep run the download later through Red Gate's tool.
{{% /premonition %}}


Figured I'd share a way to automate the SSMS 2016 updates until it gets it's own fancy self updater. I love staying up to date, but with Power BI, SSMS, and others updating monthly or more and not having any automation for keeping up to date, this is something I find a waste of time that I'd rather automate.

## ssms 2016 install

I think this gets a win, as it's by default in a dark theme. If contains the future possibility of dark theme just like Visual Studio, it gets my stamp of hearty approval. According to some social media posts I've read, it's not yet implemented, but bringing the theming and extension capabilities to SSMS is a goal, and some of it should be here soon.

![ssms 2016 install](/images/ssms-2016-install.png)

### currently using 2015 shell

![currently using 2015 shell](/images/currently-using-2015-shell.png)

### Updates applied seperately from sql service packs

Of course, the main benefit to having the SSMS install as it's own installer/update is we can get regular updates and improvements without it having to align with sql server service packs. This should allow Management Studio to have more rapidly developed and improved product with more frequent releases.

![Updates applied seperately from sql service packs](/images/updates-applied-seperately-from-sql-service-packs.png)

### changelog

Finally have a changelog to easily review Sql Management Studio updates. As I recall, previously you had to sort through all the changes with sql bug fixes to find what was updated.
[SQL Management Studio - Changelog (SSMS)](http://bit.ly/23WM6Pd)

![changelog](/images/changelog.png)

## Ketarin to the rescue

Ketarin is one of my favorite tools for automating setup and maintenance of some tedious software products. It takes a little practice to get the hang of it, but it's pretty awesome. It's sort of like a power user version of Ninite. You can automate setup and install of almost anything. The learning curve is not too bad, but to fully leverage you want to benefit from the regex parsing of the webpage to get the download link that changes with version, such as what we might deal with on version changes with SSMS.

### Download latest SSMS Version

[MSDN Installer Location](https://msdn.microsoft.com/en-us/library/mt238290.aspx)
Hopefully, they'll improve the process soon by trimming the size and allowing ssms to autoupdate. Just like Power BI, you have to download the installer for the new version and run the installer to upgrade.
**As a solution in the meantime, you could leverage the power of **[**Ketarin**](http://ketarin.canneverbe.com/)** **
I created a installer package for running the update automatically, so you could have this setup to check upon startup, and then when a download is detected, download the update, and run silent install. Perhaps this will help you if you want to stay up to date.

![Download latest SSMS Version](/images/download-latest-ssms-version.png)

### Ketarin passive install

The version parsing I added into this means you shouldn't need to download the installer unless it detects a new version applied.

![Ketarin passive install](/images/ketarin-passive-install.png)

### Update ready to download and apply

This is what you'd see on computer startup with a fresh update ready and waiting for you.

![Update ready to download and apply](/images/update-ready-to-download-and-apply.png)

### Last setup note

If you setup Ketarin, to make the app portable, copy the jobs.db from appdata folder, into the application folder and restart. This will make it portable so you can actually put this on a USB, clouddrive, or however you want to make it easily usable on other machines.





![red gate sql toolbelt updated automatically with Ketarin](/images/2016-04-27_11-22-24.png)
