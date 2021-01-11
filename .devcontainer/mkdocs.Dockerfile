#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# To fully customize the contents of this image, use the following Dockerfile instead:
# https://github.com/microsoft/vscode-dev-containers/tree/v0.123.0/containers/codespaces-linux/.devcontainer/Dockerfile
# docker build --pull --rm -f ".devcontainer/Dockerfile" -t devops-engineering:latest ".devcontainer"
FROM mcr.microsoft.com/vscode/devcontainers/universal:0-linux

# ** [Optional] Uncomment this section to install additional packages. **


USER root
RUN apt-get update --fix-missing -qy \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qqy install --no-install-recommends curl wget zip unzip pv python-pip python-dev build-essential python3-pip python3-dev build-essential python3-setuptools python3-venv

#RUN apt-get install -qy python-pip python-dev build-essential && apt-get install -qy python3-pip python3-dev build-essential python3-setuptools \
#    && pip3 install cfn_flip
# python3.8 python3.8-distutils python3.8-venv python3-pip
# RUN  export DEBIAN_FRONTEND=noninteractive \
# && apt update \
# && apt install software-properties-common \
# && apt-add-repository --yes --update ppa:ansible/ansible \
# && apt install ansible
RUN  export DEBIAN_FRONTEND=noninteractive \
    # && deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main \
    # && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    # && sudo apt -qqy update \
    && add-apt-repository ppa:ansible/ansible-2.8 \
    && apt -qqy install ansible && ansible --version

ADD init.ps1 .
ADD profile.ps1 .
ADD main.yml .
ADD requirements.yml .
ADD ansible.cfg .
ENV ANSIBLE_LOCALHOST_WARNING=False
ENV ANSIBLE_DEPRECATION_WARNINGS=False
ENV ANSIBLE_LOAD_CALLBACK_PLUGINS=True

#RUN ansible-playbook -i localhost -h localhost -u codespace ./playbook.yml && echo "Foo"
RUN ansible-galaxy install --role-file requirements.yml
RUN export ANSIBLE_LOCALHOST_WARNING=False && ansible-playbook ./main.yml -t 'build'
# ADD install-git-town.sh .
# # ADD install-terraform.sh .
# ADD init.ps1 .
# # ADD install-poetry.sh .

# RUN echo ">>> Running install-git-town.sh <<<" && chmod +x ./install-git-town.sh && bash ./install-git-town.sh
# # RUN echo ">>> Running install-terraform.sh <<<" && chmod +x ./install-terraform.sh && bash ./install-terraform.sh -i "0.12.24"
# RUN echo ">>> Running init.ps1 <<<" && chmod +x ./init.ps1 && pwsh -nologo -noprofile ./init.ps1
# # RUN echo ">>> Running install-poetry.sh <<<" && chmod +x ./install-poetry.sh && bash ./install-poetry.sh
# # ENV PATH "$PATH:$HOME/.poetry/bin"

# #ENV SHELL=/usr/bin/fish
# ENV SHELL=/usr/local/microsoft/powershell/7/pwsh
USER codespace


# # sudo apt-get -qy install software-properties-common
# # sudo apt-add-repository universe
