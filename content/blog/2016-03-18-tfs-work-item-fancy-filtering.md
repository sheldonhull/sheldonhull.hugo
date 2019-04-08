---
date: "2016-03-18T00:00:00Z"
tags:
- development
- sql-server
- tfs
- ramblings
title: "TFS Work-Item Fancy Filtering"
slug: "tfs-work-item-fancy-filtering"
---

If you want to create a TFS query that would identify work items that have changed, but were not changed by the person working it, there is a nifty way to do this.The filtering field can be set to <> another field that is available, but the syntax/setup in Visual Studio is not intuitive. It's in the dropdown list, but I'd never noticed it before!

![filter list](/images/SNAG-0037_lmuutc.png)

```sql
AND ' Changed By ' <> [Field] ' Assigned to
```

Note that you don't include brackets on the assigned to field, and that the <> [Field] is not a placeholder for you to type the field name in, it's actually the literal command for it to parse this correctly.

![Filter setup for tfs query](/images/SNAG-0036_q6zoow.png)

