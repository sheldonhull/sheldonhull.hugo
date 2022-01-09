ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/universal:1-${VARIANT} as BASE
USER root
RUN apt-get -yqq update && apt-get -qqy install --no-install-recommends build-essential \
    && coreutils \
    && libtool \
    && autotools-dev \
    && autoconf \
    && gcc \
    && gettext \
    && make \
    && openssl \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=codespace

USER ${USERNAME}

RUN git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.9.0 \
    && source "$HOME/.asdf/asdf.sh" \
    && asdf plugin add hugo \
    && asdf plugin add direnv \
    && asdf plugin add chezmoi \
    && asdf plugin add nodejs \
    && asdf plugin add yarn \
    && asdf plugin add bat \
    && asdf plugin add caddy \
    && asdf plugin add delta \
    && asdf plugin add fzf \
    && asdf plugin add jq \
    && asdf plugin add mage \
    && asdf plugin add starship \
    && asdf plugin add yq \
    && asdf plugin add fd \
    && asdf plugin add git-chglog \
    && asdf plugin add github-cli \
    && asdf plugin add go-sdk \
    && asdf plugin add go-getter \
    && asdf plugin add python\
    && asdf plugin add git \
    && asdf plugin add pre-commit \
    && asdf install
