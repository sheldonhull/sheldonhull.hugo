---
date: "2017-02-18T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- powershell
- sql-server
title: "Quick Way to Run Powershell Tasks in Parallel"
slug: "quick-way-to-run-powershell-tasks-in-parallel"
---

Running tasks in parallel can be a bit difficult in powershell. However, there are a few projects out there that optimize the performance and provide a better experience of running tasks in parallel with less effort.#cool uses
A few cool uses of this might be running parallel sql queries across multiple servers or databases while maintaining a throttled limit to avoid saturation of the target environment. Additionally, long running queries might benefit in running in parallel if running on multiple objects in the same database or in different databases.

# module magic

I've utilized two main modules to advance this.
[PSParallel](https://github.com/powercode/PSParallel) and [PoshRSJobs](https://github.com/proxb/PoshRSJob/). Both are fantastic options. The Invoke-Parallel is not steadily maintained, so I try to use PoshRSJob when possible. However, for ease of use the Invoke-Parallel option is pretty awesome as it automatically imports variables, functions, and modules into the block to allow for less work in defining parameters, having to use the `$using:variablename` clause, etc.

# lots of gotchas

However, be prepared to deal with some complications in doing this with powershell. For instance, write-host, write-verbose, write-error, at this time can throw errors in PoshRSJob or not provide any output, as these streams are not incorporated the same as your local ISE session. In fact, at the time of this post, for output to stream from the PoshRSJob module, I had to change my output from:

```powershell
write-host 'I know a kitten dies every time writehost is used, but I just cannot stop myself'
```

to

```powershell
"I know a kitten dies every time writehost is used, but I just cannot stop myself"
```

Yes... no write-host/write-error/write-verbose is used here, just quotes for it. The developer and github community is looking to improve this, but at this time, don't expect logging or error messages to come through the same way.

Be prepared to deal with some complications on error handling when dealing with runspaces, as even though they are more performant, there is a lot of issues with scope to deal with in those isolated runspaces. Once you start increasing the size of the script blocks things can get hard to debug.

**I think the simpler the task to pass into the parallel tasks, the better.**

However, for some basic tasks that would benefit in parallel, you can definitely give it a shot.
This task focused on iterating through a directory recursively and cleaning up each of the files by stripping out comments and blank lines. The following results were a simple example and interesting to compare.

```text
    -------- Summary with PoshRSJobs--------
    File Size:   9.59 MB
    Total Count: 4,600.00
    Filepath: C:\temp\MyCleanedUpZip.zip
    Total Original Lines: 1221673
    Total Lines: 1,201,746.00
    Total Lines Saved:  21,959.00
    TOTAL TIME TO RUN: 08:43

    -------- Summary with Invoke-Parallel --------
    File Size:   6.69 MB
    Total Count: 4,447.00
    Filepath: C:\temp\MyCleanedUpZip.zip
    Total Original Lines: 1221436
    Total Lines: 854,375.00
    Total Lines Saved:  360,045.00
    TOTAL TIME TO RUN: 05:22
```

PoshRSJobs seemed to approach creating the job list first, which took a long time, and then processed the output very quickly. Overall, this took longer for this type of task. Invoke-Parallel gave an almost instant response showing the progress bar with estimated time remaining, so for this type of job it actually ran faster.

```text
    -------- Summary - Native ForEach --------
    File Size:   6.69 MB
    Total Count: 4,621.00
    Filepath: C:\temp\MyCleanedUpZip.zip
    Total Original Lines: 1227408
    Total Lines: 861,600.00
    Total Lines Saved:  365,808.00
    TOTAL TIME TO RUN: 04:52
```

Surprising to me, the native foreach which was single threaded was faster. I believe in this case, the overhead of setting up the jobs was not worth parallel task processing. Since the task was a lot of small tasks, this probably wasn't a good candidate for parallel tasks. Based on this small test case, I'd venture to look into parallel tasks when longer run times are involved, such as perhaps copying large files that aren't oversaturating your IO. In this case, slow long copies would probably benefit from parallel tasks, while small text file copies as I showed wouldn't.
A simple example of the difference in syntax for using PSParallel would be just counting lines in files in a directory.


```powershell
$Folder = 'C:\Temp'
$startTime = get-date
[int]$TotalManualCount = 0
Get-ChildItem -Path $Folder -Recurse -Force ' where { ! $_.PSIsContainer } ' % { $TotalManualCount += (Get-Content -Path ($_.FullName) -Force ' Measure-Object -Line).Lines}
write-host ('Total Lines: {0:N2}' -f $TotalManualCount)
Write-host ('FOREACH: Total time to process: {0}' -f [timespan]::fromseconds(((Get-Date)-$StartTime).Totalseconds).ToString('mm\:ss'))
#Using Invoke-Parallel#
$ManualCount = [hashtable]::Synchronized(@{})
$ManualCount = @{
TotalCount     = 0
}
$Folder = 'C:\Temp'
$startTime = get-date
Get-ChildItem -Path $Folder -Recurse -Force ' where { ! $_.PSIsContainer } ' Start-RsJob -Throttle 4 -ArgumentList $ManualCount -ScriptBlock {
[cmdletbinding()]
param($ManualCount)
$ManualCount.TotalCount += (Get-Content -Path ($_.FullName) -Force ' Measure-Object -Line).Lines
}
write-host ('Total Lines: {0:N2}' -f $ManualCount.TotalCount)
Write-host ('INVOKE-PARALLEL: Total time to process: {0}' -f [timespan]::fromseconds(((Get-Date)-$StartTime).Totalseconds).ToString('mm\:ss'))
```

Note that this simple code example might have had some issues with counts due to locking with the synchronized hash table usage. Based on a few searches, it looks like you need to implement a lock on the hash table which ensures that particular thread is able to safely update. I didn't find clear proof that the synchronized hash table was working or failing, but it's something to be aware of. There are some active efforts on improving in PoshRSJob github issues.
Hopefully you'll have a few new ideas on working with Parallel tasks in powershell now, and think about leveraging it for some tedious tasks that might benefit with SQL server or other administrative jobs.
