---
date: "2016-01-20T00:00:00Z"
tags:
- sql-server
title: "Transaction Logging & Recovery (part 3)"
slug: "transaction-logging-&-recovery-(part-3)"
toc: true
---

Continuation of some notes regarding the excellent content by Paul Randal in [Pluralsight: SQL Server: Logging, Recovery, and the Transaction Log](http://www.pluralsight.com/courses/sqlserver-logging).
Please consider supporting his excellent material by using Pluralsight and subscribing to his [blog](http://www.sqlskills.com/blogs/paul/). He's contributed a vast amount to the SQL server community through [SQLSkills](https://www.sqlskills.com/sql-server-resources/) This is my absorbing of key elements that I never had worked through

## Jackalopes Are Real....so are Virtual Log Files

Ever seen a picture of a jackalope?
[Image by Mark Freeman (Jackalope, Grand Canyon North Rim, Oct 07) Creative Commons License](https://www.flickr.com/photos/46357488@N00/1778904004)

This is how I used to feel about Virtual Log Files. Folks were saying things like

*   "Your server may be slowing down because of those darn VLF's".....
*   "Have you checked your VLF count"...
*   "My VLF count was x" and more

Finding clarification on VLF (Virtual Log Files) can be difficult, as what is considered a high count for some may be contradicted by another with another "target VLF count" claim.
Paul Randal unpacks this excellently in his class, providing some great transparency.

![jackalopes-are-real-so-are-virtual-log-files_ibbrwc](/images/jackalopes-are-real-so-are-virtual-log-files_ibbrwc.png)

## Why Should I Care About VLFs?

In an excellent article regarding the performance impact analysis of VLF's, Linchi Shea provides some valuable insight into the impact.
For more detailed analysis & graphs please look at this great article:
[Performance impact: a large number of virtual log files - Part I (2009)](http://sqlblog.com/blogs/linchi_shea/archive/2009/02/09/performance-impact-a-large-number-of-virtual-log-files-part-i.aspx)

1.  Inserts were about 4 times as slow
2.  Updates were about 8 times slower
3.  Deletes were about 5 times slower
4.  Recovery time can be impacted [Slow recovery times and slow performance due to large numbers of Virtual Log Files (2008)](http://blogs.msdn.com/b/grahamk/archive/2008/05/16/slow-recovery-times-and-slow-performance-due-to-large-numbers-of-virtual-log-files.aspx)
5.  Triggers & Log Backups can be slowed down [Tony Rogerson article (2007)](http://sqlblogcasts.com/blogs/tonyrogerson/archive/2007/07/25/sql-2000-yes-lots-of-vlf-s-are-bad-improve-the-performance-of-your-triggers-and-log-backups-on-2000.aspx)

## Virtual Log Files

*   At the beginning of each log file is a header. This is 8kb header that contains settings like autogrowth & size metadata.
*   Active VLF's are not free for usage until they are marked as available when clearing the log (see previous post about backups)
*   When you create a db you have one active VLF file, but as you progress more VLF's will be used.
*   Too few or too many VLF's can cause problems.

### VLF Count

*   You cannot change the number and size of VLF's in a new portion of the transaction log. This is SQL server driven.
*   The VLF size is determined by a formula.
*   For detailed breakdown of the changes that SQL 2014 brought for the VLF algorithm, see this excellent post by Paul Randal: [Important change to VLF creation algorithm in SQL Server 2014 ](http://www.sqlskills.com/blogs/paul/important-change-vlf-creation-algorithm-sql-server-2014/)
Since I'm working with SQL 2014, I found it interesting as the increased VLF count issue that can be impacting to server performance has been greatly improved. Paul's example cited that the number of VLF's in his example would result in 3192 VLF prior to 2014, but with SQL 2014 it decreased down to 455, which is a substantial improvement. Paul indicated that the prior algorithm was designed primarily for around 1997-1980's, when [log files wouldn't be sized as large.](http://www.sqlskills.com/blogs/paul/important-change-vlf-creation-algorithm-sql-server-2014/#comment-643223)
Also note a critical question that he [answers](http://www.sqlskills.com/blogs/paul/important-change-vlf-creation-algorithm-sql-server-2014/): **_COMPATIBILITY LEVEL IS IGNORED BY THE STORAGE ENGINE PROCESSOR_**
This is great information he's shared, as I've found it confusing at times to separate out the Query Engine impact from compatibility level, and understanding this scope of impact can help with assessing possible impact.

### More Detail than You Ever Wanted to Know on VLF's

*   VLF's internally contain log block sizes. 512-60KB.
*   When the log block is filled it must be flushed to disk.
*   Within the log block are the log records.
*   VLF's contain a header. This indicates whether or not the VLF is active or not, LSN, and parity bits.
*   VLF log records support multiple concurrent threads, so the associated transaction records don't have to be grouped.
*   LSN. I've heard the term used, but until you understand the pieces above, the term won't make sense. - Log Sequence Number = VLF Sequence Number : Log Block Number : Log Record
*   They are important as the LSN is stamped on the data file to show the most recent log record it reflects, letting sql server know during crash recovery that recovery needs to occur or not.

### Number of Log Files

This is determine by a formula that has been updated for 2014.

*   Different size growths have different number of VLFs.
*   VLF's don't care about the total size, but instead about the growth.
*   For instance, Above 1 GB growth events on log file will split into 16 new VLF's, 1/16.

### FAQ (I've asked and looked for some answers!)

**Create small log and then expand or create larger log initially? **

> [Paul Randal answered: ](http://www.sqlskills.com/blogs/paul/important-change-vlf-creation-algorithm-sql-server-2014/#comment-811320) No. If I was creating, say a 64 GB log, I'd create it as 8GB then expand in 8GB chunks to 64GB to keep the number of VLFs small. That means each VLF will be 0.5 GB, which is a good size.
> **What is the ideal l number of VLFs?**
> Some key articles I've found for detailed answers on understanding proper VLF count:
>
> 1.  [Transaction Log VLFs - too many or too few (2008)](http://www.sqlskills.com/blogs/kimberly/transaction-log-vlfs-too-many-or-too-few/)
> 2.  [8 Steps to better Transaction Log throughput (2005)](http://www.sqlskills.com/blogs/kimberly/8-steps-to-better-transaction-log-throughput/)
> 3.  [A Busy/Accidental DBA's Guide to Managing VLFs (2009)](http://adventuresinsql.com/2009/12/a-busyaccidental-dbas-guide-to-managing-vlfs/)
> Resources
> 4.  [Brentozar SP_BLITZ will check VLF counts](http://www.brentozar.com/blitz/high-virtual-log-file-vlf-count/)
> **How do I ensure my log file gets marked as available for reuse when in full recovery?**
> Full recovery is required for point-in-time recovery after a failure. This is because every change to data or to database objects are written to the transaction log prior to being committed. These transactions are then written to the data file as SQL Server sees fit after this initial write to disk. The transaction log is a rolling history of all changes in the database and will allow for redo of each transaction in case of failure to rebuild the state of the data at failure. In the case of Full Recovery, the transaction log continues to expand until a checkpoint is issued via a successful transaction log backup. [Top 13 SQL Server Mistakes and Misteps (2012)](http://thesqlagentman.com/2012/03/top-13-sql-server-mistakes-and-missteps-10-default-database-autogrowth-settings/) This great article by Tim Ford should be reviewed, as it's one of the best simple breakdowns of growth issues and prevention that I've read.
