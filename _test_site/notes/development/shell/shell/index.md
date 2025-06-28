# shell


This is a mix of shell, linux, and macOS commands.
Comments are welcome with any corrections or suggestions.

## CLI Usage

### PowerShell &amp; Bash Comparison

#### Brevity

See all aliases with `Get-Alias` and to expedite your CLI usage you could use a gist like this: [Aliaser.ps1](https://gist.github.com/JustinGrote/3eeec61472da1aa9f86a8f746eac905f).

Note that PowerShell eschews brevity for clarity, but you can alias anything you like to be nearly as succinct as bash commands.

&gt; IMO readability/brevity trumps succinctness. However for interactive terminal usage, aliasing can be a great tool. Use VSCode to auto-expand aliases into fully qualified functions if you decide to turn your adhoc work into a script file.

Using `pushd` in a PowerShell session actually aliases to `Push-Location`.
This pushes the location into a stack for later retrieval.

#### PowerShell Works With Native Tooling

I&#39;ve included the similar PowerShell command to help those jumping between multiple shells.

Please note that unlike Python, PowerShell works as a terminal with native tools &#43; scripting language.

You can use `pwsh` in almost every case on Linux &amp; macOS and use the same tools you prefer, while being able to execute PowerShell commands as well.

For example, something like AWS CLI returning JSON could be automatically unmarshaled into an object instead of using `jq`

```powershell
&amp; (aws ec2 describe-instances | ConvertFrom-Json).Instances.InstanceId
```

Another example is paths.

Prerequiresites for the PowerShell examples:

```powershell
Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Force
```

| Command                            | shell                | pwsh                                                                                    |
| ---------------------------------- | -------------------- | --------------------------------------------------------------------------------------- |
| View history                       | `history`            | `Get-History`                                                                           |
| Execute Line from History          | `!Number`            | `Invoke-Expression (Get-History | Out-ConsoleGridView -OutputMode Single).CommandLine` |
| Execute Last Command With Sudo     | `sudo !!`            |                                                                                         |
| Check if a file exists             | `test -f ./filename` | `Test-Path $filename -PathType Leaf` or `[io.file]::exists($filename)`                 |

## Installation

### Common App Installs

| Application | Notes                            | Install Command                                                                                     |
| ----------- | -------------------------------- | --------------------------------------------------------------------------------------------------- |
| HomeBrew    | Works on Linux and macOS now 👏. | `/bin/bash -c &#34;$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)&#34;` |

### Ansible Initialization

```shell
#!/usr/bin/env bash
sh -c &#34;$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)&#34;
brew install python3 ansible
```

```shell
sudo python3 -m pip install --upgrade pip
CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments python3 -m pip install --user ansible
echo &#34;======== Ansible Version Info ======== &#34;
ansible-galaxy --version
```

### A Few More Ansible Commands

| Command                                     | Code                                                                                                                                 |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Run ansible playbook against a specific tag | `ansible-playbook main.yml --inventory inventory --ask-become-pass -t &#39;ui&#39;`                                                          |
| Install requirements                        | `ansible-galaxy collection install community.general &amp;&amp; ansible-galaxy install --role-file requirements.yml --force --ignore-errors` |

### Installing go-task

This tool is great for cross-platform shell scripting as it runs all the commands in the `Taskfile.yml` using a built in go shell library that supports bash syntax (and others).

Quickly get up and running using the directions here: [Install Task](https://github.com/go-task/task/blob/master/docs/installation.md)

| Command                                                            | Code                                                                           |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| Default Installation to local directory with debug logging enabled | `sh -c &#34;$(curl -ssL https://taskfile.dev/install.sh)&#34; -- -d`                   |
| Installation for user level access                                 | `sh -c &#34;$(curl -ssL https://taskfile.dev/install.sh)&#34; -- -d -b /usr/local/bin` |

### Installing Brew Packages

This eliminates any attempt to install if the package already exists.
For quick adhoc installs, this is useful.

```shell
#!/usr/bin/env bash

# Minimize Homebrew updates for each run, making things faster
export HOMEBREW_NO_AUTO_UPDATE=1

# if linux install script, might want to include this: export PATH=&#34;/home/linuxbrew/.linuxbrew/bin:$PATH&#34;

# Example of installing with a tap
brew tap lucagrulla/tap
package=cw
brew list $package &amp;&gt;/dev/null || brew install $package

# git-delta needs an updated version, so make sure it&#39;s available
package=less
brew list $package &amp;&gt;/dev/null || brew install $package

package=git-delta
brew list $package &amp;&gt;/dev/null || brew install $package
```

### Reduce Noise With Progress Bar

Use unzip with a progress bar to display progress, rather than the thousands of lines of output.
This is an example of installing the AWS CLI v2 in a Dockerfile, while not forcing the output of each line when unzipping.

This shows how to use the `pv` command line tool to help display progress in both a count fashion, and also by just using it as a timer.

```shell
RUN apt-get -yqq update --fix-missing &amp;&amp; apt-get -yqq install pv \
    &amp;&amp; mkdir -p ./tmpinstall &amp;&amp; curl --silent &#34;https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip&#34; -o &#34;./tmpinstall/awscliv2.zip&#34; \
    &amp;&amp; COUNT=`unzip -q -l &#34;./tmpinstall/awscliv2.zip&#34; | wc -l` \
    &amp;&amp; mkdir -p ./tmpinstall/aws \
    &amp;&amp; unzip &#34;./tmpinstall/awscliv2.zip&#34; -d &#34;./tmpinstall/&#34;  | pv -l -s $COUNT &gt;/dev/null \
    &amp;&amp; ./tmpinstall/aws/install --update | (pv --timer --name &#34;🤖 awscli&#34;)  \
    &amp;&amp; rm -rf ./tmpinstall/ \
    &amp;&amp; apt-get clean -y &amp;&amp; rm -rf /var/lib/apt/lists/* /tmp/library-scripts
```

### Check for And Install Tooling

This can help provide an example of how to double-check that some installed tools are available as part of a setup script.

```shell
if command -v ghq &amp;&gt;/dev/null; then
    echo &#39;✔️ ghq installed&#39;
else
    warning &#34;❌ failed to find ghq, attempting to setup via source&#34;
    go install github.com/x-motemen/ghq@latest || echo &#34;✅ installed ghq&#34;
fi
if command -v gum &amp;&gt;/dev/null; then
    echo &#39;✔️ gum installed&#39;
else
    warning &#34;❌ failed to find gum, attempting to setup via source&#34;
    go install github.com/charmbracelet/gum@latest || echo &#34;✅ installed gum&#34;
fi
if ! command -v gum &amp;/dev/null; then
  echo &#39;might need go binaries on path, trying now..., try adding the line to your .zshrc&#39;
  export PATH=&#34;$(go env GOPATH)/bin:${PATH}&#34;
fi
```

## Conditional

Only Proceed If First Condition Returns Nothing

```shell
package=cw
brew list $package &amp;&gt;/dev/null || brew install $package
```

On error do this:

```shell
test -f nonexistentfile || echo &#34;😢 boo. file does not exist&#34;
```

On success do the next command:

```shell
test -f ~/.bashrc &amp;&amp; echo &#34;✅ congrats, you have a bashrc file&#34;
```

## Web Requests

### Fetch A GitHub Release

This fetches the latest release from GitHub, parses the json, then moves it to the target path.
This release doesn&#39;t wrap in a tar file; it&#39;s just a binary.

This might fail due to anonymous API hits on GitHub API being rate-limited aggressively.

```shell
#!/usr/bin/env bash

echo &#34;Grabbing latest release of fetch (a GitHub CLI for release downloads)&#34;
USER=gruntwork-io
REPO=fetch
TAG=latest
ASSET=fetch_linux_amd64
FILE=fetch
curl --silent &#34;https://api.github.com/repos/$USER/$REPO/releases/latest&#34; \
| jq -r &#34;.assets[] | select(.name | test(\&#34;${ASSET}\&#34;)) | .browser_download_url&#34; \
| wget -qi - --output-document=$FILE --progress=bar:force

echo &#34;Setting as executable and moving to /usr/local/bin&#34;
chmod &#43;x $FILE
sudo mv fetch /usr/local/bin
echo &#34;Downloaded $(fetch --version) successfully&#34;
```

### Fetch a GitHub Release That Requires Extraction

This is more of a Linux focused shell script example for grabbing a release and extracting the tar file.

```shell
#!/usr/bin/env bash
sudo apt -qqy update
sudo apt -qqy -o Dpkg::Progress-Fancy=true install wget

curl -s https://api.github.com/repos/GitTools/GitVersion/releases/latest \
| grep &#34;browser_download_url.*gitversion\-debian.*\-x64.*\.tar\.gz&#34; \
| cut -d &#34;:&#34; -f 2,3 \
| tr -d \&#34; \
| wget -qi -

tarball=&#34;$(find . -name &#34;gitversion-debian*.tar.gz&#34;)&#34;
tar -xzf $tarball

sudo chmod &#43;x gitversion
sudo mv gitversion /usr/local/bin

sudo rm $tarball
echo &#34;&gt;&gt;&gt;&gt; gitversion version: $(~/gitversion /version)&#34;
echo &#34;Trying to install dotnet tools version&#34;
dotnet tool update --global GitVersion.Tool
```

## Concepts

### Shebang

A common pattern is just `#!/bin/bash`.

To make your script more portable, by respecting the users&#39; env preferences try:

- `#!/usr/bin/env bash`
- `#!/usr/bin/env zsh`
- `#!/usr/bin/env sh`

Some good info on this from [Shebang](https://bash.cyberciti.biz/guide/Shebang#.2Fusr.2Fbin.2Fenv_bash)

- If you do not specify an interpreter line, the default is usually the `/bin/sh`
- For a system boot script, use `/bin/sh`
- The `/usr/bin/env` run a program such as a bash in a modified environment. It makes your bash script portable. The advantage of #!/usr/bin/env bash is that it will use whatever bash executable appears first in the running user&#39;s `$PATH` variable.

## SSH

Setup your permissions for `~/.ssh`

```shell
echo &#34;Setting full user permissions for ~/.ssh&#34;
chmod -R u&#43;rwX ~/.ssh
echo &#34;Remove group access for ~/.ssh&#34;
chmod go-rwx ~/.ssh
echo &#34;now set any pem files to chmd 400 \$key to ensure read-only&#34;
chmod 0600 ~/.ssh/id_rsa
```

For why 0600 see footnote.[^why-0600]

{{&lt; admonition type=&#34;tip&#34; title=&#34;Troubleshooting macOS permissions&#34; open=true &gt;}}

I&#39;ve had issues with macOS adding an `@` with ACL issues on the ssh key&#39;s when downloaded.

To resolve this, just copy the contents of the ssh key to a new file and remove the original.

```shell
cat original_key.pem &gt; key.pem
```

[How To List Users In Linux](https://linuxize.com/post/how-to-list-users-in-linux/)

{{&lt; /admonition &gt;}}

[^why-0600]: [Why are ssh keys 600 and not 400 by default? authorized_keys immutable? : linux4noobs](https://www.reddit.com/r/linux4noobs/comments/bjpbnl/why_are_ssh_keys_600_and_not_400_by_default/)

## Search Contents of a File

Using `ripgrep` you can search very quickly through file contents.

In this example, I&#39;m searching for a text string in a PowerShell file that VSCode wasn&#39;t able to find after 1-2 mins due to the size of the directory.

```shell
rg -l -c &#34;Start-ThreadJob&#34; *.ps1
```

{{&lt; admonition type=&#34;note&#34; title=&#34;Benchmark&#34; open=true &gt;}}

I ran a quick test to see how ripgrep performed compared to normal grep search.
Grep wasn&#39;t optimized, and by default is single threaded.
Ripgrep is multithreaded, automatically honors gitignore and more.

```shell
grep -rnw $HOME -e &#39;Start-ThreadJob&#39;
```

| Tool      | Time     |
| --------- | ----     |
| `ripgrep` | 5m6s     |
| `grep`    | 1h&#43;      |
{{&lt; /admonition &gt;}}

## Using yq to edit yaml files for Datadog service

&gt; [GitHub - mikefarah/yq: yq is a portable command-line YAML processor](https://github.com/mikefarah/yq)

I&#39;ve used yq to edit yaml files programmatically, such as datadog configuration files.

Here&#39;s a few samples on how to use this tool, using datadog agent config files as an example.

### Quick Install of Datadog Service

```shell
DD_HOST_TAGS=&#34;type:custom-server,stage:dev&#34;
DD_HOSTNAME=&#34;custom-server&#34;

DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=FancyAPIKey DD_SITE=&#34;datadoghq.com&#34; bash -c &#34;$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)&#34;
sudo chmod -R 777 /etc/datadog-agent/
```

### Start and stop the datadog services

```shell
sudo systemctl stop datadog-agent
sudo systemctl start datadog-agent
```

### Edit Default Datadog Config File

Next, configure the main configuration with custom tags and host name, including additional EC2 tags, metadata, and a custom tag to show the specific load test this is capturing.

```shell
config=/etc/datadog-agent/datadog.yaml
nametag=mycustom-server
testname=bigloadtest

echo &#34;set the basic config for app&#34;
yq eval &#34;
.hostname = \&#34;$nametag\&#34; |
.process_config.enabled = true |
.tags = [\&#34;scope:loadtest\&#34;,\&#34;testname:$testname\&#34;] |
.env = \&#34;dev\&#34; |
.cloud_provider_metadata = [\&#34;aws\&#34;] |
.collect_ec2_tags = true&#34; --inplace $config
yq eval &#34;.hostname, .process_config.enabled, .tags, .env, .cloud_provider_metadata ,.collect_ec2_tags&#34; $config
```

### Enable Datadog Network Monitoring

```shell
echo &#34;set the process level config to search for ssh/sshd metrics&#34;
sudo cp /etc/datadog-agent/system-probe.yaml.example /etc/datadog-agent/system-probe.yaml
netconfig=/etc/datadog-agent/system-probe.yaml
yq eval &#39;.network_config.enabled&#39; $netconfig
yq eval --inplace  &#39;
.network_config.enabled = true
&#39; $netconfig
yq eval &#39;.network_config.enabled&#39; $netconfig
```

### Enable Datadog Process Level Tracking

Enable process level tracking, with a specific match on `ssh, sshd`.

```shell
echo &#34;set the process level config to search for ssh/sshd metrics&#34;
sudo cp /etc/datadog-agent/conf.d/process.d/conf.yaml.example  /etc/datadog-agent/conf.d/process.d/conf.yaml
processconfig=/etc/datadog-agent/conf.d/process.d/conf.yaml
yq eval &#39;.instances&#39; $processconfig
yq eval --inplace  &#39;
.instances[0].name = &#34;ssh&#34; |
.instances[0].search_string = [&#34;ssh&#34;,&#34;sshd&#34;]
&#39; $processconfig
yq eval --inplace  &#39;
.instances[1].name = &#34;myprocess&#34; |
.instances[1].search_string = [&#34;myprocess&#34;]
&#39; $processconfig
yq eval &#39;.instances&#39; $processconfig
```

You can do a lot with `yq`.

## Parse Kubernetes Secrets Using JQ

Using jq, you can parse out secrets from base64 encoded values for some quick scripting.

&gt; NOTE: This uses [sttr](https://github.com/abhimanyu003/sttr) but you can modify to whatever your platform provides (zsh `base64 -decode` or pwsh `[System.Convert]::FromBase64String($Base64String)`))
&gt; If you have Go installed then run `go install github.com/abhimanyu003/sttr@latest`.

This example parses an encoded JSON string to help registry an Azure Container Registry from a Kubernetes stored secret.

```shell
namespace=&#34;mynamespace&#34;
secretname=&#34;mysecretname&#34;
kubectl config set-context --current --namespace=$namespace

configEncoded=$(kubectl get secret $secretname -o jsonpath=&#39;{.data.\.dockerconfigjson}&#39;)
configDecoded=$(sttr base64-decode $configEncoded)
registry=$(echo $configDecoded | jq -r &#39;.auths | keys[0]&#39;)
creds=$(echo $configDecoded | jq -r .auths[$registry].auth)

echo -e &#34;👉 registry: $registry&#34;
echo -e &#34;👉 username:password: $( sttr base64-decode $creds )&#34;
```

## GitHub CLI

## View The Logs Of A Prior Run

View the logs of the last run (or toggle to error logs with the switch).

- `gh run view --log $(gh run list -L1 --json &#39;databaseId&#39; --jq &#39;.[].DatabaseId&#39;)`
- `gh run view $(gh run list --limit 1 --json databaseId --jq &#39;.[0].DatabaseId&#39; ) --log`

This can be chained together with other commands to quickly iterate on testing.
When appropriate, you might avoid this by running [act](https://github.com/nektos/act) but I&#39;ve had limited success with it due to various restrictions.

```shell
git commit -am &#39;ci: get GitHub release working&#39; &amp;&amp; \
  git push &amp;&amp; \
  gh workflow run release &amp;&amp; \
  sleep 5 &amp;&amp; \
  gh run watch -i1 || gh run view --log --job $(gh run list -L1 --json &#39;workflowDatabaseId&#39; --jq &#39;.[].workflowDatabaseId&#39;)
```

### Use To Configure Settings on Many Repos At Once

This example uses [gum][^gum-tool] to filter.
Use `tab` when selecting in the multi-entry option.

```shell
org=$(gum input --prompt &#39;enter GitHub org: &#39;)
originallist=$( gh repo list $org --json &#39;name&#39; --jq &#39;.[].name&#39; |  tr &#39; &#39; &#39;\n&#39; )
repos=&#34;$( echo $originallist | gum filter --no-limit )&#34;

for repo in $( echo $repos | tr &#39;\n&#39; &#39; &#39;) ;
do
    printf &#34;processing %s ... &#34; &#34;${repo}&#34;
    gh api \
        --method PATCH \
        -H &#34;Accept: application/vnd.github&#43;json&#34; \
        /repos/$org/$repo \
        -F use_squash_pr_title_as_default=true \
        -F squash_merge_commit_title=PR_TITLE \
        -F squash_merge_commit_message=PR_BODY \
        --silent
        printf &#34;✔️\n&#34;
    # return # for testing
done
```

## Clone All The Desired

Uses gum[^gum-repo] &amp; [ghq][^ghq-repo].
See [setup directions](#check-for-and-install-tooling).

### Configure ghq

To configure `ghq` defaults run:

```shell
git config --global ghq.vcs git
git config --global ghq.root $(gum input -prompt &#39;base git directory for repos: (recommend ~/git):  &#39; )
```

### Clone All Repos Selected

```shell
org=$(gum input --prompt &#39;enter GitHub org: &#39;)
originallist=$( gh repo list $org --json &#39;name&#39; --jq &#39;.[].name&#39; |  tr &#39; &#39; &#39;\n&#39; )
echo &#39;select repos (use tab to select, and type to filter)&#39;
repos=&#34;$( echo $originallist | gum filter --no-limit )&#34;

for repo in $( echo $repos | tr &#39;\n&#39; &#39; &#39;) ;
do
    printf &#34;processing %s ... &#34; &#34;${repo}&#34;
    ghq get &#34;https://github.com/${org}/${repo}&#34; &amp;&gt; /dev/null
    printf &#34;✔️\n&#34;
done
```

[^gum-tool]: [GitHub - charmbracelet/gum: A tool for glamorous shell scripts 🎀](https://github.com/charmbracelet/gum)
[^ghq-repo]: [ghq - repo cloning tool](https://github.com/x-motemen/ghq)

