@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET /p JENKINS_SECRET=<C:\ProgramData\Docker\secrets\jenkins

cmd /c java -jar swarm-client.jar -labels "%LABELS%" -executors "%EXECUTORS%" -fsroot "%FSROOT%" -name %NODENAMEPREFIX%%COMPUTERNAME% %JENKINS_SECRET% || exit /b

