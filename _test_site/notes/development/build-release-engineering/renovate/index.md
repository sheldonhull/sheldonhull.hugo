# renovate


## Run Locally Via Docker

### For Azure DevOps

{{&lt; admonition type=&#34;note&#34; title=&#34;Git Safe Directory&#34; open=true &gt;}}

This doesn&#39;t mount to the host `/tmp`, unlike examples in GitHub, because it asserts the directory as owned by the Docker user (likely root), leading to Git&#39;s safe directory feature blocking it.

For this scenario, it&#39;s easier to disable mounting to the host because `git config --global --add safe.directory /tmp/renovate/repos/*` didn&#39;t work as expected.

{{&lt; /admonition &gt;}}

Set the environment variables: `export AZURE_DEVOPS_ORG=foo`, `AZURE_DEVOPS_EXT_PAT`, and replace `PROJECTNAME/REPO` as required.

```shell
docker run --rm -it \
    -e RENOVATE_PLATFORM=&#34;azure&#34; \
    -e RENOVATE_ENDPOINT=&#34;https://dev.azure.com/${AZURE_DEVOPS_ORG}/&#34; \
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

{{&lt; admonition type=&#34;example&#34; title=&#34;local debugging&#34; open=true &gt;}}

```shell
# Change recreation if you are testing and need to abandon, then recreate
docker run --rm \
    -it \
    -e RENOVATE_RECREATE_CLOSED=false \
    -e LOG_LEVEL=debug \
    -e RENOVATE_DRY_RUN=true \
    -e GITHUB_COM_TOKEN=$GITHUB_TOKEN \
    -e RENOVATE_TOKEN=$AZURE_DEVOPS_EXT_PAT \
    -v &#34;${PWD}/config.js:/usr/src/app/config.js&#34; \
    renovate/renovate --include-forks=false
```

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;example&#34; title=&#34;config.js&#34; open=true &gt;}}

```javascript
const pipelineToken = process.env.RENOVATE_TOKEN;
const patTokenForFeed = process.env.RENOVATE_TOKEN;

module.exports = {
  platform: &#39;azure&#39;,
  endpoint: &#39;https://dev.azure.com/{myorg}/&#39;,
  token: pipelineToken,
  hostRules: [
    {
      hostType: &#39;npm&#39;,
      matchHost: &#39;pkgs.dev.azure.com&#39;,
      username: &#39;apikey&#39;,
      password: patTokenForFeed,
    },
    {
      hostType: &#39;npm&#39;,
      matchHost: &#39;{myorg}.pkgs.visualstudio.com&#39;,
      username: &#39;apikey&#39;,
      password: patTokenForFeed,
    },
    {
      matchHost: &#39;https://pkgs.dev.azure.com/{myorg}/&#39;,
      hostType: &#39;nuget&#39;,
      username: &#39;renovate&#39;, // username doesn&#39;t matter for azure
      password: patTokenForFeed,
    },
    {
      matchHost: &#39;github.com&#39;,
      token: process.env.GITHUB_COM_TOKEN,
    },
  ],
  repositories: [
    // specify format as &#39;Project/reponame&#39;
    &#39;Project/reponame&#39;,
  ],
};
```

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;example&#34; title=&#34;renovate.azure-pipelines.yml&#34; open=true &gt;}}

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
          git config --global user.email &#39;bot@renovateapp.com&#39;
          git config --global user.name &#39;Renovate Bot&#39;
          npx --userconfig .npmrc renovate
        displayName: npx-renovate
        env:
          RENOVATE_TOKEN: $(System.AccessToken)
          GITHUB_COM_TOKEN: $(GITHUB_COM_TOKEN)

```

{{&lt; /admonition &gt;}}

