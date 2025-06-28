---
title: Pester
date: 2023-03-06T14:49:00+00:00
---

## Pester

Many changes have occurred after version 5.
This provides a few examples on how to leverage Pester for data-driven tests with this new format.

### BeforeAll And BeforeDiscovery

One significant change was the addition of two scopes.
Read the Pester docs for more details.

The basic idea is that BeforeAll is in the "run" scope, while the test generation is BeforeDiscovery.
While older versions of Pester would allow more `foreach` type loops, they should be in the discovery phase now, and then `-Foreach` (aka `-TestCases`) hashtable can be used to iterate effortlessly through the result sets.

<!-- ### Using Inline Script With PesterContainer -->

### Pester Container To Help Setup Data Driven Tests

Below is an example of setting up inputs for the test script from your InvokeBuild job.

```powershell
$pc = New-PesterContainer -Path (Join-Path $BuildRoot 'tests\configuration.tests.ps1') -Data @{
    credential_user1 = Get-PSFConfigValue "Project.$ENV:GROUP.credential.user1" -NotNull
    credential_user2 = Get-PSFConfigValue "Project.$ENV:GROUP.credential.user2" -NotNull
    sql_instance     = Get-PSFConfigValue "Project.$ENV:GROUP.instance_address" -NotNull
    database_list    = $DatabaseList
}
```

### Pester Configuration Object

Now, you'd add this `PesterContainer` object to the `PesterConfiguration`.

{{< admonition type="tip" title="Explore PesterConfiguration" open=true >}}

If you want to explore the Pester configuration, try navigating through it with:`[PesterConfiguration]::Default` and then explore sub-properties with actions like: `[PesterConfiguration]::Default.Run | Get-Member`.

{{< /admonition >}}

```powershell

$configuration = [PesterConfiguration]@{
    Run        = @{
        Path        = (Join-Path $BuildRoot 'tests\configuration.tests.ps1')
        ExcludePath = '*PSFramework*', '*_tmp*'
        PassThru    = $True
        Container   = $pc
    }
    Should     = @{
        ErrorAction = 'Continue'
    }
    TestResult = @{
        Enabled      = $true
        OutputPath   = (Join-Path $ArtifactsDirectory 'TEST-configuration-results.xml')
        OutputFormat = 'NUnitXml'
    }
    Output     = @{
        Verbosity = 'Diagnostic'
    }
}


```

This Pester configuration is a significant shift from the parameterized arguments provided in versions earlier than 5.

### Invoke Pester

Run this with: `Invoke-Pester -Configuration $Configuration`

To improve the output, I took a cue from `PSFramework` and used the summary counts here, which could be linked to a chatops message.
Otherwise, the diagnostic output should be fine.

```powershell
$testresults = @()
$testresults +=  Invoke-Pester -Configuration $Configuration

Write-Host '======= TEST RESULT OBJECT ======='

$totalRun = 0
$totalFailed = 0
foreach ($result in $testresults)
{
    $totalRun += $result.TotalCount
    $totalFailed += $result.FailedCount
    # -NE 'Passed'
    $result.Tests | Where-Object Result | ForEach-Object {
        $testresults += [pscustomobject]@{
            Block   = $_.Block
            Name    = "It $($_.Name)"
            Result  = $_.Result
            Message = $_.ErrorRecord.DisplayErrorMessage
        }
    }
}

#$testresults | Sort-Object Describe, Context, Name, Result, Message | Format-List
if ($totalFailed -eq 0) { Write-Build Green "All $totalRun tests executed without a single failure!" }
else { Write-Build Red "$totalFailed tests out of $totalRun tests failed!" }
if ($totalFailed -gt 0)
{
    throw "$totalFailed / $totalRun tests failed!"
}

```

### Use Test Artifacts

You can utilize the artifact generated in the Azure Pipelines yaml to publish pipeline test results.

```yaml

- task: PowerShell@2
  displayName: Run Pester Tests
  inputs:
    filePath: build.ps1
    arguments: '-Task PesterTest -Configuration $(Configuration)'
    errorActionPreference: 'Continue'
    pwsh: true
    failOnStderr: true
  env:
    SYSTEM_ACCESSTOKEN: $(System.AccessToken)
- task: PublishTestResults@2
  displayName: Publish Pester Tests
  inputs:
    testResultsFormat: 'NUnit'
    testResultsFiles: '**/TEST-*.xml' # <---------  MATCHES MULTIPLE TEST FILES AND UPLOADED
    failTaskOnFailedTests: true
  alwaysRun: true # <---------  Or it won't upload if test fails
```

