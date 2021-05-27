---
date: 2020-09-09T11:40:18-05:00
title: Terraform's Elegance in Abstraction
slug: terraform's-elegance-in-abstraction
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
    - tech
    - development
    - microblog
    - terraform
---

Migrated a forked copy of a module over to a new module with similar schema.
There were some additional properties that were removed.
In rerunning the plan I was expecting to see some issues with resources being broken down and rebuilt.
Instead, Terraform elegantly handled the module change.

I imagine this has to do with the resource name mapping being the same, but regardless it's another great example of how agile Terraform can be.
