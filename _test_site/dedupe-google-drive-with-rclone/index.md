# Dedupe Google Drive with RClone


## An issue with duplicates

I migrated from Amazon Cloud Drive to a paid Google Drive account. To facilate this move, I used a paid service called MultCloud. For me, Comcast prevents unlimited data, so it would have been challenging to manage 1.5TB of video and photography files movement by downloading then reuploading to Google Drive.

I ran into issues due to hitting rate limiting with Multcloud. As a result, I had to work through their awkard user interface to relaunch those jobs, which still had failures. I basically was left at the point of not really trusting all my files had successfully transferred.

What&#39;s worse is that I found that the programmatic access by MultCloud seemed to be creating duplicates in the drive. Apparently Google Drive will allow you have to files side by side with the same name, as it doesn&#39;t operate like Windows in this manner, instead each file is considered unique. Same with folders.

![Duplicate Images](/images/2018-08-20_00-09-09.png)


## RClone

I ran across RClone a while ago, and had passed over it only to arrive back at the documentation regarding Google Drive realizing they have specific functionality for this: [dedupe](https://rclone.org/commands/rclone_dedupe). After working through some initial issues, my situation seems to have improved, and once again Google Drive is usable. In fact, it&#39;s time for some house cleaning.

## Successfully Running

I suggest you make sure to find the [developer api section](https://console.developers.google.com/apis/api/drive.googleapis.com/) and create an api access key. If you don&#39;t do this and just use Oauth2, you are going to get the dreaded message: `Error 403: Rate Limit Exceeded` and likely end up spending 30&#43; mins trying to track down what to do about this.
![403 Rate Limit Messages](/images/TailBlazer_2018-08-19_18-06-22.png)

You&#39;ll see activity start to show up in the developer console and see how you are doing against your rate limits.
![Developer Console](/images/chrome_2018-08-19_23-45-28.png)


## Start Simple and Work Up From There

To avoid big mistakes, and confirm the behavior is doing what you expect, start small. In my script at the bottom, I walked through what I did.

![Magic As It Works](/images/TailBlazer_2018-08-19_21-14-28.png)


## Other Cool Uses for RClone

### Merging
While I think the `dedupe` command in RClone is specific to Google Drive, you can leverage it&#39;s logic for merging folders in other systems, as well as issue remote commands that are server side and don&#39;t require download locally before proceeding.

### Server Side Operations
This means, basically I could have saved the money over MultCloud, and instead used Rclone to achieve a copy from Amazon Cloud Drive to Google Drive, all remotely with server side execution, and no local downloads to achieve this. This has some great applications for data migration.

For an update list of what support they have for server side operations, take a look at this page: [Server Side Operations](https://rclone.org/overview/#optional-features)

### AWS
This includes quite a few nifty S3 operations. Even though I&#39;m more experienced with the AWSPowershell functionality, this might offer some great alternatives to syncing to an s3 bucket

### Mounting Remote Storage As Local

Buried in there was also mention of the ability to mount **any** of the storage systems as local drives in Windows. See [RClount Mount documentation.](https://rclone.org/commands/rclone_mount/). This means you could mount an S3 bucket as a local drive with RClone. I&#39;ll try and post an update on that after I try it out. It&#39;s pretty promising.

{{&lt; gist sheldonhull  e286bd05ff154b47c8a1f8ecf2bdc22b &gt;}}

