# docker


## Buildx

&gt; Docker Buildx is a CLI plugin that extends the Docker command with the full support of the features provided by the Moby BuildKit builder toolkit. It provides the same user experience as docker build with many new features like creating scoped builder instances and building against multiple nodes concurrently. [^docker-buildx]

Enable:

    DOCKER_BUILDKIT=1

[Set as default builder](https://docs.docker.com/buildx/working-with-buildx/#set-buildx-as-the-default-builder)

## Resources
...
The majority of the code examples apply to a base image of Ubuntu &amp; Debian.

Since this image has GCC prebaked in, it&#39;s much easier to use with dotnet tools and other apps that require it.

## Arguments

[Understand how ARG and FROM interact.](https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact)

The manual triggering of build can be done via the command below, replacing `codespace` with whatever tagged image name is desired.

    docker build --pull --rm -f &#34;.devcontainer/Dockerfile&#34; -t codespace:latest &#34;.devcontainer&#34;```

## Installation Scripts

Clone the `microsoft/vscode-dev-containers` repo and then copy the `script-library` directory to `${ProjectDirectory}/.devcontainer/script-library`.

## Syntax Tips
...

## User Configuration

Using dotfiles with Chezmoi, manually trigger using a command such as:

    curl -sfL https://git.io/chezmoi | sh
    echo &#34;Enter GitHub username for Chezmoi repo&#34;
    ./bin/chezmoi init --apply --verbose https://github.com/$(read)/chezmoi.git

## Environment Variables

## Homebrew

You can install Homebrew for Linux in two different ways, using a multi-stage build, or the vscode install script [homebrew-debian.sh](https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/homebrew-debian.sh)

A multistage would do this:

...

## Go-Task

    version: &#39;3&#39;
    silent: true
    output: prefixed
    vars:
...

## Full Dockerfile Examples

### Codespaces - Ubuntu General Development Build

This is a general-purpose dev container for dev tooling such as Python3, Go, PowerShell, pre-commit, and other useful tools.

...

The end goal is to provide mounting of AWS local credentials into the container, use volumes for high IO package/artifact directories, and improve the drive performance by marking the container as the primary and the host directory as mounted. The version should be okay to lag a bit.

      &#34;workspaceMount&#34;: &#34;source=${localWorkspaceFolder},target=/home/codespace/workspace,type=bind,consistency=delegated&#34;,
      &#34;mounts&#34;: [
        &#34;source=vscodeextensions,target=/root/.vscode-server/extensions,type=volume&#34;,
        &#34;source=artifacts,target=${containerWorkspaceFolder}/artifacts,type=volume&#34;,
        &#34;source=packages,target=${containerWorkspaceFolder}/packages,type=volume&#34;,
        &#34;source=tools,target=${containerWorkspaceFolder}/tools,type=volume&#34;,
        &#34;source=${localEnv:HOME}${localEnv:USERPROFILE}/.aws/credentials,target=/home/codespace/.aws/credentials,type=bind,consistency=delegated&#34;,
      ],
      &#34;postCreateCommand&#34;: [
        &#34;uname -a&#34;,
        &#34;pre-commit install&#34;
      ],
    // Set *default* container specific settings.json values on container create.
      &#34;settings&#34;: {
...



