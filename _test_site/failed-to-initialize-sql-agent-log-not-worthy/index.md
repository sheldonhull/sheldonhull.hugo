# Failed to Initialize SQL Agent Log... not worthy


Moving system databases in SQL Server takes a bit of practice. I got that again, along with a dose of SQL humility (so tasty!), today after messing up some cleanup with sql agent server log files.

```text
Failed to initialize SQL Agent log (reason: Access is denied).
```

I was creating a sql template when this came about. SQL Server Agent wouldn&#39;t start back up despite all the system databases having very little issues with my somewhat brilliant sql commands.
I had moved all my databases to the new drive location, and changed the advanced startup parameters for sql server and SQL Agent... or so I thought.

![Logging location not the same](/images/2016-04-01_18-20-41.png)

I apparently missed the order of operations with SQL Server Agent, and so it was unable to start. MSDN actually says to go into the SQL agent in SSMS to change this, and I thought I was smarter than msdn....

&gt; [MSDN](https://msdn.microsoft.com/en-us/library/ms345408.aspx)
&gt;
&gt; *   Change the SQL Server Agent Log Path
&gt; From SQL Server Management Studio, in Object Explorer, expand SQL Server Agent.
&gt; *   Right-click Error Logs and click Configure.
&gt; *   In the Configure SQL Server Agent Error Logs dialog box, specify the new location of the SQLAGENT.OUT file.
&gt; *   The default location is C:\Program Files\Microsoft SQL Server\MSSQL
&gt; &lt;version data-preserve-html-node=&#34;true&#34;&gt;.
&gt; &lt;instance_name data-preserve-html-node=&#34;true&#34;&gt;\MSSQL\Log.
&gt; Found the registry entry and changed here... all fixed!&lt;/instance_name&gt;&lt;/version&gt;

![Fixing in the registry](/images/2016-04-01_18-16-31.png)
I also updated the WorkDirectoryEntry to ensure it matched new paths.

Thanks to this [article](https://blogs.msdn.microsoft.com/sqlserverfaq/2009/06/12/unable-to-start-sql-server-agent/) I was saved some headache. I also learned to read directions more carefully :-)

