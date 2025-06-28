# Azure Pipelines


## Azure Pipelines Tips

### Dynamic Link to a Pipeline Run

Create a link to a pipeline for your chatops.

```powershell
$button = &#34;${ENV:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI}${ENV:SYSTEM_TEAMPROJECT}/_build/results?buildId=$($ENV:BUILD_BUILDID)&amp;view=logs&#34;
```

### Helper Function for Reporting Progress on Task

This is an ugly function, but hopefully useful as a jump start when in a hurry. 😁

This primarily allows you to quickly report:

- ETA
- Percent complete on a task
- Log output on current task

Needs more refinement and probably should just be an invoke build function, but for now it&#39;s semi-useful for some long-running tasks

Setup up your variables like demonstrated.
This doesn&#39;t handle nested task creation, so parentid won&#39;t be useful for anything other than local progress bar nesting.

```powershell
$ProgressId =  [int]$RANDOM.Next(1, 1000)
$ProgressCounter = 0
$ProgressTotalToProcess = 1000
$ProgressStopwatch =  [diagnostics.stopwatch]::new()
$ProgressStopwatch.Start()
foreach ($i in $List.Items)
{
    $ProgressCounter&#43;&#43;
        $ProgressSplat = @{
        Activity       =  &#39;&gt;&gt;&gt; Tacos&#39;
        StatusMessage  =  &#34;$($i.Foo).$($i.Bar)&#34;
        ProgressId     =  $ProgressId
        Counter        =  $Counter
        TotalToProcess =  $ProgressTotalToProcess
        Stopwatch      =  $ProgressStopwatch
        # ParentId       =  $ParentProgressId
        BuildOutput    = $true # for write-host special commands to show task progress in pipelines
    }
    Write-BuildProgressInfo @ProgressSplat
}
```

Include this function in InvokeBuild job.
If not using InvokeBuild, you&#39;ll need to change `Write-Build` to `Write-Host` and remove the color attribute.

```powershell
function Write-BuildProgressInfo
{
    [cmdletbinding()]
    param(
        [string]$Activity=&#39;doing stuff&#39;,
        [string]$StatusMessage,
        [int]$ProgressId,
        [int]$Counter,
        [int]$TotalToProcess,
        $StopWatch,
        $ParentId,
        [switch]$Complete,
        [switch]$BuildOutput
    )
    [hashtable]$writeProgressSplat = @{}
    $writeProgressSplat.Add(&#39;Id&#39;, $ProgressId)
    $writeProgressSplat.Add(&#39;Activity&#39;  , $Activity)
    if ($ParentId)
    {
        $writeProgressSplat.Add(&#39;ParentId&#39;, $ParentId )
    }

    # Write-Debug($PSBoundParameters.GetEnumerator() | Format-Table -AutoSize| Out-String)
    if ($Counter -lt $TotalToProcess -and $Complete -eq $false)
    {
        #still processing
        [int]$PercentComplete = [math]::Ceiling(($counter/$TotalToProcess)*100)
        try { [int]$AvgTimeMs = [math]::Ceiling(($StopWatch.ElapsedMilliseconds / $counter)) } catch { [int]$AvgTimeMs=0 } #StopWatch from beginning of process

        [int]$RemainingTimeSec = [math]::Ceiling( ($TotalToProcess - $counter) * $AvgTimeMs/1000)
        [string]$Elapsed = &#39;{0:hh\:mm\:ss}&#39; -f $StopWatch.Elapsed

        $writeProgressSplat.Add(&#39;Status&#39;, (&#34;Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)&#34;))
        $writeProgressSplat.Add(&#39;PercentComplete&#39;, $PercentComplete)
        $writeProgressSplat.Add(&#39;SecondsRemaining&#39;, $RemainingTimeSec)
        Write-Progress @writeProgressSplat
        if ($BuildOutput)
        {
            Write-Build DarkGray (&#34;$Activity | $PercentComplete | ETA: $(&#39;{0:hh\:mm\:ss\.fff}&#39; -f [timespan]::FromSeconds($RemainingTimeSec)) |  Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)&#34;)
            Write-Build DarkGray &#34;##vso[task.setprogress value=$PercentComplete;]$Activity&#34;
        }
    }
    else
    {
        [int]$PercentComplete = 100
        try { [int]$AvgTimeMs = [math]::Ceiling(($StopWatch.ElapsedMilliseconds / $TotalToProcess)) } catch { [int]$AvgTimeMs=0 } #StopWatch from beginning of process
        [string]$Elapsed = &#39;{0:hh\:mm\:ss}&#39; -f $StopWatch.Elapsed

        $writeProgressSplat.Add(&#39;Completed&#39;, $true)
        $writeProgressSplat.Add(&#39;Status&#39;, (&#34;Percent Complete: 100% `nAverage MS: $($AvgTimeMs)ms`nElapsed: $Elapsed&#34;))
        Write-Progress @writeProgressSplat
        if ($BuildOutput)
        {
            Write-Build DarkGray (&#34;COMPLETED | $Activity | $PercentComplete | ETA: $(&#39;{0:hh\:mm\:ss\.fff}&#39; -f $RemainingTimeSec) |  Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)&#34;)
        }
    }
}
```

