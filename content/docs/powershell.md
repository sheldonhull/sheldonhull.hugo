---
title: powershell
slug: powershell
date: 2019-03-19
last_modified_at: 2019-03-19
toc: true
excerpt: A cheatsheet for some interesting PowerShell related concepts that might
  benefit others looking for some tips and tricks
permalink: "/docs/powershell"
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


## Date & Time Conversion

Converting dates to Unix Epoc time can be challenging without using the correct .NET classes. There is some built in functionality for converting dates such as `(Get-Date).ToUniversalTime() -UFormat '%s'` but this can have problems with time zone offsets. A more consistent approach would be to leverage the following. This was very helpful to me in working with Grafana and InfluxDb which commonly leverage Unix Epoc time format with seconds or milliseconds precision.

```powershell

$CurrentTime = [DateTimeOffset]::new([datetime]::now,[DateTimeOffset]::Now.Offset);

# Unix Epoc time starts from this date
$UnixStartTime = [DateTimeOffset]::new(1970, 1, 1, 0, 0, 0,[DateTimeOffset]::Now.Offset);

# To Use This Now On Timestamp you could run the following
$UnixTimeInMilliseconds = [Math]::Floor( ((get-date $CurrentTime) - $UnixStartTime).TotalMilliseconds)

# To Use with Different Time just change the `$CurrentTime` to another value like so
$UnixTimeInMilliseconds = [Math]::Floor( ((get-date $MyDateValue) - $UnixStartTime).TotalMilliseconds)
```