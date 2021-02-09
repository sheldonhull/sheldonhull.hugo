---
title: Getting Started with Stream Analytics
slug: getting-started-with-stream-analytics
date: 2020-07-24T19:00:00-05:00
toc: true
summary: If you are a newbie to the world of streaming analytics and need to get
  moving  on parsing some Application Insights this is for you.
featuredImage: /static/images/2019-02-08_18-04-50-stream-analytics-project.png
tags:
  - tech
  - development
  - azure
---

## Resources

| Resources                                                                                                                                                                  |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| If you want a schema reference for the json Application Insights produces // [Azure Application Insights Data Model // Microsoft Docs](http://bit.ly/2S3kFlD)              |
| If you want to visualize last 90 days of App Insight Data with Grafana // [Monitor Azure services and applications using Grafana // Microsoft Docs](http://bit.ly/2S1Kkv9) |

## The Scenario

Application insights is integrated into your application and is sending the results to Azure. In my case, it was blob storage. This can compromise your entire insights history.

Application Insights has some nice options to visualize data, Grafana included among them.
However, the data retention as of this time is still set to 90 days. This means historical reporting is limited, and you'll need to utilize `Continuous Export` in the Application Insights settings to stream out the content into blob storage to

## The process

1. Install Visual Studio Azure Plugin
2. Initialize a new Stream Analytics project in Visual Studio
3. Import some test data
4. (Optional) If using SQL Server as storage for stream analytics then design the schema.
5. Write your stream analytics sql, aka asql.
6. Debug and confirm you are happy with this.
7. Submit job to Azure (stream from now, or stream and backfill)
8. Configure Grafana or PowerBI to connect to your data and make management happy with pretty graphs.

## Install Visual Studio Azure Plugin

I don't think this would have been a feasible learning process without having run this through Visual Studio, as the web portal doesn't provide such a smooth experience.
Highly recommend using Visual Studio for this part.

Learning the ropes through the web interface can be helpful, but if you are exploring the data parsing you need a way to debug and test the results without waiting minutes to simply have a job start.
In addition, you need a way to see the parsed results from test data to ensure you are happy with the results.

## New Stream Analytics Project

![stream analytics project](/images/2019-02-08_18-04-50-stream-analytics-project.png "Stream Analytics In Visual Studio 2017")

## Setup test data

Grab some blob exports from your Azure storage and sample a few of the earliest and the latest of your json, placing into a single json file. Put this in your solution folder called inputs through Windows Explorer. After you've done this, right click on the input file contained in your project and select `Add Local Input`. This local input is what you'll use to debug and test without having to wait for the cloud job. You'll be able to preview the content in Visual Studio just like when you run SQL Queries and review the results in the grid.

## Design SQL Schema

Unique constraints create an index.
If you use a unique constraint, you need to be aware of the following info to avoid errors.

> When you configure Azure SQL database as output to a Stream Analytics job, it bulk inserts records into the destination table. In general, Azure stream analytics guarantees at least once delivery to the output sink, one can still achieve exactly-once delivery to SQL output when SQL table has a unique constraint defined.
Once unique key constraints are set up on the SQL table, and there are duplicate records being inserted into SQL table, Azure Stream Analytics removes the duplicate record.
[Common issues in Stream Analytics and steps to troubleshoot
](http://bit.ly/2Bugzh0)
Using the warning above, create any unique constraints with the following syntax to avoid issues.

```sql
create table dbo.Example (
...
,constraint uq_TableName_internal_id_dimension_name
          unique ( internal_id, dimension_name ) with (IGNORE_DUP_KEY  = on)
```

## Stream Analytics Query

> warning "Design Considerations"
> Pay attention to the limits and also to the fact you aren't writing pure T-SQL in the `asaql` file. It's a much more limited analytics syntax that requires you to simplify some things you might do in TSQL. It does not support all TSQL features. [Stream Analytics Query Language Reference](https://docs.microsoft.com/en-us/stream-analytics-query/stream-analytics-query-language-reference)

Take a look at the [query examples](https://docs.microsoft.com/en-us/azure/azure-monitor/app/code-sample-export-sql-stream-analytics) on how to use `cross apply` and `into` to quickly create Sql Server tables.

## Backfilling Historical Data

When you start the job, the default start job date can be changed.
Use custom date and then provide it the oldest data of your data.
For me this correctly initialized the historical import, resulting in a long running job that populated all the historical data from 2017 and on.

## Configure Grafana or PowerBI

Initially I started with Power BI.
However, I found out that Grafana 5.1 > has data source plugins for Azure and Application insights, along with dashboard to get you started.
I've written on Grafana and InfluxDB in the past and am huge fan of Grafana.
I'd highly suggest you explore that, as it's free, while publishing to a workspace with PowerBI can require a subscription, that might not be included in your current MSDN or Office 365 membership. YMMV.

### Filter Syntax

[Filter Syntax Reference](http://bit.ly/2Uft9bv)

I had to search to find details on the filtering but ended up finding the right syntax for doing partial match searches in the Filter Syntax Reference linked above.
This also provides direct links to their ApiExplorer which allows testing and constructing api queries to confirm your syntax.

If you had a custom metric you were grouping by that was `customEvent\name` then the filter to match something like a save action could be:

```text
startswith(customEvent/name, 'Save')
```

This would match the custom metrics you had saved that might provide more granularity that you'd normally have to specify like:

```text
customEvent/Name eq 'Save(Customer)'
customEvent/Name eq 'Save(Me)'
customEvent/Name eq 'Save(Time)'
customEvent/Name eq 'Save(Tacos)'
```


## Wrap-up

I only did this one project so unfortunately I don't have exhaustive notes this.
However, some of the filter syntax and links were helpful to get me jump started on this and hopefully they'll be useful to anyone trying to get up and running like I had too.
