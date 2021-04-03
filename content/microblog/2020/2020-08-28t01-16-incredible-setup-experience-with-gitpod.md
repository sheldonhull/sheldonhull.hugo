---
title: Incredible setup experience with gitpod
date: 2020-08-27T20:00:00-05:00
tags:
  - tech
  - development
  - microblog
  - docker
  - kubernetes
  - terraform
---
What a polished setup experience from gitpod. Super impressed as I've never seen an interactive terraform setup asking for user input.

This basically generated an entire setup for GitPod, and persisted the Terraform plan for the entire stack it created in a directory for management and adjustments as desired.

I'm seriously impressed.

Check this out at: [Install on AWS](https://bit.ly/2YGACVe)

```powershell
# Setup Gitpod with self-setup docker installer
# https://www.gitpod.io/docs/self-hosted/latest/install/install-on-aws-script/
# Set-Location ./terraform/gitpod

Import-Module aws.tools.common, aws.tools.SecurityToken

Set-AWSCredential -ProfileName 'MyProfileName' -Scope Global

$ENV:AWS_ACCESS_KEY_ID = $cred.GetCredentials().AccessKey
$ENV:AWS_SECRET_ACCESS_KEY = $cred.GetCredentials().SecretKey
$ENV:AWS_DEFAULT_REGION = 'eu-west-1'

# can't use STS temporary credentials to create iam resources, so use normal iam credentials
docker run --rm -it -e AWS_ACCESS_KEY_ID=$ENV:AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$ENV:AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$ENV:AWS_DEFAULT_REGION `
-v ${PWD}/awsinstall:/workspace eu.gcr.io/gitpod-io/self-hosted/installer:latest aws
```
