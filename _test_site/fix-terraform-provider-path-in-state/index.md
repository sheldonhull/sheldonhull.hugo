# Fix Terraform Provider Path in State


Fixing Terraform provider paths in state might be required after upgrading to 0.13-0.14 if your prior state has the following paths.

First, get the terraform providers from state using: `terraform providers`

The output should look similar to this:

![image-of-providers](/images/2021-03-10-microblog-provider-list-01.png)

To fix these, try running the commands to fix state.
Please adjust to the required providers your state uses, and make sure your tooling has a backup of the state file in case something goes wrong.
Terraform Cloud should have this backed up automatically if it&#39;s your backend.

```shell
terraform state replace-provider -- registry.terraform.io/-/aws registry.terraform.io/hashicorp/aws
terraform state replace-provider -- registry.terraform.io/-/random registry.terraform.io/hashicorp/random
terraform state replace-provider -- registry.terraform.io/-/null registry.terraform.io/hashicorp/null
terraform state replace-provider -- registry.terraform.io/-/azuredevops registry.terraform.io/microsoft/azuredevops
```

The resulting changes can be seen when running `terraform providers` and seeing the dash is now gone.

![image-of-providers-changed](/images/2021-03-10-microblog-provider-list-02.png)

[Upgrading to Terraform v0.13 - Terraform by HashiCorp](http://bit.ly/3rvFPvr)

{{&lt; admonition type=&#34;Example&#34; title=&#34;Loop&#34; open=&#34;false&#34;&gt;}}

If you have multiple workspaces in the same folder, you&#39;ll have to run fix on their seperate state files.

This is an example of a quick adhoc loop with PowerShell to make this a bit quicker, using `tfswitch` cli tool.

```powershell
tf workspace list | ForEach-Object {
    $workspace = $_.Replace(&#39;*&#39;,&#39;&#39;).Trim()
    Write-Build Green &#34;Selecting workspace: $workspace&#34;
    tf workspace select $workspace
    tfswitch 0.13.5
    tf 013.upgrade
    tfswitch
    tf init
    # Only use autoapprove once you are confident of these changes
    terraform state replace-provider -auto-approve -- registry.terraform.io/-/aws registry.terraform.io/hashicorp/aws
    terraform state replace-provider -auto-approve -- registry.terraform.io/-/random registry.terraform.io/hashicorp/random
    terraform state replace-provider -auto-approve -- registry.terraform.io/-/null registry.terraform.io/hashicorp/null
    terraform state replace-provider -auto-approve -- registry.terraform.io/-/azuredevops registry.terraform.io/microsoft/azuredevops
    tf validate
}
```

{{&lt; /admonition &gt;}}

