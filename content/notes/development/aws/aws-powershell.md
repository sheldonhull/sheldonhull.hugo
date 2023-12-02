---
title: AWS PowerShell
---

## AWS Tools

### Install AWS.Tools

Going forward, use AWS.Tools modules for newer development.
It is much faster to import and definitely offer a better development experience in alignment with the .NET SDK namespace approach.

Use the installer module to simplify versioning and avoid conflicts with automatic clean-up of prior SDK versions.

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

Install-AWSToolsModule $modules -Cleanup -Force
```

### Using Systems Manager Parameters (SSM) To Create A PSCredential

```powershell
$script:SqlLoginName = (Get-SSMParameterValue -Name $SSMParamLogin -WithDecryption $true).Parameters[0].Value
$script:SqlPassword = (Get-SSMParameterValue -Name $SSMParamPassword -WithDecryption $true).Parameters[0].Value | ConvertTo-SecureString -AsPlainText -Force
$script:SqlCredential = [pscredential]::new($script:SqlLoginName, $script:SqlPassword)
```

### Using AWS Secrets Manager To Create a PSCredential

Note that this can vary in how you read it based on the format.
The normal format for entries like databases seems to be: `{"username":"password"}` or similar.

```powershell
$Secret = Get-SECSecretValue -SecretId 'service-accounts/my-secret-id' -ProfileName $ProfileName
```

### Generate a Temporary Key

This is useful when you need to generate some time-sensitive access credentials while connected via an SSM Session and needing to access another account's resources.

```powershell
Import-Module aws.tools.common, aws.tools.SecurityToken
Set-AWSCredential -ProfileName 'ProfileName' -scope Global
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(8).TotalSeconds)
@"
`$ENV:AWS_ACCESS_KEY_ID = '$($cred.AccessKeyId)'
`$ENV:AWS_SECRET_ACCESS_KEY = '$($cred.SecretAccessKey)'
`$ENV:AWS_SESSION_TOKEN  = '$($cred.SessionToken)'
"@
```

### Install SSM Agent Manually

This is based on the AWS install commands, but with a few enhancements to better work on older Windows servers.

```powershell
# https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-win.html
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "Downloading installer"
$InstallerFile = Join-Path $env:USERPROFILE 'Downloads\SSMAgent_latest.exe'
$invokeWebRequestSplat = @{
    Uri = 'https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe'
    OutFile = $InstallerFile
}
Invoke-WebRequest @invokeWebRequestSplat

Write-Host "Installing SSM Agent"
$startProcessSplat = @{
    FilePath     = $InstallerFile
    ArgumentList = '/S'
}
Start-Process @startProcessSplat

Write-Host "Cleaning up SSM Agent download"
Remove-Item $InstallerFile -Force
Restart-Service AmazonSSMAgent
```

### AWS PowerShell Specific Cheatsheets

<script src="https://gist.github.com/sheldonhull/9534958236fbc3973e704f648cec27e7.js"></script>
