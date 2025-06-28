# 2020-05-07T22:54:34&#43;00:00

Kept getting an error `Incorrect syntax near the keyword &#39;read&#39;` when running the some updated PowerShell 7 in lambda with the `dotnet3.1` sdk. Was troubleshooting loading types thinking I was having path issues.

Turns out one of these things is not like the other. 🤣

```sql
set nocount on
set transaction isolation read uncommitted
```

```sql
set nocount on
set transaction isolation level read uncommitted
```

I think this explains why &#34;error during &#34;read&#34;.
Maybe I should have run in my Azure Data Studio session before trying serverless 😀

