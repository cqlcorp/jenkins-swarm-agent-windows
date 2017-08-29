# escape=`
FROM openjdk:8-windowsservercore

MAINTAINER Chad Gilbert <chad.gilbert@cqlcorp.com>

ARG JENKINS_SWARM_CLIENT_VERSION=3.4

RUN powershell -Command Invoke-WebRequest $('https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/' + $Env:JENKINS_SWARM_CLIENT_VERSION + '/swarm-client-' + $Env:JENKINS_SWARM_CLIENT_VERSION + '.jar') -OutFile 'swarm-client.jar' -UseBasicParsing ;

COPY entrypoint.cmd C:\entrypoint.cmd

CMD [ "cmd", "/C", "entrypoint.cmd"]
