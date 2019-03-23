---
date: "2016-10-17T00:00:00Z"
tags:
- sql-server
- mysteries
title: Cannot Generate SSPI Context
---

## Troubleshooting

I ran into an error: The target principal name is incorrect.  Cannot generate SSPI context. (Microsoft SQL Server, Error: 0)

I evaluated the sql server configuration manager protocols for sql server and saw that named pipes was disabled. I tried ensuring that this wasn't causing the issue, but enabling but it didn't fix. Thankfully, Andrew on StackOverflow had the answer here:

> First thing you should do is go into the logs (Management\SQL Server Logs) and see if SQL Server successfully registered the Service Principal Name (SPN). If you see some sort of error (The SQL Server Network Interface library could not register the Service Principal Name (SPN) for the SQL Server service) then you know where to start.
> We saw this happen when we changed the account SQL Server was running under. Resetting it to Local System Account solved the problem. Microsoft also has a guide on manually configuring the SPN.
> [Andrew 3/19/2014](http://stackoverflow.com/a/22505719/68698)

When I went into the configuration manager I changed the format from the DOMAIN\USER to searching with advanced and matching the user. The username was applied as USER@DOMAIN.COM instead. When I applied, and restarted the sql service, this still didn't fix.

I read some help documentation on this on [smatskas.com](http://bit.ly/2dZG6p7) but it didn't resolve my issue as I had the correct permissions, and I verified no duplicate SPN by running the command setspn -x
I ran gupdate /force to ensure was properly in sync with the policies and it did get the time updated. However, the problem persisted. I went back to checking for a specific conflict by running

Still no luck....

Finally, I switched the account to use LocalSystem (this was in a dev environment) following the [directions by Bob Sullentrup ](http://dba.stackexchange.com/a/150447/7682) and this allowed it to successfully register the SPN.

I'll update my blog post when I have a better understanding on exactly why this occurs, but for now, at least I was able to proceed.
