---
date: 2019-07-16T13:00:00+00:00
title: Painless Synchronization of Azure Blob Storage with AWS S3
slug: painless-synchronization-of-azure-blob-storage-with-aws-s3
summary: leverage the free tool RClone for using the cloud api's easily to synchronize
  cloud based storage without the need to copy locally
tags:
- tech
- aws
- devops
- azure

---
## Synchronization

Moving data between two cloud providers can be painful, and require more provider scripting if doing api calls. For this, you can benefit from a tool that abstracts the calls into a seamless synchronization tool.

I've used RClone before when needing to deduplicate several terabytes of data in my own Google Drive, so I figured I'd see if it could help me sync up 25GB of json files from Azure to S3.

Very happy to report it worked perfectly, and with only a couple minutes of refamilarizing myself with the tool setup.


## Install RClone

For windows users, it's as easy as leveraging Chocolatey and running

```powershell
choco upgrade rclone -y
```

## Setup Providers

Go through `rclone config` dialogue and setup your cloud provider. In my case, I setup Azure as a provider to connect to blob storage, and then AWS with s3.

> [!info] Cloud to Cloud+
> Providers that support cloud to cloud based calls without copying locally are provided in the section for [Optional Features](http://bit.ly/2LEOSrR) where you can view the operations that support calls


## Initialize Sync

```powershell
rclone copy azure:containername s3:bucketname/keyprefix --log-level ERROR --progress --dry-run
```

## Wrap-up

Take a look at this if you need a simple way to grab some data from one provider and leverage in another and you might want to save yourself some time on learning provider specific api calls. I've found tools like this, Terraform, and others that help abstract the api calls can be a great resource as you can leverage one syntax to work with two completely different providers and eliminate a lot of effort in coding.
