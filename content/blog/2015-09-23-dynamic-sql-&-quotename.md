---
date: "2015-09-23T00:00:00Z"
tags:
- sql-server
title: Dynamic SQL & Quotename
url: dynamic-sql-quotename
---

## Not quite fineprint, but sure feels like it!

Quotename can be a pretty cool function to simplify your dynamic sql, as it can ease some of the escaping of strings.
However, I normally use it for table/column names, and so hadn't ran into a "gotcha" of this function until today.
It's limited to 128 characters, and if you pass in greater than 128 characters will yield a null.
Yep... you could be trying to track down that error for a null string somewhere in your concatenation for a while... only to find out this silent error is occurring.
I'd like to thank [NoSqlSolution](http://nosqlsolution.blogspot.com/2012/07/problems-with-quotename.html) for mentioning this and helping me go back to the other window I had open and rereading it.... I guess sometimes it pays to read the darn BOL.

![not-quite-fineprint-but-sure-feels-like-it-_w3xtwg](/assets/img/not-quite-fineprint-but-sure-feels-like-it-_w3xtwg.png)
