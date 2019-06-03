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

* Quickly access an instance that normally would require an additional hop, and then evaluate
* Restart remote service without having to hop into it (or issue SSM prebuilt command docs)
* Interact in other ways that are more adhoc in nature, and don't have prebuilt SSM Documents ready to go.

## Browser

![](images/SNAG-0000- 2019-06-03-112313.png)

![](images/SNAG-0000- 2019-06-03-112325.png)

![](images/SNAG-0000- 2019-06-03-112309.png)

## Local Interactive Setup

I use Cmder for my main terminal, with all other terminals normally running in Visual Studio Code. If you open a Powershell session using the powershell plugin you can write your powershell in the editor, and the interactively run it in Visual Studio Code using the predefined `F8` key.

### Install

{{% gist d2c4b009e7da1845081327121a61a05c %}}

Ensure your AWS Credentials are setup, and use the session manager plugin after installation by running:

### Start Session

```powershell
aws ssm start-session --target MyInstanceId
```

### Limitations

Refresh rate is slow, and input for large blocks of text is also really slow. This means that putting a local function in scope by runnning `F8` against it and then wanting to run this function interactively can take a while.

The best use case I see is for adhoc administrative or investigative work, not requiring large script blocks to be run.