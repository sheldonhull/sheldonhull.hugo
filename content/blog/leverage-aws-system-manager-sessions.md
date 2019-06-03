---
date: 2019-06-10T05:06:00+00:00
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

---
# Use Case

Leveraging aws system manager sessions can help with aws development, by eliminating the need to RDP for work that can be done via a PowerShell session. In addition, it can help bypass the need to use SSH tunneling, remote Windows management, or RDP hops into the final destination.

This leverages IAM Credentials, allowing consistent security management in alignment with other IAM policies, instead of having to manage another security setting like remote management would require, potentially reducing the security explore footprint.

* Quickly access an instance that normally would require an additional hop, and then evaluate
* Restart remote service without having to hop into it (or issue SSM prebuilt command docs)
* Interact in other ways that are more adhoc in nature, and don't have prebuilt SSM Documents ready to go.

## Browser

This is a great option for leveraging AWS Systems Manager web console. When you select start a session you'll be presented with the tagged instances by name that you can quickly select and start a remote session with. 

![Select Instances to Start Session Against](/images/SNAG-0000- 2019-06-03-112313.png "Select Instances to Start Session Against")

![Start Session](/images/SNAG-0000- 2019-06-03-112325.png "Start Session")

Once you've started the session you'll enter into a remote prompt. 

![Interactive PowerShell Prompt on Remote Instance](/images/SNAG-0000- 2019-06-03-112309.png "Interactive PowerShell Prompt on Remote Instance")

## Local Interactive Setup

I use Cmder for my main terminal, with all other terminals normally running in Visual Studio Code. If you open a Powershell session using the powershell plugin you can write your PowerShell in the editor, and the interactively run it in Visual Studio Code using the predefined `F8` key.

### Install on Windows

{{% gist d2c4b009e7da1845081327121a61a05c %}}

Ensure your AWS Credentials are setup, and use the session manager plugin after installation by running:

### Start Session

```powershell
aws ssm start-session --target MyInstanceId
```

### Limitations

Refresh rate is slow. Input for large script blocks from Visual Studio Code is also really slow. This means that putting a local function in scope by running `F8` against it and then wanting to run this function interactively can take a while.

The best use case I see is for adhoc administrative or investigative work. If larger scripts are required, then having a script setup to install module or copy from s3 would be a much more performance solution, as it wouldn't require large amounts of console text streaming.