---
date: "2013-04-23T00:00:00Z"
tags:
- sql-server
title: "snippet designate a certain time of the day in getdate()"
slug: "snippet designate a certain time of the day in getdate()"
---

Snippet to designate a certain time of the day to evaluate in the current day. If you need to limit a result to the current date after a particular time, strip the time out of the date, and concatenate the current time together with it, and then convert back to datetime2.

```sql
select convert(datetime2(0),cast(cast(getdate() as date) as varchar(10)) + ' 09:00 ')
```
