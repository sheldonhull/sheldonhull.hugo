---
title: Compiling a Custom Provider and Including for Terraform Cloud
slug: compiling-a-custom-provider-and-including-for-terraform-cloud
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
* You have a good familiarity with Terraform and the concept of providers.
* You need to include a custom provider which isn't included in the current registry (or perhaps you've geeked out and modified one yourself 😁).
* You want to run things in Terraform Enterprise ☁.

## Terraform Cloud

For Terraform Cloud, bundling is not allowed.

Instead, the "legacy" way of running this is to include the plugin directly in the directory that Terraform will be invoked on with `terraform.d/plugins/linux_amd64` as the path containing the provider. See discussion: [Using Community Providers With Terraform Cloud](https://discuss.hashicorp.com/t/using-community-providers-with-terraform-cloud-api/5432/4).

Part of my current walk-through (primarily using terraform-bundle) is relevant only for Terraform Enterprise, not Terraform Cloud.
I missed the ending documentation section on the custom bundle requiring installation and not being supported in Terraform Cloud.

For the directions below, disregard the bundle aspect for Terraform Cloud, and instead focus on building the custom provider and including in the project directory as shown.

If you are willing to explore Atlantis, I bet something can be done with custom providers in there.

After following the custom provider build steps below, create a `.terraformignore` file in your project directory and put in the config below.

```text
.terraform
.git
.gtm
*.tfstate
```

With a backend like below, I was actually able to get terraform cloud to run the custom provider and return the plan.

```
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "myorg"

    workspaces {
      name = "terraform-artifactory"
    }
  }
}
```

If you get an error the first time you run this, see the troubleshooting section at the end.

## Custom Providers Bundling

As of the time of this post, to include a custom provider with Terraform Enterprise, you need to create a custom [terraform bundle](https://bit.ly/3fA4CZu) bundle to package up the terraform package and any desired custom plugins.

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

You need to target the platform for Go in the build step, as the Terraform Enterprise environment expects `Linux` and `amd64` as the target.

```powershell
git clone https://github.com/atlassian/terraform-provider-artifactory.git
git install .

# I use pwsh even on macOS 😁
#$ENV:GOOS='linux'
#$ENV:GOARCH='amd64'
#go build

#See troubleshooting section below. More robust than simple go build. This simplifies things and will generate all binaries for you

goreleaser build --snapshot
```

## Get Stuff Setup

```powershell
git clone https://github.com/hashicorp/terraform.git
```

To checkout a specific tagged version (recommended):

```powershell
git checkout tags/<tag_name>
```

Quick little #devhack... Use Git Graph in Visual Studio Code to make working with busy repositories much easier.
Yes, I'm no Vim magician. Sometimes a little visual help is much better than trying to do it all in cli. #heresy

![Use Git Graph to Visually Navigate A Busy Repo and Checkout a Tagged Commit](/images/2020-07-14_14-57-48_using_git_graph.png "Git Graph Makes Things Easier")

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

Here is a trimmed down example config with what worked for me.
See the bottom troubleshooting section for more details on why I did not adhere to the documented config from the README.

```hcl
terraform {
  version = "0.12.28"
}
providers {
 artifactory = ["0.0.0"]
}

```

We need to include this plugin in a [specific location](https://bit.ly/32jetib) for the bundle tool to do it's magic.

Also ensure you follow the naming convention for a provider.

> To be recognized as a valid plugin, the file must have a name of the form `terraform-provider-<NAME>`

This is where PowerShell shines, and it's easy to make this path without issue using `Join-Path` in a way that also is fully cross-platform with macOS, Linux, or Windows (pick your poison)

```powershell
try
{
    $version = terraform-bundle --version *>&1
    if ($version -notmatch '\d{1}[.]\d{2}[.]\d{1,2}') { throw "failed to run terraform bundle: $($_.Exception.Message)" }
}
catch
{
    Write-Host "Adding go bin/path to path so terraform-bundle can be resolved"
    $ENV:PATH += "${ENV:HOME}/go/bin/:$PATH"
}


$SOURCEHOST     ='github.com'  # any arbitrary value allowed per docs
$SOURCENAMESPACE='atlassian'    # any arbitrary value allowed per docs
$NAME           ='artifactory'
$OS             ='linux'
$ARCH           ='amd64'
$VERSION        = '0.0.0'
$PluginPath     = Join-Path plugins $SOURCEHOST $SOURCENAMESPACE $NAME $VERSION "${OS}_${ARCH}"
$null           = New-Item -Path $PluginPath -ItemType Directory -Force
Remove-Item -LiteralPath ./plugins -Recurse -Confirm:$false
New-Item plugins -ItemType directory -Force -ErrorAction silentlycontinue
Copy-Item ${ENV:HOME}/git/github/terraform-provider-artifactory/dist/terraform-provider-artifactory_linux_amd64/terraform-provider-artifactory -Destination (Join-Path plugins "terraform-provider-artifactory") -Force
terraform-bundle package -os=linux -arch=amd64 --plugin-dir ./plugins ./jfrog-bundle.hcl
```

Now to bundle this up

```powershell
terraform-bundle package -os=linux -arch=amd64 jfrog-bundle.hcl
```

## Troubleshooting

### Problems Parsing the bundle configuration file

I ran into some issues with it parsing the configuration file as soon as I added the custom plugin. It reported `unknown type for string *ast.ObjectType`.

Here's what I looked at:

In the project, there is a `tools/terraform-bundle/config.go` that is responsible for parsing the hcl file.

First, the configuration looks correct in taking a string slice for the versions, and the source is a normal string.

```go
type TerraformConfig struct {
    Version discovery.VersionStr `hcl:"version"`
}

type ProviderConfig struct {
    Versions []string `hcl:"versions"`
    Source   string   `hcl:"source"`
}
```

This seems to mean the configuration syntax of meets with the schema required by the configuration code.

```hcl
terraform {
    version = "0.12.28"
}
providers {
    artifactory = {
        versions = ["0.1"]
        source = "example.org/myorg/artifactory"
    }
}
```

It looks like the configuration syntax from the example is a bit different from what is being successfully parsed.
Instead of using the fully designated schema, I adjusted it to `artifactory = ["0.0.0"]` and it succeeded in parsing the configuration.

The help `terraform-bundle package --help` also provides an example indicating to just use the simple syntax and let it look for the provider in the default directory of `./plugins`.

### Failed to resolve artifactory provider 0.1: no provider exists with the given name

This next piece was a bit trickier to figure out.
Once I enabled `$ENV:TF_LOG = 'TRACE'` I found some output showing an issue with the version of the provider.

```text
2020/07/14 16:12:51 [WARN] found legacy provider "terraform-provider-artifactory"
plugin: artifactory (0.0.0)
- Resolving "artifactory" provider (0.1)...
- Checking for provider plugin on https://releases.hashicorp.com...
```

I went back to the provider project and installed [goreleaser](https://goreleaser.com/quick-start/) using: `brew install goreleaser/tap/goreleaser` which provided me the same tool to build the various packages for this provider.
Build the provider by running `goreleaser build --snapshot`.

After reviewing the help in more detail, the following CLI content conflicts with the main README.md, so I had to experiment with various output methods and finally... success! 🎉

The message did provide a warning: `found legacy provider "terraform-provider-artifactory-v2.0.0"`.

I tested and found it matched the local provider with `0.0.0` by running `terraform providers` and seeing the output:

```text
2020/07/14 16:49:52 [TRACE] Meta.Backend: backend *remote.Remote supports operations
.
└── provider.artifactory
```

However, what to bundle correctly required simplifying the output to no nested directories.

![What Actually Worked In Plugin Directory Was a simple flat directory](/images/2020-07-14_16-56-17-terraform-plugin-output.png "What Actually Worked In Plugin Directory")

The output of the bundle was successful with

```text
Fetching Terraform 0.12.28 core package...
2020/07/14 16:54:34 [TRACE] HTTP client HEAD request to https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
2020/07/14 16:54:35 [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
Fetching 3rd party plugins in directory: ./plugins
2020/07/14 16:54:37 [DEBUG] checking for provider in "./plugins"
2020/07/14 16:54:37 [WARN] found legacy provider "terraform-provider-artifactory"
plugin: artifactory (0.0.0)
- Resolving "artifactory" provider (0.0.0)...
Creating terraform_0.12.28-bundle2020071421_linux_amd64.zip ...
All done!
```

### Terraform Cloud Fails with terraform.tfstate detected

Since the local plugins seem to generate some tfstate for mapping the local plugin directory, I ensure you have a `.terraformignore` file in the root of your directory per the notes I provided at the beginning.

```text
Terraform Enterprise detected a terraform.tfstate file in your working
directory: <VCS-REPO>/terraform.tfstate
```

Once I added the `.terraformignore` the apparent conflict with uploading a local tfstate on the plugins was resolved and the plan succeeded.