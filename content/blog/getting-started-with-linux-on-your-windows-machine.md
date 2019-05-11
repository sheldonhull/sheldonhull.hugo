---
date: 2019-05-11T13:57:40-05:00
title: Getting Started With Linux on Your Windows Machine
slug: getting-started-with-linux-on-your-windows-machine
excerpt: 'As I''ve continued on in my DevOps journey, I''ve wanted to become more
  proficient with my linux cli-fu. A good way to get familar with Linux if you are
  in a Windows machine based environment can be running docker containers, as well
  as working with Windows Subsystem for Linux. '
tags:
- tech
- development
- devops
- linux
draft: true

---
## Windows Subsystem for Linux

As I've continued on in my DevOps journey, I've wanted to become more proficient with my linux cli-fu. A good way to get familar with Linux if you are in a Windows machine based environment can be running docker containers, as well as working with Windows Subsystem for Linux. I found a great tutorial that helped me on my experiment: 

[https://blog.ropnop.com/configuring-a-pretty-and-usable-terminal-emulator-for-wsl/](https://blog.ropnop.com/configuring-a-pretty-and-usable-terminal-emulator-for-wsl/ "configuring-a-pretty-and-usable-terminal-emulator-for-wsl")

I took a few minor differences in the process, so figured I'd do a basic walk through of what steps I took to get this working.

## Before you begin

I'm assuming you have installed Chocolatey & enabled WSL for linux and installed Ubuntu from Windows Store.

You should assume all my syntax is from powershell prompt, not command prompt. There is no reason to use command prompt in Windows except for edge cases, when powershell is available. :smile:

## Enabling WSL

## Customizing Terminal

    choco upgrade vcxsrv -y

Then i installed this as a service using NSSM. 

## Use Case

## Limitations & Gotchas