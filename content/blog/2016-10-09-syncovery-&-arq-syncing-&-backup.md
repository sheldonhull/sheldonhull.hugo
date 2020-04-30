---
date: "2016-10-09T00:00:00Z"
tags:
- cool-tools
- ramblings
title: "Syncovery & Arq - Syncing & Backup"
slug: "syncovery-&-arq-syncing-&-backup"
---

# Syncovery & Arq 5I've tried a lot of file sync/backup utilities.

{{< premonition type="info" title="Updated: 2020-04-29" >}}
broken image links removed
{{< /premonition >}}


The primary definition to get right is that there are two main functions people try to achieve with this type of software.

*   File Syncing: Syncing Files Between Cloud and Local
*   File Backup: Preserving Files, sometimes with versioning, in order to protect against loss.
These two approaches require a diffferent solution many times, as focusing on file syncing means you are more at risk, as handing conflicting sync scenarios might cause loss. However, file backup doesn't give you flexibility to grab files to sync to another machine in many cases (for example CrashPlan does a great job of being quiet and backing things up, however, it is not designed for syncing, rather a single machine archive).

## Syncovery

_Disclaimer: They provided a license for me to evaluate and provide feedback. This doesn't bias me, as I just love finding great software!_

I actually obtained [Syncovery ](http://bit.ly/2decyo1) back at the beginning of the year and so have had quite a bit of time to utilize.

### TL;DR

**Pros**

1.  It's a powerhouse of customization, which provides an incredibly customizable set of options
2.  Typically well documented and easy for a power user to figure out the options
3.  It can solve backups and file syncing inside the same app.
**Cons**
4.  It's a powerhouse of customization. This isn't something I'd recommend for a non-technical user.
5.  I ran into errors syncing with Amazon Cloud Drive with deletes. Wasn't able to figure that piece out completely, but for the most part everything ran smoothly.
So, would I recommend? If you are looking to solve some file syncing options between multiple systems, as well as backup files/folders and are willing to deal with tweaking it to get it just like you want, it's awesome. If you want something like plug and play, then you need to look at Arq instead. Arq provides an incredibly simply alternative for those focused on backup, and not on file syncing.

### Profile Overview

This provides an overview of all activity. Even though it's not necessarily a styled gui, and has a lot of detail, I think it's well designed for the information it's providing. Having tried some other apps I think I found the majority of what I needed pretty quickly here.
I had a huge backup to Amazon Cloud Drive of my entire lightroom catalog (600-800GB) and Syncovery handled the majority of this backup with no issues. I have run into some issues as you can see.

![Profile Overview](/images/profile-overview.png)

### Profile Settings

I won't go into every option, read their documentation for the full details.
At a high level, some of the powerful options I appreciated where the exact mirror vs smart tracking. Smart Tracking looks try and resolve the conflicts that can happen when syncing on several machines by choosing which version wins.

![Profile Settings](/images/profile-settings.png)

### Running backup in attended mode

Shows the current progress. I have used some backup apps that froze when running large backups in the past. So far, I've had good experinces with Syncovery's stability.


![Running backup in attended mode](/images/running-backup-in-attended-mode.png)

### Detailed Logs

The app provides the output via powershell console, or in your native editor. Since I prefer Sublime Text 3, this was perfectly fine with me. Nice detailed logs give me a chance to figure out any issues.

![Detailed Logs](/images/detailed-logs.png)

### A few other thoughts

Again, the options are too massive to cover them all. However, a few stood out to me.

*   Versioning deletes: Could have deleted files archived into a relative root folder, or a main archive folder, and then removed after a certain period. This provides a safety net for deletes to be reviewed.
*   Safety Checks: Deletes or overwrites over a certain percentage of the files will require manual run. This ensures something accidental doesn't cause a mass deletion of files in your cloud storage.
*   Zip versioning. If you want, you can version your backups with zipped contents
*   Remote agent: If you are using another computer and syncing between them, you can setup the destination to have an agent so a zipped copy could be unzipped locally on the system by the agent, or file scans could be run locally by this agent instead of a remote agent having to do all the work.
*   Run as a Service: I enabled to run as a service to ensure this always was running in the background
*   Change Detection: You can setup near real-time file sync based on monitoring a folder. With additional customization, you can tell it to batch up the changes if over a certain number are detected and do them in a batch run instead.

## Arq 5

_Disclaimer: Arq also provided me with a license to evaluate._
[Arq ](http://bit.ly/2debEIl)is on the app list for Amazon Cloud Drive supported applications.

### Arq approaches things differently

This tool is focused on file backup, so the options are going to be much different in focus. However, the approach reminds me a lot of the "Apple" approach with simplifying things.

![Arq approaches things differently](/images/arq-approaches-things-differently.png)

### Filtering Backup Selection

This is pretty straight forward. However, I was happy to see the folder filter options actually provide Regex matching as well for power users.

![Filtering Backup Selection](/images/filtering-backup-selection.png)

### Advanced Options

Again, the options are much more limited... and less daunting

![Advanced Options](/images/advanced-options.png)

### Arq approaches as encrypted backup

One big different to note is that if you are focused on backing up files like photography/video, then you probably want the cloud drive to have those files in their native format, to ensure they are usable to view from the cloud drive. Arq approaches things from a different standpoint. Your cloud drive will have encrypted blocks that this app can download and interpret. For privacy, this is fantastic. For media not so much. You have to decide if you want everything encrypted or "open".

### Windows User

This probably is just me, but I've had some issues with Arq 5 on Windows 10. They could probably use some better error messages, as this error detail wasn't very user friendly.
When I reached out to support in the past, I got an answer in 2 days, so their support has been responsive.

![Windows User](/images/windows-user.png)

## What Would I Recommend?

For the power user wanting to implement file sync and backup in a single utility, Syncovery all the way.
For anyone looking to do pure backups, with no configuration or tweaking, and ok with it being completely encrypted, then Arq.
They both have different focuses. For me, I've migrated to a hybrid approach. For personal code snippets I use Gists, as I can version control them. For media and settings I use Syncovery because I like the customization options. If I was focusing on something like CrashPlan for simplicity and simple configuration, I'd probably go with Arq for that.
One last one that I hope eventually is supported by Amazon Cloud Drive is Stablebits Cloud Drive. It has a lot of promise, but my tests a while back had it peforming really slow (not due to them, but [due to Amazon's throttling](http://bit.ly/2dec8hG)) Another similar to that was ExpanDrive. I wasn't able to contact them for a license to evaluate in my review, but my short trial seemed promising, as it tries to add the cloud provide as a drive, allowing you to manage in explorer... or [Xyplorer (yes I still use it!)](https://www.xyplorer.com/)
