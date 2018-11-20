#!/bin/bash

OLDPASS=changeme
NEWPASS=thisIsALongPassword123

if [ -f $SPLUNK_HOME/etc/pwd_changed ]
then
        echo `date -R` $HOSTNAME: Splunk account password was already changed.
        exit
fi
$SPLUNK_HOME/bin/splunk edit user admin -password $NEWPASS -auth admin:$OLDPASS
CHANGED=`tail -n 10 $SPLUNK_HOME/var/log/splunk/splunkd.log | grep ExecProcessor | grep Login`
if [ -z "$CHANGED" ]
then
	echo `date -R` $HOSTNAME: Splunk account password successfully changed.
	echo `date -R` $HOSTNAME: Splunk account password successfully changed. > $SPLUNK_HOME/etc/pwd_changed
else
	echo `date -R` $HOSTNAME: Splunk account login failed. Old password is not correct for this host.
fi
#rm -frv $SPLUNK_HOME/etc/apps/TA_PWChange