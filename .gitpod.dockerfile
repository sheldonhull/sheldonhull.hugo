# Great blog example: https://www.gitpod.io/blog/docker-in-gitpod/
# To examine the base container definition: https://hub.docker.com/r/gitpod/workspace-full/dockerfile

# has go, git, and lots of other things already ready
FROM gitpod/workspace-full:latest
USER root


ENV VERSION 0.55.2
# Install custom tools, runtime, etc.
#RUN apt-get update && apt-get install -y \
#    snap \
#    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*apt-get install hugo
#RUN snap install git
#RUN snap install go --classic


# openssl \
#     py-pygments \
#     libc6-compat \
#     g++ \
#     curl \
USER gitpod
RUN mkdir $HOME/src \
    cd $HOME/src \
    git clone https://github.com/gohugoio/hugo.git \
    cd hugo \
    go install --tags extended

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