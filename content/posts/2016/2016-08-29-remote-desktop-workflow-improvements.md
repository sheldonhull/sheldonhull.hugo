---
date: "2016-08-29T00:00:00Z"
tags:
- cool-tools
- sql-server
- ramblings
title: "Remote Desktop Workflow Improvements"
slug: "remote-desktop-workflow-improvements"
toc: true
---

Remote server management is a fact of life for folks involved with sql server. Since we work so often with remote machines I looked into a few tools that provided a better workflow than the default Microsoft tools. This one came out as the winner by far.

## A better remote desktop manager

First off, if you are using RDC.... why? At least move up to RDCMan, a microsoft tool that allows for much quick context switching between machines, inherited password settings for a group of servers, and more.
Next, if you are using RDCMan... and perhaps you work with a lot of remote machines, perhaps there is an even better option? There are some great alternatives out there, and in my experience, with a little learning curve, the one I've worked on with Devolutions is fantastic!
Link to app: [Devolutions Remote Desktop Manager ](http://bit.ly/1Pey0Qs)

## Devolutions Remote Desktop Manager

_Disclaimer: I have been provided with a free license because I mentioned I might review the product. This doesn't impact my assessment of the tool._
I'm a big fan of this app after having used it for months to get a feel for it. I've found it helpful when working with remote desktop machines, as well as some basic credential management. For folks dealing with lots of remote machines, I think this tool is well worth the investment and it has my stamp for one of my top essential tools in my cool-tools toolkit.
There is a free version that is less powerful, but a still a good upgrade from the standard RDM from microsoft. [The free version comparison is located HERE](http://bit.ly/1Pexsdy)

## Synchronizer... some potentially powerful automation here for managing connections to remote machines

Having to deal with a lot of remote machines, especially ones that change IP addresses periodically can be annoying for a DBA trying to remotely connect again. Devolutions Remote Desktop Manager (RDM) has some really cool functionality that can help automate refreshing these lists from a variety of sources.

![Synchronizer... some potentially powerful automation here for managing connections to remote machines](/images/synchronizer-some-potentially-powerful-automation-here-for-managing-connections-to-remote-machines.png)

## Synchronized Session Listing

You can setup a synchronized session listing based on csv, activedirectory, spiceworks, and more. Eventually, I believe they'll have an amazon ec2 synchronizer as well. In the meantime, with some powershell magic we can create a synchronized listing of remote machines to work with, no longer having to update ip's manually in a Amazon EC2 system.

![Synchronized Session Listing](/images/synchronized-session-listing.png)

## Output Results from Powershell into CSV Source

setup a powershell script that would obtain EC2 instances and output into a csv file.
I found pieces of the needed code from various sources and modified to work for me. It's not elegant, and much better ways are available I'm sure. This was helpful to me though and got the job done!

[Gist](https://gist.github.com/sheldonhull/f38807512bbbc14a5aab0680dccd4fba)


![Output Results from Powershell into CSV Source](/images/output-results-from-powershell-into-csv-source.png)

## Automatically keeping things up to date

Synchronizing automatically gives us the flexibility to have a scheduled script to run the powershell command to get a new list of machines, and have the synchronized list run automatically maintain the latest connection information. In my case, I setup the powershell script to run every X hours so my connection information was always up to date.

![Automatically keeping things up to date](/images/automatically-keeping-things-up-to-date.png)

## organized results

Thanks to the synchronizer, I know have two folders with separated instances for production and QA, allowing me to quickly access with minimal effort!
This would allow me to set credentials as well, to reduce the effort in logging in for each of the sets of instances

![organized results](/images/organized-results.png)

## Other Cool Stuff

### Multiple Monitor Support

Microsoft remote desktop connections have support for multiple monitors by spanning display. I tested this out with an unconventional setup. I have 3 24inch monitors, with 1 landscape in the middle surrounded by 2 in portrait mode. It had some problems with this as it's trying to create a spanned clone, however, if I had a typical setup, I think this would work fine, (such as a dual screen setup with the same orientation).

![Multiple Monitor Support](/images/multiple-monitor-support.png)

### Continual Updates

I'm continually getting updates on this product. In any inquiries on their forum, I've seen helpful responses from staff within the day, with great support help (such as powershell tips on accomplishing what I needed with synchronizers)

![Continual Updates](/images/continual-updates.png)

### Better Local Password Management

I'm a big fan of Lastpass, but as I use it for personal password management, I wanted to keep my work related passwords entirely separate. Devolutions RDM offers some nice password management options and credential inheritance setup.

![Better Local Password Management](/images/better-local-password-management.png)

### Jump

If you have a scenario where you need to remote into one machine and then remote from that machine to another, things can get very confusing with copying/pasting/navigating. RDM solves this by having a "RDM Jump Agent", basically a service that allows you to set a remote desktop connection as a "jump point" and then connect through that connection to the next destination, while using one remote desktop window in the app. For those scenarios, I found it incredibly helpful.  Best scenario... just avoid having to jump in the first place :-)

### Handles Remote Desktop Connections + The Kitchen Sink

*   Handles a breadth of different types of remote connections, such as Chrome remote desktop manager, Hyper V, remote command line, powershell sessions, Amazon S3, Amazon AWS console, Citrix ICA/HDX, and more.
*   Can wrap up the trick of running SSMS (Sql Management Studio) with "RunAs" as a different domain and user, allowing locally run SSMS to be connected to AWS, or other environments.

![Handles Remote Desktop Connections + The Kitchen Sink](/images/handles-remote-desktop-connections---the-kitchen-sink.png)

### Other Odds and Ends

Lots of features, so I'm just covering some of the highlights that are of interest to me.

*   Quickly ping and get status
*   View event logs from remote machine loaded in your local event viewer
*   List services
*   Run powershell script remotely with RDM-Agent (executes the script as if running locally, and could do this in parallel with other instances)

![Other Odds and Ends](/images/other-odds-and-ends.png)

## Summary

I review quite a few apps, but this one is really difficult to review in detail as it covers such a range of functionality I've never even touched. The only con to the app I'd say is it can have a bit of a higher learning curve than using the plain old Remote Desktop Manager from windows due to the breadth of functionality it covers. However, once using this app, and discovering little pieces of functionality here and there, this is in my permanent "essential tools" toolkit.

### Free version

They have a free version that will suffice for many people. The pro version has more enterprise level focus, so give the free one a shot if you are looking for a basic improvement to your RDM workflow

> ####
> [Remote Desktop Manager - Remote connection and password management software](http://remotedesktopmanager.com)
>
> Remote Desktop Manager is an all-in-one remote connections, passwords and credentials management platform for IT teams trusted by over 270,000 users in over 120 countries.
<script data-preserve-html-node="true" async=" src="platform.js" charset="UTF-8"></script>
