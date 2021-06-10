---
date: 2021-06-09T19:02:34-05:00
title: Log4 Brains Improves ADR Experience
slug: log4-brains-improves-adr-experience
tags:
  - tech
  - development
  - microblog
# images: [/images/]
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

I'm a fan of architectural decision records.
Docs as code sets a practice for a team to track decisions in process and design.

[Log4Brains](https://github.com/thomvaill/log4brains) provides markdown template based adr creation, with an option to render a static site for reading.

If you want to start managing your ADRs in a structured way, but benefit from simple markdown as the source files, then this is a great option to consider.

It's really easy to get started with docker, no `npm install` required.

Just run: `docker run --rm -p 4004:4004 -v ${PWD}:/opt/adr trivadis/log4brains` and open `http://127.0.0.1:4004`

```text
# Proposal To Write a Microblog Post on ADRS

- Status: proposed
- Approver: Me
- Tags: microblog,hugo,magic

## Context and Problem Statement

Overally inhibiting view on tacos is preventing continual tacoops from meeting required SLA.

## Decision

- Tacos for everyone. 🌮
```
