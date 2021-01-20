---
title: AWS Systems Manager Apply-DSCMofs for State Management on Windows EC2 Instances
date: 2021-01-22T19:00:00-06:00
toc: true
excerpt: Journey down the rabbit hole of DSC, AWS SSM, and poorly named AWS
  services with me...
tags:
  - tech
  - development
  - powershell
  - configuration
---

## AWS Needs Better Names

It's quite a mouthful of a title for a blog post.
Can't help it.
It's what AWS gave to us.
Simple Systems Manager turned out not to be so simple, so now it's Amazon Systems Manager.

I'll highlight the buzzwords so you can appreciate this.

Let's take a little trip. We are going to use `AWS (Not So Simple) Systems Manager` by navigating to the `State Manager` section, which will allow us to view `Associations` based on tags to apply desired `SSM Command Docs` to the targeted instances.

Having to write that down, I can now appreciate why it's been so hard to convince more folks to dive into it.

This service, like any other, has it's on quirks, so maybe you'll save sometime by building upon the foundation of my foibles.

## Definition

This isn't an intro into DSC, SSM, etc. You should know about those a bit to use this.

`Apply-DSCMofs` used compiled DSC plans, which produce a `mof` artifact. This artifact is placed in S3. The command pulls this down from S3 and runs this "state" based approach to configure, install, or do whatever you need based on the contents of your compiled mof file.

For me this was actually the 2nd time I applied DSC in production usage, so I'm still new to it, not having built my own custom DSC resource of anything like that at this time.

The alternative to using DSC was homegrown scripts, which I preferred to avoid for user management.


## Troubleshooting

If you are replacing an existing process to deploy the user, this might cause you a problem when you try to run DSC against an already existing adminstrative user with the error:

```text
Exception calling "SetInfo" with "0" argument(s): "This operation is disallowed as it could result in an administration account being disabled, deleted or unable to logon."
```

In this case, you can run an SSM Command to `Remove-LocalUser UserName` to cleanup the user account, and then reapply the DSC mof to deploy your service account.
