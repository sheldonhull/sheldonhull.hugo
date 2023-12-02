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

This doesn't mount to the host `/tmp`, unlike examples in GitHub, because it asserts the directory as owned by the Docker user (likely root), leading to Git's safe directory feature blocking it.

For this scenario, it's easier to disable mounting to the host because `git config --global --add safe.directory /tmp/renovate/repos/*` didn't work as expected.

{{< /admonition >}}

Set the environment variables: `export AZURE_DEVOPS_ORG=foo`, `AZURE_DEVOPS_EXT_PAT`, and replace `PROJECTNAME/REPO` as required.

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

Create a `config.js` in the `renovate-config` repo you created.
According to the Renovate documentation, this type of config supports NuGet, npm, and GitHub authentication.

Change various options by reviewing the Renovate documentation.
Options like the creation of closed pull requests can be configured by flags or environment variables.

For Azure DevOps Pipelines, see the example below.
For GitHub, consider using the Renovatebot GitHub app for a smoother integration, which also checks the status by default every 3 hours.

{{< admonition type="example" title="local debugging" open=false >}}

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

{{< /admonition >}}
{{< admonition type="example" title="config.js" open=false >}}

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
      username: 'renovate', // username doesn't matter for azure
      password: patTokenForFeed,
    },
    {
      matchHost: 'github.com',
      token: process.env.GITHUB_COM_TOKEN,
    },
  ],
  repositories: [
    // specify format as 'Project/reponame'
    'Project/reponame',
  ],
};
```

{{< /admonition >}

{{< admonition type="example" title="renovate.azure-pipelines.yml" open=false >}}

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

{{< /admontion >}}
