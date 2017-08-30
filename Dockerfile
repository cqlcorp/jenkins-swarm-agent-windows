FROM openjdk:8-nanoserver

MAINTAINER Chad Gilbert <chad.gilbert@cqlcorp.com>

ARG JENKINS_SWARM_CLIENT_VERSION=3.4

ENV LABELS=docker \
    EXECUTORS=3 \
    FSROOT=C:\w \
    NODENAMEPREFIX=docker- \
    GIT_VERSION=2.14.1 \
    GIT_SHA256=65c12e4959b8874187b68ec37e532fe7fc526e10f6f0f29e699fa1d2449e7d92 \
    DOCKER_VERSION=17.06.0

VOLUME C:\\w

RUN $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'SilentlyContinue' ;\
    Invoke-WebRequest $('https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/' + $Env:JENKINS_SWARM_CLIENT_VERSION + '/swarm-client-' + $Env:JENKINS_SWARM_CLIENT_VERSION + '.jar') -OutFile 'swarm-client.jar' -UseBasicParsing ; \
    Invoke-WebRequest -UseBasicParsing $('https://github.com/git-for-windows/git/releases/download/v' + $Env:GIT_VERSION + '.windows.1/MinGit-' + $Env:GIT_VERSION + '-64-bit.zip') -OutFile git.zip; \
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; \
    Expand-Archive git.zip -DestinationPath C:\git; \
    Remove-Item git.zip; \
    Invoke-WebRequest $('https://download.docker.com/win/static/stable/x86_64/docker-' + $Env:DOCKER_VERSION + '-ce.zip') -UseBasicParsing -OutFile docker.zip; \
    Expand-Archive docker.zip -DestinationPath C:\\; \
    Remove-Item -Force docker.zip; \
    Write-Host 'Updating PATH ...'; \
    $env:PATH = 'C:\\git\\cmd;C:\\git\\mingw64\\bin;C:\\git\\usr\\bin;C:\\docker;' + $env:PATH; \
    Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\\' -Name Path -Value $env:PATH

COPY entrypoint.cmd C:\\entrypoint.cmd

CMD [ "cmd", "/C", "C:\\entrypoint.cmd"]
