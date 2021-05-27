---
date: 2021-05-25T18:11:54-05:00
title: Get Started With GoReleaser
slug: get-started-with-goreleaser
summary:
  Improve your CICD skills with building Go apps
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- tech
- development
- azure-devops
- go
- devops
draft: true
toc: true
# images: [/images/]
---

## GoReleaser

I'm a believer in setting up your project from the very beginning to support CICD.

The key things for this to work:

- Use a task runner for actions.
  - This allows the CICD job to call the same essential job you run locally.
  - It reduces effort in maintaining a CICD job with inline scripts by having it call the same commands you run locally.
  - The CICD service doesn't become super critical to your job, as it's just running your task commands, rather than relying on difficult to debug plugins.
- Use versioning such as GitVersion[^gitversion] or svu[^svu] to allow automatic metadata parsing
- Use tools like GoReleaser[^goreleaser]

{{< admonition type="Tip" title="Semver Versioning" open="true">}}

Protip: This can be passed to tools such as Datadog for comparison in APM tools.
You'd set the build flags to pass in this build time value and then your binary would contain version metadata.

{{< /admonition >}}

[^goreleaser]: [GoReleaser](https://goreleaser.com/)
[^gitversion]: [GitVersion](https://github.com/GitTools/GitVersion)
[^svu]: [svu](https://github.com/caarlos0/svu)

## Why Use GoReleaser

You can get by with a multistage docker build, make build style command, or other basic example.
However, if you go with GoReleaser, you'll save a massive amount of effort to bring CICD into the mix, as it wraps up a lot of functionality that can simplify releases.

Look at the website for a list of plugins.

## How I've Found It Useful

- Build go locally for Darwin, Linux, and Windows.
- Copy that same binary automatically into a docker container and tag
- Publish this tagged image to AWS ECR or Docker.
- Zip up the artifact and copy to S3 for distribution (including with a little effort automatic github download and install scripts)

{{< admonition type="Info" title="GoReleaser Vs Tasks" open="true">}}

Be aware GoReleaser is focused on Go.
If you need to build some Docker images with no Go binaries involved, then you will have some minor effort to add this as a seperate task.

As of now, I've not gotten docker images unassociated with Go binaries to build and publish.

{{< /admonition >}}
## Basic Start

```yaml

```
