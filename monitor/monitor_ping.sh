#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
HOST=`hostname`

while read line; do
    
    #8da3b5b2開頭是沒有開ping的域名
    domain=`echo $line | grep -v '8da3b5b2' |cut -d "," -f1 `
    echo $domain
    
    #res=`ping -c 2 "$domain" 2>&1 | grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g' `
    res=`ping -c 1 "$domain" 2>&1`

    #檢查ping指令有沒有錯誤
    value=`echo $?`

    if [ $value = 0  ]; then
        lost_value=`echo $res| grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g' `
        rtt_value=` echo $res| grep rtt | sed 's/^.*=//g'|cut -d "/" -f2`
        #echo $rtt_value
        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        if [ $lost_value -ge 50 ]; then
            python $BOT "$GROUP" "Ping Error" "$domain Pack loss 50%"
        fi

        #判斷 ping rtt ms 的回傳值,如果>=100則輸出 pack loss 50%
        if [ `echo "$rtt_value > 100" |bc` -eq 1 ];then
            python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain rtt average over 100ms"

        fi
    fi

done < $LIST
