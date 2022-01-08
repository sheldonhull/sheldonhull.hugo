ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/universal:1-${VARIANT} as BASE

ARG USERNAME=codespace

USER root
# Install Nix
RUN addgroup --system nixbld \
  && adduser ${USERNAME} nixbld \
  && for i in $(seq 1 30); do useradd -ms /bin/bash nixbld$i &&  adduser nixbld$i nixbld; done \
  && mkdir -m 0755 /nix && chown ${USERNAME} /nix \
  && mkdir -p /etc/nix && echo 'sandbox = false' > /etc/nix/nix.conf

# Install Nix
CMD /bin/bash -l
USER ${USERNAME}
ENV USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN touch .bash_profile \
 && curl https://nixos.org/releases/nix/nix-2.3.14/install | sh

RUN echo '. /home/${USERNAME}/.nix-profile/etc/profile.d/nix.sh' >> /home/${USERNAME}/.bashrc
RUN mkdir -p /home/${USERNAME}/.config/nixpkgs && echo '{ allowUnfree = true; }' >> /home/${USERNAME}/.config/nixpkgs/config.nix

# Install cachix
RUN . /home/${USERNAME}/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -iA cachix -f https://cachix.org/api/v1/install \
  && cachix use cachix

# Install git
RUN . /home/${USERNAME}/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i git git-lfs

# Install direnv
RUN . /home/${USERNAME}/.nix-profile/etc/profile.d/nix.sh \
  && nix-env -i direnv \
  && direnv hook bash >> /home/${USERNAME}/.bashrc

RUN  nix-env -iA nixpkgs.go \
      && nix-env -iA nixpkgs.hugo \
      && nix-env -iA nixpkgs.chezmoi \
      && nix-env -iA nixpkgs.nodejs
