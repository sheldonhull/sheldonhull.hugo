---
title: docker
date: 2021-06-01
toc: true
summary:
  A cheatsheet for some docker container magic. Docker has it's own quirks, so this is a way for me to remember and reuse some of this without trying to formalize into a standardized repo
comments: true
tags:
- development
- docker
---

## Buildx

> Docker Buildx is a CLI plugin that extends the docker command with the full support of the features provided by Moby BuildKit builder toolkit.
> It provides the same user experience as docker build with many new features like creating scoped builder instances and building against multiple nodes concurrently.[^docker-buildx]

Enable.

```shell
DOCKER_BUILDKIT=1
```

[Set as default builder](https://docs.docker.com/buildx/working-with-buildx/#set-buildx-as-the-default-builder)

## Resources

| Resource                                                     | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Codespaces](https://github.com/microsoft/vscode-dev-containers) | Install scripts for debian, examples of complex builds and installs for dev tooling |
| [Codespaces Library Scripts](https://github.com/microsoft/vscode-dev-containers/tree/main/script-library) | Subdirectory with installation scripts so I don't need to rebuild the wheel 😀 |
| [Advanced Codespaces Configuration](https://code.visualstudio.com/docs/remote/containers-advanced) | Cool tips on improving codespaces configuration performance, customization, and installs |

## Assumptions

The majority of the code examples apply to a base image of Ubuntu & Debian.

Since this image has GCC prebaked in, it's much easier to use with dotnet tools and other apps that require it.

## Arguments

[Understand how ARG and FROM interac](https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact)

## Building

Manually triggering build can be done via command below, replacing `codespace` with whatever tagged image name is desired.

```shell
docker build --pull --rm -f ".devcontainer/Dockerfile" -t codespace:latest ".devcontainer"
```

## Installation Scripts

`gh repo clone microsoft/vscode-dev-containers` and then copy the `script-library` directory to `${ProjectDirectory}/.devcontainer/script-library`

## Syntax Tips

### Installing Apps

Use an environment variable to cleanup the dockerfile install commands.

```dockerfile
# Additonal applications to install
ENV ADDITIONAL_APPS \
    curl \
    g++ \
    gcc \
    gettext \
    git \
    locales \
    locales-all \
    make \
    nano \
    openssh-client \
    rsync
RUN apt -yqq install ${ADDITIONAL_APPS} --no-install-recommends  \
    && apt-get -yqq autoremove \
 && rm -rf /var/lib/apt/lists/*

```

## Best Practice

### Smaller Layers

- Use [dive](https://github.com/wagoodman/dive) and the associated VSCode extension to explore the layers for reducing size.

- Use cleanup commands on any layer to reduce it's cached size by running the clean and rm command at the end of the layer.

- Use `--no-install-recommends` to reduce installation size when running `apt-get`

```dockerfile
RUN apt-get -yyq update && apt-get -yyq install tree --no-install-recommends  \
    && apt-get -yyq clean && rm -rf /var/lib/apt/lists/*
```

## User Configuration

Using dotfiles with chezmoi, manually trigger using a command such as:

```shell
curl -sfL https://git.io/chezmoi | sh
echo "enter github username for chezmoi repo"
./bin/chezmoi init --apply --verbose https://github.com/$(read)/chezmoi.git
```

## Environment Variables

## Homebrew

You can install Homebrew for Linux in two different ways, using multi-stage build, or the vscode install script [homebrew-debian.sh](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/homebrew-debian.sh)

 Multistage would do this:

```dockerfile
ARG VARIANT="focal"
FROM homebrew/brew:latest AS DOCKERBREW
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

USER root
RUN useradd -m -s /bin/bash linuxbrew  && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
COPY --from=DOCKERBREW /home/linuxbrew/.linuxbrew /usr/local/bin/brew
USER root
RUN chmod -R a+rwx /usr/local/bin/brew

USER $USERNAME
ENV BREW_PREFIX=/home/linuxbrew/.linuxbrew
ENV PATH=${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:${PATH}
RUN echo "✅ brew version: $(brew --version)"
```

Using the install script or the curl command to install might take signficantly longer as it recompiles due to gcc.

```dockerfile
USER root
ENV BREW_PREFIX=/home/linuxbrew/.linuxbrew
ENV PATH=${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:${PATH}
RUN yes | unminimize 2>&1 \
    && echo "⚡ Beginning homebrew-debian.sh" && bash /tmp/library-scripts/homebrew-debian.sh \
    && echo "🎉 HomeBrew Installed: [$(brew --version)]" \
    && apt-get -yyq clean && rm -rf /var/lib/apt/lists/*
```

## PowerShell Tooling

## Python 3

Use the library scripts [python-debian.sh](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/python-debian.sh) in vscode repo to simplify installation then use the following install command.

```dockerfile
ARG PYTHON_PATH="/usr/local/python"
ARG PYTHON_VERSION="3.8.3"
ARG PIPX_BIN_DIR="/usr/local/py-utils/bin"
ARG PIPX_HOME="/usr/local/py-utils"
ARG UPDATE_RC="true"
ARG INSTALL_PYTHON_TOOLS="true"

USER root

# From .devcontainer/script-library/docs/python.md
ENV PIPX_HOME=${PIXY_HOME} \
    PIPX_BIN_DIR=${PIPX_BIN_DIR}}
ENV PATH=${PYTHON_PATH}/bin:${PATH}:${PIPX_BIN_DIR}
RUN yes | unminimize 2>&1 \
    && bash /tmp/library-scripts/python-debian.sh "${PYTHON_VERSION}" "${PYTHON_PATH}" "${PIPX_HOME}" "${USERNAME}" "${UPDATE_RC}" "${INSTALL_PYTHON_TOOLS}"  \
    && apt-get -yyq clean && rm -rf /var/lib/apt/lists/*
USER $USERNAME

# Verify the nonroot user has access now
ENV PATH="/usr/local/python${PYTHON_VERSION}:${PATH}"
RUN echo "🎉 python-debian installed with version: [$(python3 --version)]"
```

```dockerfile
RUN apt-get -yyq update && apt-get -qyy install python3-venv python3-pip --no-install-recommends \
    && apt-get -yyq clean \
    && rm -rf /var/lib/apt/lists/*
```

## Pre-Commit Tooling

This requires python and pip to be installed correctly (see previous section).

```dockerfile
RUN python3 -m pip install pre-commit
```

Since pre-commit needs a repo to install the pre-commit hook to, after loading the project run `task precommit:init` if Task is installed, else run `pre-commit install` in the cloned repo.

## Go-Task

```yaml
version: '3'
silent: true
output: prefixed
vars:
  CONTAINERNAME: codespace-general
  DOCKER_BUILDKIT: 1
tasks:
  build:
    desc: build codespaces container
    cmds:
    - docker build --pull --rm -f ".devcontainer/Dockerfile" -t {{ .CONTAINERNAME }}:latest ".devcontainer"
  rebuild:
    desc: build codespaces container without using cache in case of cached changes preventing new updates from being picked up
    cmds:
    - docker build --pull --rm --no-cache -f ".devcontainer/Dockerfile" -t {{ .CONTAINERNAME }}:latest ".devcontainer"
```

## Full Dockerfile Examples

### Codespaces - Ubuntu General Development Build

This is a general purpose dev container for dev tooling such python3, Go, PowerShell, pre-commit, and other useful tools.

It is designed to be used for any of these projects with some useful tooling like Brew, bit (git enhanced cli), git town and others.

Tweaks to the `devcontainer.json`  support mounting aws local credentials into the container, using volumes for high IO package/artifact directories, and improve drive performance by marking the container as the primary and the host directory mounted version to be ok to lag a bit.

```json
  "workspaceMount": "source=${localWorkspaceFolder},target=/home/codespace/workspace,type=bind,consistency=delegated",
  "mounts": [
    "source=vscodeextensions,target=/root/.vscode-server/extensions,type=volume",
    "source=artifacts,target=${containerWorkspaceFolder}/artifacts,type=volume",
    "source=packages,target=${containerWorkspaceFolder}/packages,type=volume",
    "source=tools,target=${containerWorkspaceFolder}/tools,type=volume",
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.aws/credentials,target=/home/codespace/.aws/credentials,type=bind,consistency=delegated",
  ],
  "postCreateCommand": [
    "uname -a",
    "pre-commit install"
  ],
 // Set *default* container specific settings.json values on container create.
  "settings": {
    "terminal.integrated.profiles.linux": {
      "bash": {
        "path": "bash"
      },
      "zsh": {
        "path": "zsh"
      },
      "fish": {
        "path": "fish"
      },
      "tmux": {
        "path": "tmux",
        "icon": "terminal-tmux"
      },
      "pwsh": {
        "path": "pwsh",
        "icon": "terminal-powershell"
      }
    }
  },
```

```dockerfile
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.163.1/containers/ubuntu/.devcontainer/base.Dockerfile

ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# Codespace/Docker User Config
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USERNAME=vscode

# Common Debian Install Settings
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"

# PYTHON INSTALL SETTINGS
ARG PYTHON_PATH="/usr/local/python"
ARG PYTHON_VERSION="3.8.3"
ARG PIPX_BIN_DIR="/usr/local/py-utils/bin"
ARG PIPX_HOME="/usr/local/py-utils"
ARG UPDATE_RC="true"
ARG INSTALL_PYTHON_TOOLS="true"

# CONFIGURE USER FOR LINUXBREW
USER root
RUN useradd -m -s /bin/bash linuxbrew  && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

# Install Software Properties Common
# From Stack Overflow: This software provides an abstraction of the used apt repositories.
# It allows you to easily manage your distribution and independent software vendor software sources.
# Without it, you would need to add and remove repositories (such as PPAs) manually by editing /etc/apt/sources.list and/or any subsidiary files in /etc/apt/sources.list.d
USER root
RUN apt-get -yyq update && apt-get -yyq install software-properties-common --no-install-recommends  && add-apt-repository universe && apt-get -yyq update && rm -rf /var/lib/apt/lists/*

# Install Python 3 & Python tools
RUN apt-get -qqy update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qqy install --no-install-recommends build-essential gcc python3 python3-pip python3-setuptools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip install --upgrade pip

# For spinning up an interactive desktop using container as host
# Optional to allow simulated desktop dev experience without need to use VirtualBox VM's for this
# Adds a lightweight [Fluxbox](http://fluxbox.org/) based desktop to the container that can be accessed using a VNC viewer or the web.
# UI-based commands executed from the built in VS code terminal will open on the desktop automatically.
ENV DBUS_SESSION_BUS_ADDRESS="autolaunch:" DISPLAY=":1" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
# Go SDK
ENV GOROOT=/usr/local/go GOPATH=/go
ENV PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
# Python SDK
ARG PYTHON_PATH="/usr/local/python"
ENV PIPX_HOME=${PIXY_HOME} PIPX_BIN_DIR=${PIPX_BIN_DIR}
ENV PATH=${PYTHON_PATH}/bin:${PATH}:${PIPX_BIN_DIR}

# RUN #yes | unminimize 2>&1 \
RUN echo "⚡ Beginning common-debian.sh" && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" && echo "🎉 finished common-debian.sh" \
    # && echo "⚡ Beginning python-debian.sh" && bash /tmp/library-scripts/python-debian.sh "${PYTHON_VERSION}" "${PYTHON_PATH}" "${PIPX_HOME}" "${USERNAME}" "${UPDATE_RC}" "${INSTALL_PYTHON_TOOLS}"  && echo "🎉 finished python-debian.sh" \
    && echo "⚡ Beginning azcli-debian.sh install" && bash /tmp/library-scripts/azcli-debian.sh && echo "🎉 PowerShell Installed: [$(pwsh --version)]" \
    && echo "⚡ Beginning docker-in-docker-debian.sh" && bash /tmp/library-scripts/docker-in-docker-debian.sh && echo "🎉 docker-in-docker-debian.sh completed" \
    && echo "⚡ Beginning go-debian.sh" && bash /tmp/library-scripts/go-debian.sh && echo "🎉 go-debian completed" \
    # && echo "⚡ Beginning sshd-debian.sh" && bash /tmp/library-scripts/sshd-debian.sh && echo "🎉 sshd-debian completed" \
    # && echo "⚡ Beginning desktop-lite-debian.sh" && bash /tmp/library-scripts/desktop-lite-debian.sh && echo "🎉 desktop-lite-debian completed" \
    && apt-get -yyq clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/library-scripts && echo "🧹 cleaned install helper scripts"


#################################
# CONFIGURE USER LEVEL SETTINGS #
#################################
USER $USERNAME


########################################
# Configure Environment Vars For Tools #
########################################
ENV BREW_PREFIX=/home/linuxbrew/.linuxbrew
ENV PATH=${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:${PATH}
ENV PATH=${PYTHON_PATH}/bin:${PATH}:${PIPX_BIN_DIR}

# Ensure default profile directory exists for preferences to be saved and loaded as desired
RUN pwsh -nologo -c 'New-Item -Path ($Profile | Split-Path -Parent) -ItemType Directory'



#################
# BREW PACKAGES #
#################
# For enhanced git cli experience
# MACOS: Not Linux RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install bit-git

# For enhanced cross platform prompt with git and powershell both supported
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install starship

# Dotfiles loader so easy to initialize personal preferences in container with chezmoi init command
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install chezmoi

# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gitversion


#####################
# OTHER DEV TOOLING #
#####################
# bit: For enhanced git cli experience
RUN GO111MODULE=on go get -v -u github.com/chriswalz/bit

USER root
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
USER $USERNAME

########################
# GO DEVELOPMENT TOOLS #
########################
# Installing proactively to speed up vscode and precommit usage of various tools
  # use binary install not go get for golangci-lint https://golangci-lint.run/usage/install/#local-installation
RUN echo "installing go tools" \
  && curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $(go env GOPATH)/bin vX.Y.Z \
  && go get -u "golang.org/x/tools/cmd/goimports" \
  && go get -u "github.com/sqs/goreturns" \
  && go get -u "golang.org/x/lint/golint" \
  && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.39.0 \
  && GO111MODULE=on go get -v -u "github.com/go-critic/go-critic/cmd/gocritic" \
  && go get -v -u "github.com/uudashr/gopkgs/v2/cmd/gopkgs" \
  && go get -v -u "github.com/ramya-rao-a/go-outline" \
  && go get -v -u "github.com/cweill/gotests/gotests" \
  && go get -v -u "github.com/fatih/gomodifytags" \
  && go get -v -u "github.com/josharian/impl" \
  && go get -v -u "github.com/haya14busa/goplay/cmd/goplay" \
  && go get -v -u "github.com/go-delve/delve/cmd/dlv" \
  && go get -v -u "github.com/go-delve/delve/cmd/dlv@master" \
  && go get -v -u "honnef.co/go/tools/cmd/staticcheck" \
  && go get -v -u "golang.org/x/tools/gopls@v0.6.11" \
  && go get -v -u github.com/git-chglog/git-chglog/cmd/git-chglog # Generate Changelogs automatically

#####################
# Precommit Install #
#####################
RUN echo "Validating python3 command is recognized: $(python3 --version)"
RUN echo "Validating python3 pip module command is recognized: $(python3 -m pip --version)"
RUN echo "Validating pip command is recognized: $(pip --version)"
RUN python3 -m pip install pre-commit


#############################################################
# SUPPORT CACHING VSCODE EXTENSIONS FOR FASTER PROVISIONING #
#############################################################
# IMPORTANT: This requires updating devcontainer.json per directions to ensure mount arguments passed in
# See: https://code.visualstudio.com/docs/remote/containers-advanced#_avoiding-extension-reinstalls-on-container-rebuild
RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
    /home/$USERNAME/.vscode-server/extensions && \
    chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server

# Set multiple labels at once, using line-continuation characters to break long lines
LABEL vendor=misc \
      type=codespaces \
      is-beta=true \
      user=vscode \
      is-production=false \
      version="0.0.1-beta" \
      release-date="2021-06-01" \
      description="development image with tooling for vscode codespaces" \
      maintainer="me" \
      name=codespaces-general

```

### Other Dockerfile Fragments

#### Mount SSH Keys

- Use cached: when the host performs changes, the container is in read only mode.[^stack-overflow-answer-cached-or-delegated]
- Use delegated: when docker container performs changes, host is in read only mode.
- Use default: When both container and host actively and continuously perform changes on data.

```json
"mounts": [
  "source=${localEnv:HOME}${localEnv:USERPROFILE}/.ssh,target=/home/codespace/.ssh/,type=bind,consistency=cached"
]
```

{{< admonition type="Note" title="cannot create /home/$USERNAME/.ssh/known_hosts: Permission denied" open=false >}}

If this fails, try this in your Dockerfile.
Not sure this is required, but did help in one test case, so I'm pinning here.

```dockerfile
RUN mkdir -p /home/$USERNAME/.ssh/ && touch /home/$USERNAME/.ssh/known_hosts
```

{{< /admonition >}}

#### dotnet

```dockerfile
# Install DOTNET tooling for benefit of tools like gitversion
RUN echo "downloading microsoft prod packages source" && wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb
# RUN sudo dpkg --purge packages-microsoft-prod && sudo dpkg -i packages-microsoft-prod.deb && sudo apt-get update
RUN echo "Installing dotnet sdk" && apt-get update \
  && apt-get  -yyq install apt-transport-https --no-install-recommends \
  && apt-get  -yyq update \
  && apt-get  -yyq install dotnet-sdk-5.0 --no-install-recommends  \
  && rm -rf /var/lib/apt/lists/*
```

#### GitVersion

```dockerfile
RUN echo "installing gitversion for automatic semver versioning" && dotnet tool install --global GitVersion.Tool
```

#### Mage

Go based Make alternative.

```dockerfile
RUN go version && go install github.com/magefile/mage@latest \
    # mage-select provides a nice little mage task selector menu
    && go install github.com/iwittkau/mage-select@latest
```

#### Security Tools for Lefthook

```dockerfile
RUN go install github.com/evilmartians/lefthook@latest \
&& go install github.com/owenrumney/squealer/cmd/squealer@latest \
&& go install -v github.com/zricethezav/gitleaks@latest
```

#### Terminal Tools

```dockerfile
RUN curl -sf https: //gobinaries.com/chriswalz/bit | sh && echo "installed bit-git" &&
    \ curl -fsSL https://starship.rs/install.sh | sudo bash -s -- --force && echo "completed setup of starship.rs"
```

#### powershell

Configure pwsh profile

```shell
# Ensure default profile directory exists for preferences to be saved and loaded as desired
RUN pwsh -nologo -c 'New-Item -Path ($Profile | Split-Path -Parent) -ItemType Directory'
```

## Installation Snippets

### Markdown Lint

Use the docker image of markdownlint to quickly fix basic formatting issues that can cause occasional issues with various markdown renderers.

```shell
docker run -i --rm -v ${PWD}:/work tmknom/markdownlint --fix --config .markdownlint.yaml /work/
```

Use a config like this to tweak the rules to your desired settings

```yaml
# name this file .markdownlint.yaml in your root directory or put in settings directory and pass --config in the setup.

comment: my-markdown-linting-rules
default: true
# MD003:
#   style:
MD007:
  indent: 4
no-hard-tabs: true
whitespace: true
no-bare-urls: true
fenced-code-language: true
no-inline-html: false
MD004:
  style: dash
MD025:
MD041: false
MD013: false
MD046: false
  #style: consistent

```

### Gitversion

Generate semver versioning from commit history automatically, removing need to manually manage semver.

This results in a version history built by the actual commits and merges.

Override allowed using `git tag -a 0.1.0 -m"initial commit" && git push --tags`

| Description                                                  | Code                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Pull gitversion                                              | `docker pull gittools/gitversion:latest`                     |
| Run gitversion (calculate current semver from git history) using config from `build/GitVersion.yml` | `docker run --rm -v ${pwd}:/repo gittools/gitversion:latest /repo /config ./build/GitVersion.yml /showvariable FullSemVer /nofetch` |
| Output Build Server Variables for use in Azure DevOps        | `docker run --rm -v ${pwd}:/repo gittools/gitversion:latest /repo /config ./build/GitVersion.yml /showvariable FullSemVer /nofetch /output buildserver` |

You can use those output variables in your Azure Pipeline to update the build name to include Semver versioning, or pass it into a task to use for building any app.

```yaml
name: build-$(GitVersion.FullSemVer).$(Build.Reason).$(SourceBranchName).$(Date:yyyyMMdd)-$(Rev:.r)

steps:
- bash: |
    echo "This is your new version: $VERSION"
  displayName: PublishSomething
  env:
    VERSION: $(GitVersion.FullSemVer)
- pwsh: |
  Write-Host "This is your new $ENV:VERSION"
  displayName: PublishingSomethingElse
  env:
    VERSION: $(GitVersion.FullSemVer)
```

I normally start with `Mainline` development mode, but if you want to customize this to drive behavior off of conventional commits or other branching and delivery methods, there's a wide range of customization at you can review at: [GitVersion Incrementing](https://gitversion.net/docs/reference/version-increments)

```yaml
---
mode: Mainline
branches: {}
ignore:
  sha: []
merge-message-formats: {}
```

#### Install AWS CLI & Session Manager Plugin

This is for arm64 based ubuntu containers.

```dockerfile
RUN apt-get -yqq update --fix-missing && apt-get -yqq install pv \
    && mkdir -p ./tmpinstall && curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "./tmpinstall/awscliv2.zip" \
    && COUNT=`unzip -q -l "./tmpinstall/awscliv2.zip" | wc -l` \
    && mkdir -p ./tmpinstall/aws \
    && unzip "./tmpinstall/awscliv2.zip" -d "./tmpinstall/"  | pv -l -s $COUNT >/dev/null \
    && ./tmpinstall/aws/install --update | (pv --timer --name "🤖 awscli")  \
    && rm -rf ./tmpinstall/ \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
```

```dockerfile
RUN echo "✅ installing session manager plugin" && mkdir -p ./tmpinstall \
    && curl --silent "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "./tmpinstall/session-manager-plugin.deb" \
    && dpkg -i ./tmpinstall/session-manager-plugin.deb \
    && rm -rf ./tmpinstall/
```

## Codespaces & Remote Containers

Using remote containers is great for isolation of unique work and a clean environment.
I tend to use the Universal Image provided by Codespaces, which includes Go, .NET, PowerShell, Python, NodeJS, and more.

### Troubleshooting Cloning a Repo In Volume

{{< admonition type="Failure" title="Prompted for SSH Password When Cloning Repo Via SSH In Volume" open=true >}}

Fixed my issues with a combination of help from:

- [Git SSH public key authentication failed with git on Azure DevOps - Stack Overflow](https://stackoverflow.com/a/60939986/68698) helped a lot.
- [Git · macOS Setup Guide](https://sourabhbajaj.com/mac-setup/Git/)

I updated my `~/.ssh/config` to the following, and was able to clone without being prompted for a password.

```config
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa

Host ssh.dev.azure.com
     PubkeyAcceptedKeyTypes=ssh-rsa
     IdentityFile ~/.ssh/id_rsa
     IdentitiesOnly yes
```

- `ssh-add -K ~/.ssh/id_rsa` to finish up.

{{< /admonition >}}

[^stack-overflow-answer-cached-or-delegated]: [How do I add :cached or :delegated into a docker-compose.yml volumes list? - Stack Overflow](https://stackoverflow.com/a/63437557/68698)
[^docker-buildx]: [Docker Buildx | Docker Documentation](https://docs.docker.com/buildx/working-with-buildx/#overview)
