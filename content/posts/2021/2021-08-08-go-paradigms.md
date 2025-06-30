---
date: 2021-08-08T15:45:25Z
draft: true
title: Go Paradigms (Or Why Succintness Isn't Always A Good Thing)
summary: Maybe err != nil isn't so bad
slug: go-paradigms
tags:
- tech
- development
- til

# images: [/images/]
---

## Fluent Interface

I've heard term the terminology Fluent thrown around, but never had context on what this meant.

Some phrases such as Fluent API's, or in Go's case the conflict with new developers interested in "Fluent expressions" weren't clear.

> In software engineering, a fluent interface is an object-oriented API whose design relies extensively on method chaining. Its goal is to increase code legibility by creating a domain-specific language (DSL). [^fluent-interface]

While, not a perfect reflection of this, you can see the pipeline expression in PowerShell follow a mix of method and pipeline chaining on operations.

```powershell
[io.file]::create('taco.txt').Name.ToUpper()

(Get-ChildItem -Filter '*.txt').Where{$_.Fullname -match 'taco'}.ForEach{ $_ | Copy-Item}
```

This was something I first noticed with Go and even blogged about in [Filtering Results in Go]({{< relref "2020-11-17-filtering-results-in-go.md" >}} "Filtering Results in Go").

> Is there any library used by many to do this type of filtering, or is my .NET background coloring my perspective with dreams of Linq?

The answer to my past self is: Yes, your background in .NET impacted this perspective.

## So Why Is Chaining Operations or Expressions So Hard in Go?

Simple answer, it is fundamentally at odds with the core paradigm of the language.

[^fluent-interface]: [Fluent interface - Wikipedia](https://en.wikipedia.org/wiki/Fluent_interface)
