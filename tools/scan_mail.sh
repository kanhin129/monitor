#!/bin/bash

array=()
#取得email
email=`sqlite3 /root/matrix-riot-docker/files/homeserver.db  "select * from  user_threepids;" | grep "bcow" | cut -d "|" -f3`

#切割字串獲取名稱
user=`echo "$email" |cut -d "@" -f1`
array+=($user)

for ((i=0; i<${#array[@]}; i++)); do
    #echo ${array[$i]}
    #執行停權
    python update_user_status.py "off" ${array[$i]}
done

