ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/universal:1-${VARIANT} as BASE
ARG USERNAME=codespace
ARG USE_MOBY="true"
ARG ENABLE_NONROOT_DOCKER="true"
ARG DOCKER_VERSION="latest"
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG HOMEDIR="/home/codespace"

USER root

RUN  apt-get -yqq update && apt-get -yqq install --no-install-recommends coreutils \
  build-essential \
  pv \
  curl \
  wget \
  tree \
  apt-utils \
  sudo \
  git \
  autoconf \
  gpg \
  python3-pip \
  python3-setuptools \
  && apt-get -yqq autoremove && apt-get -yqq clean && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# These will require root user level access, so run before switching to user scope
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get -yqq update && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}"  \
  && apt-get -yqq autoremove && apt-get -yqq clean && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

USER ${USERNAME}

ENV MAGEFILE_ENABLE_COLOR=1
ENV DOCKER_BUILDKIT=1
ENV GOPATH=/home/${USERNAME}/go
ENV PATH=/home/${USERNAME}/go/bin:$PATH
ENV SHELL /usr/bin/zsh

COPY files/install-asdf.sh /tmp/install-asdf.sh
COPY .tool-versions /home/${USERNAME}/.tool-versions
RUN bash /tmp/install-asdf.sh
