---

date: 2022-06-11T22:03:28+0000
title: The Local First Automation Manifesto
slug: the-local-first-automation-manifesto
summary:
  Foo
tags:

- tech
- development
- azure-devops
- powershell
- devops
draft: true
toc: true

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

## Local First Automation Manifesto

I've had a lot of conversations over the last few years on this, as well as wrestled with various approaches and decided to codify my current thoughts on this.

I think I've particularly cared about this because I've tended to notice the repeat "chore style" work we do as developers and particulary the wasted reimplementation on common sets of actions across projects.

## Common Objections

### Abstracting Means Folks Don't Understand the Tools

### Simple To Use Vs Simple To Understand

I've seen some stances that simple to understand should always trump simple to use.

The idea is that if you make something easy to do, but have heavily abstracted it, the underlying work isn't really understood and this is a problem for the developer.

Here's my main issue with this:

We use a plethora of tooling that abstracts complexity away.
Docker doesn't make things simplier to understand, it's simplier to use.
Mastering the underlying technology and all the quirks of containers can be a lifelong journey. However, we are fine with `docker --rm -it redis`.
We don't expect to become masters of the startup process of Redis, configuration, and such.
We use only what we need and consume it.
If we need to go beyond that, we can self-host, or manage it, but that's not our default stance.
