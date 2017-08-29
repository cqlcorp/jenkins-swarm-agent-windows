@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET /p JENKINS_SECRET=<C:\ProgramData\Docker\secrets\jenkins

IF NOT DEFINED LABELS (
    SET LABELS=docker
)

IF NOT DEFINED EXECUTORS (
    SET EXECUTORS=3
)

IF NOT DEFINED FSROOT (
    SET FSROOT=C:\tmp\jenkins
)

IF NOT DEFINED NODENAMEPREFIX (
    SET NODENAMEPREFIX=docker-
)

IF NOT EXIST "%FSROOT%" (
    mkdir "%FSROOT%"
)

cmd /c java -jar swarm-client.jar -labels "%LABELS%" -executors "%EXECUTORS%" -fsroot "%FSROOT%" -name %NODENAMEPREFIX%%COMPUTERNAME% %JENKINS_SECRET% || exit /b

