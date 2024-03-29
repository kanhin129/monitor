#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/socket_list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
#GROUP='james-test'
HOST=`hostname`
array=()
array2=()

#wscat -c wss://ws.silverlighting.net/fishingking/lobby -x q

#第一次檢測 level1
while read line; do
    res=`python3 /root/gitlab-project/manager-tools/monitor/conn_ws.py $line 2>&1 | head -n 1 `
    if [ "$res" != "ok" ];then
        #python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Problem: WS Error {{fire}}Level1{{fire}} \nDomain: ${line}\nStatus: ${res}")"
        array+=($line)
    fi
done  < $LIST

#判斷arrya是否為空,有值才繼續執行
if [ -n "$array" ];then

    sleep 10
    
    #第二次檢測 level2
    for ((i=0; i<${#array[@]}; i++)); do
        ws_domain=${array[$i]}
        res=`python3 /root/gitlab-project/manager-tools/monitor/conn_ws.py $ws_domain 2>&1 | head -n 1 `
        if [ "$res" != "ok" ]; then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Problem: WS Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: ${ws_domain}\nStatus: ${res}")"
            array2+=($ws_domain)
        fi
    done
fi

#判斷arrya2是否為空,有值才繼續執行
if [ -n "$array2" ];then

    sleep 30
    
    #第三次檢測 level3
    for((i=0; i<${#array2[@]}; i++)); do
        ws_domain=${array2[$i]}
        #while read line; do
        res=`python3 /root/gitlab-project/manager-tools/monitor/conn_ws.py $ws_domain 2>&1 | head -n 1 `
        if [ "$res" != "ok" ];then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Problem: WS Error {{fire}}{{fire}}{{fire}}Level3{{fire}}{{fire}}{{fire}} \nDomain: ${ws_domain}\nStatus: ${res}")"
        fi
    done
fi