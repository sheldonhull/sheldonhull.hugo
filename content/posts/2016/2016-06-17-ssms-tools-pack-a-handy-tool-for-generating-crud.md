---
date: "2016-06-17T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- cool-tools
- sql-server
title: "SSMS Tools Pack - A Handy Tool for generating CRUD"
slug: "ssms-tools-pack-a-handy-tool-for-generating-crud"
---

So I've had this tool around for a while, but never found much usage out of it to be honest. I didn't end up writing a review as I had other tools that did text replacements, and history/session saving. I've always considered this tools implementation of SQL History/Tabs saver the best period, even over Red Gate Tab History, SSMSBoost, etc. However, recommending the tool solely based on it's fantastic history saver wasn't really something I was going to do.However, having to generate some CRUD procs lately I found a new reason to appreciate this tool. I dusted it off, updated to the latest, and looked for the CRUD option I remember it having. Sure enough I ended up saving myself a lot of time and generated procs that were all standard with what I wanted to create. This gets my hearty approval to avoid tedious grunt work on creating procs. Since the tool throws in a great history/session saver to avoid losing work, it's even more of a recommended tool!

## CRUD Generator

_Disclaimer: I was provided with a license to give me time to fully review. This doesn't impact my assessment of the tool. I don't recommend tools without actually using them and seeing if they'd actually benefit me in my work_

[SSMS Tools Pack](http://bit.ly/1UEbUIW)
First, I know there are some great stored procs/scripts that people have written to do this. I appreciated those, but found I was going to spend a lot of time trying to customize to get the error handling and other scripted pieces in, so I revisted SMSS Tool Pack.

## create CRUD from context menu for entire database

![create CRUD from context menu for entire database](/images/create-crud-from-context-menu-for-entire-database.png)

## general options

![general options](/images/general-options.png)

## replacement text options

This has some potential to be very helpful! You could generate the user, date and time, and more to generate some comment headers and more.

![replacement text options](/images/replacement-text-options.png)

## replacement text example

![replacement text example](/images/replacement-text-example.png)

##select template

![select template](/images/select-template.png)

## insert template

I prefer a begin try and error catch output syntax. I was able to encapsulate the CRUD generator statements with the syntax I preferred, and no longer had to manually manipulate each file to get it where i wanted it. This was a lot of time saved!

![insert template](/images/insert-template.png)

## update template

![update template](/images/update-template.png)

## warning - case sensitive parameters

Make sure to keep the case correct on the variables. This is case sensitive.

![warning - case sensitive parameters](/images/warning---case-sensitive-parameters.png)

## saving you a lot of work...

Once you've clicked the generate CRUD the magic happens.
The results were a large list of prebuilt stored procedures for doing all the CRUD operations needed, with no extra work required. Win!

![saving you a lot of work...](/images/saving-you-a-lot-of-work.png)

## Other

Searching the history of previously executed queries, versions of files edited, and sessions of tabs is all excellently handled in the SQL History Search extension. My favorite part is the useful status messages such as

![Other](/images/other.png)

## History of Execution

![History of Execution](/images/history-of-execution.png)

## updates

Some recent updates were released with version 4 that might be beneficial for your workflow such as support for SSMS 2016, renaming of tabs, better insert generator, and some other things. Check out the website for more details.

## its not CRUD.... it's quite nice!

While it doesn't really do full formatting or other things, the organized query execution, CRUD generator, and some other features make it a nice tool if you have the budget to purchase. It's a especially a good tool for those who want to generate CRUD procs easily.
