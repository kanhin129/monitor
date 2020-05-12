#!/bin/bash
LIST='/opt/manager-tools/monitor/list.txt'
BOT='/opt/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
HOST=`hostname`

while read line; do 
    
    domain=`echo $line | cut -d "," -f1`
    #echo $domain
    res=`nslookup $domain | grep -i "can't find"`
    #判斷 nslookup 回傳值,如果有 grep 到 server can't find 字串,則解析失敗
    if [  -n "$res"  ];then
        python $BOT "$GROUP" "From-${HOST} DNS Error" "$domain Parse error"
    fi

done < $LIST
