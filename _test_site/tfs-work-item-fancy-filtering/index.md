# TFS Work-Item Fancy Filtering


If you want to create a TFS query that would identify work items that have changed, but were not changed by the person working it, there is a nifty way to do this.The filtering field can be set to &lt;&gt; another field that is available, but the syntax/setup in Visual Studio is not intuitive. It&#39;s in the dropdown list, but I&#39;d never noticed it before!

![filter list](/images/SNAG-0037_lmuutc.png)

```sql
AND &#39; Changed By &#39; &lt;&gt; [Field] &#39; Assigned to
```

Note that you don&#39;t include brackets on the assigned to field, and that the &lt;&gt; [Field] is not a placeholder for you to type the field name in, it&#39;s actually the literal command for it to parse this correctly.

![Filter setup for tfs query](/images/SNAG-0036_q6zoow.png)

