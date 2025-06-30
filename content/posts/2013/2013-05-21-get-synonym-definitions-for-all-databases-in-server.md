---
date: "2013-05-21T00:00:00Z"
tags:
- sql-server
title: "Get synonym definitions for all databases in server"
slug: "get-synonym-definitions-for-all-databases-in-server"
---

If you want to audit your enviroment to look at all your synonyms and see where they are pointing, you can use `exec sys.sp_MSforeachdb` to loop through databases, and even filter. It will save some coding. However, [my research indicates it is probably a bad practice to rely on this undocumented function as it may have issues not forseen and fully tested](http://shaunjstuart.com/archive/2012/10/its-time-to-retire-sp_msforeachdb/).

Additionally, support may drop for it in the future. I recreated what I needed with a cursor to obtain all the synonym definitions into a temp table and display  results.:

```sql
/*
    create temp table for holding synonym definitions & list of DB
    */

    if object_id('tempdb..#dblist') is not null
        drop table #dblist;
    select
        *
    into #dblist
    from
        sys.databases
    where
        name not in ('master', 'tempdb', 'model', 'msdb')
        and State_desc = 'ONLINE'
        and Is_In_Standby = 0
    if object_id('tempdb..#temp') is not null
        drop table #temp;

    create table #temp
        (
            db_name               sysname
            ,object_id             int
            ,name                  sysname
            ,base_object_name      sysname
            ,server_name_hardcoded as case
                when base_object_name like '%ThisDatabaseIsOkToHardCode%'
                then 0
                when len(base_object_name)
                        - len(replace(base_object_name, '.', '')) > 2
                then 1
                else 0
            end
        )

    go

    declare @DbName sysname
    declare @XSQL varchar(max)
    declare @CompleteSQL varchar(max)
    declare db_cursor cursor fast_forward read_only local for select
                name
            from
                #dblist
    open db_cursor
    fetch next from db_cursor into @DbName;

    while @@fetch_status = 0
    begin
        set @XSQL = '
                    insert into #temp
                    ( db_name ,object_id ,name,base_object_name )
                    select
                        db_name()
                        ,s.object_id
                        ,s.name
                        ,s.base_object_name
                    from
                        sys.synonyms s
                    '
        set @CompleteSQL = 'USE ' + @DbName
                            + '; EXEC sp_executesql N'''
                            + @XSQL + '''';
        exec (@CompleteSQL)
        fetch next from db_cursor into @DbName;
    end

    close db_cursor
    deallocate db_cursor
    go
    select
        *
    from
        #temp t
```
