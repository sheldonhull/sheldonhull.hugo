# TSQL Snippet for viewing basic info on database principals and their permissions


Quick snippet I put together for reviewing basic info on database users/principals, permissions, and members if the principal is a role.:

```sql
/*******************************************************
    Some Basic Info on Database principals, permissions, explicit permissions, and if role, who is in this role currently
    *******************************************************/

    ;with roleMembers as (
                            select
                                drm.role_principal_id
                            ,dp.principal_id
                            ,dp.name
                            from
                                sys.database_role_members drm
                                inner join sys.database_principals dp
                                    on drm.member_principal_id = dp.principal_id
                            )
    select
        db_name()
        ,dp.name
        ,stuff((
                select distinct
                    &#39;, &#39; &#43; p.permission_name
                from
                    sys.database_permissions p
                where
                    dp.principal_id = p.grantee_principal_id
                    and p.major_id  = 0
                    and p.state     = &#39;G&#39;
                for xml path(&#39;&#39;), type
                ).value(&#39;.&#39;, &#39;varchar(max)&#39;), 1, 1, &#39;&#39;
                ) as general_permissions
        ,stuff((
                select distinct
                    &#39;, &#39; &#43; p.permission_name
                from
                    sys.database_permissions p
                where
                    dp.principal_id = p.grantee_principal_id
                    and p.major_id  = 0
                    and p.state     = &#39;D&#39;
                for xml path(&#39;&#39;), type
                ).value(&#39;.&#39;, &#39;varchar(max)&#39;), 1, 1, &#39;&#39;
                ) as deny_permissions
        ,stuff((
                select distinct
                    &#39;, &#39; &#43; p.permission_name &#43; &#39; on &#39; &#43; object_schema_name(p.major_id) &#43; &#39;.&#39; &#43; object_name(p.major_id)
                from
                    sys.database_permissions p
                where
                    dp.principal_id = p.grantee_principal_id
                    and p.major_id  &lt;&gt; 0
                for xml path(&#39;&#39;), type
                ).value(&#39;.&#39;, &#39;varchar(max)&#39;), 1, 1, &#39;&#39;
                ) as specific_permissions
        ,stuff((
                select distinct
                    &#39;, &#39; &#43; r.name
                from
                    roleMembers r
                where
                    r.role_principal_id = dp.principal_id
                for xml path(&#39;&#39;), type
                ).value(&#39;.&#39;, &#39;varchar(max)&#39;), 1, 1, &#39;&#39;
                ) as current_active_members
    from
        sys.database_principals dp
    order by
        dp.name asc;
```

