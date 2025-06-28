# Pester


## Pester

Many changes have occurred after version 5.
This provides a few examples on how to leverage Pester for data-driven tests with this new format.

### BeforeAll And BeforeDiscovery

One significant change was the addition of two scopes.
Read the Pester docs for more details.

The basic idea is that BeforeAll is in the &#34;run&#34; scope, while the test generation is BeforeDiscovery.
While older versions of Pester would allow more `foreach` type loops, they should be in the discovery phase now, and then `-Foreach` (aka `-TestCases`) hashtable can be used to iterate effortlessly through the result sets.

&lt;!-- ### Using Inline Script With PesterContainer --&gt;

### Pester Container To Help Setup Data Driven Tests

Below is an example of setting up inputs for the test script from your InvokeBuild job.

```powershell
$pc = New-PesterContainer -Path (Join-Path $BuildRoot &#39;tests\configuration.tests.ps1&#39;) -Data @{
    credential_user1 = Get-PSFConfigValue &#34;Project.$ENV:GROUP.credential.user1&#34; -NotNull
    credential_user2 = Get-PSFConfigValue &#34;Project.$ENV:GROUP.credential.user2&#34; -NotNull
    sql_instance     = Get-PSFConfigValue &#34;Project.$ENV:GROUP.instance_address&#34; -NotNull
    database_list    = $DatabaseList
}
```

### Pester Configuration Object

Now, you&#39;d add this `PesterContainer` object to the `PesterConfiguration`.

{{&lt; admonition type=&#34;tip&#34; title=&#34;Explore PesterConfiguration&#34; open=true &gt;}}

If you want to explore the Pester configuration, try navigating through it with:`[PesterConfiguration]::Default` and then explore sub-properties with actions like: `[PesterConfiguration]::Default.Run | Get-Member`.

{{&lt; /admonition &gt;}}

```powershell

$configuration = [PesterConfiguration]@{
    Run        = @{
        Path        = (Join-Path $BuildRoot &#39;tests\configuration.tests.ps1&#39;)
        ExcludePath = &#39;*PSFramework*&#39;, &#39;*_tmp*&#39;
        PassThru    = $True
        Container   = $pc
    }
    Should     = @{
        ErrorAction = &#39;Continue&#39;
    }
    TestResult = @{
        Enabled      = $true
        OutputPath   = (Join-Path $ArtifactsDirectory &#39;TEST-configuration-results.xml&#39;)
        OutputFormat = &#39;NUnitXml&#39;
    }
    Output     = @{
        Verbosity = &#39;Diagnostic&#39;
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
$testresults &#43;=  Invoke-Pester -Configuration $Configuration

Write-Host &#39;======= TEST RESULT OBJECT =======&#39;

$totalRun = 0
$totalFailed = 0
foreach ($result in $testresults)
{
    $totalRun &#43;= $result.TotalCount
    $totalFailed &#43;= $result.FailedCount
    # -NE &#39;Passed&#39;
    $result.Tests | Where-Object Result | ForEach-Object {
        $testresults &#43;= [pscustomobject]@{
            Block   = $_.Block
            Name    = &#34;It $($_.Name)&#34;
            Result  = $_.Result
            Message = $_.ErrorRecord.DisplayErrorMessage
        }
    }
}

#$testresults | Sort-Object Describe, Context, Name, Result, Message | Format-List
if ($totalFailed -eq 0) { Write-Build Green &#34;All $totalRun tests executed without a single failure!&#34; }
else { Write-Build Red &#34;$totalFailed tests out of $totalRun tests failed!&#34; }
if ($totalFailed -gt 0)
{
    throw &#34;$totalFailed / $totalRun tests failed!&#34;
}

```

### Use Test Artifacts

You can utilize the artifact generated in the Azure Pipelines yaml to publish pipeline test results.

```yaml

- task: PowerShell@2
  displayName: Run Pester Tests
  inputs:
    filePath: build.ps1
    arguments: &#39;-Task PesterTest -Configuration $(Configuration)&#39;
    errorActionPreference: &#39;Continue&#39;
    pwsh: true
    failOnStderr: true
  env:
    SYSTEM_ACCESSTOKEN: $(System.AccessToken)
- task: PublishTestResults@2
  displayName: Publish Pester Tests
  inputs:
    testResultsFormat: &#39;NUnit&#39;
    testResultsFiles: &#39;**/TEST-*.xml&#39; # &lt;---------  MATCHES MULTIPLE TEST FILES AND UPLOADED
    failTaskOnFailedTests: true
  alwaysRun: true # &lt;---------  Or it won&#39;t upload if test fails
```


