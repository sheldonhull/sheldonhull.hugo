FROM mcr.microsoft.com/devcontainers/base:ubuntu
ARG USERNAME=${USERNAME}

USER root
ENV DOCKER_BUILDKIT=1
ENV GOPATH=${GOPATH}
ENV PATH="${GOPATH}/bin:${PATH}"
ENV MAGEFILE_ENABLE_COLOR=1
ENV TRUNK_LAUNCHER_QUIET=true

USER ${USERNAME}
RUN mkdir -p /home/${USERNAME}/.minikube \
  && chown ${USERNAME} /home/${USERNAME}/.minikube \
  && /bin/bash -c 'set -euo pipefail && curl https://get.trunk.io -fsSL | bash -s -- -y' \
  && /bin/bash -c 'set -euo pipefail && curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v1.0.0/aqua-installer | bash'
COPY files/.zshrc /home/${USERNAME}/.zshrc
COPY files/first-run-notice.txt /home/${USERNAME}/first-run-notice.txt

VOLUME [ "/var/lib/docker" ]
ENTRYPOINT ["/usr/local/share/docker-init.sh"]
CMD ["sleep", "infinity"]
