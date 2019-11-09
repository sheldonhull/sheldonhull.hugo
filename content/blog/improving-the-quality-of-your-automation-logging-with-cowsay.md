---
date: 2019-11-09T19:01:13+00:00
title: Improving the Quality of Your Automation Logging with Cowsay
slug: improving-the-quality-of-your-automation-logging-with-cowsay
excerpt: 'Everyone involved in DevOps should have this critical tool in their toolchain... '
tags:
- cool-tools
- devops
- tech
draft: true

---
## Automation Taxes Your Sanity

You have to glue together systems with your amazing duct taped scripts.

You see failure after failure.

You want help predicting the success of your next run, so I'm going to provide you with an advanced artificially intelligent way to do this through the power of npm packages.

```powershell
npm install cowsay -g
npm install lucky -g
```

Now include the header in your script

```powershell
"Will my run succeed this time? $( lucky --eightball)" | cowsay -r
```

There's a few PowerShell related one's, but I honestly just use the node packages for this. I have a forked copy of the PowerShell one that's got some of the more offensive ascii art versions removed if you want a way to send message via a PowerShell module. It's not as extensive as the node module though.

[Cowsay-Sharp](https://github.com/sheldonhull/Posh-Cowsay)

```powershell
git clone https://github.com/sheldonhull/Posh-Cowsay
```


## Level Up

Level it up by installing `lolcat` and if running Cmder you'll enjoy the Skittlitizing of your console output.

```powershell
npm install lolcat -g
```

PowerShell version is: `Install-Module lolcat -Scope CurrentUser`