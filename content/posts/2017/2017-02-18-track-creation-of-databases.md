---
date: "2017-02-18T00:00:00Z"
tags:
- sql-server
title: "Track Creation of Databases"
slug: "track-creation-of-databases"
---

Sys.Databases has some create information, but I was looking for a way to track aging, last access, and if databases got dropped. In a development environment, I was hoping this might help me gauge which development databases were actually being used or not.

<script data-preserve-html-node="true" id="codeblock" src="830a4514f6c9a2fd938c6eeb67db6000.js"></script>

```sql

/*******************************************************
    run check on each constraint to evaluate if errors
*******************************************************/
if object_id('tempdb..##CheckMe') is not null
    drop table ##CheckMe;

select
    temp_k =    identity(int, 1, 1)
    ,X.*
into ##CheckMe
from
    (select

            type_of_check =                                            'FK'
            ,'[' + s.name + '].[' + o.name + '].[' + i.name + ']'    as keyname
            ,CheckMe =                                                'alter table ' + quotename(s.name) + '.' + quotename(o.name) + ' with check check constraint ' + quotename(i.name)
            ,IsError =                                                convert(bit, null)
            ,ErrorMessage =                                            convert(varchar(max), null)
        from
            sys.foreign_keys i
            inner join sys.objects o
                on i.parent_object_id = o.object_id
            inner join sys.schemas s
                on o.schema_id = s.schema_id
        where
            i.is_not_trusted = 1
            and i.is_not_for_replication = 0
        union all
        select
            type_of_check =                                            'CHECK'
            ,'[' + s.name + '].[' + o.name + '].[' + i.name + ']'    as keyname
            ,CheckMe =                                                'alter table ' + quotename(s.name) + '.' + quotename(o.name) + ' with check check constraint ' + quotename(i.name)
            ,IsError =                                                convert(bit, null)
            ,ErrorMessage =                                            convert(varchar(max), null)
        from
            sys.check_constraints i
            inner join sys.objects o
                on i.parent_object_id = o.object_id
            inner join sys.schemas s
                on o.schema_id = s.schema_id
        where
            i.is_not_trusted = 1
            and i.is_not_for_replication = 0
            and i.is_disabled = 0) as X

```
