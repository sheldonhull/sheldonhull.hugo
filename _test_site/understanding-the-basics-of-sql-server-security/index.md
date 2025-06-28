# Understanding The Basics of SQL Server Security


## Confusing

As I&#39;ve worked with folks using other database engines, I&#39;ve realized that Microsoft SQL Server has some terminology and handling that is a bit confusing.
Here&#39;s my attempt to clarify the basics for myself and others needing a quick overview.
This is not comprehensive coverage of security architecture, which is a very complex topic, more just terminology.

## Terminology

Note that it&#39;s best to consider SQL Server as it&#39;s own operating system, not just a standard application running.
It has its own memory manage, cpu optimization, user security model, and more.
It&#39;s helpful in understanding why a `Server Login != Instance Login` by reviewing common terminology.
I&#39;ve noticed that among other open-source tools like MySQL, it&#39;s much more common to hear terms like &#34;Database Server&#34;, which in my mind mix up for non-dbas the actual scope being talked about.

| Term     | Definition                                                   |
| -------- | ------------------------------------------------------------ |
| Server   | The operating system                                         |
| Instance | The SQL Server Instance that can contain 1 or many databases |
| Database | The database inside the instance.                            |

This can be 1 or many.

| Term          | Definition                                                                                                                                                                    |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Server Login  | Windows or Linux user at the Operating System level                                                                                                                           |
| SQL Login     | Login created inside SQL Server, using SQL statement. This is internal to SQL Server and not part of the Server OS.                                                           |
| Database User | A database user is created and linked to the Instance SQL Login                                                                                                               |
| Server Role   | Roles for Instance level permissions, such `sysadmin (sa)`, `SecurityAdmin`, and others. These do not grant database-level permissions, other than `sa` having global rights. |
| Database Role | A defined role that grants read, write, or other permissions inside the database.                                                                                             |

Here&#39;s a quick visual I threw together to reinforce the concept.

Yes, I&#39;m a talented comic artist and take commissions.
😀

![sql-login-database-architecture](/images/2021-06-25-1658-sql-login-database-architecture-dark.png &#34;Visualize SQL Security 101&#34;)

## Best Practice

When managing user permissions at a database level, it&#39;s best to leverage Active Directory (AD) groups.
Once this is done, you&#39;d create roles.
The members of those roles would be the AD Groups.

## No Active Directory

SQL Logins and corresponding database users must be created if active directory groups aren&#39;t being used.

## Survey Said

I did a quick Twitter survey and validated that Active Directory Groups are definitely the most common way to manage.

&lt;blockquote class=&#34;twitter-tweet&#34;&gt;&lt;p lang=&#34;en&#34; dir=&#34;ltr&#34;&gt;As a SQL Server dba, how do you grant access to less privileged devs, including production?
&lt;br&gt;&lt;br&gt;I&amp;#39;m curious.
I&amp;#39;ve been part of both AD managed environments and ones where I did everything with SQL Login auth.
&lt;a href=&#34;https://twitter.com/hashtag/sqlfamily?src=hash&amp;amp;ref_src=twsrc%5Etfw&#34;&gt;#sqlfamily&lt;/a&gt;
&lt;a href=&#34;https://twitter.com/hashtag/sqlserver?src=hash&amp;amp;ref_src=twsrc%5Etfw&#34;&gt;#sqlserver&lt;/a&gt;
&lt;a href=&#34;https://twitter.com/hashtag/mssql?src=hash&amp;amp;ref_src=twsrc%5Etfw&#34;&gt;#mssql&lt;/a&gt;
&lt;/p&gt;&amp;mdash; Sheldon Hull (@sheldon_hull)
&lt;a href=&#34;https://twitter.com/sheldon_hull/status/1408118509104676869?ref_src=twsrc%5Etfw&#34;&gt;June 24, 2021&lt;/a&gt;&lt;/blockquote&gt;
&lt;script async src=&#34;https://platform.twitter.com/widgets.js&#34; charset=&#34;utf-8&#34;&gt;&lt;/script&gt;

