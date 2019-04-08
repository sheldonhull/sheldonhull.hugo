---
date: "2013-05-22T00:00:00Z"
tags:
- sql-server
title: "View computed columns in database"
slug: "view-computed-columns-in-database"
---

Snippet to quickly view computed column information. You can also view this by doing a "create table" script. This however, was a little cleaner to read and view for me.

```sql

select
    database_name = db_name()
    ,object_schema_name = object_schema_name( object_id )
    ,object_name = object_name( object_id )
    ,full_object_name = object_schema_name( object_id ) + '.' + object_name( object_id )
    ,column_name = name
    ,cc.is_persisted
    ,cc.Definition
from
    sys.computed_columns cc
order
    by full_object_name asc
```
