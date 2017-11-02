@ECHO OFF
SETLOCAL EnableDelayedExpansion


IF NOT DEFINED LABELS (
    SET LABELS=docker
)

IF NOT DEFINED EXECUTORS (
    SET EXECUTORS=3
)

IF NOT DEFINED FSROOT (
    SET FSROOT=C:\w
)

IF NOT DEFINED NODENAMEPREFIX (
    SET NODENAMEPREFIX=docker-
)

IF NOT DEFINED JENKINS_PASSWORD (
    SET /p JENKINS_PASSWORD=< C:\ProgramData\Docker\secrets\jenkins-agent-password
)

cmd /c java -jar swarm-client.jar -labels "%LABELS%" -executors "%EXECUTORS%" -fsroot "%FSROOT%" -name "%NODENAMEPREFIX%%COMPUTERNAME%" -disableClientsUniqueId -master "%JENKINS_URL%" -sslFingerprints "%JENKINS_SSL_FINGERPRINTS%" -username "%JENKINS_USERNAME%" -passwordEnvVariable JENKINS_PASSWORD || exit 1 /b

