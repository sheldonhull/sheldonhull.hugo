---
date: "2015-07-28T00:00:00Z"
tags:
- sql-server
title: "Database Stuck in Single-User Mode Due to Botched Restore"
slug: "database-stuck-in-single-user-mode-due-to-botched-restore"
---

Working in a development environment, I botched up a restore. After this restore attempt to overwrite my database with the previous version, I had it stuck in single-user mode.

SSMS provided me with helpful messages such as this:
`Changes to the state or options of database 'PoorDb' cannot be made at this time. The database is in single-user mode, and a user is currently connected to it.`
Additionally, I was told I was the deadlock victim when attempting to set the user mode back to multi-user.

Going forward I looked at several articles from Stack Overflow and various other blogs, and followed the recommended steps such as

[Gist](https://gist.github.com/sheldonhull/97c73c8ef61c84e6adbb)

I even added a step to kill the connections to it by using this statement, helpfully posted by [Matthew Haugen](http://stackoverflow.com/questions/7197574/script-to-kill-all-connections-to-a-database-more-than-restricted-user-rollback)

[Gist](https://gist.github.com/sheldonhull/252ca75b8e8ab4fe64fa)
 Finally went through and removed all my connections from master based on an additional post. No luck. Stopped my monitoring tools, no luck. At this point, it felt like a Monday for sure.

Since I was working in a development environment, I went all gung ho and killed every session with my login name, as there seemed to be quite a few , except for the spid executing. Apparently, the blocking process was executing from master, probably the incomplete restore that didn't successfully rollback. I'll have to improve my transaction handling on this, as I just ran it straight with no error checks.

# VICTORY!
What a waste of time, but at least I know to watch out next time, ensure my actions are checked for error and rolled back.
I'm going to just blame it on the darn SSMS GUI. Seems like a convenient scapegoat this time.

Successful pushed out my changes with the following script:
[Gist](https://gist.github.com/sheldonhull/a3db2c337d8e5d4f67a7)
