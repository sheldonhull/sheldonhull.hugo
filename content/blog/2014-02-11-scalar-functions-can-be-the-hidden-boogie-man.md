---
date: "2014-02-11T00:00:00Z"
tags:
- sql-server
title: Scalar functions can be the hidden boogie man
---

Ran across a comment the other day that scalar functions prohibit parallelism for a query when included. I thought it would be worth taking a look, but didn't take it 100% seriously. Came across the same indication today when reviewing MVP deep dives, so I put it to the test.Turns out even a simple select with a dateadd in a scalar format was affected enough with that one action to drop 5% on the execution plan. When dealing with merge or other processes that would benefit from parallelism, this would become even more pronounced.
Suggest reading "Death by UDF" section by Kevin Boles.
This comment is buried at the very end of the chapter. He indicates

> "One final parting gift: scalar UDFs also void the use of parallel query plans, which is why the FormatDate UDFpegged only ONE CPU core on my laptop! " (Page 194-summary)
