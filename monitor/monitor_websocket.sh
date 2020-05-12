#!/bin/bash
LIST='/opt/manager-tools/monitor/socket_list.txt'
BOT='/opt/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
HOST=`hostname`


#wscat -c wss://ws.silverlighting.net/fishingking/lobby -x q

#for line in $(cat $LIST);do
while read line; do
    
    res=`python /opt/manager-tools/monitor/conn_ws.py $line 2>&1 | grep ok`
    if [ "$res" != "ok" ];then
        python $BOT "$GROUP" "From-${HOST} WS Error" "$line"
    fi

done  < $LIST

