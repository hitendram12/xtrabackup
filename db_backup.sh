#!/bin/bash
BACKUP=/home/hiten/DB-BAK/
MUSER="samco_user"
MPASS="samco123456"
MHOST="192.168.5.73"
GZIP="$(which gzip)"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
NOW=$(date +"%d-%m-%Y")
mkdir $BACKUP/$NOW
DBS=`cat dblist.txt`
for db in $DBS
do
        mkdir $BACKUP/$NOW/$db
        for i in `echo "show tables" | $MYSQL -u $MUSER -h $MHOST -p$MPASS $db|grep -v Tables_in_`;
  do
    FILE=$BACKUP/$NOW/$db/$i.sql.gz
    echo $i; $MYSQLDUMP  --add-drop-table --allow-keywords --column-statistics=0 --single-transaction --quick -q -c -u $MUSER -h $MHOST -p$MPASS $db $i | $GZIP -9 > $FILE
  done
done
