#FROM golang:1.15
FROM klakegg/hugo:latest-ext

RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get -qqy update \
    && apt-get -qqy install --no-install-recommends powershell


RUN export GOROOT=/opt/go && export GOPATH=/home/codespaces/go && wget -q -O - https: //git.io/vQhTU | bash
ENV PATH=$PATH:/opt/go/bin
ENV GOPATH=/home/codespaces/go
RUN go get -u all
EXPOSE 1313
