---
date: 2020-11-02T21:39:39Z
title: Unable To Resolve Provider AWS with Terraform Version 0.13.4
slug: unable-to-resolve-provider-aws-with-terraform-013
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
    - tech
    - development
    - microblog
    - terraform
    - troubleshooting
---

I couldn't get past this for a while when I accidentally stumbled across a fix.
I believe the fix was merged, however this problem still existed in `0.13.4` so I stuck with it.

{{< admonition type=info title="GitHub Issues" open=true >}}
When investigating the cause, I found this PR which intended this to be the installer behaviour for the implicit global cache, in order to match 0.12. Any providers found in the global cache directory are only installed from the cache, and the registry is not queried.
Note that this behaviour can be overridden using provider_installation configuration.
That is, you can specify configuration like this `~/.terraform.d/providercache.tfrc`

[GitHub Issue Comment](https://github.com/hashicorp/terraform/issues/25985#issuecomment-680052845)

{{< /admonition >}}

I used the code snippet here: `micro ~/.terraform.d/providercache.tfrc`

Wasn't sure if it was interpreted with shell, so I didn't use the relative path `~/.terraform.d/plugins`, though that might work as well.

```hcl
provider_installation {
  filesystem_mirror {
    path = "/Users/sheldonhull/.terraform.d/plugins"
  }
  direct {
    exclude = []
  }
}
```

After this `terraform init` worked.
