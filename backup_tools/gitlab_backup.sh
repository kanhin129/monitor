#!/bin/bash

bk_data_path='/mnt/ebs/fs1/gitlab-docker-compose/gitlab_data/backups'
s3_path='s3://bcowtech-gitlab-backup/gitlab_backup/'
#start_time=`date "+%Y-%m-%d %H:%M:%S"`

gitlab_id=`docker container ps | grep 'gitlab-docker-compose_gitlab_1' | awk '{print $1}'`
bk_name=`docker exec -it $gitlab_id gitlab-rake gitlab:backup:create | grep -E 'tar.*done' |sed  's/^.*: //g' | sed 's/ .*$//g'`

BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
DATE=`date +%F`
GROUP='james-test'


##判斷有沒有備份成功,失敗就發訊息
if [ ! -n "$bk_name"  ];then
    echo 'bk_faile' 
    python $BOT "$GROUP" "$DATE Gitlab backup Faile" ""
    exit

#成功就把備份檔搬移到S3
else
    #end_time=`date "+%Y-%m-%d %H:%M:%S"`
    #duration=`echo  $(($(date +%s -d "${end_time}") - $(date +%s -d "${start_time}"))) \
    # | awk '{t=split("60 s 60 m 24 h 999 d",a);for(n=1;n<t;n+=2){if($1==0)break;s=$1%a[n]a[n+1]s;$1=int($1/a[n])}print s}'`
    #mv to s3
    #mv ${bk_data_pathdd}/${bk_name} $s3_path
    aws s3 mv ${bk_data_pathdd}/${bk_name}  $s3_path
    #python $BOT "$GROUP" "Gitlab backup $DATE Ok" "Duration: $duration"

fi
