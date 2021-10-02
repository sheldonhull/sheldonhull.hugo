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

# Logic for nix install was pulled from this great example by @ghuntley: https://github.com/gitpod-io/template-nix/blob/main/.gitpod.Dockerfile
USER root
RUN apt-get -yqq update && apt-get -qqy install build-essential curl file git gcc --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
# Install Nix
RUN addgroup --system nixbld \
  && adduser codespace nixbld \
  && for i in $(seq 1 30); do useradd -ms /bin/bash nixbld$i &&  adduser nixbld$i nixbld; done \
  && mkdir -m 0755 /nix && chown codespace /nix \
  && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf

# Install Nix
CMD /bin/bash -l
USER codespace
ENV USER codespace
WORKDIR /home/codespace

RUN touch .zshrc \
 && curl https://nixos.org/releases/nix/nix-2.3.14/install | sh

# RUN echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> /home/codespace/.zshrc
RUN mkdir -p /home/codespace/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/codespace/.config/nixpkgs/config.nix

# Install cachix
RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -iA cachix -f https://cachix.org/api/v1/install \
  && cachix use cachix

# Install git
RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i git git-lfs

# Install direnv
RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i direnv \
  && direnv hook bash >> /home/codespace/.zshrc
  # && direnv allow

# Install Other Tooling
RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -iA nixpkgs.git-town && echo "✅ installed git-town" \
    # && nix-env -iA nixpkgs.go && echo "✅ installed go" \
    && nix-env -iA nixpkgs.hugo && echo "✅ installed hugo" \
    && nix-env -iA nixpkgs.chezmoi && echo "✅ installed chezmoi" \
    && nix-env -iA nixpkgs.nodejs && echo "✅ installed nodejs" \
    && nix-env -iA nixpkgs.go-task && echo "✅ installed nixpkgs.go-task"
USER root
RUN echo "⚙️ installing go" && mkdir -p ./tmpinstaller/ && wget "https://raw.githubusercontent.com/udhos/update-golang/master/update-golang.sh" -O ./tmpinstaller/update-golang.sh \
    && wget -q https://raw.githubusercontent.com/udhos/update-golang/master/update-golang.sh.sha256 -O ./tmpinstaller/hash.txt  \
    && chmod +r ./tmpinstaller/hash.txt && bash -c 'pushd ./tmpinstaller && sha256sum --check hash.txt && popd' \
    && chmod +x ./tmpinstaller/update-golang.sh && bash ./tmpinstaller/update-golang.sh && rm -rf ./tmpinstaller && echo "✅ go installed"
USER codespace

# this might be required for codespaces
ENV PATH=$PATH:/go/bin



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


# RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin \
# && bash -c "$(wget -qO- git.io/chezmoi)" && sudo mv ./bin/chezmoi /usr/local/bin/chezmoi && sudo rm -rf ./bin
# ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

#RUN bash -c "$(wget -qO- https://nixos.org/nix/install)" && echo "✅ installed nixos"
# for troubleshooting:
# $ENV:PATH = "/home/linuxbrew/.linuxbrew/bin:$($ENV:PATH)"
USER codespace
#RUN curl -L https://nixos.org/nix/install | sh -s
# RUN curl --quiet -L https://nixos.org/nix/install | sh -s -- --daemon
  #curl --quiet -L https://nixos.org/nix/install | sh && echo "✅ installed nixos"
#RUN curl -L "https://github.com/whalebrew/whalebrew/releases/download/0.3.0/whalebrew-$(uname -s)-$(uname -m)" -o /usr/local/bin/whalebrew; chmod +x /usr/local/bin/whalebrew
# RUN bash -c brew --version
#RUN bash -c brew update
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
# RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon
# RUN mkdir -p /home/codespace/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/codespace/.config/nixpkgs/config.nix
# RUN echo '. /home/codespace/.nix-profile/etc/profile.d/nix.sh' >> /home/codespace/.zshrc

# Install git
# RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  # && nix-env -i git git-lfs

# This requires dotnet install so bypassing as not critical
# RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install gitversion
# Install direnv
# RUN . /home/codespace/.nix-profile/etc/profile.d/nix.sh \
  # && nix-env -i direnv \
  # && direnv hook bash >> /home/codespace/.zshrc \
  # && direnv allow


RUN go install github.com/magefile/mage@latest && echo "✅ mage installed" \
    && go install github.com/iwittkau/mage-select@latest && echo "✅ mage-select installed"
