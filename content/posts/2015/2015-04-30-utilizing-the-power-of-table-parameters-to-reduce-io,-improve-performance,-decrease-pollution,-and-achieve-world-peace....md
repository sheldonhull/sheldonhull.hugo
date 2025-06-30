---
date: "2015-04-30T00:00:00Z"
tags:
- sql-server
- deep-dive
title: "Utilizing the power of table parameters to reduce IO, improve performance, decrease pollution, and achieve world peace..."
slug: utilizing-the-power-of-table-parameters-to-reduce-io,-improve-performance,-decrease-pollution,-and-achieve-world-peace
---

I was dealing with a challenging dynamic sql procedure that allowed a .NET app to pass in a list of columns and a view name, and it would generate a select statement from this view. Due to requirements at the time, I needed the flexibility of the "MAIN" proc which generated a dynamic select statement, while overriding certain requested views by executing a stored proc instead of the dynamic sql.

During this, I started looking into the string parsing being completed for a comma delimited list of numbers to lookup (the primary key). I figured I'd explore the benefits of the user defined table and pass through the list of ids from the .NET application with a table parameter instead of using comma delimited list. [Some great material](http://www.sommarskog.se/arrays-in-sql-2008.html#Performance_Considerations)

I came across indicated the overhead might be a little more client side, but that the benefits to cardinality estimation and providing SQL Server a table to work with can far outweigh the initial startup cost when dealing with lots of results to join against. The main area I wanted to address first, that I couldn't find any clear documentation on was the memory footprint. I saw mention on various sources that a TVP can have a lower memory footprint in SQL Server's execution due to the fact as intermediate storage it can be pointed at by reference, rather than creating a new copy each time, like when working with parsing into another variable using comma delimited lists.

I get that passing the stored proc a table variable means it's working with provided object, but what about the portability of this object? In my case, there are at least 2 levels being worked. The MAIN proc and the CHILD proc. The child proc needs access to the same list of ids. The dynamic statement in the MAIN proc also needs the list of ids. Currently it was creating the list of ids by inserting into a table parameter the delimited list of values.

Could I instead consider passing the actual table parameter around since it's by a readonly object and hopefully keep referring to it, instead of having separate copies being created each time. This could reduce the IO requirements and tempdb activity by having a single TVP being used by the MAIN and CHILD procs.
![TVP Testing 2](/images/SQL_Sentry_Plan_Explorer_PRO-2015-04-30_09_56_17_xkvtbz.png)
![TVP Testing 3](/images/SQL_Sentry_Plan_Explorer_PRO-2015-04-30_09_52_10_bxzrlg.png)
![TVP Testing 4](/images/SQL_Sentry_Plan_Explorer_PRO-2015-04-30_09_58_30_j7k6u3.png)
![TVP Testing 5](/images/SQL_Sentry_Plan_Explorer_PRO-2015-04-30_09_52_10_bxzrlg.png)
Summarized IO:
![TVP Testing 1](/images/-2015-04-30_09_06_36_s37z0t.png)
The footprint is reduced when dealing with IO from the child statement, because it keeps pointing to the same in memory object. I also validated this further by examining a more complex version of the same query that compares the comma delimited list against executing a nested stored procedure, which in turn has dynamic sql that needs the table parameter passed to it. The results of the review show successfully that it keeps pointing to the same temp object!
![TVP Test 6](/images/Miscellaneous_Files_-_Testing_New_Stored_Proc_with_Debug.sql_--2015-04-30_10_06_40_ojiues.png)

In summary, the table valued parameter can end up being pretty powerful when dealing with passing a list of values that may need to be referenced by several actions or passed to nested procs (not that this is the best practice anyway). Disclaimer: this is working with the constraints of what I have to release soon, so not saying that nested procs with dynamic sql in both MAIN and CHILD are a great practice, but sometimes you gotta do what you gotta do!
