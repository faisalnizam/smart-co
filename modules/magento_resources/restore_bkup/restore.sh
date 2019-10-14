#! /bin/bash

DBHOSTNAME=$1

tar zxvf ../../../restore_from_backup/sprii-backup.sql.tar.gz

 mysql -h ${DBHOSTNAME} -u magento --all-databases -pUPLARDhjGAWvd3KB9JrV7A < sprii-backup.sql
