---
title: How to Iterate Through A List of Objects with Terraform's for_each function
slug: how-to-iterate-through-a-list-of-objects-with-terraforms-for-each-function
date: 2020-07-24T16:00:00-05:00
toc: true
excerpt: While iterating through a map has been the main way I've handled this,
  I finally ironed out how to use expressions with Terraform to allow an object
  list to be the source of a for_each operation. This makes feeding Terraform
  plans from yaml or other collection input much easier to work with.
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

What I want to work
```hcl

resource "something" { 
for_each local.users_config

name = each.key # or even each.value.name
email = each.value.email

}
```

## What I've had to do

Now to iterate through this collection, I've had challenges, as the only way I've gotten this to work would be to ensure their was a designated key in the yaml structure, in essence providing a map object with a key/value format, instead of a collection of normal objects.

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

Iterating through a map has been the main way I've handled this, I finally ironed out how to use expressions with Terraform to allow an object list to be the source of a for_each operation. This makes feeding Terraform plans from yaml or other collection input much easier to work with.