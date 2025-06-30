---
date: "2015-04-28T00:00:00Z"
tags:
- sql-server
title: "Restoring a database that doesn't exist"
slug: "restoring-a-database-that-doesn't-exist"
---

When restoring a database that doesn't exist, say for instance when a client sends a database to you, you can't use the option to restore database, because there is no database matching to restore. To get around this you need to use the Restore Files and Filegroups option and then restore the database.
![Restore database doesn](/images/mRemoteNG_-_X__Copy_Apps_Remote_mRemoteNG-Portable-1.72_confCons.xml-2015-04-28_15_54_07_om8x9n.png)
![Restore files and filegroups](/images/mRemoteNG_-_X__Copy_Apps_Remote_mRemoteNG-Portable-1.72_confCons.xml-2015-04-28_15_53_53_xweny4.png)
Another option I found interesting was the support for loading database hosted on a fileshare. Brentozar has an article on [hosting databases on a NAS](http://www.brentozar.com/archive/2012/01/sql-server-databases-on-network-shares-nas/) that I found interesting. I haven't tried it yet, but think it has a great usage case for dealing with various databases loaded from clients. If you haven't read any material by him... then my question is why are you reading mine? His whole team is da bombiggity.... stop reading my stuff and head on over there!
