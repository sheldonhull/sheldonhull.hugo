---
title: Getting Started With Terraform
slug: getting-started-with-terraform
date: 2019-11-07T07:30:00+00:00
toc: true
excerpt: Getting started with using Terraform for infrastructure can be a bit
  daunting if you've not dived into this stuff before. I put this together as a
  write up for those looking to get their feet wet and have a better idea of
  where to go for getting going
tags:
  - tech
  - infrastructure-as-code
  - devops
  - terraform
---
{{< premonition type="info" title="Updated 2020-07" >}}
- Added comments about brand new Terraform users ignoring Terraform Cloud for first time tests.
- Added comment about pulling credentials using data source instead of environment variables for AWS as a more advanced option to consider in the future.
- Replaced details on creating terraform credential file with the new `tf login` command
{{< /premonition >}}

Getting started with using Terraform for infrastructure can be a bit daunting if you've not dived into this stuff before. 
I put this together as a write up for those looking to get their feet wet and have a better idea of where to go for getting some momentum in starting. 
There are some assumptions in this, such as basic familiarity with git for source control automation, basic command line usage, and basic cloud familiarity.

If time permits, I plan on writing up some more detailed walk through in future posts on Terraform iteration methods, object types, dynamic data inputs, and other things I've explored. 
However, what I've found is just getting the initial start seems to be a blocker for many people interested in trying it. 
Hopefully, this will give someone a head start on getting a basic plan going so they can understand how this works a little better and the other more detailed tutorials that abound will make more sense then. 
Give this post a clap or leave a comment if it helps you or you have any feedback. Cheers! :cheers:

## Purpose of This Post

{{< premonition type="info" title="Using Terraform Cloud 2020-07" >}}
If you are brand new to Terraform, then consider ignoring the "backend" section.
This will have all the artifacts that Terraform produces (such as the state file) just sit in your local directory.
In retrospect, Terraform Cloud intermixed with getting up and running as a new user might add more complication than required.
{{< /premonition >}}


In technical documentation, there is a difference between a tutorial and a getting started. The getting started here is going to focus just on getting up and running, not on all the concepts about infrastructure as code.
I found that just doing it the first time was the hardest thing.
Terminology about modules and re-usability at the beginning of my efforts with Terraform went straight over my head as I couldn't fully wrap my understanding around how it would work. 
Now that I've gotten a lot more experience with Terraform for various projects, I've got some personal "best-practices" that I've found as well as insight from the community. 

That's for another day :grin:

Let's just make sure you can get up and running with a basic deployment Terraform deployment from the scratch.

I had minimal Cloudformation authoring experience, so this was new stuff to me at the time.

## What about Cloudformation?

More knowledgeable people than me have written about this. I'll just say these personal subjective observations:

1. Terraform is recognized for being a great tool in the industry, it's not some "indie open source project about to fail". Hashicorp has some serious vision.
2. Just because you aren't going "cross provider" with Azure and AWS doesn't rule out Terraform. You aren't necessarily gaining anything special by "sticking with native" AWS CF, like you might think.
3. Terraform's much more succinct, less prone to whitespace/indentation failures.
4. IMO re-usability of Terraform provides itself to a better team collaborative experience.
5. Terraform's preview of changes is more intuitive to me. Less nervous to deploy stuff.
6. I just like HCL (Hashicorps DSL) better than writing YAML docs.
7. If you are writing YAML without any generator... just why!

## Resources

| Links                                                                                       | Description                          |
| ------------------------------------------------------------------------------------------- | ------------------------------------ |
| [Terraform Documentation Reference](https://www.terraform.io/docs/commands/cli-config.html) | Terraform Documentation for CLI      |
| [Terraform Documentation For AWS](http://terraform.io/docs/providers/aws)                   | Terraform AWS Provider Documentation |

## Setup

### Installation and setup

Install chocolatey via command prompt as administrator

```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```

For macOS
```shell
brew cask install terraform
```

### Terraform Cloud Setup

{{< premonition type="warning" title="Subscription" >}}
This will require a Terraform Cloud account.
At the time of this post they have a plan for around 5 users for free with a few features turned off.
{{< /premonition >}}

Setup your [Terraform App Account](https://app.terraform.io/signup/account) and *make sure to enable 2FA*.

Once you've been added, create a personal access token at your user settings (this is personal, not team based)

If you are using Terraform Cloud, run `tf login` to generate your local credential file to allow connecting to Terraform Cloud and easily using the registry and remote state workspaces provided.

## Creating Your First Project

Create `main.tf`. It will be the first file you create.
{{< gist 95c3f9533b2111d7d9fa40ff90a917e3 "main.tf" >}}

Create `provider.tf`

{{< gist 95c3f9533b2111d7d9fa40ff90a917e3 "provider.tf" >}}

Create `terraform.auto.tfvars`

Note that if you try to create this file with the `terraform.tfvars` name, it won't work if using Terraform Cloud, as tfvars get generated dynamically from the variables setup in the Cloud workspace.

{{< gist 95c3f9533b2111d7d9fa40ff90a917e3 "terraform.tfvars" >}}

Create `variables.tf` which is going to house all the input variables we want to declare.

{{< gist 95c3f9533b2111d7d9fa40ff90a917e3 "variables.tf" >}}

Create `iam.tf` which will provide a nice low risk resource to create that will show you how to use string interpolation for dynamic names in the most simple way, as well as the way to leverage `EOT` syntax to easily escape mutliline strings. However, if you see yourself doing this constantly, you might reevaluate your approach to ensure you are using objects and properties as much as possible and not just strings.

{{< gist 95c3f9533b2111d7d9fa40ff90a917e3 "iam.tf" >}}

{{< premonition type="info" title="HCL Multiline String Syntax" >}}
If you use `<<-EOT` you get a nice little benefit that's not well documented. The `-` means it strings buffering whitespace for the following lines. This can allow you to keep your content indented and if you preface the first line with 6 spaces, then all the following lines trim 6 spaces as well to allow you to avoid a bunch of difficult to read string blocks.
{{< /premonition >}}

You'll likely want to use a workspace with Terraform to organize this work, so instead of using the default, use the command

```terraform
terraform workspace new qa
```

Terraform should select this new workspace by default. You can list the current workspaces using `terraform workspace list` and then select another one later if you wish by running `terraform workspace select qa`.

{{< premonition type="warning" title="Terraform Workspace Naming" >}}
Personally, I'd recommend to not drive much of your naming or other configuration based on the workspace name, and instead use variables. 

Terraform Cloud behavior with trying to use workspace names at the time of this post was not what I expected, so I ended up removing my dependency on workspace names being important for the configuration. See [GitHub Issue](https://github.com/hashicorp/terraform/issues/22802#issuecomment-544499610)

Instead, I use it as metadata only to organize the workspaces, not try to build configuration based heavily on using workspace name.
{{< /premonition >}}

## Deploying Infrastructure

Deploying is as simple as running `terraform apply`. You'll get a preview of the plan before apply, and then you can approve it to actually apply.

### If You Connected This to Terraform Cloud

This is assuming you are running via Terraform Cloud. 
To run locally, you'll want to go to the workspace you created in Terraform Cloud and in the General Settings set to run locally instead of remote.

This means you'll be able to run the apply directly on your machine instead of running it from the remote location.
Running remote is great, but for this to work you need to edit your Terraform remote cloud workspace and add the AWS access keys, as the job is actually running in the remote context and not using your local machine credentials.

{{< premonition type="info" title="Terraform Cloud Credentials" >}}
My preferred solution for this is to setup another Terraform workspace to create the credentials and then call this datasource to provide me with access instead of having to configure environment variables per workspace.
This is a more advanced operation and not required on your first go-round, but keep it in mind as you scale up to managing many workspaces later on.
{{< /premonition >}}

Connecting your git repository to your Terraform workspace can also be done for automatically planning on commit. 
This forces changes to come through your git commits instead of being able to run locally, which can be great for ensuring source control truly is the equivalent of your release when working with a team.

## Tearing Down Infrastructure

To tear down the infrastructure we just deployed, you can run: `terraform destroy` and approve the resulting preview it gives you.

If you are using Terraform Cloud, in order to destroy a remote workspace (by queuing the destroy then destroying the workspace fully), you'll need to ensure the environment variable is set in the remote workspace for `CONFIRM_DESTROY = 1`

## Wrap up

Terraform documentation is pretty solid on all the provider resources, so you can normally copy and paste (or use vscode extension mentioned). 
Another great way to learn is to look at github and the various Terraform modules that have been published. 
You can see how they structure their code a bit better and learn from that as well.

If you are using Visual Studio Code, also download the Hashicorp Terraform extension for extra support.

Good luck! If any steps were unclear or confusing please put in a comment and I'll do my best to improve this for an initial on-boarding experience for a new Terraform user.