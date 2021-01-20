#FROM golang:1.15
FROM mcr.microsoft.com/vscode/devcontainers/go

# RUN sudo apt update \
#     && sudo apt install snapd
# this checks to see if it is being run interactively so codespaces shouldn't have a problem
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    && test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv) \
    && test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) \
    && test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile \
    && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
ENV PATH "$PATH:/home/linuxbrew/.linuxbrew/bin"
RUN brew install hugo
#RUN sudo snap install hugo --channel=extended

RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get -qqy update \
    && apt-get -qqy install --no-install-recommends powershell curl wget


ARG USERNAME=codespace
ARG USER_UID=1000
ARG USER_GID=$USER_UID

 # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

USER codespace
# RUN echo ">>> Running init.ps1 <<<" && sudo chmod +x ./init.ps1 && sudo pwsh -nologo -noprofile -c '$ProgressPreference = "Ignore"; &./init.ps1'


# BREW HAS ISSUES IN THIS LIMITED IMAGE
# RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
#     && echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/codespace/.profile \
#     && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# ENV PATH "$PATH:/home/linuxbrew/.linuxbrew/bin"

# RUN export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin/brew" \
#     && export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib" \
#     && export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/isl@0.18/include" \
#     && /home/linuxbrew/.linuxbrew/bin/brew install git-town \
#     && /home/linuxbrew/.linuxbrew/bin/brew install go-task/tap/go-task


ADD install-git-town.sh .
ADD install-starship.sh .
# ADD init.ps1 .
# # ADD install-poetry.sh .

RUN echo ">>> Running install-git-town.sh <<<" && sudo chmod +x ./install-git-town.sh && bash ./install-git-town.sh
RUN echo ">>> Running install-starship.sh <<<" && sudo chmod +x ./install-starship.sh && bash ./install-starship.sh
ENV SHELL=/opt/microsoft/powershell/7/pwsh



RUN export GOROOT=/opt/go && export GOPATH=/home/codespace/go && wget -q -O - https: //git.io/vQhTU | sudo bash
ENV PATH=$PATH:/opt/go/bin
ENV GOPATH=/home/codespace/go
#RUN sudo go get -u all
EXPOSE 1313
