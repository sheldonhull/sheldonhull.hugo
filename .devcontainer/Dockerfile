# Why Do I use brew?
# Since this is a dev container and not a publishing container
# brew simplifies a lot of quick adhoc tooling like gitversion for example
# and also improves the path handling so I don't have to worry about it.
# this is how to copy from

# See here for image contents: https://github.com/microsoft/codespace-dev-containers/tree/v0.154.2/containers/ubuntu/.devcontainer/base.Dockerfile
# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM homebrew/brew:latest AS DOCKERBREW
FROM mcr.microsoft.com/vscode/devcontainers/universal:1-${VARIANT} as BASE

# RUN sudo apt-get update \
# # Install pre-requisite packages.
# && sudo apt-get install -y wget apt-transport-https software-properties-common \
# # Download the Microsoft repository GPG keys
# && wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
# # Register the Microsoft repository GPG keys
# && sudo dpkg -i packages-microsoft-prod.deb \
# # Update the list of products
# && sudo apt-get update \
# # Enable the "universe" repositories
# && sudo add-apt-repository universe \
# # Install PowerShell
# && sudo apt-get install -y powershell
# RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
#     && dpkg -i packages-microsoft-prod.deb \
#     && apt-get -qqy update \
#     && apt-get -qqy install --no-install-recommends powershell curl wget
USER root
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
COPY --from=DOCKERBREW /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
#RUN   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

USER root
RUN sudo apt update && sudo apt-get -qqy install build-essential curl file git \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
# for troubleshooting:
# $ENV:PATH = "/home/linuxbrew/.linuxbrew/bin:$($ENV:PATH)"
USER codespace
#RUN curl -L "https://github.com/whalebrew/whalebrew/releases/download/0.3.0/whalebrew-$(uname -s)-$(uname -m)" -o /usr/local/bin/whalebrew; chmod +x /usr/local/bin/whalebrew
RUN brew --version
RUN brew update
#RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gcc
#RUN brew postinstall gcc
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install golang
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install hugo
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install git-town
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install go-task/tap/go-task
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install npm
RUN mkdir $HOME/.git-template
#RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask powershell


# This requires dotnet install so bypassing as not critical
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gitversion
