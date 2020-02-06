---
date: "2017-06-07T00:00:00Z"
tags:
- sql-server
- tech
title: "Best Practices: Defining Explicit Length for Varchar/Nvarchar"
slug: "best-practices-defining-explicit-length-for-varchar-nvarchar"
---

> SA0080 : Do not use VARCHAR or NVARCHAR data types without specifying length. Level: Warning

When using varchar/nvarchar it should be explicitly defined. This can be a very nasty bug to track down as often nothing will be thrown if not checked in an application. Instead, ensure your script explicitly defines the smallest length that fits your requirements. The reason I rate this as a very dangerous practice, is that no error is thrown. Instead, the results being returned will be shorter than expected and if validation checks aren't implemented this behavior can lead to partial results returned and used. Make sure to always explictly define length!

Here's an short example script that demonstrates the behavior.

{{< gist ab043077045ed9d5f26b4bbf6b326f45 >}}
