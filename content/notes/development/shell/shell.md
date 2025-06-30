---
title: shell
date: 2020-10-30
toc: true
summary:
  A cheatsheet for some bash stuff. I really ♥️ pwsh... but acknowledge it's not everyone's cup of tea.
  This page helps me get by with being a terrible basher
slug: shell
permalink: /notes/shell
comments: true
tags:
  - development
  - shell
---

This is a mix of shell, linux, and macOS commands.
Comments are welcome with any corrections or suggestions.

## CLI Usage

### PowerShell & Bash Comparison

#### Brevity

See all aliases with `Get-Alias` and to expedite your CLI usage you could use a gist like this: [Aliaser.ps1](https://gist.github.com/JustinGrote/3eeec61472da1aa9f86a8f746eac905f).

Note that PowerShell eschews brevity for clarity, but you can alias anything you like to be nearly as succinct as bash commands.

> IMO readability/brevity trumps succinctness. However for interactive terminal usage, aliasing can be a great tool. Use VSCode to auto-expand aliases into fully qualified functions if you decide to turn your adhoc work into a script file.

Using `pushd` in a PowerShell session actually aliases to `Push-Location`.
This pushes the location into a stack for later retrieval.

#### PowerShell Works With Native Tooling

I've included the similar PowerShell command to help those jumping between multiple shells.

Please note that unlike Python, PowerShell works as a terminal with native tools + scripting language.

You can use `pwsh` in almost every case on Linux & macOS and use the same tools you prefer, while being able to execute PowerShell commands as well.

For example, something like AWS CLI returning JSON could be automatically unmarshaled into an object instead of using `jq`

```powershell
& (aws ec2 describe-instances | ConvertFrom-Json).Instances.InstanceId
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
| HomeBrew    | Works on Linux and macOS now 👏. | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"` |

### Ansible Initialization

```shell
#!/usr/bin/env bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install python3 ansible
```

```shell
sudo python3 -m pip install --upgrade pip
CFLAGS=-Qunused-arguments CPPFLAGS=-Qunused-arguments python3 -m pip install --user ansible
echo "======== Ansible Version Info ======== "
ansible-galaxy --version
```

### A Few More Ansible Commands

| Command                                     | Code                                                                                                                                 |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Run ansible playbook against a specific tag | `ansible-playbook main.yml --inventory inventory --ask-become-pass -t 'ui'`                                                          |
| Install requirements                        | `ansible-galaxy collection install community.general && ansible-galaxy install --role-file requirements.yml --force --ignore-errors` |

### Installing go-task

This tool is great for cross-platform shell scripting as it runs all the commands in the `Taskfile.yml` using a built in go shell library that supports bash syntax (and others).

Quickly get up and running using the directions here: [Install Task](https://github.com/go-task/task/blob/master/docs/installation.md)

| Command                                                            | Code                                                                           |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| Default Installation to local directory with debug logging enabled | `sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d`                   |
| Installation for user level access                                 | `sh -c "$(curl -ssL https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin` |

### Installing Brew Packages

This eliminates any attempt to install if the package already exists.
For quick adhoc installs, this is useful.

```shell
#!/usr/bin/env bash

# Minimize Homebrew updates for each run, making things faster
export HOMEBREW_NO_AUTO_UPDATE=1

# if linux install script, might want to include this: export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Example of installing with a tap
brew tap lucagrulla/tap
package=cw
brew list $package &>/dev/null || brew install $package

# git-delta needs an updated version, so make sure it's available
package=less
brew list $package &>/dev/null || brew install $package

package=git-delta
brew list $package &>/dev/null || brew install $package
```

### Reduce Noise With Progress Bar

Use unzip with a progress bar to display progress, rather than the thousands of lines of output.
This is an example of installing the AWS CLI v2 in a Dockerfile, while not forcing the output of each line when unzipping.

This shows how to use the `pv` command line tool to help display progress in both a count fashion, and also by just using it as a timer.

```shell
RUN apt-get -yqq update --fix-missing && apt-get -yqq install pv \
    && mkdir -p ./tmpinstall && curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "./tmpinstall/awscliv2.zip" \
    && COUNT=`unzip -q -l "./tmpinstall/awscliv2.zip" | wc -l` \
    && mkdir -p ./tmpinstall/aws \
    && unzip "./tmpinstall/awscliv2.zip" -d "./tmpinstall/"  | pv -l -s $COUNT >/dev/null \
    && ./tmpinstall/aws/install --update | (pv --timer --name "🤖 awscli")  \
    && rm -rf ./tmpinstall/ \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
```

### Check for And Install Tooling

This can help provide an example of how to double-check that some installed tools are available as part of a setup script.

```shell
if command -v ghq &>/dev/null; then
    echo '✔️ ghq installed'
else
    warning "❌ failed to find ghq, attempting to setup via source"
    go install github.com/x-motemen/ghq@latest || echo "✅ installed ghq"
fi
if command -v gum &>/dev/null; then
    echo '✔️ gum installed'
else
    warning "❌ failed to find gum, attempting to setup via source"
    go install github.com/charmbracelet/gum@latest || echo "✅ installed gum"
fi
if ! command -v gum &/dev/null; then
  echo 'might need go binaries on path, trying now..., try adding the line to your .zshrc'
  export PATH="$(go env GOPATH)/bin:${PATH}"
fi
```

## Conditional

Only Proceed If First Condition Returns Nothing

```shell
package=cw
brew list $package &>/dev/null || brew install $package
```

On error do this:

```shell
test -f nonexistentfile || echo "😢 boo. file does not exist"
```

On success do the next command:

```shell
test -f ~/.bashrc && echo "✅ congrats, you have a bashrc file"
```

## Web Requests

### Fetch A GitHub Release

This fetches the latest release from GitHub, parses the json, then moves it to the target path.
This release doesn't wrap in a tar file; it's just a binary.

This might fail due to anonymous API hits on GitHub API being rate-limited aggressively.

```shell
#!/usr/bin/env bash

echo "Grabbing latest release of fetch (a GitHub CLI for release downloads)"
USER=gruntwork-io
REPO=fetch
TAG=latest
ASSET=fetch_linux_amd64
FILE=fetch
curl --silent "https://api.github.com/repos/$USER/$REPO/releases/latest" \
| jq -r ".assets[] | select(.name | test(\"${ASSET}\")) | .browser_download_url" \
| wget -qi - --output-document=$FILE --progress=bar:force

echo "Setting as executable and moving to /usr/local/bin"
chmod +x $FILE
sudo mv fetch /usr/local/bin
echo "Downloaded $(fetch --version) successfully"
```

### Fetch a GitHub Release That Requires Extraction

This is more of a Linux focused shell script example for grabbing a release and extracting the tar file.

```shell
#!/usr/bin/env bash
sudo apt -qqy update
sudo apt -qqy -o Dpkg::Progress-Fancy=true install wget

curl -s https://api.github.com/repos/GitTools/GitVersion/releases/latest \
| grep "browser_download_url.*gitversion\-debian.*\-x64.*\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \" \
| wget -qi -

tarball="$(find . -name "gitversion-debian*.tar.gz")"
tar -xzf $tarball

sudo chmod +x gitversion
sudo mv gitversion /usr/local/bin

sudo rm $tarball
echo ">>>> gitversion version: $(~/gitversion /version)"
echo "Trying to install dotnet tools version"
dotnet tool update --global GitVersion.Tool
```

## Concepts

### Shebang

A common pattern is just `#!/bin/bash`.

To make your script more portable, by respecting the users' env preferences try:

- `#!/usr/bin/env bash`
- `#!/usr/bin/env zsh`
- `#!/usr/bin/env sh`

Some good info on this from [Shebang](https://bash.cyberciti.biz/guide/Shebang#.2Fusr.2Fbin.2Fenv_bash)

- If you do not specify an interpreter line, the default is usually the `/bin/sh`
- For a system boot script, use `/bin/sh`
- The `/usr/bin/env` run a program such as a bash in a modified environment. It makes your bash script portable. The advantage of #!/usr/bin/env bash is that it will use whatever bash executable appears first in the running user's `$PATH` variable.


## SSH

Setup your permissions for `~/.ssh`

```shell
echo "Setting full user permissions for ~/.ssh"
chmod -R u+rwX ~/.ssh
echo "Remove group access for ~/.ssh"
chmod go-rwx ~/.ssh
echo "now set any pem files to chmd 400 \$key to ensure read-only"
chmod 0600 ~/.ssh/id_rsa
```

For why 0600 see footnote.[^why-0600]


> [!tip] Troubleshooting macOS permissions
>
> I've had issues with macOS adding an `@` with ACL issues on the ssh key's when downloaded.
>
> To resolve this, just copy the contents of the ssh key to a new file and remove the original.
>
> ```shell
> cat original_key.pem > key.pem
> ```
>
> [How To List Users In Linux](https://linuxize.com/post/how-to-list-users-in-linux/)


[^why-0600]: [Why are ssh keys 600 and not 400 by default? authorized_keys immutable? : linux4noobs](https://www.reddit.com/r/linux4noobs/comments/bjpbnl/why_are_ssh_keys_600_and_not_400_by_default/)

## Search Contents of a File

Using `ripgrep` you can search very quickly through file contents.

In this example, I'm searching for a text string in a PowerShell file that VSCode wasn't able to find after 1-2 mins due to the size of the directory.

```shell
rg -l -c "Start-ThreadJob" *.ps1
```


> [!note] Benchmark
>
> I ran a quick test to see how ripgrep performed compared to normal grep search.
> Grep wasn't optimized, and by default is single threaded.
> Ripgrep is multithreaded, automatically honors gitignore and more.
>
> ```shell
> grep -rnw $HOME -e 'Start-ThreadJob'
> ```
>
> | Tool      | Time     |
> | --------- | ----     |
> | `ripgrep` | 5m6s     |
> | `grep`    | 1h+      |


## Using yq to edit yaml files for Datadog service

> [GitHub - mikefarah/yq: yq is a portable command-line YAML processor](https://github.com/mikefarah/yq)

I've used yq to edit yaml files programmatically, such as datadog configuration files.

Here's a few samples on how to use this tool, using datadog agent config files as an example.

### Quick Install of Datadog Service

```shell
DD_HOST_TAGS="type:custom-server,stage:dev"
DD_HOSTNAME="custom-server"

DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=FancyAPIKey DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
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

echo "set the basic config for app"
yq eval "
.hostname = \"$nametag\" |
.process_config.enabled = true |
.tags = [\"scope:loadtest\",\"testname:$testname\"] |
.env = \"dev\" |
.cloud_provider_metadata = [\"aws\"] |
.collect_ec2_tags = true" --inplace $config
yq eval ".hostname, .process_config.enabled, .tags, .env, .cloud_provider_metadata ,.collect_ec2_tags" $config
```

### Enable Datadog Network Monitoring

```shell
echo "set the process level config to search for ssh/sshd metrics"
sudo cp /etc/datadog-agent/system-probe.yaml.example /etc/datadog-agent/system-probe.yaml
netconfig=/etc/datadog-agent/system-probe.yaml
yq eval '.network_config.enabled' $netconfig
yq eval --inplace  '
.network_config.enabled = true
' $netconfig
yq eval '.network_config.enabled' $netconfig
```

### Enable Datadog Process Level Tracking

Enable process level tracking, with a specific match on `ssh, sshd`.

```shell
echo "set the process level config to search for ssh/sshd metrics"
sudo cp /etc/datadog-agent/conf.d/process.d/conf.yaml.example  /etc/datadog-agent/conf.d/process.d/conf.yaml
processconfig=/etc/datadog-agent/conf.d/process.d/conf.yaml
yq eval '.instances' $processconfig
yq eval --inplace  '
.instances[0].name = "ssh" |
.instances[0].search_string = ["ssh","sshd"]
' $processconfig
yq eval --inplace  '
.instances[1].name = "myprocess" |
.instances[1].search_string = ["myprocess"]
' $processconfig
yq eval '.instances' $processconfig
```

You can do a lot with `yq`.

## Parse Kubernetes Secrets Using JQ

Using jq, you can parse out secrets from base64 encoded values for some quick scripting.

> NOTE: This uses [sttr](https://github.com/abhimanyu003/sttr) but you can modify to whatever your platform provides (zsh `base64 -decode` or pwsh `[System.Convert]::FromBase64String($Base64String)`))
> If you have Go installed then run `go install github.com/abhimanyu003/sttr@latest`.

This example parses an encoded JSON string to help registry an Azure Container Registry from a Kubernetes stored secret.

```shell
namespace="mynamespace"
secretname="mysecretname"
kubectl config set-context --current --namespace=$namespace

configEncoded=$(kubectl get secret $secretname -o jsonpath='{.data.\.dockerconfigjson}')
configDecoded=$(sttr base64-decode $configEncoded)
registry=$(echo $configDecoded | jq -r '.auths | keys[0]')
creds=$(echo $configDecoded | jq -r .auths[$registry].auth)

echo -e "👉 registry: $registry"
echo -e "👉 username:password: $( sttr base64-decode $creds )"
```

## GitHub CLI

## View The Logs Of A Prior Run

View the logs of the last run (or toggle to error logs with the switch).

- `gh run view --log $(gh run list -L1 --json 'databaseId' --jq '.[].DatabaseId')`
- `gh run view $(gh run list --limit 1 --json databaseId --jq '.[0].DatabaseId' ) --log`

This can be chained together with other commands to quickly iterate on testing.
When appropriate, you might avoid this by running [act](https://github.com/nektos/act) but I've had limited success with it due to various restrictions.

```shell
git commit -am 'ci: get GitHub release working' && \
  git push && \
  gh workflow run release && \
  sleep 5 && \
  gh run watch -i1 || gh run view --log --job $(gh run list -L1 --json 'workflowDatabaseId' --jq '.[].workflowDatabaseId')
```

### Use To Configure Settings on Many Repos At Once

This example uses [gum][^gum-tool] to filter.
Use `tab` when selecting in the multi-entry option.

```shell
org=$(gum input --prompt 'enter GitHub org: ')
originallist=$( gh repo list $org --json 'name' --jq '.[].name' |  tr ' ' '\n' )
repos="$( echo $originallist | gum filter --no-limit )"

for repo in $( echo $repos | tr '\n' ' ') ;
do
    printf "processing %s ... " "${repo}"
    gh api \
        --method PATCH \
        -H "Accept: application/vnd.github+json" \
        /repos/$org/$repo \
        -F use_squash_pr_title_as_default=true \
        -F squash_merge_commit_title=PR_TITLE \
        -F squash_merge_commit_message=PR_BODY \
        --silent
        printf "✔️\n"
    # return # for testing
done
```

## Clone All The Desired

Uses gum[^gum-repo] & [ghq][^ghq-repo].
See [setup directions](#check-for-and-install-tooling).

### Configure ghq

To configure `ghq` defaults run:

```shell
git config --global ghq.vcs git
git config --global ghq.root $(gum input -prompt 'base git directory for repos: (recommend ~/git):  ' )
```

### Clone All Repos Selected

```shell
org=$(gum input --prompt 'enter GitHub org: ')
originallist=$( gh repo list $org --json 'name' --jq '.[].name' |  tr ' ' '\n' )
echo 'select repos (use tab to select, and type to filter)'
repos="$( echo $originallist | gum filter --no-limit )"

for repo in $( echo $repos | tr '\n' ' ') ;
do
    printf "processing %s ... " "${repo}"
    ghq get "https://github.com/${org}/${repo}" &> /dev/null
    printf "✔️\n"
done
```

[^gum-tool]: [GitHub - charmbracelet/gum: A tool for glamorous shell scripts 🎀](https://github.com/charmbracelet/gum)
[^ghq-repo]: [ghq - repo cloning tool](https://github.com/x-motemen/ghq)
