ARG JENKINS_SWARM_CLIENT_VERSION=3.4
ARG LABELS=docker
ARG EXECUTORS=3
ARG FSROOT=C:\w
ARG NODENAMEPREFIX=docker-
ARG GIT_VERSION=2.14.1
ARG GIT_SHA256=65c12e4959b8874187b68ec37e532fe7fc526e10f6f0f29e699fa1d2449e7d92
ARG DOCKER_VERSION=17.06.0

FROM microsoft/windowsservercore:1709 as builder

ARG JENKINS_SWARM_CLIENT_VERSION
ARG LABELS
ARG EXECUTORS
ARG FSROOT
ARG NODENAMEPREFIX
ARG GIT_VERSION
ARG GIT_SHA256
ARG DOCKER_VERSION

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest $('https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/' + $Env:JENKINS_SWARM_CLIENT_VERSION + '/swarm-client-' + $Env:JENKINS_SWARM_CLIENT_VERSION + '.jar') -OutFile 'swarm-client.jar' -UseBasicParsing ; \
    Invoke-WebRequest -UseBasicParsing $('https://github.com/git-for-windows/git/releases/download/v' + $Env:GIT_VERSION + '.windows.1/MinGit-' + $Env:GIT_VERSION + '-64-bit.zip') -OutFile git.zip; \
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; \
    Expand-Archive git.zip -DestinationPath C:\git; \
    Remove-Item git.zip; \
    Invoke-WebRequest $('https://download.docker.com/win/static/stable/x86_64/docker-' + $Env:DOCKER_VERSION + '-ce.zip') -UseBasicParsing -OutFile docker.zip; \
    Expand-Archive docker.zip -DestinationPath C:\\; \
    Remove-Item -Force docker.zip;

FROM freakingawesome/java:8-nanoserver-1709

MAINTAINER Chad Gilbert <chad.gilbert@cqlcorp.com>

ARG LABELS
ARG EXECUTORS
ARG FSROOT
ARG NODENAMEPREFIX
ARG GIT_VERSION
ARG GIT_SHA256
ARG DOCKER_VERSION

ENV LABELS $LABELS
ENV EXECUTORS $EXECUTORS
ENV FSROOT $FSROOT
ENV NODENAMEPREFIX $NODENAMEPREFIX
ENV GIT_VERSION $GIT_VERSION
ENV GIT_SHA256 $GIT_SHA256
ENV DOCKER_VERSION $DOCKER_VERSION

COPY --from=builder C:\\git C:\\git
COPY --from=builder C:\\docker C:\\docker
COPY --from=builder C:\\swarm-client.jar C:\\swarm-client.jar

RUN setx PATH "C:\\git\\cmd;C:\\git\\mingw64\\bin;C:\\git\\usr\\bin;C:\\docker;%PATH%"

VOLUME C:\\w

CMD [ "cmd", "/C", "C:\\entrypoint.cmd"]
