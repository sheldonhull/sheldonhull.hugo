---
date: "2016-11-22T00:00:00Z"
tags:
- powershell
title: "Scan folder of dlls to identify x86 or x64 compiled assemblies"
slug: "scan-folder-of-dlls-to-identify-x86-or-x64-compiled-assemblies"
---

Point this at a directory of dlls and you can get some of the loaded assembly details to quickly identify what type of processor architecture they were compiled for.I did this as I wanted to explore a large directory of dlls and see if I had mixed assemblies of x32 and x64 together from a visual studio build.
Some dlls with invalid assembly header information were found, and this skips those as warnings.

{{% gist ab1a65ce636231e72214dc1acad30f6d %}}

