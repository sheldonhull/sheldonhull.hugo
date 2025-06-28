# Check Constraints can help enforce the all or nothing approach when it comes


If you have a set of columns inside your table that you want to allow nulls in, however if one of the columns is updated force all columns in the set to be updated, use a check constraint. In my case, I had 3 columns for delete info, which were nullable. However, if one value was updated in there, I want all three of the delete columns to require updating. I created the script below to generate the creation and removal of these constraints on a list of tables:

```sql

/* CHECK CONSTRAINT TO ENSURE SET OF COLUMNS IS NULL OR IF UPDATED,
THAT ALL COLUMNS IN SET ARE UPDATED Columns: delete_date null delete_by_id null delete_comment null PASS CONDITION
1: IF ALL COLUMNS NULL = PASS PASS CONDITION
2: IF ALL COLUMNS ARE UPDATED/NOT NULL = PASS

FAIL: IF 1,2 OF THE COLUMNS ARE UPDATED, BUT NOT ALL 3 THEN FAIL
*/

/* GENERATE CHECK CONSTRAINT ON ALL SELECTED TABLES TO REQUIRE ALL DELETE
DATE COLUMNS TO BE UPDATED CORRECTLY */

select
    t.TABLE_SCHEMA
    ,t.TABLE_NAME
    ,script_to_remove_if_exists = &#39; IF exists (select * from sys.objects where name =&#39;&#39;check_&#39; &#43; t.TABLE_SCHEMA &#43; &#39;_&#39; &#43; t.TABLE_NAME &#43; &#39;_softdelete_requires_all_delete_columns_populated_20130718&#39;&#39;) begin alter table &#39; &#43; t.TABLE_SCHEMA &#43; &#39;.&#39; &#43; t.TABLE_NAME &#43; &#39; drop constraint check_&#39; &#43; t.TABLE_SCHEMA &#43; &#39;_&#39; &#43; t.TABLE_NAME &#43; &#39;_softdelete_requires_all_delete_columns_populated_20130718 end &#39;
    ,script_to_run =              &#39; alter table &#39; &#43; t.TABLE_SCHEMA &#43; &#39;.&#39; &#43; t.TABLE_NAME &#43; &#39; add constraint check_&#39; &#43; t.TABLE_SCHEMA &#43; &#39;_&#39; &#43; t.TABLE_NAME &#43; &#39;_softdelete_requires_all_delete_columns_populated_20130718 check ( ( case when delete_date is not null then 1 else 0 end &#43; case when delete_by_id is not null then 1 else 0 end &#43; case when delete_comment is not null then 1 else 0 end ) in (0, 3) ) &#39;
from
    INFORMATION_SCHEMA.TABLES t
where
    t.TABLE_NAME like &#39;mytablename%&#39;
    and exists (select
            *
        from
            INFORMATION_SCHEMA.COLUMNS C
        where
            t.TABLE_CATALOG = C.TABLE_CATALOG
            and t.TABLE_SCHEMA = C.TABLE_SCHEMA
            and t.TABLE_NAME = C.TABLE_NAME
            and C.COLUMN_NAME = &#39;delete_by_id&#39;)
    and exists (select
            *
        from
            INFORMATION_SCHEMA.COLUMNS C
        where
            t.TABLE_CATALOG = C.TABLE_CATALOG
            and t.TABLE_SCHEMA = C.TABLE_SCHEMA
            and t.TABLE_NAME = C.TABLE_NAME
            and C.COLUMN_NAME = &#39;delete_comment&#39;)
    and exists (select
            *
        from
            INFORMATION_SCHEMA.COLUMNS C
        where
            t.TABLE_CATALOG = C.TABLE_CATALOG
            and t.TABLE_SCHEMA = C.TABLE_SCHEMA
            and t.TABLE_NAME = C.TABLE_NAME
            and C.COLUMN_NAME = &#39;delete_date&#39;)
order by
    t.TABLE_SCHEMA asc
go
```

