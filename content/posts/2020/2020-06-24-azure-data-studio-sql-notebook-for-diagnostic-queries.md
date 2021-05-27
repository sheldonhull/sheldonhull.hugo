---
date: 2020-06-24T11:00:00.000+00:00
title: Azure Data Studio SQL Notebook for Diagnostic Queries
slug: azure-data-studio-sql-notebook-for-diagnostic-queries
summary: Dbatools has many amazing features. This one is a pretty amazing quick win
  for diagnostic efforts
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- dbatools
- powershell
- cool-tools
- azure-data-studio
- sql-server
---

## Diagnostic Queries

Glenn Berry has long been known for producing the definitive diagnostic query set for various SQL Server versions. Between his amazing work and my favorite Brent Ozar First Responder Kit, you are pretty much set.

One of the things that can be painful though about running diagnostic queries is that it's a lot of small individual queries that you want to run and ideally save the results for review.

You can do this with dbatools and running queries individually, which is actually what I did a while back for a special support tool that dynamically split those queries into files and exported to xml for later import and review.

## Azure Data Studio

I'm a big fan of Azure Data Studio and as I'm not primarily focused right now on SQL Server administration, the feature-set perfectly fits my needs for running queries, doing some basic server administration, and overall just having a lighter weight solution to SSMS. Since I migrated to macOS, this provides me a nice cross-platform tool that I can use on Windows or macOS.

A great feature that has been continually improving is the Azure Data Studio notebooks. Not only can you run T-SQL notebooks now, but also PowerShell and python using whatever kernel you desire.

As part of this, you get the benefits of a nice intuitive structure to ad-hoc queries you might want to provide to someone with details on what it means and more. Additionally, the results are cached as part of the JSON so if you save the file and come back later you can review all the results that were pulled (and as a plus they render in GitHub viewer too).

## Diagnostic Queries + Azure Data Studio + dbatools = 🎉

To merge the power of all 3 technologies, you can use dbatools to export the diagnostic queries for a targeted SQL server version as an Azure Data Studio Notebook. Pretty freaking cool.

To get started on this just make sure you have the latest dbatools: `Install-Module dbatools -confirm:$false`

Then generate a new Azure Data Studio Notebook like this:

```powershell
# This will create the notebook in whatever location you currently are in
$Version = 2017
New-DbaDiagnosticAdsNotebook -Path "DiagnosticNotebook${Version}.ipynb" -TargetVersion $Version
```

Open up this new notebook and enjoy the result! To make reading easier, you can issue the command to "collapse all cells" and the queries will be minimized allowing you to read through all the query options.

Note that even the description of the queries is provided in the notebook, providing insight on the purpose of the query.

{{< admonition type="warning" title="Warning" >}}

As always, make sure you are careful before just running all queries by default against a production server.
Some queries take heavy resources and might not be appropriate to run in the middle of a production workflow.

{{< /admonition >}}

![Shows the diagnostic query view in Azure Data Studio](/images/2020-06-23_13-23-07_azure_data_studio.png "Azure Data Studio Diagnostic Queries")
