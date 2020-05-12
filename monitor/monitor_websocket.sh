#!/bin/bash
LIST='/opt/manager-tools/monitor/socket_list.txt'
BOT='/opt/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'


#source /root/.bashrc

#wscat -c wss://ws.silverlighting.net/fishingking/lobby -x q

for line in $(cat $LIST);do
#while read line; do
    #echo $line >> /tmp/log.txt
    echo $line
    #echo "/usr/local/bin/wscat -c "$line" -x q" >> /tmp/log.txt
    #res=`/usr/local/bin/wscat -c "$line" -x q `
    res=`/usr/local/bin/wscat -c "$line" -x q`
    #amos=`ls -la /usr/local/bin/wscat`
    #echo $res >> /tmp/log.txt
    echo $res >> /tmp/log.txt
    #echo $?
    #檢查 wscat 執行後有沒有錯誤
    #statu=`echo $?`
    #echo $statu >> /tmp/log.txt
    #echo $value >> /tmp/log.txt
    
    #if [[ -n $res  ]];then
    #if [ `echo $?` != 0 ];then
    if [ $statu != 0 ];then
        python $BOT "$GROUP" "WS Error" "$line"
    fi

done 

