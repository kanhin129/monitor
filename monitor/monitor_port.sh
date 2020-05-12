#!/bin/bash
LIST='/opt/manager-tools/monitor/list.txt'
BOT='/opt/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
HOST=`hostname`

while read line; do
    cnt=0
    domain=`echo $line |cut -d "," -f1`
    port=`echo $line |cut -d "," -f2`
    
    #進行3次掃描
    for i in {1..3};do
        res=`nc -v -z -w 3 "$domain" "$port" > /dev/null 2>&1 && echo "Online" || echo "Offline"`

        #判斷回傳值如果是Offline則計數器+1
        if [ "$res" = "Offline" ];then
           cnt=$((cnt+1))
           #echo $cnt
        fi
    done
    #如果掃描掃有兩次是offline則輸出Error           
    if [ "$cnt" -ge 2  ];then
            python $BOT "$GROUP" "From-${HOST} Port Error" "$domain : $port is down"
    fi
done < $LIST
