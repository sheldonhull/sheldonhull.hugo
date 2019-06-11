---
date: 2019-06-17T14:00:00+00:00
title: Bump nuspec file version with powershell
slug: bump-nuspec-file-version-with-powershell
excerpt: " This snippet should help give you a way to bump a nuspec file version programmatically."
tags:
- chocolatey
- azuredevops
- devops
- powershell

---
## Bump Nuspec Version

Bumping the version of the nuspec file requires a little tweaking and I got some help from the slack powershell community to ensure I handled the xml parsing correctly. This was the result. If you are running a chocolatey package build or equivalent nuspec build via an agent and want a way to ensure the latest build updates the build version incrementally this should help.

This snippet should help give you a way to bump a nuspec file version programmatically.

{{% gist f0c2bd47e18e5d074c5e2b9943f79dfc %}}

I modified the logic to support `-WhatIf` since I'm a fan of being able to run stuff like this without actually breaking things first.