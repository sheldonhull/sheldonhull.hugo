# Setup Sourcegraph Locally


I went through the Sourcegraph directions, but had a few challenges due to the majority of code being behind SSH access with Azure DevOps.

Finally figured out how to do this, with multiple repos in one command and no need to embed a token using https.

Navigate to: [manage-repos](http://localhost:7080/site-admin/repositories) and use this.[^changes]
Better yet, use [Loading configuration via the file system (declarative config) - Sourcegraph docs](https://docs.sourcegraph.com/admin/config/advanced_config_file) and persist locally in case you want to upgrade or rebuild the container.

    {
      &#34;url&#34;: &#34;ssh://git@ssh.dev.azure.com&#34;,
      &#34;repos&#34;: [
        &#34;v3/{MYORG}/{PROJECT_NAME}/{REPO}&#34;,
        &#34;v3/{MYORG}/{PROJECT_NAME}/{REPO}&#34;
      ]

    }

For the json based storage try:

      {
          &#34;GITHUB&#34;: [],
          &#34;OTHER&#34;: [
              {
                  &#34;url&#34;: &#34;ssh://git@ssh.dev.azure.com&#34;,
                  &#34;repos&#34;: [
                    &#34;v3/{MYORG}/{PROJECT_NAME}/{REPO}&#34;,
                    &#34;v3/{MYORG}/{PROJECT_NAME}/{REPO}&#34;
                  ]
              }
          ],
          &#34;PHABRICATOR&#34;: []
      }

To ensure SSH tokens are mounted, you need to follow-up the directions here: [SSH Access for Sourcegraph](https://docs.sourcegraph.com/admin/install/docker/operations#ssh-authentication-config-keys-known-hosts)

    cp -R $HOME/.ssh $HOME/.sourcegraph/config/ssh
    docker run -d \
      -e DISABLE_OBSERVABILITY=true \
      -e EXTSVC_CONFIG_FILE=/etc/sourcegraph/extsvc.json \
      --publish 7080:7080 \
      --publish 127.0.0.1:3370:3370 \
      --volume $HOME/.sourcegraph/extsvc.json:/etc/sourcegraph/extsvc.json:delegated \
      --volume $HOME/.sourcegraph/config:/etc/sourcegraph:delegated \
      --volume $HOME/.sourcegraph/data:/var/opt/sourcegraph:delegated \
      sourcegraph/server:3.34.1

![cloned-repos](/images/2021-12-02-16.53.00-cloned-repos.png &#34;cloned repos&#34;)

## LSIF For Go

I didn&#39;t get this to work yet with my internal repos, but it&#39;s worth pinning as Go module documentation for API docs can be generated for review as well.
Change `darwin` to `linux` to use the linux version.

    go install github.com/sourcegraph/lsif-go/cmd/lsif-go@latest
    sudo curl -L https://sourcegraph.com/.api/src-cli/src_darwin_amd64 -o /usr/local/bin/sourcegraph
    sudo chmod &#43;x /usr/local/bin/sourcegraph

{{&lt; admonition type=&#34;Tip&#34; title=&#34;Docker&#34; open=true &gt;}}

    docker pull sourcegraph/lsif-go:v1.2.0

{{&lt; /admonition &gt;}}

Now index code in repo

    lsif-go
    sourcegraph_host=http://127.0.0.1:7080
    sourcegraph -endpoint=$sourcegraph_host lsif upload

[^changes]: I removed `--rm` from the tutorial.

