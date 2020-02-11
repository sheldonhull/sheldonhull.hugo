# Great blog example: https://www.gitpod.io/blog/docker-in-gitpod/
# To examine the base container definition: https://hub.docker.com/r/gitpod/workspace-full/dockerfile

# has go, git, and lots of other things already ready
FROM gitpod/workspace-full:latest
USER root

ENV VERSION 0.64.1

# Install custom tools, runtime, etc.
#RUN add-apt-repository universe
#RUN add-apt-repository ppa:longsleep/golang-backports

RUN apt-get update && apt-get install -y \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*apt-get install hugo
# RUN apt install snap -y
# RUN snap install git
# RUN snap install go --classic
#RUN apt install git
#RUN apt install golang-go
#RUN apt install golang-go --classic

# openssl \
#     py-pygments \
#     libc6-compat \
#     g++ \
#     curl \


RUN brew install tree
USER gitpod
RUN mkdir $HOME/src
RUN tree
RUN cd $HOME/src
# RUN wget -qO- https://github.com/gohugoio/hugo/releases/download/v$VERSION/hugo_$VERSION_Linux-64bit.tar.gz | tar xvz -C /usr/bin
#               https://github.com/gohugoio/hugo/releases/download/v0.64.1/hugo_0.64.1_Linux-64bit.deb
RUN git clone https://github.com/gohugoio/hugo.git $HOME/src/hugo
#RUN cd $HOME/src/hugo
#RUN go install --tags extended
RUN brew install hugo --HEAD
#RUN brew upgrade hugo

# Apply user-specific settings
#RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_Linux-64bit.tar.gz | tar -xz  \
#    && cp hugo /usr/bin/hugo \
#    && hugo version

# RUN apt-get install hugo
RUN hugo version

ENV HUGO_ENABLEGITINFO=true
#ENV HUGO_BASEURL=
ENV HUGO_MINIFY=true
ENV HUGO_DESTINATION=_site

# Give back control
USER root