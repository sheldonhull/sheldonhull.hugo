# Azure Data Studio SQL Notebook for Diagnostic Queries


## Diagnostic Queries

Glenn Berry has long been known for producing the definitive diagnostic query set for various SQL Server versions. Between his amazing work and my favorite Brent Ozar First Responder Kit, you are pretty much set.

One of the things that can be painful though about running diagnostic queries is that it&#39;s a lot of small individual queries that you want to run and ideally save the results for review.

You can do this with dbatools and running queries individually, which is actually what I did a while back for a special support tool that dynamically split those queries into files and exported to xml for later import and review.

## Azure Data Studio

I&#39;m a big fan of Azure Data Studio and as I&#39;m not primarily focused right now on SQL Server administration, the feature-set perfectly fits my needs for running queries, doing some basic server administration, and overall just having a lighter weight solution to SSMS. Since I migrated to macOS, this provides me a nice cross-platform tool that I can use on Windows or macOS.

A great feature that has been continually improving is the Azure Data Studio notebooks. Not only can you run T-SQL notebooks now, but also PowerShell and python using whatever kernel you desire.

As part of this, you get the benefits of a nice intuitive structure to ad-hoc queries you might want to provide to someone with details on what it means and more. Additionally, the results are cached as part of the JSON so if you save the file and come back later you can review all the results that were pulled (and as a plus they render in GitHub viewer too).

## Diagnostic Queries &#43; Azure Data Studio &#43; dbatools = 🎉

To merge the power of all 3 technologies, you can use dbatools to export the diagnostic queries for a targeted SQL server version as an Azure Data Studio Notebook. Pretty freaking cool.

To get started on this just make sure you have the latest dbatools: `Install-Module dbatools -confirm:$false`

Then generate a new Azure Data Studio Notebook like this:

```powershell
# This will create the notebook in whatever location you currently are in
$Version = 2017
New-DbaDiagnosticAdsNotebook -Path &#34;DiagnosticNotebook${Version}.ipynb&#34; -TargetVersion $Version
```

Open up this new notebook and enjoy the result! To make reading easier, you can issue the command to &#34;collapse all cells&#34; and the queries will be minimized allowing you to read through all the query options.

Note that even the description of the queries is provided in the notebook, providing insight on the purpose of the query.

{{&lt; admonition type=&#34;warning&#34; title=&#34;Warning&#34; &gt;}}

As always, make sure you are careful before just running all queries by default against a production server.
Some queries take heavy resources and might not be appropriate to run in the middle of a production workflow.

{{&lt; /admonition &gt;}}

![Shows the diagnostic query view in Azure Data Studio](/images/2020-06-23_13-23-07_azure_data_studio.png &#34;Azure Data Studio Diagnostic Queries&#34;)

