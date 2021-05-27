---
date: "2015-08-12T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
- redgate
- cool-tools
title: "Red Gate SQL Source Control v4 offers schema locks"
slug: "red-gate-sql-source-control-v4-offers-schema-locks"
---

Looks like the rapid release channel now has a great feature for locking database objects that you are working on. Having worked in a shared environment before, this could have been a major help. It's like the poor man's version of checking an object out in visual studio except on database objects! With multiple developers working in a shared environment, this might help reduce conflicting multiple changes on the same object.

Note that this doesn't look to evaluate dependency chains, so there is always the risk of a dependent object being impacted. I think though that this has some promise, and is a great improvement for shared environment SQL development that uses source control.
