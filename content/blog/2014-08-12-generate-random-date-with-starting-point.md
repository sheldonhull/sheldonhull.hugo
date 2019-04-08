---
date: "2014-08-12T00:00:00Z"
tags:
- sql-server
title: "Generate Random Date With Starting Point"
slug: "Generate Random Date With Starting Point"
---

If you want to create sample random samples when dealing with date calculations to test your results, you can easily create a start and end point of randomly created dates. This is a snippet I've saved for reuse:

`DATEADD(day, (ABS(CHECKSUM(NEWID())) % $Days Seed Value$), '$MinDate$')`

This should let you set the starting point (Min Date) and choose how far you want to go up from there as a the seed value. Ie, starting point 1/1/2014 with seed of 60 will create random dates up to 60 days outside the min date specified. [Stackoverflow Original Discussion: How to update rows with a random date asked Apr 27 '09](http://stackoverflow.com/questions/794637/how-to-update-rows-with-a-random-date)
