---
date: 2020-04-20T12:00:00+00:00
title: Improved Windows Terminal Setup
slug: improved-windows-terminal-setup
excerpt: Quickly get some nice defaults going for latest Windows Terminal
tags:
- powershell
- development
- cool-tools
- tech
draft: true

---
I've long been a Cmder/ConEmu user for Windows as it's provided a much needed improvement of the standard Windows terminal.

I've started trying to use the newer Windows Terminal project to benefit from the improved performance and support, and found getting it up and running with any customizations was a little time consuming and confusing. This wasn't something I'd hand off to someone who wasn't looking for experimentation.

So here it goes! Rather than hunting all around to get a nice start on some default prompts, I've linked to some gists that can help you get up and running quickly with a few extra perks.

## Getting Started

This will help you get the terminal installed, along with downloading some settings I've already presetup with keybindings and more.

To customize your own keybindings, you can go to the [profiles.json](https://github.com/microsoft/terminal/blob/master/doc/cascadia/SettingsSchema.md) documentation.

{{% gist "sheldonhull/93d8060e6f86e0c46535ef6699d6e0c8" "install-settings.ps1" %}}

## Improve Your Experience

After install, you can run the next command to help you get a better font setup with full support for ligatures and more.

{{% gist "sheldonhull/93d8060e6f86e0c46535ef6699d6e0c8" "install-font.ps1" %}}

And after this, if you don't have a nice PowerShell prompt experience, this will help give you a great start. This contains a few things, including [starship](https://starship.rs). This is really useful as it has a library of prompt enhancements baked in. For example, if you are have an AWS profile active, it will display that for reference. It can display an active terraform workspace, git branch info, python virtual environment and more. Definitely a nice quick productivity booster with no real configuration needed to get going.

{{% gist "sheldonhull/93d8060e6f86e0c46535ef6699d6e0c8" "configure-profile-prompt.ps1" %}}

If you are wondering why I didn't leave the pretty awesome `"useAcrylic": true` on for my main pwsh session, it's because I found the background constrast reduction made it hard to read some darker colors on the prompt.

Be sure to try out the retro pwsh theme for some nice eye candy.

## The result

PowerShell Protip: Note the suggested completion based on prior commands in the pwsh prompt. This is some great prerelease work on a better PSReadline experience with powershell.

![](images/windows-terminal-01.png)![](images/windows-terminal-02.png)