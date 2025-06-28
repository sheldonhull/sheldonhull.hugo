# Parallel Powershell for Running SQL


This is just a quick look. I plan on diving into this in the future more, as I&#39;m still working through some of the changes being made in the main parallel modules I utilize for SQL server. In the meantime, if you are looking for a quick way to leverage some parallel query running, take a look at [PSParallel](http://bit.ly/2gcXl7H). I&#39;ve avoided Powershell Jobs/Workflow due to limitations they have and the performance penalty I&#39;ve seen is associated with them.For my choice, I&#39;ve explored PSParallel &amp; PoshRSJob.
I&#39;ve found them helpful for running some longer running queries, as I can have multiple threads running across server/database of my choice, with no query windows open in SSMS.
Another great option that is under more active development is [PoshRsJob](http://bit.ly/2gd0aW2). Be clear that this will have a higher learning curve to deal with as it doesn&#39;t handle some of the implicit import of external variables that PSParallel does. You&#39;ll have to work through more issues initially to understand correctly passing parameters and how the differents scope of runspaces impact updating shared variables (ie, things get deeper with synchronized hashtables and more :-) )
Hope this helps get you started if you want to give parallel query execution a shot. Here&#39;s a function using PSParallel to get you started. Let me know if it helps

{{&lt; gist sheldonhull  5bb1a8adea09276c4fd274b5b2900b6a &gt;}}

