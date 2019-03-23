---
date: "2016-06-14T00:00:00Z"
tags:
- cool-tools
- sql-server
title: 'OmniCompare: A free tool to compare SQL Instances'
toc: true
---

## comparing instances

When working with a variety of instances, you can often deal with variances in configuration that might impact the performance. Without digging into each instance you wouldn't know immediately that this had happened. There are fantastic tools, like Brent Ozar's SP_Blitz, but this doesn't focus on every single configuration value and cross instance comparison. To supplement great material like that a tool like OmniCompare is great.

## side by side comparison

![Initial View of Comparison](/assets/img/initial-view-of-comparison.png)
I am definitely adding to my list of great sql tools. OmniCompare provides a side by side comparison of various configuration and system related values in a side by side format so you can easily see variances in basic configuration.

## release post

I read the post about this by [Phil Grayson here](http://bit.ly/25Wg7TM) . He's got some great examples of what you could use it for, such as auditing, performancing tuning, synchronizing server settings, and more. [The link for OmiCompare to try it out](http://bit.ly/25Wga1H)

## synchronization

Apparently, it's got the ability to synchronize some of the configuration settings so you could use a template to help setup a new configuration of sql server quickly. I haven't had a chance to try that piece out, but I will be exploring it for sure! It might be something that is in the works, as I couldn't find the options to synchronize currently in the tool. Sounds a lot more elegant than my homebrewed scripts that a nest of code needing some cleaning.
Well done Aireforge team!

## Easy Visual Summary of differences

Quite a few ways to filter and sort down to the information you care about.

![Easy Visual Summary of differences](/assets/img/easy-visual-summary-of-differences.png)

## Listing of the servers you want to compare

Add more or import a list of them to easily do a comparison on configuration in the environments.

![Listing of the servers you want to compare](/assets/img/listing-of-the-servers-you-want-to-compare.png)

## Configuring A Server

Simple and quick to add a server, as well as tag them so you can easily compare based on whatever grouping you see fit. For example, you could compare all common versions, all UAT type environments, etc.

![Configuring A Server](/assets/img/configuring-a-server.png)

## Configuration Differences

Makes it very easy to immediately just view configuration scoped differences between each

![Configuration Differences](/assets/img/configuration-differences.png)
