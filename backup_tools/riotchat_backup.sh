#!/bin/bash

DATA_PATH='/root/matrix-riot-docker/files/homeserver.db'
DIR_NAME=`date +%F`
DATE=`date +%Y%m%d-%H-%M`
S3_PATH='/mnt/s3_bucket/riotchat_backup'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
#GROUP='james-test'
HOST=`hostname`


#判斷資料夾有沒有存在,沒有就創新的
if [ ! -d "$S3_PATH/$DIR" ]; then
    mkdir "$S3_PATH/$DIR_NAME"
    #echo "$S3_PATH/$DIR_NAME"
fi

#判斷備份有沒有成功,失敗就發告警
sqlite3 $DATA_PATH .dump > "$S3_PATH/$DIR_NAME/$DATE-homeserver.sql"

if [ ! -f  "$S3_PATH/$DIR_NAME/$DATE-homeserver.sql" ]; then
    echo "faile"
    python $BOT "$GROUP" "$DATE riotchat backup Faile" ""
fi
