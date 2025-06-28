# Azure Devops PR Automation Requires Generic Contribute


Big fan of renovate for terraform dependency management.

Ran into some complications with restarting an onboarding with Whitesource Renovate in Azure DevOps Repos and the Azure Pipeline automation.
I&#39;ve run into this before, so logging this for my sanity.

- If you failed to onboard with Azure DevOps, you can&#39;t rename the PR like in GitHub to simplify restarting the onboarding process.
- Instead, delete the `renovate.json` file and commit to your default branch.
- Then re-add and get the `renovate.json` committed back to your default branch.
- Run your Azure DevOps Pipeline to trigger the dependency assessment.
- If you didn&#39;t add the project build service account to your repo with `Contribute`, `Contribute to Pull Requests`, `Force Push` (to allow force update of branches it creates), and `Create Tag`.

{{&lt; admonition type=&#34;Tip&#34; title=&#34;Where do you add the permissions for build?&#34; open=&#34;true&#34;&gt;}}

Go to your repository security settings (in this case I&#39;m adding to all to simplify, but you can do on a repo by repo basis if you enjoy tedium):

`https://dev.azure.com/MYORG/MYPROJECT/_settings/repositories?_a=permissions`

Then in the search type your project name and you should see a `PROJECTNAME\Build Service (PROJECTNAME)` show up.

If you are using a custom service account with on-premise agents instead of hosted, then adjust your approach accordingly.

{{&lt; /admonition &gt;}}

