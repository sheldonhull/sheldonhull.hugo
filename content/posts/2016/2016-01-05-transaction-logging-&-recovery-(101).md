---
date: "2016-01-05T00:00:00Z"
last_modified_at: "2019-02-09"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Transaction Logging & Recovery (101)"
slug: "transaction-logging-&-recovery-(101)"
toc: true
---

Logging & Recovery Notes from SQL Server Logging, Recovery, and the Transaction Log (pluralsight) Paul Randal
Going to share some key points I've found helpful from taking the course by Paul Randal at pluralsight. I've found his knowledge and in detail presentation extremely helpful, and a great way to expand my expertise. Highly recommend pluralsight.com as well as anything by Paul Randal (just be prepared to have your brain turned to mush... he's definitely not writing "how to write a select statement" articles

## Logging & Recovery

_Why is it important to know about this?_

*   One of the most critical components to how SQL server works and provides the Durability in ACID [(Atomicity, Consistency, Isolation, Durability)](http://blog.sqlauthority.com/2007/12/09/sql-server-acid-atomicity-consistency-isolation-durability) is the logging and recovery mechanisms.
*   If log files didn't exist we couldn't guarantee after a crash the integrity of the database. This recovery process ensures after a crash even if the data file hasn't be changed yet (after a checkpoint) that SQL server can reply all the transactions that had been performed and thereby recover to the consistent point, ensuring integrity. This is critical and why we know even with a crash that no transactions will be left "halfway", as we'd require the transactions to be harden to the log file before SQL server would allow the data file to be changed. If this was done in the reverse order of writing to the data file, then if a crash happened, the log file might be out of sync, and you couldn't reply actions that might not have been fully made to the log file as the data file and log file wouldn't be in sync with the transactions noted.
*   The logging & recovery mechanism is actually the backend architecture driving most of the disaster recovery options like Mirroring, Replication, Availability Groups and more. They each have different ways of handling/processing, but underneath, they all rely on utilizing the transaction logs. - Logging = the backbone of sql server.

## Data Files Aren't Changed Immediately

*   Unlike what you might think initially, data files are actually note being written to realtime with transactions. This would be inefficient. Instead, the log is written to, hardened, and then periodic checkpoints (default I believe is 1 minute) take these changes that have been hardened and ensure the changed pages in the buffer (dirty pages at this point) are updated as well.

## Can't get away from transactions

*   Note that all actions occur in transactions. If not explicitly stated, then an implicit transaction is gathered by SQL server in how it handles the action (when dealing with DML). For example, if we alter 2 tables, we could manually set a transaction for each, so if one fails, both were rolled back to the original state, allowing us to commit one table changes even if the other experienced a failure. If we combined both of these statements without defining a transaction then SQL server would imply a transaction, and this might result in a different behavior.

For example:

```sql
    alter table foo
    alter table bar
    GO
    -- if foo failed, then both tables would not be changed, as the transaction itself failed
```

on the other hand the statement below would be promised in SSMS as a batch separator and SQL server would have two separate transaction for each. If one had an error, then the other would still be able to proceed.

```sql
    alter table foo
    GO
    alter table bar
```

## Everything gets logged!

*   Everything has some logging to describe changes in log file (even in simple recovery)
*   Version store & workfile changes in tempdb

## Commitment Issues

Transaction Has Committed

*   Before the transaction can commit, the transaction log file has to be written through to disk. - Once the transaction log is written out to disk, the transaction is considered _durable_
*   If you are using mirroring, the system will stop and wait for the replica/mirror to harden the transaction to the mirror db log file on disk, and then can harden the transaction log to the disk on the primary.
*   The Log file basically represents an exact playback of what changes have been made, so even if the buffer was cleared (removing the pages that were changed in buffer), SQL crashed, or your server went down, SQL server can recover the changes that were made from the log file. This is the "description" of the changes that were made.
