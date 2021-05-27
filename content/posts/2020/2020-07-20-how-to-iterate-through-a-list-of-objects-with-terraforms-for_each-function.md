---
title: How to Iterate Through A List of Objects with Terraform's for_each function
slug: how-to-iterate-through-a-list-of-objects-with-terraforms-for-each-function
date: 2020-07-29T16:00:00-05:00
toc: true
summary: While iterating through a map has been the main way I've handled this,
  I finally ironed out how to use expressions with Terraform to allow an object
  list to be the source of a for_each operation. This makes feeding Terraform
  plans from yaml or other collection input much easier to work with.
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - tech
  - development
  - terraform
---
## What I want to do

```yml
# create file local.users.yml
user:
  - name: foobar1
    email: foobar1@foobar.com
  - name: foobar2
    email: foobar2@foobar.com
  - name: foobar3
    email: foobar3@foobar.com
```

```hcl
locals {
  users_file         = "local.users.yml"
  users_file_content = fileexists(local.users_file) ? file(local.users_file) : "NoSettingsFileFound: true"
  users_config       = yamldecode(local.users_file_content)
}
```

What I want to work:

```hcl
resource "something" {
for_each local.users_config

name = each.key # or even each.value.name
email = each.value.email
}
```

## What I've had to do

Now to iterate through this collection, I've had challenges, as the only way I've gotten this to work would be to ensure there was a designated key in the `yaml` structure.
This provides a map object with a key/value format, instead of a collection of normal objects.

This would result in a yaml format like:

```yml
user:
  - 'foobar1':
      name: foobar1
      email: foobar1@foobar.com
  - 'foobar2':
       name: foobar2
       email: foobar2@foobar.com
  - 'foobar3':
       name: foobar3
       email: foobar3@foobar.com
```

This provides the "key" for each entry, allowing Terraform's engine to correctly identify the unique entry.
This is important, as without a unique key to determine the resource a plan couldn't run in a deterministic manner by comparing correctly the previously created resource against the prospective plan.

## Another Way Using Expressions

Iterating through a map has been the main way I've handled this, I finally ironed out how to use expressions with Terraform to allow an object list to be the source of a `for_each` operation.
This makes feeding Terraform plans from `yaml` or other input much easier to work with.

Most of the examples I've seen confused the issue by focusing on very complex flattening or other steps.
From this stack overflow answer, I experimented and finally got my expression to work with only a single line.

```hcl
resource "foobar" "this" {
    for_each = {for user in local.users_config.users: user.name => user}
    name     = each.key
    email    = each.value.email
}
```

This results in a simple yaml object list being correctly turned into something Terraform can work with, as it defines the unique key in the expression.
