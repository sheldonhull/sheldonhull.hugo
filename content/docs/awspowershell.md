---
title: "AWSPowershell"
slug: "awspowershell"
permalink: /docs/awspowershell/
excerpt: "A cheatsheet and quick start reference for working with AWSPowershell"
date:  2019-02-19
toc: true
comments: true
---

{{< premonition type="info" title="Requests or Suggestions" >}}
If you have any requests or improvements for this content, please comment below. It will open a GitHub issue for chatting further.
I'd be glad to improve with any additional quick help and in general like to know if anything here in particular was helpful to someone.
Cheers! 👍
{{< /premonition >}}

## Setup

Going forward, use AWS.Tools modules for newer development.
It's much faster to import and definitely a better development experience in alignment with .NET SDK namespace approach.

```powershell
install-module 'AWS.Tools.Installer' -Scope CurrentUser

$modules = @(
'AWS.Tools.Common'
'AWS.Tools.CostExplorer'
'AWS.Tools.EC2'
'AWS.Tools.Installer'
'AWS.Tools.RDS'
'AWS.Tools.S3'
'AWS.Tools.SecretsManager'
'AWS.Tools.SecurityToken'
'AWS.Tools.SimpleSystemsManagement'
)

Install-AWSToolsModule $modules -Cleanup
```

## Getting the Output of A Lambda Function

Reading the content of a Lambda function requires a little .NET magic. The result is not a predefined property you can just access like `$result.result`. Instead, you need to read the output stream using [StreamReader](https://docs.microsoft.com/en-us/dotnet/api/system.io.streamreader.readtoend "StreamReader.ReadToEnd")

```powershell
$result = Invoke-LMFunction -FunctionName $FunctionName -ProfileName $AWSProfile
$StreamReader = [System.IO.StreamReader]::new($Result.Payload)
$json = $StreamReader.ReadToEnd()
$json | Select-Object Property,OtherProperty  | ConvertFrom-Json | FT
```
