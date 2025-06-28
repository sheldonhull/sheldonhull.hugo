# AWS PowerShell


## AWS Tools

### Install AWS.Tools

Going forward, use AWS.Tools modules for newer development.
It is much faster to import and definitely offer a better development experience in alignment with the .NET SDK namespace approach.

Use the installer module to simplify versioning and avoid conflicts with automatic clean-up of prior SDK versions.

```powershell
install-module &#39;AWS.Tools.Installer&#39; -Scope CurrentUser

$modules = @(
    &#39;AWS.Tools.Common&#39;
    &#39;AWS.Tools.CostExplorer&#39;
    &#39;AWS.Tools.EC2&#39;
    &#39;AWS.Tools.Installer&#39;
    &#39;AWS.Tools.RDS&#39;
    &#39;AWS.Tools.S3&#39;
    &#39;AWS.Tools.SecretsManager&#39;
    &#39;AWS.Tools.SecurityToken&#39;
    &#39;AWS.Tools.SimpleSystemsManagement&#39;
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
The normal format for entries like databases seems to be: `{&#34;username&#34;:&#34;password&#34;}` or similar.

```powershell
$Secret = Get-SECSecretValue -SecretId &#39;service-accounts/my-secret-id&#39; -ProfileName $ProfileName
```

### Generate a Temporary Key

This is useful when you need to generate some time-sensitive access credentials while connected via an SSM Session and needing to access another account&#39;s resources.

```powershell
Import-Module aws.tools.common, aws.tools.SecurityToken
Set-AWSCredential -ProfileName &#39;ProfileName&#39; -scope Global
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(8).TotalSeconds)
@&#34;
`$ENV:AWS_ACCESS_KEY_ID = &#39;$($cred.AccessKeyId)&#39;
`$ENV:AWS_SECRET_ACCESS_KEY = &#39;$($cred.SecretAccessKey)&#39;
`$ENV:AWS_SESSION_TOKEN  = &#39;$($cred.SessionToken)&#39;
&#34;@
```

### Install SSM Agent Manually

This is based on the AWS install commands, but with a few enhancements to better work on older Windows servers.

```powershell
# https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-win.html
$ProgressPreference = &#39;SilentlyContinue&#39;
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host &#34;Downloading installer&#34;
$InstallerFile = Join-Path $env:USERPROFILE &#39;Downloads\SSMAgent_latest.exe&#39;
$invokeWebRequestSplat = @{
    Uri = &#39;https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe&#39;
    OutFile = $InstallerFile
}
Invoke-WebRequest @invokeWebRequestSplat

Write-Host &#34;Installing SSM Agent&#34;
$startProcessSplat = @{
    FilePath     = $InstallerFile
    ArgumentList = &#39;/S&#39;
}
Start-Process @startProcessSplat

Write-Host &#34;Cleaning up SSM Agent download&#34;
Remove-Item $InstallerFile -Force
Restart-Service AmazonSSMAgent
```

### AWS PowerShell Specific Cheatsheets

&lt;script src=&#34;https://gist.github.com/sheldonhull/9534958236fbc3973e704f648cec27e7.js&#34;&gt;&lt;/script&gt;

