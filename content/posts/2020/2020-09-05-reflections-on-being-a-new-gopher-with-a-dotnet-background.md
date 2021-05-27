---
date: 2020-09-07T07:00:00-05:00
title: Reflections on Being a New Gopher With A Dotnet Background
slug: reflections-on-being-a-new-gopher-with-a-dotnet-background
summary:
  Quick reflections on being a new gopher with a dotnet background.
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - tech
  - development
  - golang
  - dotnet
  - 100DaysOfCode
toc: true
---

## Disclaimer

Newbie Gopher.
Much of what I observe is likely to be half right.
I'll probably look back at the end of the year and shake my head, but gotta start the journey somewhere, right? 😁

## My Background

I've learned my development skills primarily in the dotnet world.
Coming from SQL Server performance, schema, and development, I transitioned into learning PowerShell and some C#.
I found for the most part the "DevOps" nature of what I was doing wasn't a good fit for focusing on C# and so have done the majority of my development in PowerShell.

For those unfamilar with PowerShell, I highly recommend it as a fantastic shell experience and as a great ecosystem for automation oriented programming.

With everything as an "object" in PowerShell, not only does the manipulation of those objects tend to be pretty flexible, but built in methods, properties, and deep diving into object collections in objection collections provide powerful control of working with things like AWS.Tool.SDK and Windows.

## Why I Started With Go

I wanted to focus on Python, as I think it's a beautiful language and I'd probably be more productive quickly in it.
However, as I started my Python journey I discovered that I was basically substituting PowerShell (my goto) with a language that in many ways was very similar.

Python provides a "glue" language that can do many things, in many varying domains with a vast ecosystem of user built modules.

So why Go?

Primarily, I wanted 2 main things from my next step:

- Expand my horizons with a language that approached things differently than what I'm used to, forcing me to solve problems in a new way, not just a simple syntax shift.
- Try something that was more strictly typed and opinionated to help align my next development to be less "adhoc" but more robust.

Some additional perks would be: choosing a language that made me more competitive in the market (so choosing low adoption languages), immersed me more in Linux while still supporting cross platform work, and additionally supported quick adhoc tooling to be able to deliver small portable tooling to help support a DevOps culture.

## Is it better than x

No. It's not "better" than PowerShell, C#, Python, or even Bash.

That's an incomplete way to consider this, just like saying your hammer is better than a screwdriver or replaces the need for a table saw. 😁

## How It's Helping Me Think Differently

What I find myself observing is it is accomplishing one of my primary objectives of thinking differently.

## Interfaces

Interfaces are something I've rarely used, as I'm not doing much C#, but when I had used this it seemed to be extra work for the the sack of good design and abstraction of implementation.
Since, most of my development was automation oriented, I had little case for regularly using them.

## Bytes

Bytes are something I've rarely had to work with, as it's abstracted in PowerShell.
However, in Go, bytes seem to be a universal medium.

Let's say I need to run a web request for gathering some results in json and manipulating then.
With PowerShell a simple rest call with `ConvertFrom-Json` is all that is required.
With Go, you have to convert the bytes and use `json.Unmarshal` as one way to take the response and place the response into a predefined struct (or empty struct is possible as well I believe)

Want to deal with images, files, web requests, and more... bytes.
Endless streams of bytes.

## Dotnet Types

Say, I want to work with a semver version number.
This is provided in the standard System library in C#, and also accessible via a type accelerator in PowerShell.

```powershell
$ver = [System.Version]::new()
[System.Version]::TryParse($ParseMe,[ref]$ver) # Returned bool success/fail
Write-Host $ParseMe
```

In Go, this wouldn't be part of the standard library (at least from what I've found).
Instead, you'd get the same essential functionality by finding a package like: [go-version](https://bit.ly/2F1XSX7) and using it.

Instead of a class object being returned, such as shown about with PowerShell, you'd have structs returned.

Where `[pscustomobject]@{}| Get-Member` would report back the .NET type of `System.Management.Automation.PSCustomObject`, running reflection against something go.

From [go-version](https://github.com/hashicorp/go-version/blob/59da58cfd357de719a4d16dac30481391a56c002/version.go#L33)

```go
// Version represents a single version.
type Version struct {
    metadata string
    pre      string
    segments []int64
    si       int
    original string
}
```

This would be basically the new Type that I'd expect to see in Go.

## Last Thoughts

I'm really enjoying the experience of looking at things from a new perspective and doing my best to keep an open mind to learn Go without prejudice to force it to my way of thinking.

So far it has been interesting and probably harder initially because my paradigm has come from the dotnet ecosystem.
Removing dotnet from the equation, it's interesting to see how much I take for granted.

I think if I had been immersed in Python from the beginning, transitioning to Go would be more intuitive to me.
When I was juggling C# and PowerShell, I found it very intuitive as most of the basics were just syntax differences, until you added in more complex things like Linq/Delegates, abstract classes, interfaces, and other things that don't have quite the place in the PowerShell world.

The generalization of "everything is an object" in Windows vs in Linux "everything is a file/text" rings true in the approach I think I've observed underlying the way the languages function.

## Give Something New A Shot

If you are from a Linux background, I'd suggest you give PowerShell a shot (its cross platform now) and try this experience of learning a new paradigm.
Using something like `InvokeBuild` will give you a much richer experience than `Make` files.
If from Windows, then Python or Go would be a great choice to help challenge you.

## Give Yourself Time To Be Terrible At It

I read recently from [@Duffney](https://bit.ly/35bbXMy):

> My biggest challenge with using the 20 hours rule to learn new things is becoming comfortable being "unproductive"

I think that was a very freeing concept, as I've wrestled with this.
Being pretty experienced in PowerShell, being ok writing non-idiomatic Go code with rough project structure, limited tests, and more has been mentally inhibiting.

It's always better to get momentum on something and once competence is growing, challenge yourself to excel with more idomatic, tested, and well designed solutions.
Build and ship some stuff so you can even get to the place where you wince at your old work in the first place 😆
