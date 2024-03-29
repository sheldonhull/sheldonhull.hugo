---
date: "2016-10-10T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- redgate
- sql-server
- cool-tools
title: "Migrating Database Collation - The Red Gate Way"
slug: "migrating-database-collation-the-red-gate-way"
---

I had some cross database comparisons that I wanted to simplify, but ensuring the collation matched. The amount of objects that I would have had to drop and recreate was a bit daunting, so I looked for a way to migrate the database to a different collation.Using the Red Gate toolkit, I was able to achieve this pretty quickly. There are other methods with copying data built in to SSMS that could do some of these steps, but the seamless approach was really nice with the SQL Toolbelt.

1.  First I created the database with the collation I wanted to match using SQL Compare 12.
2.  I deployed the original schema to the new location.
3.  Ran SQL Data Compare 12 and migrated all the data to the new database.
Since the new database was created with the desired migration, I was good to go!

_Note: I'm a member of Friends of Redgate program, and am provided with licenses for testing and feedback. This doesn't impact my assessments, as I just love finding good tools for development, regardless of who makes them!_
