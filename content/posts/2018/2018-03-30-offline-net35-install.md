---
date: "2018-03-30T00:00:00Z"
summary: SQL Server requirements vary based on the version.
last_modified_at: "2019-02-21"
draft: false
tags:
- sql-server
- tech
title: "SQL .NET Requirements"
slug: "offline-net35-install"
toc: true
---

## SQL Server Install Requirements

SQL Server Installation requirements indicate .NET 3.5, 4.0, or 4.6 depending on the version. This is not including SSMS. At this point you shouldn't use SSMS from any SQL ISO. Just install SQL Management Studio directly.

See for more details on this
- [Improvements with SSMS 2016]([[2016-07-12-improvements-with-ssms-2016]])
- [Update SSMS With PS1]([[2017-07-03-update-ssms-with-ps1]])

From a quick review here's what you have regarding .NET requirements for the database engine.

| SQL Version                                                  | .NET Required                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [>= SQL 2016 RC1 (SQL 2017 included)](http://bit.ly/2IdFXsv) | .NET 4.6                                                    |
| [SQL 2014](http://bit.ly/2uxROj5)                            | .NET 3.5 (manual install required)<br />.NET 4.0 (automatic) |
| [SQL 2012](http://bit.ly/2uyUmgH)                            | .NET 3.5 (manual install required)<br />.NET 4.0 (automatic) |

Specifically noted in [SQL 2012-2014 documentation](https://msdn.microsoft.com/library/ms143506.aspx#Anchor_1) is:

> .NET 3.5 SP1 is a requirement for SQL Server 2014 when you select Database Engine, Reporting Services, Master Data Services, Data Quality Services, Replication, or SQL Server Management Studio, and it is no longer installed by SQL Server Setup.

## When .NET 3.5 Install Just Won't Cooperate

If you need to install SQL Server that requires .NET 3.5 things can get a little tricky. This is a core feature with windows, so typically it's just a matter of going to Features and enabling, both in Windows 10 and Windows Server.

However, if you have a tighter GPO impacting your windows update settings, then you probably need to get this whitelisted. If you are on a time-crunch or unable to get the blocking of .NET 3.5 fixed, then you can also resolve the situation by using a manual offline install of .NET 3.5. Even the setup package Microsoft offers has online functionality and thereby typically fails in those situations.

## Offline Approach

Surprisingly, I had to dig quite a bit to find a solution, as the .NET 3.5 installers I downloaded still attempted online connections, resulting in installation failure.

Turns out that to get an offline install correctly working you need a folder from the Windows install image (ISO) located at `sources\sxs`.

Since I wouldn't want to provide this directly here's the basic steps you take.

### Get NetFx3 Cab

1. Download ISO of Windows 10 (I'm guessing the version won't really matter as you just want the contents in one folder)
2. Mount ISO
3. Navigate to: `MountedISO > sources` and copy the `sxs` directory to your location. It should contain `microsoft-windows-netfx3-ondemand-package.cab`. This is the big difference, as the other methods provide an MSI, not the cab file.

### Create Package

Next to create a reusable package

1. Create a directory: `Install35Offline`

2. Copy SXS directory to this

3. Create 2 files. Gist below to save you some time.
    1. Install35Offline.ps1
    2. Install35Offline.bat

[Gist](https://gist.github.com/sheldonhull/954303c02bf1a5e05b45628dada83f9a)

Hopefully this will save you some effort, as it took me a little to figure out how to wrap it all up to make it easy to run.

Packing this up in an internal chocolately package would be a helpful way to fix for any developers needing the help of their local dba wizard, and might even earn you some dev karma.
