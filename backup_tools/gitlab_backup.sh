#!/bin/bash

bk_data_path='/mnt/ebs/fs1/gitlab-docker-compose/gitlab_data/backups'
s3_path='s3://bcowtech-gitlab-backup/gitlab_backup/'
#start_time=`date "+%Y-%m-%d %H:%M:%S"`

gitlab_id=`docker container ps | grep 'gitlab-ee:12.8.2-ee.0' | awk '{print $1}'`
bk_name=`docker exec -i $gitlab_id gitlab-rake gitlab:backup:create | grep -E 'tar.*done' |sed  's/^.*: //g' | sed 's/ .*$//g'`

BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
DATE=`date +%F`
#GROUP='james-test'
GROUP='BCowtech-alert'
HOST=`hostname`


##判斷有沒有備份成功,失敗就發訊息
if [ ! -n "$bk_name"  ];then
    echo 'bk_faile' 
    python $BOT "$GROUP" "$DATE Gitlab backup Faile" ""
    exit

#成功就把備份檔搬移到S3
else
    #end_time=`date "+%Y-%m-%d %H:%M:%S"`
    #計算開始和結束時間
    #duration=`echo  $(($(date +%s -d "${end_time}") - $(date +%s -d "${start_time}"))) \
    # | awk '{t=split("60 s 60 m 24 h 999 d",a);for(n=1;n<t;n+=2){if($1==0)break;s=$1%a[n]a[n+1]s;$1=int($1/a[n])}print s}'`
    #使用 aws-cli 搬移備份檔案到 s3
    /root/.local/bin/aws s3 mv "$bk_data_path/$bk_name  $s3_path"
    #執行完成發送成功訊息以及執行所花的時間
    #python $BOT "$GROUP" "Gitlab backup $DATE Ok" "Duration: $duration"

fi
