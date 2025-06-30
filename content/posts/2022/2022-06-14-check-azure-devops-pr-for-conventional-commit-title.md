---

date: 2022-06-14T09:00:00+0000
title: Check Azure Devops Pr for Conventional Commit Title
slug: check-azure-devops-pr-for-conventional-commit-title
summary:
  Use azure pipeline builds to help run pull request merge checks, such as conventional commit for a PR title.
tags:
- tech
- development
- azure-devops
- powershell
- devops
- pre-commit
- ci

# images: [/images/]
---

## Conventional Commit

- Is it needed... No.
- Is it the only way... No.
- Is consistency better than inconsistentcy, mostly yes.

I've used conventional commit most of my career and it's a fine basic standard, even if sometimes it feels strange as you get used to it.
I think it's far better than inconsistency and is common enough with tooling you can do some nice release, changelog, and versioning with it.

However, getting folks used to it can be tricky.
I'm a big believer in don't ask folks to remember a bunch of "conventions" and just codify with linters, pre-commit, and CI checks.
This eliminates policing and changing a standard just becomes a PR with proposed changes.

GitHub has a lot of actions that help check and prompt for fixes on this, but Azure DevOps doesn't.

I created an Azure Pipeline task with a little adhoc powershell that works well and helps prompt for more consistency in the creation of consistent titles.

## PowerShell code

```powershell

try { &commitlint --version } catch { npm install commitlint -g }

Write-Host "Validating PR Title matches what's acceptable in project (should have a .commitlintrc.yml in your project to use this)..."

$result = $($ENV:PR_TITLE | commitlint)
if ($LASTEXITCODE -eq 1) {
  $result | Select-Object -Skip 1 |  ForEach-Object {
    if ($_ -match '✖') {
      Write-Host "##vso[task.logissue type=error]$_"
    } else {
      Write-Host "##[info]$_"
    }
  }
  Write-Host "##vso[task.logissue type=error]Topic should be in the form of 'type(scope): lower case title < 120 characters' (please note colon after scope has no spaces)"

  exit 1
} else {
  Write-Host "✅ PR Title looks good. Nice work! 👍"
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
          PR_TITLE="$(curl --silent -u azdo:$SYSTEM_ACCESSTOKEN \
          $(System.CollectionUri)_apis/git/repositories/$(Build.Repository.ID)/pullRequests/$(System.PullRequest.PullRequestId)?api-version=5.1 \
          | jq -r .title)"
          echo "##vso[task.setvariable variable=Pr.Title]$PR_TITLE"
        env:
          SYSTEM_ACCESSTOKEN: $(System.AccessToken)
        displayName: get-pull-request-title
        condition: and(succeeded(), eq(variables['Build.Reason'], 'PullRequest'))
      - pwsh: |
          <PUT THE POWERSHELL CODE HERE>
        displayName: check-conventional-commit-pr-title
        failOnStderr: true
        ignoreLASTEXITCODE: true
```

To require this on a PR, you can setup a policy on merges to your trunk.
I normally manage this with terraform, so here's a hint to get you started.
Managing your Azure DevOps configuration, builds, and pipelines with Terraform or Pulumi is a far nicer way to keep things maintainable and scale up as more are added.

This sets up your base configuration.

```hcl
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.2.1"
    }
  }
}
data "azuredevops_project" "projname" {
  name = "MyProjectName"
}

data "azuredevops_git_repository" "myrepo" {
  project_id = data.azuredevops_project.projname.id
  name       = "MyRepoName"
}
```

Next, you'll want to register the pipeline as a valid pipeline to show up linked to the yaml.

```hcl
resource "azuredevops_build_definition" "ci-projname-check-pr-title" {
  project_id = data.azuredevops_project.projname.id
  name       = "ci-projname-check-pr-title"
  path       = "\\pull-request-checks"
  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repository.myrepo.id
    branch_name = data.azuredevops_git_repository.myrepo.default_branch
    yml_path    = "pathto/azure-pipelines.checks.prtitle.yml" # Match this to whatever you call your template
  }
}
```

Finally, you'll link your pipeline to a policy that requires the run of this to be successful to merge.

```hcl
resource "azuredevops_branch_policy_build_validation" "projname-check-pr-title" {
  project_id = data.azuredevops_project.projname.id

  enabled  = true
  blocking = true # This means to bypass you'd have to have permissions and document the override.

  settings {
    display_name        = "🧪 PR Title Adheres to Conventional commit"
    build_definition_id = azuredevops_build_definition.ci-projname-check-pr-title.id

    # Set to however long before it has to be rerun. This is fine to be at a high duration as title shouldn't be changing constantly after it passes
    valid_duration      = 720
    filename_patterns = [
      "*",
    ]
    scope {
      repository_id  = data.azuredevops_git_repository.myrepo.id
      repository_ref = data.azuredevops_git_repository.myrepo.default_branch
      match_type     = "Exact"
    }
  }
}
```

Definitely a bit more work than GitHub actions, but you can still get around some of this by using this approach for any PR merge validations you want.
There's also PR Status policies, but they are a bit more involved, and often involve running some Azure Functions or other things to post back a status.

In my opinion, that is worth investing in as you scale, but initially it's just too much plumbing so I just stick with fast small pipelines like this.

Good luck! 👍
