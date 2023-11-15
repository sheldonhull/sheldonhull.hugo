---
title: Pester
date: 2023-03-06 14:49
---

## Pester

Many changes occurred after version 5.
This provides a few examples on how to leverage Pester for data driven tests with this new format.

### BeforeAll And BeforeDiscovery

One big change was the two scopes.
Read the Pester docs for more details.

The basic gist is that BeforeAll is in the "run" scope, while the test generation is BeforeDiscovery.
While older versions of Pester would allow a lot more `foreach` type loops, this should be in the discovery phase now, and then `-Foreach` (aka `-TestCases`) hashtable can be used to iterate more easily now through result sets.

<!-- ### Using Inline Script With PesterContainer -->

### Pester Container To Help Setup Data Driven Tests

Example of setting up inputs for the test script from your InvokeBuild job.

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

!!! Tip "Explore PesterConfiguration"

    If you want to explore the pester configuration try navigating through it with: `PesterConfiguration]::Default` and then explore sub-properties with actions like: `[PesterConfiguration]::Default.Run | Get-Member`.

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

This pester configuration is a big shift from the parameterized arguments provided in version < 5.

### Invoke Pester

Run this with: `Invoke-Pester -Configuration $Configuration`

To improve the output, I took a page from `PSFramework` and used the summary counts here, which could be linked to a chatops message.
Otherwise the diagnostic output should be fine.

```powershell
$testresults = @()
$testresults +=  Invoke-Pester -Configuration $Configuration


Write-Host '======= TEST RESULT OBJECT ======='

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

Use the artifact generated in the Azure Pipelines yaml to publish pipeline test results.

```yaml
## Using Invoke Build for running

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
