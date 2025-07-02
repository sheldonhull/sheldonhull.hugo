---
title: Assume a role with AWS PowerShell Tools
slug: assume-a-role-with-aws-powershell-tools
date: 2020-07-21T20:00:00-05:00
toc: true
summary: However, as I've wanted to run some scripts across multiple accounts,
  the need to simplify by assuming a role has been more important.
tags:
  - tech
  - development
  - aws
  - powershell
---
## Assume A Role

I've had some issues in the past working with `AWS.Tools` PowerShell SDK and correctly assuming credentials.

By default, most of the time it was easier to use a dedicated IAM credential setup for the purpose.

However, as I've wanted to run some scripts across multiple accounts, the need to simplify by assuming a role has been more important.

It's also a better practice than having to manage multiple key rotations in all accounts.

First, as I've had the need to work with more tooling, I'm not using the SDK encrypted `json` file.

Instead, I'm leveraging the `~/.aws/credentials` profile in the standard `ini` format to ensure my tooling (docker included) can pull credentials correctly.

Configure your file in the standard format.

Setup a `[default]` profile in your credentials manually or through `Initialize-AWSDefaultConfiguration -ProfileName 'my-source-profile-name' -Region 'us-east-1' -ProfileLocation ~/.aws/credentials`.

If you don't set this, you'll need to modify the examples provided to include the source `profilename`.



Next, ensure you provide the correct Account Number for the role you are trying to assume, while the MFA number is going to come from the "home" account you setup.
For the `Invoke-Generate`, I use a handy little generator from `Install-Module NameIt -Scope LocalUser -Confirm:$false`.



Bonus: Use Visual Studio Code Snippets and drop this in your snippet file to quickly configure your credentials in a script with minimal fuss. 🎉



I think the key area I've missed in the past was providing the mfa and token in my call, or setting up this correctly in the configuration file.

## Temporary Credentials

In the case of needing to generate a temporary credential, say for an environment variable based run outside of the SDK tooling, this might also provide something useful.

It's one example of further reducing risk vectors by only providing a time-limited credential to a tool you might be using (can limit to a smaller time-frame).



## AWS-Vault

Soon to come, using [aws-vault](https://bit.ly/3eTwztU) to improve the security of your AWS sdk credentials further by simplifying role assumption and temporary sessions.

I've not ironed out exactly how to deal with some issues with using this great session tool when jumping between various tools such as PowerShell, python, docker, and more, so for now, I'm not able to provide all the insight.
Hopefully, I'll add more detail to leveraging this once I get things ironed out.

Leave a comment if this helped you out or if anything was confusing so I can make sure to improve a quick start like this for others. 🌮
