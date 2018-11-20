@echo off
SET OLDPASS=changeme
SET NEWPASS=thisIsALongPassword123
SET CHECKPOINT="%SPLUNK_HOME%\etc\pwd_changed"
IF EXIST %CHECKPOINT% (
@echo on
echo "%date% %time% %HOST%: Splunk account password was already changed."
) ELSE (
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST=%%i
"%SPLUNK_HOME%\bin\splunk.exe" edit user admin -password %NEWPASS% -auth admin:%OLDPASS%
FOR /F %%C in ('find /v /c "" ^< "%SPLUNK_HOME%\var\log\splunk\splunkd.log"') DO SET LINE_COUNT=%%C
SET COUNT=%LINE_COUNT%-10
SET FAILURE=`more +%COUNT% "%SPLUNK_HOME%\var\log\splunk\splunkd.log" | findstr ExecProcessor | findstr Login`
IF EXIST %FAILURE% (
	@echo on
	echo "%date% %time% %HOST%: Splunk account login failed. Old password is not correct for this host"
) ELSE (
echo "%date% %time% %HOST%: Splunk account password successfully changed." > %CHECKPOINT%
@echo on
echo "%date% %time% %HOST%: Splunk account password successfully changed."
	)
)