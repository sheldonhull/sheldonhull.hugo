# What was I thinking? Deleting myself from localdb?


Was testing a batch file to add a user to a localdb instance. Assumed that my user as admin on the machine wouldn&#39;t have an issue inserting myself back.... didn&#39;t think that one through too carefully. Executing any type of SQLCMD against it denied me. SSMS denied me. No SA had been setup on it, so I couldn&#39;t login as SA either. Looked for various solutions, and ended up uninstalling and reinstalling (localdb)v11.0 so that I&#39;d stop having myself denied permissions.

This however, didn&#39;t fix my issue. The solution that ended up working from me came from [dba.stackstackexchange](http://dba.stackexchange.com/questions/30383/cannot-start-sqllocaldb-instance-with-my-windows-account).

I ended up deleting everything in the v11.0 Instances folder and then issuing the following command `sqllocaldb.exe c v11.0`

Resulting in message: `LocalDB instance &#34;v11.0&#34; created with version 11.0.3000.0.`

Success! This resulted in the instance being created successfully, and then I was able to login with SSMS. Apparently today was my day for learning some localdb permissions issues. What a blast..... Could have avoided this if I had simply used a test login, or had setup the SA with a proper password for logging in. `#sqlfail`

