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
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(1).TotalSeconds)

$ENV:AWS_REGION = 'us-east-1'
$ENV:AWS_ACCESS_KEY_ID = $cred.AccessKeyId
$ENV:AWS_SECRET_ACCESS_KEY = $cred.SecretAccessKey
$ENV:AWS_SESSION_TOKEN  = $cred.SessionToken

docker run --rm -it -e AWS_ACCESS_KEY_ID=$ENV:AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$ENV:AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$ENV:AWS_DEFAULT_REGION -e AWS_SESSION_TOKEN=$ENV:AWS_SESSION_TOKEN `
-v ${PWD}/awsinstall:/workspace eu.gcr.io/gitpod-io/self-hosted/installer:latest aws
```