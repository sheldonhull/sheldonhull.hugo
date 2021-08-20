# Why Do I use brew?
# Since this is a dev container and not a publishing container
# brew simplifies a lot of quick adhoc tooling like gitversion for example
# and also improves the path handling so I don't have to worry about it.
# this is how to copy from

# See here for image contents: https://github.com/microsoft/codespace-dev-containers/tree/v0.154.2/containers/ubuntu/.devcontainer/base.Dockerfile
# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
# FROM homebrew/brew:latest AS DOCKERBREW
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
# USER root
# RUN useradd -m -s /bin/bash linuxbrew && \
#     echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

# USER linuxbrew
# COPY --from=DOCKERBREW /home/linuxbrew/.linuxbrew /home/linuxbrew/.linuxbrew
# #RUN   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

USER root
RUN apt update && apt-get -qqy install build-essential curl file git gcc --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
#  sudo apt update && sudo apt-get -qqy install build-essential curl file git gcc
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN sh -c "$(wget -qO- git.io/chezmoi)" && mv ./bin/chezmoi /usr/local/bin/chezmoi && rm -rf ./bin
# for troubleshooting:
# $ENV:PATH = "/home/linuxbrew/.linuxbrew/bin:$($ENV:PATH)"
USER codespace
#RUN curl -L "https://github.com/whalebrew/whalebrew/releases/download/0.3.0/whalebrew-$(uname -s)-$(uname -m)" -o /usr/local/bin/whalebrew; chmod +x /usr/local/bin/whalebrew
RUN brew --version
RUN brew update
#RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gcc
#RUN brew postinstall gcc
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install golang
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gcc@5
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install hugo
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install git-town
#RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install go-task/tap/go-task

# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install node

# Diagnose: ssh -vT git@github.com

# echo "installing go-task via go" && go install github.com/go-task/task/v3/cmd/task@latest

#RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask powershell
RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon
RUN mkdir -p /home/codespace/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/codespace/.config/nixpkgs/config.nix
RUN echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> /home/codespace/.bashrc

# Install git
RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i git git-lfs

# This requires dotnet install so bypassing as not critical
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gitversion
# Install direnv
RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i direnv \
  && direnv hook bash >> /home/codespace/.bashrc \
  && direnv allow


RUN  nix-env -iA nixpkgs.go \
&& nix-env -iA nixpkgs.git-town \
&& nix-env -iA nixpkgs.hugo \
&& nix-env -iA nixpkgs.chezmoi \
&& nix-env -iA nixpkgs.nodejs

RUN go install github.com/magefile/mage@latest && echo "✅ mage installed" \
    && go install github.com/iwittkau/mage-select@latest && echo "✅ mage-select installed"
