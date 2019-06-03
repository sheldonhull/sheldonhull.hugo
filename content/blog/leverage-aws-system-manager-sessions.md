---
date: 2019-06-03T16:38:48+00:00
title: Leverage AWS System Manager Sessions
slug: leveraging-aws-system-manager-sessions
excerpt: leveraging aws system manager sessions can help with aws development, by
  eliminating the need to RDP for work that can be done via a PowerShell session.
  In addition, it can help bypass the need to use SSH tunneling, or RDP hops into
  the final destination.
tags:
- tech
- aws
- devops
draft: true

---
# Use Case
Leveraging aws system manager sessions can help with aws development, by eliminating the need to RDP for work that can be done via a PowerShell session. In addition, it can help bypass the need to use SSH tunneling, remote Windows management, or RDP hops into the final destination.

This leverages IAM Credentials, allowing consistent security management in alignment with other IAM policies, instead of having to manage another security setting like remote management would require, potentially reducing the security explore footprint.


## Browser







I use Cmder for my main terminal, with all other terminals normally running in Visual Studio Code. If you open a Powershell session using the powershell plugin you can write your powershell in the editor, and the interactively run it in Visual Studio Code using the predefined `F8` key. 


## Local Interactive Setup

{{% gist d2c4b009e7da1845081327121a61a05c %}}

Ensure your AWS Credentials are setup, and use the session manager plugin after installation by running:


```powershell
aws ssm start-session --target MyInstanceId
``