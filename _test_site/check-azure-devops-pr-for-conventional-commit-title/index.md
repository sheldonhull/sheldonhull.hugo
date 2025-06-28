# Check Azure Devops Pr for Conventional Commit Title


## Conventional Commit

- Is it needed... No.
- Is it the only way... No.
- Is consistency better than inconsistentcy, mostly yes.

I&#39;ve used conventional commit most of my career and it&#39;s a fine basic standard, even if sometimes it feels strange as you get used to it.
I think it&#39;s far better than inconsistency and is common enough with tooling you can do some nice release, changelog, and versioning with it.

However, getting folks used to it can be tricky.
I&#39;m a big believer in don&#39;t ask folks to remember a bunch of &#34;conventions&#34; and just codify with linters, pre-commit, and CI checks.
This eliminates policing and changing a standard just becomes a PR with proposed changes.

GitHub has a lot of actions that help check and prompt for fixes on this, but Azure DevOps doesn&#39;t.

I created an Azure Pipeline task with a little adhoc powershell that works well and helps prompt for more consistency in the creation of consistent titles.

## PowerShell code

```powershell

try { &amp;commitlint --version } catch { npm install commitlint -g }

Write-Host &#34;Validating PR Title matches what&#39;s acceptable in project (should have a .commitlintrc.yml in your project to use this)...&#34;

$result = $($ENV:PR_TITLE | commitlint)
if ($LASTEXITCODE -eq 1) {
  $result | Select-Object -Skip 1 |  ForEach-Object {
    if ($_ -match &#39;✖&#39;) {
      Write-Host &#34;##vso[task.logissue type=error]$_&#34;
    } else {
      Write-Host &#34;##[info]$_&#34;
    }
  }
  Write-Host &#34;##vso[task.logissue type=error]Topic should be in the form of &#39;type(scope): lower case title &lt; 120 characters&#39; (please note colon after scope has no spaces)&#34;

  exit 1
} else {
  Write-Host &#34;✅ PR Title looks good. Nice work! 👍&#34;
}
```

Plug this into a template in an dedicated azure pipelines template repository for easy reuse in many repos.

```yaml
---
jobs:
  - job: checkconventionalcommitprtitle
    displayName: check-conventional-commit-pr-title
    timeoutInMinutes: 5
    cancelTimeoutInMinutes: 2
    steps:
      - checkout: self
        fetchDepth: 1 # Shallow fetch to optimize performance if template repo gets larger
      - bash: |
          PR_TITLE=&#34;$(curl --silent -u azdo:$SYSTEM_ACCESSTOKEN \
          $(System.CollectionUri)_apis/git/repositories/$(Build.Repository.ID)/pullRequests/$(System.PullRequest.PullRequestId)?api-version=5.1 \
          | jq -r .title)&#34;
          echo &#34;##vso[task.setvariable variable=Pr.Title]$PR_TITLE&#34;
        env:
          SYSTEM_ACCESSTOKEN: $(System.AccessToken)
        displayName: get-pull-request-title
        condition: and(succeeded(), eq(variables[&#39;Build.Reason&#39;], &#39;PullRequest&#39;))
      - pwsh: |
          &lt;PUT THE POWERSHELL CODE HERE&gt;
        displayName: check-conventional-commit-pr-title
        failOnStderr: true
        ignoreLASTEXITCODE: true
```

To require this on a PR, you can setup a policy on merges to your trunk.
I normally manage this with terraform, so here&#39;s a hint to get you started.
Managing your Azure DevOps configuration, builds, and pipelines with Terraform or Pulumi is a far nicer way to keep things maintainable and scale up as more are added.

This sets up your base configuration.

```hcl
terraform {
  required_providers {
    azuredevops = {
      source  = &#34;microsoft/azuredevops&#34;
      version = &#34;0.2.1&#34;
    }
  }
}
data &#34;azuredevops_project&#34; &#34;projname&#34; {
  name = &#34;MyProjectName&#34;
}

data &#34;azuredevops_git_repository&#34; &#34;myrepo&#34; {
  project_id = data.azuredevops_project.projname.id
  name       = &#34;MyRepoName&#34;
}
```

Next, you&#39;ll want to register the pipeline as a valid pipeline to show up linked to the yaml.

```hcl
resource &#34;azuredevops_build_definition&#34; &#34;ci-projname-check-pr-title&#34; {
  project_id = data.azuredevops_project.projname.id
  name       = &#34;ci-projname-check-pr-title&#34;
  path       = &#34;\\pull-request-checks&#34;
  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = &#34;TfsGit&#34;
    repo_id     = data.azuredevops_git_repository.myrepo.id
    branch_name = data.azuredevops_git_repository.myrepo.default_branch
    yml_path    = &#34;pathto/azure-pipelines.checks.prtitle.yml&#34; # Match this to whatever you call your template
  }
}
```

Finally, you&#39;ll link your pipeline to a policy that requires the run of this to be successful to merge.

```hcl
resource &#34;azuredevops_branch_policy_build_validation&#34; &#34;projname-check-pr-title&#34; {
  project_id = data.azuredevops_project.projname.id

  enabled  = true
  blocking = true # This means to bypass you&#39;d have to have permissions and document the override.

  settings {
    display_name        = &#34;🧪 PR Title Adheres to Conventional commit&#34;
    build_definition_id = azuredevops_build_definition.ci-projname-check-pr-title.id

    # Set to however long before it has to be rerun. This is fine to be at a high duration as title shouldn&#39;t be changing constantly after it passes
    valid_duration      = 720
    filename_patterns = [
      &#34;*&#34;,
    ]
    scope {
      repository_id  = data.azuredevops_git_repository.myrepo.id
      repository_ref = data.azuredevops_git_repository.myrepo.default_branch
      match_type     = &#34;Exact&#34;
    }
  }
}
```

Definitely a bit more work than GitHub actions, but you can still get around some of this by using this approach for any PR merge validations you want.
There&#39;s also PR Status policies, but they are a bit more involved, and often involve running some Azure Functions or other things to post back a status.

In my opinion, that is worth investing in as you scale, but initially it&#39;s just too much plumbing so I just stick with fast small pipelines like this.

Good luck! 👍

