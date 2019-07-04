---
date: 2019-07-04T22:24:01+00:00
title: AWS SSM PowerShell Script Automation
slug: aws-ssm-powershell-script-automation
excerpt: simply your management of instances in AWS by learning how to pass PowerShell
  commands through the AWSPowershell cmdlets without having to handle complicated
  string escaping
tags:
- powershell
- devops
- aws
draft: true

---
## SSM Overview

I've found that working with a large number of environments in AWS can provide some interesting challenges for performing various tasks, in a way that scale. 

When you begin to have dozens to hundreds of servers that you might need to provide a quick fix, the last thing you want to do is RDP into each and perform some type of scripted action. 

AWS SSM (Systems Manager) provides a tremendous amount of functionality to help manage systems. It can perform tasks from running a script, installing an application, and other mundane administrative oriented tasks, to more complex state management, AMI automation, and other tasks that might go beyond the boundaries of virtual machine management. 

I'll probably be unpacking a few of these areas over the next few posts, since my world has been heavily focused on SSM usage in the last months, and leveraging it is a must for those working heavily with EC2.

## PowerShell Execution

For the first simple example, AWS SSM provides documents that wrap up various scripted actions and accept parameters. This can be something like Joining a domain or running a shell script. 

In my case, I've had the need to change a registry setting, restart a windows service, or set an environment variable across an environment. I additionally wanted to set the target of this run as a tag filter, instead of providing instanceid, since this environment is rebuilt often as part of development. 

The commands to execute scripts have one flaw that I abhor. I hate escaping strings. This probably comes from my focused effort on mastering dynamic t-sql, at which point I quickly tried to avoid using dynamic sql as much as possible as I realized it was not the end all solution I started to think it was when I just started learning it. 

With PowerShell and AWS SSM things could get even messier. You'd have to pass in the command and hope all the json syntax and escaping didn't error things out. 

## The solution
Write PowerShell as natively designed, and then encode this scriptblock for passing as an encoded command. I've found for the majority of my adhoc work this provided a perfect solution to eliminate any concerns on having to escape my code, while still letting me write native PowerShell in my Vscode editor with full linting and syntax checks. 

