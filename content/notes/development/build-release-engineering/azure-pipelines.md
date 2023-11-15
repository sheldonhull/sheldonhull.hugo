---
title: Azure Pipelines
---

## Azure Pipelines Tips

### Dynamic Link to a Pipeline Run

Create a link to a pipeline for your chatops.

```powershell
$button = "${ENV:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI}${ENV:SYSTEM_TEAMPROJECT}/_build/results?buildId=$($ENV:BUILD_BUILDID)&view=logs"
```

### Helper Function for Reporting Progress on Task

This is an ugly function, but hopefully useful as a jump start when in a hurry. 😁

This primarily allows you to quickly report:

- ETA
- Percent complete on a task
- Log output on current task

Needs more refinement and probably should just be an invoke build function, but for now it's semi-useful for some long-running tasks

Setup up your variables like demonstrated.
This doesn't handle nested task creation, so parentid won't be useful for anything other than local progress bar nesting.

```powershell
$ProgressId =  [int]$RANDOM.Next(1, 1000)
$ProgressCounter = 0
$ProgressTotalToProcess = 1000
$ProgressStopwatch =  [diagnostics.stopwatch]::new()
$ProgressStopwatch.Start()
foreach ($i in $List.Items)
{
    $ProgressCounter++
        $ProgressSplat = @{
        Activity       =  '>>> Tacos'
        StatusMessage  =  "$($i.Foo).$($i.Bar)"
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
If not using InvokeBuild, you'll need to change `Write-Build` to `Write-Host` and remove the color attribute.

```powershell
function Write-BuildProgressInfo
{
    [cmdletbinding()]
    param(
        [string]$Activity='doing stuff',
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
    $writeProgressSplat.Add('Id', $ProgressId)
    $writeProgressSplat.Add('Activity'  , $Activity)
    if ($ParentId)
    {
        $writeProgressSplat.Add('ParentId', $ParentId )
    }

    # Write-Debug($PSBoundParameters.GetEnumerator() | Format-Table -AutoSize| Out-String)
    if ($Counter -lt $TotalToProcess -and $Complete -eq $false)
    {
        #still processing
        [int]$PercentComplete = [math]::Ceiling(($counter/$TotalToProcess)*100)
        try { [int]$AvgTimeMs = [math]::Ceiling(($StopWatch.ElapsedMilliseconds / $counter)) } catch { [int]$AvgTimeMs=0 } #StopWatch from beginning of process

        [int]$RemainingTimeSec = [math]::Ceiling( ($TotalToProcess - $counter) * $AvgTimeMs/1000)
        [string]$Elapsed = '{0:hh\:mm\:ss}' -f $StopWatch.Elapsed

        $writeProgressSplat.Add('Status', ("Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)"))
        $writeProgressSplat.Add('PercentComplete', $PercentComplete)
        $writeProgressSplat.Add('SecondsRemaining', $RemainingTimeSec)
        Write-Progress @writeProgressSplat
        if ($BuildOutput)
        {
            Write-Build DarkGray ("$Activity | $PercentComplete | ETA: $('{0:hh\:mm\:ss\.fff}' -f [timespan]::FromSeconds($RemainingTimeSec)) |  Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)")
            Write-Build DarkGray "##vso[task.setprogress value=$PercentComplete;]$Activity"
        }
    }
    else
    {
        [int]$PercentComplete = 100
        try { [int]$AvgTimeMs = [math]::Ceiling(($StopWatch.ElapsedMilliseconds / $TotalToProcess)) } catch { [int]$AvgTimeMs=0 } #StopWatch from beginning of process
        [string]$Elapsed = '{0:hh\:mm\:ss}' -f $StopWatch.Elapsed

        $writeProgressSplat.Add('Completed', $true)
        $writeProgressSplat.Add('Status', ("Percent Complete: 100% `nAverage MS: $($AvgTimeMs)ms`nElapsed: $Elapsed"))
        Write-Progress @writeProgressSplat
        if ($BuildOutput)
        {
            Write-Build DarkGray ("COMPLETED | $Activity | $PercentComplete | ETA: $('{0:hh\:mm\:ss\.fff}' -f $RemainingTimeSec) |  Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)")
        }
    }
}
```
