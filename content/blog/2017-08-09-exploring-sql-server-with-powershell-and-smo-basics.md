---
categories:
- sql-server
- powershell
date: "2017-08-09T00:00:00Z"
last_modified_at: "2019-02-21"
tags:
- sql-server
- powershell
- smo
- tech
title: Exploring SQL Server With Powershell And SMO Basics
---

# SqlServer Powershell Cmdlets 2017 - Initialize Look

Diving into the Sql Server Management Objects library can be a pretty interesting process. You get to work with database objects as in a new way, and begin manipulating and execute code in a much different approach than purely using T-SQL. Powershell offers a unique way to interact with prebuilt cmdlets, and you can explore leveraging .NET in powershell as well to have a powerful toolkit of options.

This post is a not focused on a full walk-through, but instead to communicate some of the exploration I've done, to help if you are beginning to explore more database automation and management.

I plan on doing some basic walk-throughs for the powershell newbie in the future, so if you are confused about anything powershell related feel free to post a comment and I'll add it to my list of stuff to walk through.

## cmdlets vs .NET approach

What I've found interesting is there are really 2 main approaches to interacting with SQL Server. You can directly invoke the SMO dlls and access the methods, properties, and extensibility this offers. This requires more .NET knowledge as you would be directly working with the SMO namespace, in a way that is almost the same as what you code in C#. The other approach is to leverage cmdlets. The cmdlets try to abstract away a lot of the complexities that working directly with the SMO namespace for ease of use and automation, and to simplify the process for those not as comfortable with coding in C# or directly leverage the SMO namespace in C#

If purely focused on automation and little experience working with .NET then **cmdlet's** will be by far the way to go. There is a serious learning curve in working with .NET directly vs prebuilt cmdlets. If desiring to expand your .NET knowledge, as well find that the prebuilt cmdlets don't offer the behavior you are trying to achieve, then exploring the SMO namespace for directly invoking the methods and accessing properties can be valuable. The learning curve is more intense, so just be prepared for that if you are new to working with .NET directly in Powershell.

## dbatools.io & other sources

When possible, I personally am going to recommend to leverage a package like dbatools instead of rolling your own. Dbatools.io is a powerful project that I've recently begun to explore more. This well rounded package gives you a powerful powershell set of commands that can help you set server properties, obtain default paths, backup, restore, migrate entire sets of databases to a new location and more. To code all of this from scratch would be a massive project. I'd recommend considering dbatools.io and just getting involved in that project if you have something to contribute. I found it really helpful to quickly setup some default server options without having to configure manually myself.

## Exploring SQL Path Provider

![](/images/exploring-sql-path-provider.pngexploring-sql-path-provider?format=original)

Trying to find the path initially can be challenging. However, by opening SSMS up, right clicking, and launching the powershell window you'll be able to easily find the correct path to get the server level object.

This allows you to leverage default methods in powershell like Get-ChildItem for iterating through objects. It treats the navigated SQL server path basically as a "file structure" allowing some interesting actions to be performed. One of these is a different approach to killing connections to a particular database.

I found this great pointer by reading [Killing SPIDS in Powershell](http://www.midnightdba.com/DBARant/killing-spids-in-powershell/) from MidnightDBA

Review that article for scripts focused on the termination of running spids.

For an adhoc purpose the scripts MidnightDba provided are excellent and would allow quickly executing a kill script on connections from ssms > powershell prompt.

    import-module -name sqlserver -disablenamechecking -verbose:$false -debug:$false
     CD SQLSERVER:\SQL\$ServerName -Verbose:$false -Debug:$false
     dir ' ?{$_.Name -eq "$DatabaseName"} ' %{$_.KillAllProcesses($DatabaseName)}

I approach this with a different method in one final script using just the SMO server method KillAllProcesses. For some tasks I've found it really helpful to have a simple 1 line kill statement thanks to MidnightDba's pointer with the statements similar to the one above.

Using Microsoft's documented method shows another example of how to use to restart the service. This was one modified approach I took. I prefer not to use this type of approach as working with `get-childitem` with server objects to me as a little unintuitive.

    <#
            .LINK https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/start-stop-pause-resume-restart-sql-server-services#PowerShellProcedure

    #>
    $ErrorActionPreference = 'continue'
    [bool]$Matched = (get-module -name SqlServer -listavailable ' measure-object).count
    if($Matched -eq $false) { install-package SqlServer -scope CurrentUser -verbose:$false -Force}

    [datetime]$StepTimer = [datetime]::Now

    $private:ServerName = $env:ServerName
    import-module -name sqlserver -disablenamechecking -verbose:$false -debug:$false

    # Get a reference to the ManagedComputer class.
    CD SQLSERVER:\SQL\$private:ServerName -Verbose:$false -Debug:$false
    $Wmi = (get-item -debug:$false -verbose:$false .).ManagedComputer
    $DfltInstance = $Wmi.Services['MSSQLSERVER']

    #Display the state of the service.
    write-host "Stopping Instance: $($DfltInstance.ServiceState.value__)"
    $DfltInstance.Stop()

    while($DfltInstance.ServiceState.value__ -ne 1) #1 stopped
    {
        Start-Sleep -seconds 5
        $DfltInstance.Refresh()
        write-host "... state: $($DfltInstance.ServiceState)"
    }
    ## Start the service.
    $DfltInstance.Refresh()
    write-host "Current Service State: $($DfltInstance.ServiceState)"
    write-host "Initiating Service Start"
    $DfltInstance.Start()

    while($DfltInstance.ServiceState.value__ -ne 4) #4 running
    {
        Start-Sleep -seconds 5
        $DfltInstance.Start()
        $DfltInstance.Refresh()
        write-host "... state: $($DfltInstance.ServiceState)"
    }
    write-host( "{0:hh\:mm\:ss\.fff} {1}: finished" -f [timespan]::FromMilliseconds(((Get-Date)-$StepTimer).TotalMilliseconds),'SQL Service Restart')

## Database as an Object

Getting the database as an object proved to be easy though, if a little confusing to navigate initially.

    $s = SqlServer\Get-SqlDatabase -ServerInstance $ServerInstance -Verbose

Once the object is obtained, you can begin scripting objects, change database properties and more very easily.

I found this method an interesting alternative to invoking using .NET accelerators as it was a quick way to easily get a database level object to work with. However, some of the limitations of not having the server level object immediately available made me end up preferring the .NET accelerator version which could look like this.

    param(
             $ServerName = 'localhost'
             ,$DatabaseName = 'tempdb'
     )
     $s = [Microsoft.SqlServer.Management.Smo.Server]::New($ServerName)
     $d = [Microsoft.SqlServer.Management.Smo.Database]::New($s, $DatabaseName)
     $s.EnumProcesses() ' format-table -AutoSize
     $d.EnumObjects() ' Out-GridView

Interestingly, to actually access the many of the database properties you actually would call it via reference to the server object with SMO calls instead of the cmdlet. Trying $d.PrimaryFilePath doesn't work as I believe it's initiating the instance of a new database object for creation instead of referencing the initialization of a new object to an existing database. I found documentation a bit challenging to immediately sift through to get an answer, so YMMV. Someone coming from a .NET focused background might find the process a little more clear, but for me it did take some work to correctly identify the behavior.

    #doesn't work. Probably trying to initialize new object for creating a db
     $d = [Microsoft.SqlServer.Management.Smo.Database]::New($s, $db)
     $d.PrimaryFilePath

     #works to access current existing object
     $s.Databases[$db].PrimaryFilePath

### Exploring Properties

If you want to explore properties of an object, try using the ever faithful get-member

Depending on the type of object, you can additionally explore them with GetEnumerator, GetProperties, etc. You'll find intellisense helpful as you explore more.

For instance, here's a walkthrough on the various ways you might explore the object and find you need to dig into it to get the full detail of what you have access to.

{{% gist e3ed8534b1565c67d6d59163b0921d59 %}}


## Comparing Restoring a Database with Cmdlet vs SMO

### using dbatools cmdlet

An example of how simple using dbatools cmdlet can make restoring a database copy

{{% gist 7314ffa3fc830f36a2eda8ee7e27f7c4 %}}


### rolling your own wheel

Now compare this to the complexity of running your own invocation of the SMO namespace and requires a lot more coding. Since dbatools wraps up a lot of the functionality, I've actually migrated to leveraging this toolkit for these dba related tasks instead of trying to reinvent the wheel.

{{% gist 08fe28dd236a239f25821378268ef8e5 %}}
