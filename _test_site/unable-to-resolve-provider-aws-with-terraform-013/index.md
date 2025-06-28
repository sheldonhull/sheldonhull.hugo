# Unable To Resolve Provider AWS with Terraform Version 0.13.4


I couldn&#39;t get past this for a while when I accidentally stumbled across a fix.
I believe the fix was merged, however this problem still existed in `0.13.4` so I stuck with it.

{{&lt; admonition type=info title=&#34;GitHub Issues&#34; open=true &gt;}}
When investigating the cause, I found this PR which intended this to be the installer behaviour for the implicit global cache, in order to match 0.12. Any providers found in the global cache directory are only installed from the cache, and the registry is not queried.
Note that this behaviour can be overridden using provider_installation configuration.
That is, you can specify configuration like this `~/.terraform.d/providercache.tfrc`

[GitHub Issue Comment](https://github.com/hashicorp/terraform/issues/25985#issuecomment-680052845)

{{&lt; /admonition &gt;}}

I used the code snippet here: `micro ~/.terraform.d/providercache.tfrc`

Wasn&#39;t sure if it was interpreted with shell, so I didn&#39;t use the relative path `~/.terraform.d/plugins`, though that might work as well.

```hcl
provider_installation {
  filesystem_mirror {
    path = &#34;/Users/sheldonhull/.terraform.d/plugins&#34;
  }
  direct {
    exclude = []
  }
}
```

After this `terraform init` worked.

