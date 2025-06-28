# Painless Synchronization of Azure Blob Storage with AWS S3

## Synchronization

Moving data between two cloud providers can be painful, and require more provider scripting if doing api calls. For this, you can benefit from a tool that abstracts the calls into a seamless synchronization tool.

I&#39;ve used RClone before when needing to deduplicate several terabytes of data in my own Google Drive, so I figured I&#39;d see if it could help me sync up 25GB of json files from Azure to S3.

Very happy to report it worked perfectly, and with only a couple minutes of refamilarizing myself with the tool setup.


## Install RClone

For windows users, it&#39;s as easy as leveraging Chocolatey and running

```powershell
choco upgrade rclone -y
```

## Setup Providers

Go through `rclone config` dialogue and setup your cloud provider. In my case, I setup Azure as a provider to connect to blob storage, and then AWS with s3.

{{&lt; admonition type=&#34;info&#34; title=&#34;Cloud to Cloud&#34; &gt;}}
Providers that support cloud to cloud based calls without copying locally are provided in the section for [Optional Features](http://bit.ly/2LEOSrR) where you can view the operations that support calls
{{&lt; /admonition &gt;}}


## Initialize Sync

```powershell
rclone copy azure:containername s3:bucketname/keyprefix --log-level ERROR --progress --dry-run
```

## Wrap-up

Take a look at this if you need a simple way to grab some data from one provider and leverage in another and you might want to save yourself some time on learning provider specific api calls. I&#39;ve found tools like this, Terraform, and others that help abstract the api calls can be a great resource as you can leverage one syntax to work with two completely different providers and eliminate a lot of effort in coding.

