---
date: 2020-04-20T07:00:00-05:00
title: Improved Windows Terminal Setup
slug: improved-windows-terminal-setup
summary: Quickly get some nice defaults going for latest Windows Terminal
tags:
- cool-tools
- development
- git
- powershell
- tech
draft: false

---
I've long been a Cmder/ConEmu user for Windows as it's provided a much-needed improvement of the standard Windows terminal.

I've started trying to use the newer Windows Terminal project to benefit from the improved performance and support, and found getting it up and running with any customizations was a little time consuming and confusing. This wasn't something I'd hand off to someone who wasn't looking for experimentation.

So here it goes! Rather than hunting all around to get a nice start on some default prompts, I've linked to some gists that can help you get up and running quickly with a few extra perks.

## Getting Started

This will help you get the terminal installed, along with downloading some settings I've already pre-setup with keybindings and more.

To customize your own keybindings, you can go to the [profiles.json](https://github.com/microsoft/terminal/blob/master/doc/cascadia/SettingsSchema.md) documentation.



## Improve Your Experience

After install, you can run the next command to help you get a better font setup with full support for ligatures and more.



And after this, if you don't have a nice PowerShell prompt experience, this will help give you a great start. This contains a few things, including [starship](https://starship.rs). This is really useful as it has a library of prompt enhancements baked in. For example, if you are have an AWS profile active, it will display that for reference. It can display an active terraform workspace, git branch info, python virtual environment and more. Definitely a nice quick productivity booster with no real configuration needed to get going.



If you are wondering why I didn't leave the pretty awesome `"useAcrylic": true` on for my main pwsh session, it's because I found the background contrast reduction made it hard to read some darker colors on the prompt.

Be sure to try out the retro pwsh theme for some nice eye candy.

## The result

PowerShell Protip: Note the suggested completion based on prior commands in the pwsh prompt. This is some great prerelease work on a better PSReadline experience with Powershell.

![image of windows terminal](images/windows-terminal-01.png)

![images of windows terminal](images/windows-terminal-02.png)
