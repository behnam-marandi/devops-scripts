#!/bin/bash

# Find back ups older than 7 days and delete them
find /home/backup/db_backups/ -name "*.gz" -type f -mtime +7 -delete

# Enter the details for the MYSQL user you want to use below:
PASSWD=;
USER=;
DB=;
# Get the correct paths to use for the binaries we want to use:
MYSQL=`which mysql`;MYSQLDUMP=`which mysqldump`;GZIP=`which gzip`;TAR=`which tar`;
LOCATION='/home/backup/db_backups';
TEMP='/individual_backups';
# Does our backup Dir exist
if [ ! -d $LOCATION ]; then
	mkdir $LOCATION
fi
#Does our temporary backup location exist? - probably won't
if [ ! -d $LOCATION$TEMP ]; then
        mkdir $LOCATION$TEMP
fi
 
# Dump & gzip
$MYSQLDUMP -u$USER --password=$PASSWD $DB | $GZIP &gt; $LOCATION$TEMP/$db\_`date +\%d\%m\%y-%H%M`.sql.gz

# Now create tar of the whole backups dir! - removing the individual gz files
cd $LOCATION$TEMP
$TAR -zc --remove-files -f ../db_backups_`date +\%d\%m\%y-\%H\%M`.tar.gz *
cd $LOCATION
rm -Rf .$TEMP
