---
date: "2016-10-09T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Fixing non-deterministic error when creating indexed view"
slug: "fixing-non-deterministic-error-when-creating-indexed-view"
---

I discovered a bit of info on working with float values, while creating a hash value that contained a float value, and a date value.

    create unique clustered index ix_clustered_ViewK_Catfood_K
    Msg 1901, Level 16, State 1, Line 1517
    Cannot create index or statistics 'ix_clustered_ViewK_Catfood_K' on view 'compareCatfood' because key column 'ViewK' is imprecise, computed and not persisted. Consider removing reference to column in view index or statistics key or changing column to be precise. If column is computed in base table consider marking it PERSISTED there.

And...

    Msg 2729, Level 16, State 1, Line 38
    Column 'Hash' in view 'compare.Catfood_test' cannot be used in an index or statistics or as a partition key because it is non-deterministic.

Stack Overflow to the rescue... The issue is with float values.
[http://stackoverflow.com/a/19915032/68698](http://stackoverflow.com/a/19915032/68698)

> Even if an expression is deterministic, if it contains float expressions, the exact result may depend on the processor architecture or version of microcode. To ensure data integrity, such expressions can participate only as non-key columns of indexed views. Deterministic expressions that do not contain float expressions are called precise. Only precise deterministic expressions can participate in key columns and in WHERE or GROUP BY clauses of indexed views. [MSDN](http://bit.ly/2btYtxp)
> Restrictions also apply to formatting dates when you are calculating a checksum. This is because every region has variations on the way the date may be displayed. This makes dates non-deterministic in a hash, unless the convert format is explicitly defined.

# ensuring date is converted with style

    + isnull(convert(nvarchar(max), do oe.Somedate ,102), ''') + N'''
    + isnull(convert(nvarchar(max),la.SomeDater ,102), N''') + N'''
    + isnull(cast  (ft.ToBeOrNotToBe as nvarchar(max)),''') + N'''
    + isnull(cast  (t2.Fooey as nvarchar(max)),''') + N'''

If you can resolve these issues then you are on your way to resolving the other thousand restrictions on indexed views.... :-)  Good luck!
