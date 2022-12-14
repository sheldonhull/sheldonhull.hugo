---

date: 2021-06-11T16:35:44-05:00
title: Using Azure DevOps for Private Go Modules
slug: using-azure-devops-for-private-go-modules
summary: How to use Azure DevOps for private Go modules
tags: [azure-devops, golang, devops]
toc: true
typora-root-url: ../../../static
typora-copy-images-to: ../../../static/images
modified: 2021-06-18T22:24:51-05:00
---

{{< admonition type="Note" title="2022-12-14" open=true >}}

Provided an example of how to handle private go modules in Azure Pipeline compatible method.

{{< /admonition >}}

## TL;DR

This took a few hours of work to iron out, so figured maybe I'd save someone time.

:zap: Just keep it simple and use SSH

:zap: Use `dev.azure.com` even if using older `project.visualstudio.com` to keep things simple.

## Modules Support

Unlike GitHub, Azure DevOps has some quirks to deal with, specifically in the odd path handling.

My original goal was to set the default handling to be `https` support, with the SSH override in git config allowing me to use SSH.

This didn't work.

- HTTPS requires `_git`  in the path.
- SSH will not work with that, and also trims out the org name in the url when git config set based on instructions from Microsoft[^azdos-docs].

> There is a long-running issue with go get imports of Azure DevOps repositories due to the fact that the HTTPS URL contains a `_git` segment:
[^private-go-mod-support]

Compare the path.

| Type                   | Path                                                        |
| ---------------------- | ----------------------------------------------------------- |
| HTTPS                    | `go get dev.azure.com/<organization>/<project>/_git/<repo>` |
| :zap: What I used with SSH | `go get dev.azure.com/<project>/_git/<repo>`                |
| SSH                  | `go get dev.azure.com/<organization>/<project>/<repo>.git`  |

## Git Config

Set this in your `.profile, .bashrc, or $PROFILE`

```shell
export GOPRIVATE=dev.azure.com
```

There are two approaches you can take.

One seems focused on allowing other `dev.azure.com` public projects to be used.
I've never had that need, so I'm ok with my `dev.azure.com` references being resolved only to my own organization.

| Type                              | Command                                                                                                               | GitConfig                                                                                      |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Support All Azure DevOps (Public) | `git config --global url."git@ssh.dev.azure.com:v3/<organization>/".insteadOf "https://dev.azure.com/<organization>"` | `[url "git@ssh.dev.azure.com:v3"]<br/>`<br><br>`insteadOf = https://dev.azure.com`            |
| :zap: What I Used for  Private Org    | `git config --global url."git@ssh.dev.azure.com:v3/<organization>/".insteadOf "https://dev.azure.com/`                | `[url "git@ssh.dev.azure.com:v3/<organization>/"]`<br><br>`insteadOf = https://dev.azure.com/` |

{{< admonition type="Info" title="Organization in Dependency Path" open="true">}}

This changes the path for dependencies to not require the organization in the dependency path.
Instead, the import path will look like this: `import "dev.azure.com/<project>/repo.git/subdirectory"`

{{< /admonition >}}

## HTTPS

If you don't have restrictions on this, then you can do https with the following command to add the token in or use a more complex credential manager based process.

```shell
git config --global url."https://anythinggoeshere:$AZURE_DEVOPS_TOKEN@dev.azure.com".insteadOf "https://dev.azure.com"
```

## Azure Pipelines

If you run into timeout issues with `go get`, I found this solution worked well.

I provided `ORGANIZATION` as a value if you are on the legacy url scheme, it's easier to just set this as variable and not worry about parsing out the org name itself from the url to place it in there.
I got stuck on this recently and was pointed to the answer in this great article [Using Go Modules With Private Azure Devops Repositories](https://seb-nyberg.medium.com/using-go-modules-with-private-azure-devops-repositories-4664b621f782).

```yaml
parameters:
  - name: workingDirectory
    type: string
    default: $(Pipeline.Workspace)

variables:
    - name: ORGANIZATION
      value: myorg
steps:
- checkout: self
  fetchDepth: 0
  path: $(Build.Repository.Name) # Note: you'll want to provide workingdirectory inputs for tasks if you have multi-repo checkout going on.
- pwsh: |
    git clone "https://$(ORGANIZATION):$(System.AccessToken)@dev.azure.com/$(ORGANIZATION)/$(System.TeamProject)/_git/$(Build.Repository.Name)"
  displayName: git-checkout-with-pat
# internal modules with go-get might fail without this.
- pwsh: |
    git config --global url."https://$(ORGANIZATION):$(System.AccessToken)@dev.azure.com".insteadOf "https://dev.azure.com"
  displayName: ensure-system-token-used-for-other-internal-repos
- pwsh: |
    Write-Host "example, with working directory set"
  displayName: exampleTask
  workingDirectory: ${{ parameters.workingDirectory }}/$(Build.Repository.Name)
```

## Other References

- SSH key usage in Azure Pipelines[^ssh-task].
- Using with docker[^private-go-mod-support]

[^azdos-docs]: [Go get command support in Azure Repos Git](https://docs.microsoft.com/en-us/azure/devops/repos/git/go-get)
[^private-go-mod-support]: [Private Go Modules on Azure DevOps](https://seb-nyberg.medium.com/using-go-modules-with-private-azure-devops-repositories-4664b621f782)
[^ssh-task]: [Install SSH Key task - Azure Pipelines | Microsoft Docs](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key)
