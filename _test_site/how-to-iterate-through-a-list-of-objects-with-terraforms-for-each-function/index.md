# How to Iterate Through A List of Objects with Terraform&#39;s for_each function

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
  users_file         = &#34;local.users.yml&#34;
  users_file_content = fileexists(local.users_file) ? file(local.users_file) : &#34;NoSettingsFileFound: true&#34;
  users_config       = yamldecode(local.users_file_content)
}
```

What I want to work:

```hcl
resource &#34;something&#34; {
for_each local.users_config

name = each.key # or even each.value.name
email = each.value.email
}
```

## What I&#39;ve had to do

Now to iterate through this collection, I&#39;ve had challenges, as the only way I&#39;ve gotten this to work would be to ensure there was a designated key in the `yaml` structure.
This provides a map object with a key/value format, instead of a collection of normal objects.

This would result in a yaml format like:

```yml
user:
  - &#39;foobar1&#39;:
      name: foobar1
      email: foobar1@foobar.com
  - &#39;foobar2&#39;:
       name: foobar2
       email: foobar2@foobar.com
  - &#39;foobar3&#39;:
       name: foobar3
       email: foobar3@foobar.com
```

This provides the &#34;key&#34; for each entry, allowing Terraform&#39;s engine to correctly identify the unique entry.
This is important, as without a unique key to determine the resource a plan couldn&#39;t run in a deterministic manner by comparing correctly the previously created resource against the prospective plan.

## Another Way Using Expressions

Iterating through a map has been the main way I&#39;ve handled this, I finally ironed out how to use expressions with Terraform to allow an object list to be the source of a `for_each` operation.
This makes feeding Terraform plans from `yaml` or other input much easier to work with.

Most of the examples I&#39;ve seen confused the issue by focusing on very complex flattening or other steps.
From this stack overflow answer, I experimented and finally got my expression to work with only a single line.

```hcl
resource &#34;foobar&#34; &#34;this&#34; {
    for_each = {for user in local.users_config.users: user.name =&gt; user}
    name     = each.key
    email    = each.value.email
}
```

This results in a simple yaml object list being correctly turned into something Terraform can work with, as it defines the unique key in the expression.

