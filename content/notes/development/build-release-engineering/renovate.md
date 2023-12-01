---
title: renovate
description: Use renovate for dependency management
date: 2023-03-06 17:18
tags:
  - dependency-management
slug: renovate
---

## Run Locally Via Docker

### For Azure DevOps

{{< admonition type="note" title="Git Safe Directory" open=true >}}

This doesn't mount to the host `/tmp`, unlike examples in GitHub, because it flags the directory as owned by the docker user (likely root), which causes Git's safe directory feature to block.

Easier to just disable mounting to the host in this scenario, as `git config --global --add safe.directory /tmp/renovate/repos/*` didn't seem to work.

{{< /admonition >}}

Set the environment variables: `export AZURE_DEVOPS_ORG=foo`, and the other `AZURE_DEVOPS_EXT_PAT`, and finally replace `PROJECTNAME/REPO`.

```shell
docker run --rm -it \
    -e RENOVATE_PLATFORM="azure" \
    -e RENOVATE_ENDPOINT="https://dev.azure.com/${AZURE_DEVOPS_ORG}/" \
    -e GITHUB_COM_TOKEN=$(gh auth token) \
    -e SYSTEM_ACCESSTOKEN=$AZURE_DEVOPS_EXT_PAT \
    -e RENOVATE_TOKEN=$AZURE_DEVOPS_EXT_PAT \
    -e RENOVATE_DRY_RUN=full \
    -e LOG_LEVEL=debug \
    -v ${PWD}/config.js:/usr/src/app/config.js \
    -v /var/run/docker.sock:/var/run/docker.sock \
    renovate/renovate:latest --include-forks=false --dry-run=full PROJECTNAME/REPO

```

### Centralizing Config

Create a `config.js` in the `renovate-config` repo you create.
Based on the docs for renovate, this type of config can support nuget, npm, and github auth.

Change the various options by reviewing the renovate docs.
Each option such as creation of closed pull requests can be configured by flags or environment variables.

For Azure DevOps Pipelines, see the example below.
For GitHub, you'll benefit from using the Renovatebot GitHub app as a much smoother integration (it also checks by default every 3 hours).

=== "local debugging"

      ```shell
      # Change recreation if you are testing and need to abandon, then recreate
      docker run --rm \
          -it \
          -e RENOVATE_RECREATE_CLOSED=false \
          -e LOG_LEVEL=debug \
          -e RENOVATE_DRY_RUN=true \
          -e GITHUB_COM_TOKEN=$GITHUB_TOKEN \
          -e RENOVATE_TOKEN=$AZURE_DEVOPS_EXT_PAT \
          -v "${PWD}/config.js:/usr/src/app/config.js" \
          renovate/renovate --include-forks=false
      ```

=== "config.js"

      ```javascript
      const pipelineToken = process.env.RENOVATE_TOKEN;
      const patTokenForFeed = process.env.RENOVATE_TOKEN;

      module.exports = {
        platform: 'azure',
        endpoint: 'https://dev.azure.com/{myorg}/',
        token: pipelineToken,
        hostRules: [
          {
            hostType: 'npm',
            matchHost: 'pkgs.dev.azure.com',
            username: 'apikey',
            password: patTokenForFeed,
          },
          {
            hostType: 'npm',
            matchHost: '{myorg}.pkgs.visualstudio.com',
            username: 'apikey',
            password: patTokenForFeed,
          },
          {
            matchHost: 'https://pkgs.dev.azure.com/{myorg}/',
            hostType: 'nuget',
            username: 'renovate', // doesn't matter for azure
            password: patTokenForFeed,
          },
          {
            matchHost: 'github.com',
            token: process.env.GITHUB_COM_TOKEN,
          },
        ],
        repositories: [
          // 'Project/reponame',
          'Project/reponame',
        ],
      };
      ```
=== "renovate.azure-pipelines.yml"

      ```yaml
      ---
      name: renovate.$(Build.Reason)-$(Date:yyyyMMdd)-$(Rev:.r)
      pr: none
      trigger:
        batch: true
        branches:
          include:
            - main
      schedules:
        - cron: 0 07 * * Mon
          displayName: Mon7am
          branches:
            include: [main]
          always: true
      jobs:
        - job: renovate
          displayName: renovate-repos
          timeoutInMinutes: 15
          pool:
            name: Azure Pipelines
            vmImage: ubuntu-latest
          steps:
            - checkout: self
            - bash: |
                git config --global user.email 'bot@renovateapp.com'
                git config --global user.name 'Renovate Bot'
                npx --userconfig .npmrc renovate
              displayName: npx-renovate
              env:
                RENOVATE_TOKEN: $(System.AccessToken)
                GITHUB_COM_TOKEN: $(GITHUB_COM_TOKEN)

      ```
