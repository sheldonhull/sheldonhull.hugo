---
date: "2016-03-18T00:00:00Z"
tags:
- entity-framework
- sql-server
title: SQL 2012 SP3 and entity framework conflict
---

## the problem

An issue with SQL Server 2012 SP3 was identified that impacted EF4/5 due to additional datatypes in the dll.

    System.EntryPointNotFoundException: Unable to find an entry point named 'SetClrFeatureSwitchMap' in DLL 'SqlServerSpatial110.dll'

## diagnosing

To easily identify the available dll versions of sql server, I ran a quick adhoc bat file.

{% gist 88ff6ce9caa927a27804 %}
 The output returns a simple text file like this:

![](/assets/img/SNAG-0035_pucmdd.jpg)
A post in technet mentioned that the DLL shipped with SP3 could cause these conflicts and if the uninstall didn't clean up the GAC correctly, problems could occur with Entity Framework calls.

> Can confirm in my case it was due to dll shipped in SQL Server SP3.  I had to uninstall the patch but the newer dll was still in the gac so I had to overwrite with the older version using gacutil. ( [Edited by snowcow Thursday, January 14, 2016 12:41 PM](https://social.technet.microsoft.com/Forums/appvirtualization/en-US/72d07fcb-e3cb-45f1-bff5-abeb13adc5f8/entity-framework-cant-make-updates-in-db-missing-entry-point-setclrfeatureswitchmap-in?forum=sqldataaccess) )

# The Fix

In my case, I still needed the current SP3 version, but we wanted to make sure that the app was pointing to the older version to avoid this error.
I apparently needed to point backwards to:  `C:\Windows\assembly\GAC_MSIL\Microsoft.SqlServer.Types\10.0.0.0__89845dcd8080cc91`
Stack Overflow, the golden mecca of programming knowledge, saved the day with a solid answer

> [EF Cannot Update Database](http://stackoverflow.com/a/34431276/68698)
> This forces the EntityFramework to use the version 10 of the SqlServer.Types.dll, which doesn't have the Geometry type apparently. - KdBoer
> When the fix was applied to map the application config to the older version of the Microsoft.SqlServer.Types.dll (in this case 10). Apparently the 2012 SP3 provided some additional functionality in the dll and this had a conflict with Entity Framework 4 for my situation (and according to online posts EF5 also had some issues)
