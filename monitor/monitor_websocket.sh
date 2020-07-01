#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/socket_list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
#GROUP='james-test'
HOST=`hostname`
tmp_file='/tmp/tmp_ws.txt'
array=()

#wscat -c wss://ws.silverlighting.net/fishingking/lobby -x q

#for line in $(cat $LIST);do
#第一次檢測 level1
while read line; do
    res=`python3 /root/gitlab-project/manager-tools/monitor/conn_ws.py $line 2>&1 | head -n 1 `
    if [ "$res" != "ok" ];then
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Problem: WS Error {{fire}}Level1{{fire}} \nDomain: ${line}\nStatus: ${res}")"
        array+=($line)
    fi
done  < $LIST

#第二次檢測 level2
for ((i=0; i<${#array[@]}; i++)); do
    #echo ${array[$i]}
    ws_domain=${array[$i]}
    res=`python3 /root/gitlab-project/manager-tools/monitor/conn_ws.py $ws_domain 2>&1 | head -n 1 `
    if [ "$res" != "ok" ]; then
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Problem: WS Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: ${ws_domain}\nStatus: ${res}")"
        echo "$ws_domain" >> $tmp_file
    fi
    sleep 3
done

#第三次檢測 level3
while read line; do
    cnt=0
    res=`python3 /root/gitlab-project/manager-tools/monitor/conn_ws.py $line 2>&1 | head -n 1 `
    if [ "$res" != "ok" ];then
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Problem: WS Error {{fire}}{{fire}}{{fire}}Level3{{fire}}{{fire}}{{fire}} \nDomain: ${line}\nStatus: ${res}")"
    fi
done  < $tmp_file

#刪除ws_domain暫存檔
rm -rf $tmp_file
