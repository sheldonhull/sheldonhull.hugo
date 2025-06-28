# Red Gate SQL Clone (1) - Initial Setup


Note this was during earlier beta usage, so some of the UI and other features will have been updated more. I plan on writing more on this promising tool as  I get a chance to dive into it more, especially the powershell cmdlets for database cloning automation. In the meantime, I believe the permissions issue is still relevant, so I&#39;ll post this as a reminder in case someone is working through the initial setup.

It seems like a real promising toolkit for testing and reducing storage requirements for testing database automated deployment pipelines.

![Clone Setup Getting Started](/images/2016-08-15_10-19-34.png)

![Clone Setup Creating Clone](/images/2016-08-15_10-11-17.png)

![Add to local admin on machine](/images/2016-08-15_10-19-04.png)

## Error starting service

&gt;The Redgate SQL Clone service on Local Computer started and then stopped. Some services stop automatically if they are not in use by other services or programs.

I wasn&#39;t using for a while due to error message I couldn&#39;t figure out. I then read through the help documentation again and found that the permissions required for the service account should be a **local admin**. Once I added the service account to local admins, it correctly allowed the service to start.

![Error if you don](/images/2016-08-15_10-17-17.png)

