---
title: Syncing Files Using S5Cmd
---

## Syncing Files Using S5Cmd

### Get S5Cmd

Older versions of PowerShell (4.0) and the older AWSTools don't have the required ability to sync down a folder from a key prefix.
This also performs much more quickly for a quick sync of files like backups to a local directory for initiating restores against.

In testing by the tool creator, it was shown that this could saturate a network for an EC2 with full download speed and be up to 40x faster than using CLI with the benefit of being a small self-contained Go binary.

Once the download of the tooling is complete, you can run a copy from S3 down to a local directory with a command similar to below, assuming you have access rights to the bucket.
If you don't have rights, you'll want to set environment variables for the access key and secret key such as:

```powershell
Import-Module aws.tools.common, aws.tools.SecurityToken
Set-AWSCredential -ProfileName 'MyProfileName' -Scope Global
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(8).TotalSeconds)
@"
`$ENV:AWS_ACCESS_KEY_ID = '$($cred.AccessKeyId)'
`$ENV:AWS_SECRET_ACCESS_KEY = '$($cred.SecretAccessKey)'
`$ENV:AWS_SESSION_TOKEN  = '$($cred.SessionToken)'
"@
```

You can copy that string into your remote session to get the access tokens recognized by the s5cmd tool and allow you to grab files from another AWS account's S3 bucket.

> NOTE: To sync a full "directory" in S3, you need to leave the asterisks at the end of the key as demonstrated.

### Windows

#### Install S5Cmd For Windows

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ToolsDir = 'C:\tools'
$ProgressPreference = 'SilentlyContinue'
$OutZip = Join-Path $ToolsDir 's5cmd.zip'
Invoke-WebRequest -Uri 'https://github.com/peak/s5cmd/releases/download/v1.2.1/s5cmd_1.2.1_Windows-64bit.zip' -UseBasicParsing -OutFile $OutZip

# Not available on 4.0 Expand-Archive $OutZip -DestinationPath $ToolsDir

Add-Type -assembly 'system.io.compression.filesystem'
[io.compression.zipfile]::ExtractToDirectory($OutZip, $ToolsDir)
$s5cmd = Join-Path $ToolsDir 's5cmd.exe'
&$s5cmd version
```

#### Windows Sync A Directory From S3 to Local

```powershell
$ErrorActionPreference = 'Stop'
$BucketName = ''
$KeyPrefix = 'mykeyprefix/anothersubkey/*'

$Directory = "C:\temp\adhoc-s3-sync-$(Get-Date -Format 'yyyy-MM-dd')\$KeyPrefix"
New-Item $Directory -ItemType Directory -Force -ErrorAction SilentlyContinue
$s5cmd = Join-Path $ToolsDir 's5cmd.exe'
Write-Host "This is what is going to run: `n&$s5cmd cp `"s3://$BucketName/$KeyPrefix`" $Directory"
Read-Host 'Enter to continue if this makes sense, or cancel (ctrl+c)'


&$s5cmd cp "s3://$BucketName/$KeyPrefix" $Directory
```
