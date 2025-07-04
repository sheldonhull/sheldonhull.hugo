---
date: "2016-11-18T00:00:00Z"
tags:
- automation
- powershell
- sql-server
title: "Attaching Database Using SMO & Powershell"
slug: "attaching-database-using-smo-and-powershell"
---

Steve Jones wrote a great article on using this automation titled `The Demo Setup-Attaching Databases with Powershell`. I threw together a completed script and modified it for my functionality here. MSDN documentation on the functionality is located here [Server.AttachDatabase Method (String, StringCollection, String, AttachOptions)](http://bit.ly/2fZPypU)I see some definitive room for improvement with some future work on this to display percentage complete and so on, but did not implement at this time.

For the nested error handling I found a great example of handling the error output from: [Aggregated Intelligence: Powershell & SMO-Copy and attach database](http://bit.ly/2fZPrL9). If you don't utilize the logic to handle nested errors your powershell error messages will be generic. This handling of nested error property is a must to be able to debug any errors you run into.
[http://blog.aggregatedintelligence.com/2012/02/powershell-smocopy-and-attach-database.html](http://blog.aggregatedintelligence.com/2012/02/powershell-smocopy-and-attach-database.html)

If you want to see some great example on powershell scripting restores with progress complete and more I recommend taking a look at this post which had a very detailed powershell script example. [SharePoint Script - Restoring a Content Database](http://bit.ly/2fZQGJX)

[Gist](https://gist.github.com/sheldonhull/fe14ed313d1259f0aab7b73c7ce39f6f)
