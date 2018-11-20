#!/bin/bash
# Define the original and new passwords here
OLDPASS=changeme
NEWPASS=thisIsALongPassword123

# Look for the checkpoint file and error out if it exists
if [ -f $SPLUNK_HOME/etc/pwd_changed ]
then
        echo `date -R` $HOSTNAME: Splunk account password was already changed.
        exit
fi

# Change the password
$SPLUNK_HOME/bin/splunk edit user admin -password $NEWPASS -auth admin:$OLDPASS > /dev/null 2>&1

# Check splunkd.log for any error messages relating to login during the script and determine whether the change was successful or not
CHANGED=`tail -n 10 $SPLUNK_HOME/var/log/splunk/splunkd.log | grep pwchange | grep Login`
if [ -z "$CHANGED" ]
then
	echo `date -R` $HOSTNAME: Splunk account password successfully changed.
	echo `date -R` $HOSTNAME: Splunk account password successfully changed. > $SPLUNK_HOME/etc/pwd_changed
else
	echo `date -R` $HOSTNAME: Splunk account login failed. Old password is not correct for this host.
fi
#rm -frv $SPLUNK_HOME/etc/apps/TA_PWChange
