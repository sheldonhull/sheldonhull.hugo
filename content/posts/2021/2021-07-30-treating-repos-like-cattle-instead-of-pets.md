---

date: 2021-07-30T13:08:42-05:00
title: Treating Repos Like Cattle Instead of Pets
slug: treating-repos-like-cattle-instead-of-pets
summary:
  Thinking on handling repositories tooling in a consistent manner.
  What can we do to handle projects in a consistent way and reduce the rework required?
  Shift the responsibility to the CI system with the cost of slower iterative feedback for a developer and reliance on plugins?
tags:
- tech
- development
- continual-integration
- devops
- golang
draft: true
toc: true

# images: [/images/]

---

## Glue Work

I've been thinking on the approach that Cloudposse has taken in this project:

> [GitHub - cloudposse/build-harness: 🤖Collection of Makefiles to facilitate building Golang projects, Dockerfiles, Helm charts, and more](https://github.com/cloudposse/build-harness)

When managing many repos I think that  concept is so freaking amazing. Why aren't more tools centrally synced and updated like this!

Thinking on handling repositories tooling in a consistent manner.
What can we do to handle projects in a consistent way and reduce the rework required?
Shift the responsibility to the CI system with the cost of slower iterative feedback for a developer and reliance on plugins?

It's sorta like we treat repos as "pets" rather than cattle with our tooling.
I think this is where github actions is so amazing, as they've brought in ways to use organizational level definitions to run and reuse.

Tools like "cookie-cutter" or github repo templates seem nice, but I think they might be a bandaid.
They are solving the problem of making it faster to setup a new project with tooling and structure.

If there is a tool like build-harness though, customizing automation tooling becomes a breeze as you just sync the latest defaults.

## Docker

Docker solves much more of the problem by wrapping up tools and dependencies in a single package that can be reused in many projects.

It does come with the downside of a less friendly interface, but there are options around this.
Debugging and running compiled applications is also possible, yet does come with the downside of added complexity.

## A Happy Mix

Maybe the mix of task definitions in Docker, while not expecting developers to run every single command fully embedded in Docker is a happy medium?
