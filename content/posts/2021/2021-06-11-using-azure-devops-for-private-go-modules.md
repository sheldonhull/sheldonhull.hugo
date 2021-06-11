---
date: 2021-06-11T16:35:44-05:00
title: Using Azure DevOps for Private Go Modules
slug: using-azure-devops-for-private-go-modules
summary:
  Foo
tags:
- development
- azure-devops
- go
- devops
draft: true
toc: true
# images: [/images/]
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

## TL;DR

This took a few hours of work to iron out, so figured maybe I'd save someone time.

⚡ Just keep it simple and use SSH

⚡ Use `dev.azure.com` even if using older `project.visualstudio.com` to keep things simple.

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
| SSH                    | `go get dev.azure.com/<organization>/<project>/_git/<repo>` |
| ⚡ What I used with SSH | `go get dev.azure.com/<project>/_git/<repo>`                |
| HTTPS                  | `go get dev.azure.com/<organization>/<project>/<repo>.git`  |

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
| Support All Azure DevOps (Public) | `git config --global url."git@ssh.dev.azure.com:v3/<organization>/".insteadOf "https://dev.azure.com/<organization>"` | `[url "git@ssh.dev.azure.com:v3"]<br/>	`<br><br>`insteadOf = https://dev.azure.com`            |
| ⚡ What I Used for  Private Org    | `git config --global url."git@ssh.dev.azure.com:v3/<organization>/".insteadOf "https://dev.azure.com/`                | `[url "git@ssh.dev.azure.com:v3/<organization>/"]`<br><br>`insteadOf = https://dev.azure.com/` |

{{< admonition type="Info" title="Organization in Dependency Path" open="true">}}

This changes the path for dependencies to not require the organization in the dependency path.
Instead, the import path will look like this: `import "dev.azure.com/<project>/repo.git/subdirectory"`

{{< /admonition >}}

## HTTPS

If you don't have restrictions on this, then you can do https with the following command to add the token in or use a more complex credential manager based process.

```shell
git config --global url."https://anythinggoeshere:$AZURE_DEVOPS_TOKEN@dev.azure.com".insteadOf "https://dev.azure.com"
```

## Other References

- SSH key usage in Azure Pipelines[^ssh-task].
- Using with docker[^private-go-mod-support]

[^azdos-docs]: [Go get command support in Azure Repos Git](https://docs.microsoft.com/en-us/azure/devops/repos/git/go-get)
[^private-go-mod-support]: [Private Go Modules on Azure DevOps](https://seb-nyberg.medium.com/using-go-modules-with-private-azure-devops-repositories-4664b621f782)
[^ssh-task]: [Install SSH Key task - Azure Pipelines | Microsoft Docs](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key)
