# Case of the Mondays... causing me to randomly redefine the Scope of Global


Today, I was reminded that global temp tables scope lasts for the session, and doesn&#39;t last beyond that. The difference is the scope of the global temp allows access by other users and sessions while it exists, and is not limited in scope to just the calling session. For some reason I can&#39;t remember, I had thought the global temp table lasted a bit longer. Remembering this solved the frustration of wondering why my adhoc comparison report was empty..... #mondayfail [SQLMag article I referenced](http://goo.gl/FCs8lv)

