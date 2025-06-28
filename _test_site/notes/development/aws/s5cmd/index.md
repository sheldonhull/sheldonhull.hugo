# Syncing Files Using S5Cmd


## Syncing Files Using S5Cmd

### Get S5Cmd

Older versions of PowerShell (4.0) and the older AWSTools don&#39;t have the required ability to sync down a folder from a key prefix.
This also performs much more quickly for a quick sync of files like backups to a local directory for initiating restores against.

In testing by the tool creator, it was shown that this could saturate a network for an EC2 with full download speed and be up to 40x faster than using CLI with the benefit of being a small self-contained Go binary.

Once the download of the tooling is complete, you can run a copy from S3 down to a local directory with a command similar to below, assuming you have access rights to the bucket.
If you don&#39;t have rights, you&#39;ll want to set environment variables for the access key and secret key such as:

```powershell
Import-Module aws.tools.common, aws.tools.SecurityToken
Set-AWSCredential -ProfileName &#39;MyProfileName&#39; -Scope Global
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(8).TotalSeconds)
@&#34;
`$ENV:AWS_ACCESS_KEY_ID = &#39;$($cred.AccessKeyId)&#39;
`$ENV:AWS_SECRET_ACCESS_KEY = &#39;$($cred.SecretAccessKey)&#39;
`$ENV:AWS_SESSION_TOKEN  = &#39;$($cred.SessionToken)&#39;
&#34;@
```

You can copy that string into your remote session to get the access tokens recognized by the s5cmd tool and allow you to grab files from another AWS account&#39;s S3 bucket.

&gt; NOTE: To sync a full &#34;directory&#34; in S3, you need to leave the asterisks at the end of the key as demonstrated.

### Windows

#### Install S5Cmd For Windows

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ToolsDir = &#39;C:\tools&#39;
$ProgressPreference = &#39;SilentlyContinue&#39;
$OutZip = Join-Path $ToolsDir &#39;s5cmd.zip&#39;
Invoke-WebRequest -Uri &#39;https://github.com/peak/s5cmd/releases/download/v1.2.1/s5cmd_1.2.1_Windows-64bit.zip&#39; -UseBasicParsing -OutFile $OutZip

# Not available on 4.0 Expand-Archive $OutZip -DestinationPath $ToolsDir

Add-Type -assembly &#39;system.io.compression.filesystem&#39;
[io.compression.zipfile]::ExtractToDirectory($OutZip, $ToolsDir)
$s5cmd = Join-Path $ToolsDir &#39;s5cmd.exe&#39;
&amp;$s5cmd version
```

#### Windows Sync A Directory From S3 to Local

```powershell
$ErrorActionPreference = &#39;Stop&#39;
$BucketName = &#39;&#39;
$KeyPrefix = &#39;mykeyprefix/anothersubkey/*&#39;

$Directory = &#34;C:\temp\adhoc-s3-sync-$(Get-Date -Format &#39;yyyy-MM-dd&#39;)\$KeyPrefix&#34;
New-Item $Directory -ItemType Directory -Force -ErrorAction SilentlyContinue
$s5cmd = Join-Path $ToolsDir &#39;s5cmd.exe&#39;
Write-Host &#34;This is what is going to run: `n&amp;$s5cmd cp `&#34;s3://$BucketName/$KeyPrefix`&#34; $Directory&#34;
Read-Host &#39;Enter to continue if this makes sense, or cancel (ctrl&#43;c)&#39;


&amp;$s5cmd cp &#34;s3://$BucketName/$KeyPrefix&#34; $Directory
```

