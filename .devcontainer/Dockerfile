FROM mcr.microsoft.com/devcontainers/base:debian as BASE
ARG USERNAME=codespace
ARG USE_MOBY="true"
ARG ENABLE_NONROOT_DOCKER="true"
ARG DOCKER_VERSION="latest"
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG HOMEDIR="/home/codespace"

ARG GO_VERSION="${GO_VERSION}"
ARG GOPATH="${GOPATH}"
ARG GOROOT="${GO_ROOT}"


USER root

ENV GOROOT=${GOROOT}
ENV GOPATH=${GOPATH}
ENV PATH=${GOPATH}:$PATH
ENV MAGEFILE_ENABLE_COLOR=1


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
RUN apt-get -yqq update \
  # && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}"  \
  && /bin/bash /tmp/library-scripts/go-updater.sh \
  && apt-get -yqq autoremove && apt-get -yqq clean && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

RUN curl -sfL https://direnv.net/install.sh | bash


USER ${USERNAME}

ENV MAGEFILE_ENABLE_COLOR=1
ENV DOCKER_BUILDKIT=1
ENV GOPATH=/home/${USERNAME}/go
ENV PATH=/home/${USERNAME}/go/bin:$PATH
ENV SHELL /usr/bin/zsh
ENV MAGEFILE_HASHFAST=1

RUN go install github.com/magefile/mage@latest && go install github.com/charmbracelet/glow@latest
# RUN python3 -m pip install --upgrade pip --user && python3 -m pip install pre-commit --user


COPY files/install-asdf.sh /tmp/install-asdf.sh
COPY .tool-versions /home/${USERNAME}/.tool-versions
RUN bash /tmp/install-asdf.sh
