---
title: powershell
date: '2019-03-19'
last_modified_at: '2019-03-19'
toc: true
excerpt: A cheatsheet for some interesting PowerShell related concepts that might benefit others looking for some tips and tricks
permalink: /docs/powershell
tags:
  - development
  - powershell
---

## String Formatting

| Type                                        | Example                                                 | Output                        | Notes                                                               |
| ------------------------------------------- | ------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------- |
| Formatting Switch                           | `'select {0} from sys.tables' -f 'name'`                | `select name from sys.tables` | Same concept as .NET `[string]::Format()`. Token based replacement  |
| [.NET String Format](http://bit.ly/2TkXh43) | `[string]::Format('select {0} from sys.tables','name')` | `select name from sys.tables` | Why would you do this? Because you want to showoff your .NET chops? |

## Math & Number Conversions

| From                | To      | Example           | Output              | Notes                                     |
|---------------------|---------|-------------------|---------------------|-------------------------------------------|
| scientific notation | Decimal | 2.19095E+08 / 1MB | 208.945274353027 MB | Native PowerShell, supports 1MB, 1KB, 1GB |
