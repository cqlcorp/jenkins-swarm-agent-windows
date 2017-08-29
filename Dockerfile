# escape=`
FROM openjdk:8-nanoserver

MAINTAINER Chad Gilbert <chad.gilbert@cqlcorp.com>

ARG JENKINS_SWARM_CLIENT_VERSION=3.4

ENV LABELS=docker EXECUTORS=3 FSROOT=C:\tmp\jenkins NODENAMEPREFIX=docker-

VOLUME C:\tmp

RUN powershell -Command Invoke-WebRequest $('https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/' + $Env:JENKINS_SWARM_CLIENT_VERSION + '/swarm-client-' + $Env:JENKINS_SWARM_CLIENT_VERSION + '.jar') -OutFile 'swarm-client.jar' -UseBasicParsing ;

COPY entrypoint.cmd C:\entrypoint.cmd

CMD [ "cmd", "/C", "entrypoint.cmd"]
