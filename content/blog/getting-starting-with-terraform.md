---
date: 2019-10-08T20:55:01.000+00:00
title: Getting Starting With Terraform
slug: getting-started-with-terraform
excerpt: Getting started with using Terraform for infrastructure can be a bit daunting
  if you've not dived into this stuff before. I put this together as a write up for
  those looking to get their feet wet and have a better idea of where to go for getting
  going
tags:
- infrastructure-as-code
- devops
- terraform
toc: true
draft: true

---
Getting started with using Terraform for infrastructure can be a bit daunting if you've not dived into this stuff before. I put this together as a write up for those looking to get their feet wet and have a better idea of where to go for getting some momentum in starting. There are some assuptions in this, such as basic familarity with git for source control automation, basic command line usage, and basic cloud familarity. 

If time permits, I plan on writing up some more detailed walkthrough's in future posts on Terraform iteration methods, object types, dynamic data inputs, and other things I've explored. However, what I've found is just getting the initial start seems to be a blocker for many people interested in trying it. Hopefully, this will give someone a headstart on getting a basic plan going so they can understand how this works a little better and the other more detailed tutorials that abound will make more sense then. Give this post a clap or leave a comment if it helps you or you have any feedback. Cheers! :cheers:

## Resources

| Links                                                                                       | Description                          |
| ------------------------------------------------------------------------------------------- | ------------------------------------ |
| [Terraform Documentation Reference](https://www.terraform.io/docs/commands/cli-config.html) | Terraform Documentation for CLI      |
| [Terraform Documentation For AWS](http://terraform.io/docs/providers/aws)                   | Terraform AWS Provider Documentation |

## Setup

### Installation and setup

#### Windows

Install chocolatey via command prompt as administrator

```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```

Install the following chocolatey packages in adminstrator powershell prompt

```powershell
choco upgrade git terraform vscode vscode-powershell -y
```

### Terraform Cloud Setup

{{% premonition type="warning" title="Subscription" %}}
This will require a Terraform Cloud account. At the time of this post they have a plan for around 5 users for free with a few features turned off. This may change in the future, so when creating the account, you'll have to see what features are no longer enabled as this matures in the free product.
{{% /premonition %}}

Setup your [Terraform App Account](https://app.terraform.io/account/new) and _make sure to enable 2FA_.

Once you've been added, create a personal access token at your [user settings](https://app.terraform.io/app/settings/tokens) (this is personal, not team based)

Now you need to add this credential file to your system so terraform can find it, which will make the remainder of projects automatically work with it.

#### Windows

```powershell
$ConfigFile = Join-Path $ENV:AppData 'terraform.rc'
@"
credentials "app.terraform.io" {
    token = ""
}
"@ | Out-File $ConfigFile -Encoding UTF8
```

#### Mac

```sh
~/.terraformrc << ENDOFFILE
credentials "app.terraform.io" {
    token = ""
}
ENDOFFILE
```

## Creating Your First Project

Create `main.tf`. It will be the first file you create.
{{% gist 95c3f9533b2111d7d9fa40ff90a917e3 "main.tf" %}}

Create `provider.tf`

{{% gist 95c3f9533b2111d7d9fa40ff90a917e3 "provider.tf" %}}

Create `terraform.tfvars`

{{% gist 95c3f9533b2111d7d9fa40ff90a917e3 "terraform.tfvars" %}}

Create `variables.tf` which is going to house all the input variables we want to declare.

{{% gist 95c3f9533b2111d7d9fa40ff90a917e3 "variables.tf" %}}

Create `iam.tf` which will provide a nice low risk resource to create that will show you how to use string interpolation for dynamic names in the most simple way, as well as the way to leverage `EOT` syntax to easily escape mutliline strings. However, if you see yourself doing this constantly, you might reevaluate your approach to ensure you are using objects and properties as much as possible and not just strings.


{{% gist 95c3f9533b2111d7d9fa40ff90a917e3 "iam.tf" %}}

{{% premonition type="info" title="HCL Multiline String Syntax" %}}
If you use `<<-EOT` you get a nice little benefit that's not well documented. The `-` means it strings buffering whitespace for the following lines. This can allow you to keep your content indented and if you preface the first line with 6 spaces, then all the following lines trim 6 spaces as well to allow you to avoid a bunch of difficult to read string blocks.
{{% /premonition %}}

You'll likely want to use a workspace with Terraform to organize this work, so instead of using the default, use the command 

```terraform
terraform workspace new qa
```

Terraform should select this new workspace by default. You can list the current workspaces using `terraform workspace list` and then select another one later if you wish by running `terraform workspace select qa`. 

Personally, I'd recommend to not drive much of your naming or other configuration based on the workspace name, and instead use variables. Terraform Cloud behavior with trying to use workspace names at the time of this post was not what I expected, so I ended up removing my dependency on workspace names being imporant for the configuration. Instead, I use it as metadata only to organize the workspaces.

## Deploying Infrastructure

Deplying is as simple as running `terraform apply`. You'll get a preview of the plan before apply, and then you can approve it to actually apply.

### If You Connected This to Terraform Cloud

This is assuming you are running via Terraform Cloud. To run locally, you'll want to go to the workspace you created in Terraform Cloud and in the General Settings set to run locally instead of remote. This means you'll be able to run the apply directly on your machine instead of running it from the remote location.

Connecting your git repository to your Terraform workspace can also be done for automatically planning on commit. This forces changes to come through your git commits instead of being able to run locally, which can be great for ensuring source control truly is the equivalent of your release when working with a team.

## Tearing Down Infrastructure

To tear down the infrastructure we just deployed, you can run: `terraform destroy` and approve the resulting preview it gives you.