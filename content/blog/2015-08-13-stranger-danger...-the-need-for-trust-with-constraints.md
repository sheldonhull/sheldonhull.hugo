---
date: "2015-08-13T00:00:00Z"
tags:
  - sql-server
title: "Stranger Danger... The need for trust with constraints"
slug: "stranger-danger-the-need-for-trust-with-constraints"
---

I ran into an issue with errors with an database upgrade running into a violation of a foreign key constraint. Don't know how it happened. Figured that while I'm at it, I'd go ahead and evaluate every single check constraint in the database to see if I could identify any other violations, because they shouldn't be happening.

## improve the execution plan by checking the data

In my reading, I found out that checking the constraints can enable the constraint to be marked as trusted. The trusted constraints are then able to be used to build a better query plan execution.
I knew that constraints could help the execution, but didn't know that they could have a trusted or untrusted trait.

## Brentozar to the rescue

I'm serious, this guy and his team are awesome. This one single team and their web resources have single handled helped me gain more understanding on SQL server than any other resource. I love how they give back to the community, and their communication always is full of humor and good examples. Kudos!
Anyway, commendation aside, the explanation from sp_blitz was fantastic at summarizing the issue.

> After this change, you may see improved query performance for tables with trusted keys and constraints. - [Blitz Result: Foreign Keys or Check Constraints Not Trusted](http://www.brentozar.com/blitz/foreign-key-trusted/)
>   As the site further mentions, this can cause locks and performance issues, so this validation might be better done off hours. The benefit might be worth it though!

## my adaption of the check constraint script

I appreciate the script as a starting point (see link above). I adapted to run this individually on each check constraint and log the errors that occurred. This runs though all FK and CHECK constraints in the database you are in, and then checks the data behind the constraint to ensure it is noted as trusted.

{{< gist 2454ce9134eac225ce264c64adb331a9 >}}
