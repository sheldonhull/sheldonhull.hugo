---
date: "2016-10-22T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Fixing Untrusted Foreign Key or Check Constraint"
slug: "fixing-untrusted-foreign-key-or-check-constraint"
---

Untrusted constraints can be found when you alter/drop foreign key relationships and then add them back without the proper syntax.If you are deploying data through several tables, you might want to disable foreign keys on those tables during the deployment to ensure that all the required relationships have a chance to insert their data before validation.

Once you complete the update, you should run a check statement to ensure the Foreign Key is trusted.
The difference in the check syntax is actually ridiculous....
This check would not ensure the actual existing rows are validated to ensure compliance with the Foreign Key constraint.

```sql
alter table [dbo].[ChickenLiver] with check constraint [FK_EggDropSoup]
```

This check would check the rows contained in the table for adherence to the foreign key relationship and only succeed if the FK was successfully validated. This flags metadata for the database engine to know the key is trusted.

```sql
alter table [dbo].[ChickenLiver] with CHECK CHECK constraint [FK_EggDropSoup]
```

I originally worked through this after running sp_Blitz and working through the helpful documentation explaining [Foreign Keys or Check Constraints Not Trusted](http://bit.ly/2efZTkr).

Untrusted Check Constraints and FKs can actually impact the performance of the query, leading to a less optimal query plan. The query engine won't know necessarily that the uniqueness of a constraint, or a foreign key is guaranteed at this point.

I forked the script from Brent's link above and modified to iterate through and generate the script for running the check against everything in the database. This could be modified to be server wide if you wish as well. Original DMV query credit to Brent, and the the tweaks for running them against the database automatically are my small contribution.

Note: I wrote on this a while back, totally missed that I had covered this. For an older perspective on this: [Stranger Danger... The need for trust with constraints]({{< relref "2015-08-13-stranger-danger...-the-need-for-trust-with-constraints.md" >}})

{{< gist sheldonhull  2454ce9134eac225ce264c64adb331a9 >}}
