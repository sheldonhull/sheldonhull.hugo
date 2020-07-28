---
title: simple conditional flag in terraform
date: 2020-07-28T18:00:00-05:00
tags:
  - tech
  - development
  - microblog
  - terraform
---
Sometimes, you just need a very simple flag for enabled or disabled, or perhaps just a resource to deploy if `var.stage == "qa"`. 
This works well for a single resource as well as collections if you provide the [splat syntax](https://bit.ly/39yHUP9). 

```powershell

resource "aws_ssm_association" "something_i_need_in_testing_only" {
   count = var.stage == "qa" ? 1 : 0
   name = var.name
}
```