# Track Creation of Databases


Sys.Databases has some create information, but I was looking for a way to track aging, last access, and if databases got dropped. In a development environment, I was hoping this might help me gauge which development databases were actually being used or not.

&lt;script data-preserve-html-node=&#34;true&#34; id=&#34;codeblock&#34; src=&#34;830a4514f6c9a2fd938c6eeb67db6000.js&#34;&gt;&lt;/script&gt;

```sql

/*******************************************************
    run check on each constraint to evaluate if errors
*******************************************************/
if object_id(&#39;tempdb..##CheckMe&#39;) is not null
    drop table ##CheckMe;

select
    temp_k =    identity(int, 1, 1)
    ,X.*
into ##CheckMe
from
    (select

            type_of_check =                                            &#39;FK&#39;
            ,&#39;[&#39; &#43; s.name &#43; &#39;].[&#39; &#43; o.name &#43; &#39;].[&#39; &#43; i.name &#43; &#39;]&#39;    as keyname
            ,CheckMe =                                                &#39;alter table &#39; &#43; quotename(s.name) &#43; &#39;.&#39; &#43; quotename(o.name) &#43; &#39; with check check constraint &#39; &#43; quotename(i.name)
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
            type_of_check =                                            &#39;CHECK&#39;
            ,&#39;[&#39; &#43; s.name &#43; &#39;].[&#39; &#43; o.name &#43; &#39;].[&#39; &#43; i.name &#43; &#39;]&#39;    as keyname
            ,CheckMe =                                                &#39;alter table &#39; &#43; quotename(s.name) &#43; &#39;.&#39; &#43; quotename(o.name) &#43; &#39; with check check constraint &#39; &#43; quotename(i.name)
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

