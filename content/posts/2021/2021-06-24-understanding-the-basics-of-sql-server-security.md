---
date: 2021-06-24T12:26:52-05:00
title: Understanding The Basics of SQL Server Security
slug: understanding-the-basics-of-sql-server-security
summary:
  As I've worked with fxolks using other database engines, I've realized that Microsoft SQL Server has some terminology and handling that is a bit confusing.
  Here's my attempt to clarify the basics for myself and others needing a very quick overview.
tags:
- tech
- development
- sql-server
- security
draft: true
toc: true
images: [/images/2021-06-25-1658-sql-login-database-architecture-dark.png]
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

## Confusing

As I've worked with fxolks using other database engines, I've realized that Microsoft SQL Server has some terminology and handling that is a bit confusing.
Here's my attempt to clarify the basics for myself and others needing a very quick overview.

## Terminology

Note that it's best to consider SQL Server as it's own micro-operating system. It has it's own mini OS, security model, and other things so it's helpful in understanding why a Server Login != Instance Login.

| Term     | Definition                                                   |
| -------- | ------------------------------------------------------------ |
| Server   | The operating system                                         |
| Instance | The SQL Server Instance that can contain 1 or many databases |
| Database | The database inside the instance. This can be 1 or many.     |

| Term          | Definition                                                                                                                                                              |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Server Login  | Windows or Linux user at the Operating System level                                                                                                                     |
| SQL Login     | Login created inside SQL Server, using SQL statement. This is internal to SQL Server, and not part of the Server OS.                                                    |
| Database User | A database user is created and linked to the Instance SQL Login                                                                                                         |
| Server Role   | Roles for Instance level permissions, such sysadmin (sa), SecurityAdmin, and others. These do not grant database level permissions, other than sa having global rights. |
| Database Role | A defined role that grants read, write, or other permissions inside the database.                                                                                       |
|               |                                                                                                                                                                         |

## Best Practice

When managing user permissions at a database level, it's best to leverage Active Directory (AD) groups.

Once this is done, you'd create roles and the members of those roles would be the AD Groups.

## No Active Directory

However, for those not using this approach, or not using active directory, then SQL Logins and corresponding database users must be created.
