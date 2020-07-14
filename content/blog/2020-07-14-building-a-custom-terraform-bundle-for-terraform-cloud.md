---
title: Building A Custom Terraform Bundle for Terraform Cloud
slug: building-a-custom-terraform-bundle-for-terraform-cloud
date: 2020-07-14T13:00:00-05:00
toc: true
excerpt: If you need to include a custom provider with Terraform Cloud, you
  currently need to perform some special work to package everything together
  properly. Here's how I did it to give you a jump start
tags:
  - tech
  - development
  - go
  - terraform
---
## Assumptions

* You are familiar with the basics of setting up `Go` and can run basic Go commands like `go build` and `go install` and don't need much guidance on that specific part.
* You have good familiarity with Terraform and the concept of providers.
* You need to include a provider that isn't included in the current registry (or perhaps you've geeked out and modified one yourself 😁).
* You want to run things in Terraform Cloud ☁.

## Custom Providers in Terraform Cloud

As of the time of this post, to include a custom provider, you need to create a custom [terraform bundle](https://bit.ly/3fA4CZu).

This terraform bundle includes the terraform program, as well as any range of other providers that you want to include for running in the remote terraform workspace.

Before you go down this route, you should make sure that the [Terraform Registry](https://registry.terraform.io/browse/providers?tier=community) doesn't already include the provider you need.

## Source Of Truth

For the most up to date directions, you can go through these directions:

* [Setting Up Development Environment](https://bit.ly/2ZsG9iX)
* [Using Terraform Bundle](https://bit.ly/3fA4CZu)
* [Installing Custom Software](https://www.terraform.io/docs/cloud/run/install-software.html)

## Compiling the custom provider

In this example, I'm working with a provider for Jfrog Artifactory, which IMO has an atrocious management experience on the web.
By compiling this custom provider, my goal was to provide a clean user, repository, and group management experience.

You need to target the platform for Go in the build step, as the Terraform Cloud environment expects `Linux` and `amd64` as the target.

```powershell
git clone https://github.com/atlassian/terraform-provider-artifactory.git
git install . 

# I use pwsh even on macOS 😁
$ENV:GOOS='linux'
$ENV:GOARCH='amd64'
go build
```

## Get Stuff Setup

```powershell
git clone https://github.com/hashicorp/terraform.git
```

To checkout a specific tagged version (recommended):

```powershell
git checkout tags/<tag_name>
```

Next, you'll want to install and validate your install worked.
`go install` ensures that dependencies are downloaded, so once again the magic of `Go` wins the day.
If you flip to a new tagged version, make sure to rerun the install so you have the correct version of the tooling available.

```powershell
go install .
go install ./tools/terraform-bundle
```

For some reason, I had issues with the path picking it up in my current session, so for expediency, I just ran the next steps with the fully qualified path: `/Users/sheldonhull/go/bin/terraform-bundle` instead of `terraform-bundle` directly.

Grab an example of the configuration `hcl` file for the terraform-bundler from the link mentioned above.
Then you can create this in the project directory or qualify it to a subdirectory if you want to save various bundle configuration files. 

```powershell
mkdir mybundles
New-Item -Path ./mybundles/terraform-bundle.hcl -ItemType File
```

Here is a trimmed down example config.

```hcl
terraform {
  version = "0.12.28"
}
providers {
  customplugin = {
    versions = ["0.1"]
    source = "atlassian/tf/artifactory"
  }
}
```

We need to include this plugin in a [specific location](https://bit.ly/32jetib) for the bundle tool to do it's magic.

Also ensure you follow the naming convention for a provider.

>  To be recognized as a valid plugin, the file must have a name of the form terraform-provider-<NAME>

This is where powershell shines, and it's easy to make this path without issue using `Join-Path` in a way that also is fully cross platform with macOS, Linux, or Windows (pick your poison)

```powershell
# From the terraform project directory
$SOURCEHOST     ='example.org'  # any arbitrary value allowed per docs
$SOURCENAMESPACE='myorg'    # any arbitrary value allowed per docs
$NAME           ='artifactory'
$OS             ='linux'
$ARCH           ='amd64'
$VERSION        = '0.1'
$PluginPath     = Join-Path plugins $SOURCEHOST $SOURCENAMESPACE $NAME $VERSION "${OS}_${ARCH}"
$null           = New-Item -Path $PluginPath -ItemType Directory -Force
Copy-Item ${ENV:HOME}/go/bin/linux_amd64/terraform-provider-artifactory -Destination $PluginPath -Force
```

Now to bundle this up

```powershell
terraform-bundle package -os=linux -arch=amd64 mybundle/jfrog-bundle.hcl
```

If you get an error `unknown type for string *ast.ObjectType` try to make sure your fully qualified path to the plugin is correct.