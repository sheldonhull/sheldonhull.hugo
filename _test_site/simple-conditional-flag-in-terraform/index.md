# simple conditional flag in terraform

Sometimes, you just need a very simple flag for enabled or disabled, or perhaps just a resource to deploy if `var.stage == &#34;qa&#34;`.
This works well for a single resource as well as collections if you provide the [splat syntax](https://bit.ly/39yHUP9).

```powershell

resource &#34;aws_ssm_association&#34; &#34;something_i_need_in_testing_only&#34; {
   count = var.stage == &#34;qa&#34; ? 1 : 0
   name = var.name
}
```

