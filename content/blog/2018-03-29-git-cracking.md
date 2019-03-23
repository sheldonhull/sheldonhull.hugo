---
date: "2018-03-29T00:00:00Z"
excerpt: Git can be an interesting learning curve if you are coming from TFS (Team
  Foundation Server). However, there are some great things about using Git if you
  can wrap you head around the terminology
last_modified_at: "2018-03-29"
published: true
tags:
- cool-tools
- tech
- git
title: Git Cracking
toc: true
---

> info "Resources"
> - [GitKraken](http://bit.ly/2J6a4mW)
> - [Source Tree](http://bit.ly/2pPQeUU)
> - [Posh-Git](http://bit.ly/2pOPLm6)
> - [Cmder](http://bit.ly/2GnxzpH)

## Git Some Pain

Having come from a Team Foundation Server background, I found Git to be a bit confusing. The problem is primarily the big difference in a distributed version control system vs non-distributed. In addition to that complexity the terminology is not exactly intuitive. A lot of phrases like `PULL` have different results depending on what step you are in.

### Here's Your Sign
Here's my version of "Here's Your Sign" For Newbie Git Users That Are Coming from TFS Background

You Must a TFS'er using Git when...
- You commit changes, and refresh the TFS Source Control Server website trying to see your changes... but nothing ... ever... changes.
- You pull changes to get things locally, but then get confused about why you are submitting a `pull request` to give someone else changes?
- You want to use a GUI
- You use force options often because: 1) You are used to forcing `Get Latest` to fix esoteric issues 2) Force makes things work better in TFS (no comment)
- You are googling ways to forcibly reset your respository to one version because you don't know what the heck is out of sync and are tired of merging your own mistakes.
- You think branching is a big deal
- You think it's magical that you can download a Git repo onto a phone, edit, commit, and all without a Visual Studio Installation taking up half your lifespan.

I claim I'm innocent of any of those transgressions.
And yes, I use command line through Cmder to get pretend some geek cred, then I go back to my GUI. :-) I have more to learn before I become a Git command line pro. I need pictures.

## The Key Difference From TFS

The biggest difference to wrap my head around, was that I was working with a DVCS (Distributed Version Control System). This is a whole different approach than TFS, though they have many overlaps. I won't go into the pros/cons list in detail but here's the basics I've *pulled* (pun intended) from this.

### Pros

- I can save my work constantly in a local commit before I need to send remotely (almost like if I did shelves for each piece of work, and finally when `pushing` to server I'd be sending all my work with history/combined history)
- File Based Workspace. Local Workspaces in TFS have benefit of recognizing additions and other changes, but it's tedious to do. Git makes this much cleaner.
- Branching! Wow. This is the best. I honestly don't mess around with branching in TFS. It has more overhead from what I've seen, and is not some lightweight process that's constantly used for experimentation. (Comment if you feel differently, I'm not a pro at TFS branching). With Git, I finally realized that instead of sitting on work that was in progress and might break something I could branch, experiment and either merge or discard all very easily. This is probably my favorite thing. I'll be using this a lot more.

### Cons

- The wording.
- More complicated merging and branching seem a little more complex with DVCS than non distributed like TFS, but that's just my high level impression. YMMV

## GitKraken

[GitKraken](http://bit.ly/2J6a4mW), a Git GUI to solve your learning woes.

### Git GUI Goodness

I'm a Powershell prompt addict. I prefer command line when possible. However, I think GitKraken helped make this process a bit easier for me. I was using `posh-git` and Cmder initially, then Vscode with GitLens. However, other than basic commit/pull, I've found myself relying on GitKraken a lot more, as it's just fast, intuitive and easier to understand with my addled brain. *I'd rather leave energy for figuring out how to get [Query Optimization Through Minification]({% post_url 2017-01-23-bad-idea-jeans-query-optimization-through-minification %})*

###  Timeline
To be honest, their timeline view and the navigation and staging of the changes seemed pretty intuitive to me compared to what I'd seen in other tools. Overall, I found it easier to wrap my head around the concepts of Git with it, and less fear of merging changes from remote as I was able to easily review and accept changes through it's built in merging tool.

![GitKraken](/assets/img/2018-03-26_9-08-39-GitKrakenTimeline.png)

### Overall Impression

Overall impression is positive. I'd say it's a nice solution to help with understanding and getting up and running faster than some other solutions, or using Git via command line along. While that's a worthy goal, being able to easily review changes, amend commits, pull and merge remote changes from multiple sources, and other things, I'm not sure a newbie could do all at any time near what a little effort in GitKraken would provide. So overall, it's a win. I've used it for this blog and am pretty darn happy with it. The cost for professional if using in a work environment with the need for better profile handling, integration with VSTS and other services is a reasonable cost. For those just working with some Github open source repos and Jekyll blogs, they have a free community version, so it's a win!

## A Free Alternative

Source Tree from Atlassian is a pretty solid product as well that I've used. Unfortunatelym I've had stability issues with it lately, and it lacks the most important feature required for all good code tools... a dark theme :-)... on Windows at least as of now. No success getting dark theme traction except on Mac. -1 demerits for this omission! Overall it has promise, but it tends towards so many options it can be daunting. I'd lean towards the implementation by GitKraken being much cleaner, designed for simplicity and flexibility.

*Disclaimer: I like to review developer software from time to time, and occcasionally recieve a copy to continue using. This does not impact my reviews whatsoever, as I only use the stuff I find helpful that might be worth sharing. Good software makes the world go round!*
