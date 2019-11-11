---
date: "2014-12-11T00:00:00Z"
tags:
- sql-server
title: "OR pattern causing indexing scans in parameter based queries"
slug: "or-pattern-causing-indexing-scans-in-parameter-based-queries"
---

#Tl;dr

_(time constraints prevented me from reworking significantly)_

"or-condition-performance" article on SQL Server Pro was forwarded over to me to research by a friend who indicated that using a variable with an or pattern had historically caused table scans. This was a suprise to me as all previous queries with optional parameters I'd used in the past seemed to use index seeks. I had to dig into this a little deeper to see if had been missing this in my past work and needed to find an alternative method for optional parameters. Original test procedure copied from original.

{{% gist 4f8446420776336f7478 %}}


The result from running the test1 procedure was to find a clustered index scan. SQL Server optimizer should be able to utilize the or conditions as long as an index covers the predicates, so I dug in deeper. When I ran a random query against a few tables I found this was creating table scans. Looking a little deeper I decided to evaluate the indexing on the tables to see if it was an issues with indexing, and not the pattern of using the OR against a variable.

{{% gist ef2d134cdd3b47dcdf84 %}}


Test 1: SCANS - except with option recompile Found index scans on all my versions of running this except when including option(recompile) inside the stored procedure statement text. This of course fixed the issue by allowing sql to build the plan based on the exact value passed in, however, this would be at the cost of increasing CPU and negating the benefits of having a cached plan ready.
Test 2: Ran `exec sys.sp_updatestats`

```text
Updating [dbo].[or_test]     [PK__or_test__3213E83F7953A2B2], update is not necessary...     [idx_or_test_col1], update is not necessary...     [idx_or_test_col2], update is not necessary...     [ix_nc_CoveringIndex], update is not necessary...     0 index(es)/statistic(s) have been updated, 4 did not require update.
```

After researching for hours more, and reading many posts, I discovered I've been missing this in previous work, probably due to query plan caching. When utilizing the variable from the stored procedure, the parameters are "sniffed". This means the plan is not rebuilt for each execution, but instead first execution is cached with the values it utilized. Thereafter, the optimizer can reuse this plan. The difference is that if you provide a value you manually plug into your test such as "declare @Value = 'FOO' " then the optimizer has an actual value to use for each of your manually run executions. This means that if you have properly indexed the column, it would be sargable.

However, the stored procedure is not passing in the actual value after the first run, it is trying to save the CPU demand the optimizer will need, and instead use the cached plan. This is likely the cause of my missing this in the past, as all my execution testing was based on commenting out the stored proc header and running manual tests. In this case, I'd correctly be seeing table seeks if indexed properly, because the optimizer was obtaining the actual values from my session. When executing the stored procedure externally, it looks to utilize parameter sniffing, which when working correctly is a **good thing** not a bug.

However, when result sets can greatly vary, the problem of parameter sniffing can become a problem. In addition, if the OR statement is utilized as my original problem mentioned, the optimizer can decide that since parameter value is unknown at this time, that with an OR clause it would be better to run a table scan since all table results might be returned, rather than a seek.

To bypass this, there are various approaches, but all are a compromise of some sort. The common approach to resolving if truly various selections may be made (in the case of SSRS reports for example) is to utilize option(recompile). This provide the actual value back to the compiler at run time, causing higher CPU usage, but also ensuring the usage of indexes and reducing scans when the columns are properly indexed. Again, this is one solution among several, which can include building dynamic query strings, logic blocks, and other methods.
