---
date: "2016-05-16T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
- cool-tools
title: "Continual Deployment of Visual Studio SqlProj"
slug: "continual-deployment-of-visual-studio-sql-proj"
---

## Unveil the inner workings of the esoteric build system...

As a data professional, I've never worked extensively with msbuild or other pipelines. I'd been mostly focused on just running schema comparisons and publishing. However, I've had the needed to try and deploy a database project from visual studio automatically, and this is my process through it.

There are benefits for those who don't necessarily want to run this against production, but instead for those who want to continually deploy check-ins and run tests, documentation, or other tasks against the deployed schema. This was my personal goal.

There are other solutions that plug into this that can make the process easier, such as Red Gate's DLM Automation with SQL Continuous Integration. For this case, since migrating to a new project format wasn't possible until later, I worked with the native sql project from the SQL Server Data Tools in Visual Studio 2015.

## Terminology

*   Build Controller: This is like Service broker. It handles the queuing and assignment of the defined builds to the appropriate agents. It doesn't do any actual building, but instead handles the delegation of the work.
*   Build Agent: This is the "wrapper" for msbuild. It does the actual work of building whatever you pass to it.

## Initial Setup & Install

1.  Configure Build Service Wizard
Choose the configure option of just the build service
![Configure Build Service Wizard](/images/configure-build-service-wizard.png)

2.  Configure collection ![Configure collection](/images/configure-collection.png)

3.  Choose configuration options for the build services
![Choose configuration options for the build services](/images/choose-configuration-options-for-the-build-services.png)

4.  Setup build service account
![Setup build service account](/images/setup-build-service-account.png)

5.  Finished with configuration. After running checks and resolving any issues (I thankfully had none for this simple install of just build controller/agent; you can proceed
![Finished with configuration](/images/finished-with-configuration.png)

6.  Create Build Agents
![Create Build Agents](/images/create-build-agents.png)

## Future Configuration of Build Agents

Once you've finished the install of the build service and agents, you need to configure them. After completing the install the Team Foundation Server Administration Console should open, if not open manually (start menu)

1.  Review build service configuration
![Review build service configuration](/images/review-build-service-configuration.png)
2.  Build Configuration Pane
![Build Configuration Pane](/images/build-configuration-pane.png)
3.  Reviewing Build Agent Properties
![Reviewing Build Agent Properties](/images/reviewing-build-agent-properties.png)

## Setup of Build

1.  Create new build
![Create new build](/images/create-new-build.png)

2.  set trigger to continous integration
![set trigger to continous integration](/images/set-trigger-to-continous-integration.png)

3.  map your working folder to the database project
![map your working folder to the database project](/images/map-your-working-folder-to-the-database-project.png)

4.  setup the process details
Make sure to the map the project to the .sqlproj file to only build the sqlproj. You can adjust other items as you desire, but this should cover the core settings.
![setup the process details](/images/setup-the-process-details.png)

5.  Copy Local
Make sure to have the new profile copied locally as part of the build or it won't have any publish profile copied when the build is triggered, and therefore might result in hours of you wondering why it is ignoring your profile target settings (true story). You can configure to not do this of course, if you want to have a fixed file on your drive instead of copying from source control each time. [Recommendation - Prepare a Publish Profile file](http://bit.ly/221zgxS)
![Copy Local](/images/copy-local.png)

6.  Setup Parameters for Build
The arguments I choose to use were:
(note the publishprofile parameter which wasn't in older versions of SSDT)

    /t:Build /t:Publish /p:SqlPublishProfilePath=foobar.publish.xml" /p:PublishScriptFileName=foobar.publish.sql /p:TargetDatabaseName="foobar";TargetConnectionString="Data Source=localhost;Integrated Security=True;Pooling=False" /p:PreBuildEvent= /p:PostBuildEvent=  /p:VisualStudioVersion=14.0

The infuriating thing about working through this is that when it doesn't find the publish profile, it defaults to the "Deploy" settings, so in my case it kept trying to deploy the changes to a local database named the same thing as my project. Please don't waste the same amount of time grinding your teeth at MSBuild as I did, and watch out for the paths to be correct! Make sure you have it set to copy the publish profile over or it will not exist and default to the deploy settings.

When I omitted the VisualStudioVersion option, it had an error "unable to connect to target server"...... 2 days of work later I realized the version parameter was critical for it to use the right msbuild version and deploy. I didn't go into more research on this, so feel free to comment if you more details on this.

![Setup Parameters for Build](/images/setup-parameters-for-build.png)

## Running MSBuild Manually

A few tips from my work with launching the process to build the database locally, if you experience an issues. This is work I was doing with MSBUILD 14 (visual studio 2015). I would trigger msbuild and it would deploy the database, but never exit the process to report success to powershell allowing my script to continue.

```text
/p:UseSharedCompilation=false               --> (Roslyn compiler bypassed http://bit.ly/1WmMVzx)
/m:4                                        --> (limit to only 4 cores http://bit.ly/1VSl9uF)
/nr:false                                   --> same link above
/verbosity:quiet
/p:Configuration=Release                    --> don't need debugging for this output, so just output release
/p:DebugSymbols=false                       --> no need for extra debugging, potential improvement in timing to get rid of this
/p:DebugType=None
/t:Build;Deploy                     --> optional. Could rebuild if you want to
/p:PreBuildEvent=                   --> bypass any prebuild/post build events if you have something doing copying of files around (optional)
update after got everything working:
/p:VisualStudioVersion=14.0 --> ensure you match the version of msbuild you need
```

Optional: If you have further issues with 2015 and want to disable globally the node reuse settings then you can do this with a registry entry. Following the directions from [TechDocs](https://techdocs.ed-fi.org/display/ODSAPI20/Step+4.+Prepare+the+Development+Environment) I did this.

![Running MSBuild Manually](/images/running-msbuild-manually.png)

## Resources

### MSDN Documentation Tasks

Creating tasks is documented in

*   [Task Writing: Visual Studio 2013](https://msdn.microsoft.com/en-us/library/t9883dzc(v=vs.120).aspx)
*   [MsBuild Tasks](https://msdn.microsoft.com/en-us/library/ms171466(v=vs.120).aspx)

The MSBuild XML project file format cannot fully execute build operations on its own, so task logic must be implemented outside of the project file.
The execution logic of a task is implemented as a .NET class that implements the ITask interface, which is defined in the Microsoft.Build.Framework namespace.

The task class also defines the input and output parameters available to the task in the project file. [MSBuild Tasks](https://msdn.microsoft.com/en-us/library/ms171466(v=vs.120).aspx#Anchor_0)
