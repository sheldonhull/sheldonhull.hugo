---
date: "2016-08-11T00:00:00Z"
tags:
- regex
- sql-server
- cool-tools
title: "Regex With SQL Server - SQLSharp"
slug: "regex-with-sql-server-sql-sharp"
toc: true
---

In the context of my developer machine, I had log files I wanted to parse through. I setup a log library to output the results on a test server to a sql table instead of text files. However, this meant that my "log viewers" that handled regex parsing weren't in the picture at this point. I wanted to parse out some columns from a section of message text, and thought about CLR as a possible tool to help this.Ideally, I wanted to feed the results for analysis easily into power bi, and avoid the need to create code to import and parse out fields. Since I knew the regex values I wanted, I thought this would be a good chance to try out some CLR functionality for the first time with SQL Server 2016 + CLR Regex parsing.
I ran across [SQL#](http://bit.ly/29Gi6AD) and installed. The install was very simple, just downloaded a SQL script and ran it, adding a final "reconfigure" statement to ensure everything was good to go.

## SQLSharp (SQL#)

I used the free version which provided great regex parsing functionality.

![SQLSharp (SQL#)](/images/sqlsharp--sql--.png)

## Simple to use

Constructing the following query parsed the results easily, with no extract coding/import process required.

[Gist](https://gist.github.com/sheldonhull/b067b6d87cda11d70c608298cff8c0d4)

![Simple to use](/images/simple-to-use.png)

## Performance

This was just an isolated 1000 record test, so nothing exhaustive. I compared it to a table function that parsing strings (could probably be optimized more). For the purpose of running a simple log parsing search on 1000 rows it did pretty good!
For better work on parsing of strings, there are detailed postings out there by [Aaron Bertrand](http://bit.ly/29GFZbi), [Jeff Moden](http://bit.ly/29GIbQ0), and others. My scope was specifically focused on the benefit for a dba/developer doing adhoc-type work with Regex parsing, not splitting delimited strings. The focus of most of the articles I found was more on parsing delimited string. However, I'm linking to them so if you are researching, you can be pointed towards so much more in-depth research on a related topic.

![Performance](/images/performance.png)

## Thoughts

The scope of my review is not covering the proper security setup for CLR with production, CLR performance at high scale, or anything that detailed. This was primarily focused on a first look at it. As much as I love creative SQL solutions, there are certain things that fit better in code, not SQL. (heresy?) I believe Regex/advanced string parsing can often be better handled in the application, powershell, or other code with access to regex libraries.
In the case of string parsing for complex patterns that are difficult to match with LIKE pattern matching, this might be a good resource to help someone write a few SQL statements to parse out some log files, adhoc ETL text manipulation, or other text querying on their machine without having to add additional work on importing and setup.
