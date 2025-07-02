---
date: "2016-01-08T00:00:00Z"
last_modified_at: "2019-02-09"
tags:
- sql-server
title: "Transaction Logging & Recovery (part 2)"
slug: "transaction-logging-&-recovery-(part-2)"
toc: true
---

Continuation of some notes regarding the excellent content by Paul Randal in [Pluralsight: SQL Server: Logging, Recovery, and the Transaction Log](http://www.pluralsight.com/courses/sqlserver-logging). Please consider supporting his excellent material by using Pluralsight and subscribing to his [blog](http://www.sqlskills.com/blogs/paul/). He's contributed a vast amount to the SQL server community through [SQLSkills](https://www.sqlskills.com/sql-server-resources/)

## Transaction Log File

* The initial size of the log file is the larger of 0.58 MB or 25% of the total data files specified in the create database statement. For example, if you create a database with 4 separate files, it would increase the initial size the log file is set to.
* This would be different if you've changed MODEL database to set the default log and database size.
* The log file physically created must be zero initialized. Note that the benefits of instant file initialization apply to the data file, but the log file still has to be fully zero initialized, so a large log file creation doesn't benefit from instant file initialization. [Previous Post on Enabling File Initialization]([[2015-05-22-enabling-instant-file-initialization]])
--- Examine the errorlog (after you've enabled trace flag 3605,3004) EXEC xp_readerrorlog; GO
* When examining the results, you can see the zeroing of the log file, but not the datafile if you have instant file initialization enabled.

![transaction-log-file_daxina](/images/transaction-log-file_daxina.png)

## Virtual Log Files

* The transaction log is divided into virtual log files. This helps the system manage the log file more efficiently.
* New VLF's are inactive & not used.
* Active VLF's contain the log record activity and can't be reused until they have been noted as available by SQL server.
**My seque based on the fun experience of giant log files.**
* Note: In Brentozar Office Hours Brent talked about the common misconception of SIMPLE VS FULL logging. Most folks (guilty) think that SIMPLE reduces the amount of logging SQL server performs, thereby improving the overall performance. However, in a general sense this is a misconception. Logging, as previously discussed from my previous post on (101), is the core of SQL server, and required for transaction durability. The difference between SIMPLE and FULL is mostly to do with how the transaction log space is marked as available for reuse.
* SIMPLE: after data files are updated and the data file is now consistent with the changes the log has recorded, the transaction logs are now marked as free and available.
* FULL: all the transaction log records, even after hardened to the data file, are still used. This is what can cause the common issue of exponential log file growth with folks not aware of how it works. 300 GB log file on a small database due to now one watching? Been there? This is because the log file will keep appending the log entries overtime, without freeing up space in the existing transaction log, unless some action is taken to let SQL server know the transaction log file space is available for reuse.
* Marking the space as available is done by ensuring you have a solid backup solution in place that is continually backing up the transaction log in the backup set) thereby letting SQL server know that the transaction log has been backed up and space can be reused in the existing log file.
* The normal process would be to ensure you have a full backup, incremental backups, and transaction log backups running on a schedule.> Under the full recovery model or bulk-logged recovery model, if the transaction log has not been backed up recently, backup might be what is preventing log truncation. If the log has never been backed up, you must create two log backups to permit the Database Engine to truncate the log to the point of the last backup. Truncating the log frees space for new log records. To keep the log from filling up again, take log backups frequently.
> [MSDN Troubleshooting a Full Transaction Log](https://msdn.microsoft.com/en-us/library/ms175495.aspx?f=255&MSPPError=-2147217396)

* My past experience was running into this challenge when performing a huge amount of bulk transactions. I ran the space out on a drive because the log files continued to grow with no backups on the log file running. The solution in my particular situation was to take a full backup, change the database recovery to Bulk-logged or SIMPLE, perform the massive changes, then get right back to full-recovery with backup. This helped ensure the log file growth didn't keep escalating (in my case it was the appropriate action, but normally you want to design the size of the transactions to be smaller, and the backup strategy to be continual so you don't run into this issue)
