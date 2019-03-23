---
date: "2013-05-31T00:00:00Z"
tags:
- sql-server
title: TSQL Snippet for viewing basic info on database principals and their permissions
---

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
                    ', ' + p.permission_name
                from
                    sys.database_permissions p
                where
                    dp.principal_id = p.grantee_principal_id
                    and p.major_id  = 0
                    and p.state     = 'G'
                for xml path(''), type
                ).value('.', 'varchar(max)'), 1, 1, ''
                ) as general_permissions
        ,stuff((
                select distinct
                    ', ' + p.permission_name
                from
                    sys.database_permissions p
                where
                    dp.principal_id = p.grantee_principal_id
                    and p.major_id  = 0
                    and p.state     = 'D'
                for xml path(''), type
                ).value('.', 'varchar(max)'), 1, 1, ''
                ) as deny_permissions
        ,stuff((
                select distinct
                    ', ' + p.permission_name + ' on ' + object_schema_name(p.major_id) + '.' + object_name(p.major_id)
                from
                    sys.database_permissions p
                where
                    dp.principal_id = p.grantee_principal_id
                    and p.major_id  <> 0
                for xml path(''), type
                ).value('.', 'varchar(max)'), 1, 1, ''
                ) as specific_permissions
        ,stuff((
                select distinct
                    ', ' + r.name
                from
                    roleMembers r
                where
                    r.role_principal_id = dp.principal_id
                for xml path(''), type
                ).value('.', 'varchar(max)'), 1, 1, ''
                ) as current_active_members
    from
        sys.database_principals dp
    order by
        dp.name asc;
```