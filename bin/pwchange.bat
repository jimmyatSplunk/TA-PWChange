@echo off
REM Define the original and new passwords here
SET OLDPASS=changeme
SET NEWPASS=veryLongPassword1234

REM Other variables relating to the checkpoint file and the path to test login and hostname for logging
SET CHECKPOINT=%SPLUNK_HOME%\etc\pwd_changed
SET LOGIN_COMMAND="%SPLUNK_HOME%\bin\splunk.exe" login -auth admin:"%OLDPASS%"
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST=%%i

REM Look for the checkpoint file and decide to error or continue
IF EXIST "%CHECKPOINT%" (
	goto NOCHANGE
) ELSE (
	goto CHANGE
)

REM Test logging in and if it fails throw error otherwise change the password
:CHANGE
FOR /F "tokens=2 usebackq" %%C in (`"%LOGIN_COMMAND%"`) DO SET LOGIN=%%C
IF NOT "%LOGIN%"=="Failed" ( 
"%SPLUNK_HOME%\bin\splunk.exe" edit user admin -password "%NEWPASS%" >NUL
) ELSE (
	goto FAILED
)

REM Create the checkpoint file and log success
:SUCCESS
echo %date% %time% %HOST%: Splunk account password successfully changed. > "%CHECKPOINT%"
echo %date% %time% %HOST%: Splunk account password successfully changed.
exit

REM Log failure
:FAILED
echo %date% %time% %HOST%: Splunk account login failed. Old password is not correct for this host.
exit

REM Log that the checkpoint file exists
:NOCHANGE
echo %date% %time% %HOST%: Splunk account password was already changed.
exit

