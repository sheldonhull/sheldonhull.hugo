# View computed columns in database


Snippet to quickly view computed column information. You can also view this by doing a &#34;create table&#34; script. This however, was a little cleaner to read and view for me.

```sql

select
    database_name = db_name()
    ,object_schema_name = object_schema_name( object_id )
    ,object_name = object_name( object_id )
    ,full_object_name = object_schema_name( object_id ) &#43; &#39;.&#39; &#43; object_name( object_id )
    ,column_name = name
    ,cc.is_persisted
    ,cc.Definition
from
    sys.computed_columns cc
order
    by full_object_name asc
```

