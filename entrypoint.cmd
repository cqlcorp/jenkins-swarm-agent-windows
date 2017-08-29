@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET /p JENKINS_SECRET=<C:\ProgramData\Docker\internal\secrets\jenkins

IF "%LABELS%" == "" (
    SET LABELS=docker
)

IF "%EXECUTORS%" == "" (
    SET EXECUTORS=3
)

IF "%FSROOT%" == "" (
    SET FSROOT=C:\tmp\jenkins
)

IF "%NODENAMEPREFIX%" == "" (
    SET NODENAMEPREFIX=docker-
)

IF NOT EXIST "%FSROOT%" (
    mkdir "%FSROOT%"
)

cmd /c java -jar swarm-client.jar -labels "%LABELS%" -executors "%EXECUTORS%" -fsroot "%FSROOT%" -name %NODENAMEPREFIX%%COMPUTERNAME% %JENKINS_SECRET% || exit /b

