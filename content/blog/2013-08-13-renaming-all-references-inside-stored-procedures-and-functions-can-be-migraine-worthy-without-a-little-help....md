---
date: "2013-08-13T00:00:00Z"
excerpt: assistance to convert database references when using synonyms
tags:
- sql-server
title: "Renaming all references inside stored procedures and functions can be migraine worthy without a little help..."
slug: renaming-all-references-inside-stored-procedures-and-functions-can-be-migraine-worthy-without-a-little-help
---

> info "Updated: 2016-03-18"
> Cleaned up formatting. This is older code limited to procs and functions. I'm sure there is a better way to do this now, but leaving here as it might help someone else in the meantime.

If you run across migrating or copying a database structure for some purpose, yet need to change the database references or some other string value inside all the procedures and functions to point to the newly named object, you are in for a lot of work! I built this procedure to search all procedures and functions, and script the replacement across multiple databases, to streamline this type of conversion.

I'll post up one for views and synonyms later, as my time was limited to post this. In my case, this script was built to replace DB1 with DB2, and I had to accomplish this across several databases at once.

This script might help save you some time!

{{% gist fd2e49f4f69202cd2da6 %}}

