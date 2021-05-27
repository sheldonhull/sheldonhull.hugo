---
date: "2016-05-15T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "The Mysterious Black Box of R - For the SQL Server Guy"
slug: "the-mysterious-black-box-of-r-for-the-sql-server-guy"
---

Took a class from Jamey Johnston @ SQLSaturday #516 in Houston. Lots of great information covered. Follow him for a much more detailed perspective on R. [Jamey Johnston  on Twitter @StatCowboy. ](http://bit.ly/1TgtXHr)Did a basic walkthrough of running an R query, and figured I'd share it as it had been a mysterious black box before this. Thanks to Jamey for inspiring me to look at the mysterious magic that is R....

## Setup to Run Query

[Simple-Talk: Making Data Analytics Simpler SQL Server and R](https://www.simple-talk.com/sql/reporting-services/making-data-analytics-simpler-sql-server-and-r/)
This _provided the core code I needed_ to start the process with R, recommend reading the walkthrough for details.
To get started in connecting in RStudio to SQL Server run this command in the RStudio console.

```r
install.packages("RODBC")
```
Verify the library is installed by running from the console

```r
library()
```

## Running Select from View

This was run against [StackOverflow database](http://bit.ly/1smWuTh)

```r
library(RODBC)
startTime1
<- Sys.time() cn <- odbcDriverConnect(connection="Driver={SQL Server Native Client 11.0};server=localhost;database=StackOverflow;trusted_connection=yes;") dataComment <- sqlFetch(cn, 'vw_testcomments', colnames=FALSE,rows_at_time=1000) View(dataComment) endTime1 <- Sys.time() odbcClose(cn) timeRun <- difftime(endTime1,startTime1,units="secs") print(timeRun)
```

 I created a simple view to select from the large 15GB comments table with top(1000)

```sql
USE [StackOverflow]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE view [dbo].[vw_testcomments] as
    select top(10000) * from dbo.Comments as C
GO
```

![Running Select from View](/images/running-select-from-view.png)

## viewing the results of basic query in r studio

![viewing the results of basic query in r studio](/images/viewing-the-results-of-basic-query-in-r-studio.png)

## running R script in PowerBi

![running R script in PowerBi](/images/running-r-script-in-powerbi.png)

## execute r script

![execute r script](/images/execute-r-script.png)

## results preview

![results preview](/images/results-preview.png)

## Visualized in Power Bi

![Visualized in Power Bi](/images/visualized-in-power-bi.png)
