---
date: 2019-10-08T20:55:01+00:00
title: Getting Starting With Terraform
slug: getting-started-with-terraform
excerpt:
  Getting started with using Terraform for infrastructure can be a bit daunting
  if you've not dived into this stuff before. I put this together as a write up for
  those looking to get their feet wet and have a better idea of where to go for getting
  going
tags:
  - infrastructure-as-code
  - devops
  - terraform
draft: true
toc: true
---

Getting started with using Terraform for infrastructure can be a bit daunting if you've not dived into this stuff before. I put this together as a write up for those looking to get their feet wet and have a better idea of where to go for getting going

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

## Deploying Infrastructure

## Tearing Down Infrastructure

## Dealing With Existing Infrastructure


## TODO: Remove terraform.workspace from name