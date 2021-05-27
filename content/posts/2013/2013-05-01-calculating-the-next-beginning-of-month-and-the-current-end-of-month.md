---
date: "2013-05-01T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Calculating the next beginning of month and the current end of month"
slug: "calculating-the-next-beginning-of-month-and-the-current-end-of-month"
---

Handling dates is always a fun challenge in T-SQL! Finding the current end of month and next months beginning of month is straight forward, but I like to find new ways to do things that take less coding, and hate date conversions that require a lot of manipulation of characters and concatenation. This was what I came up with for avoiding character conversions and concatenation for finding the current BOM (beginning of month) and EOM (end of month) values. Adjust according to your needs. Cheers!

```sql
    --use datediff from 0, ie default 1900 date, to calculate current months as int
    declare @ThisMonth int = datediff(month,0,cast(getdate() as date))

    --add 1 to the current month to get the next month
    declare @NextBom date = dateadd(month,@ThisMonth+1,0)

    -- subtract a day from the beginning of next month to get the current end of month, without worrying about 28, 30, or 31 days.
    declare @ThisEom date = dateadd(day,-1,@NextBom)
    select @ThisMonth select @NextBom select @ThisEom
```
