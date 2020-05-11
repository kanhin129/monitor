#!/bin/bash

LIST='./socket_list.txt'
#wscat -c wss://ws.silverlighting.net/fishingking/lobby -x q

for line in $(cat $LIST);do
    res=`wscat -c "$line" -x q`
 
    #檢查 wscat 執行後有沒有錯誤
    value=`echo $?`
    if [ $value -ne 0 ];then
        echo "$line Error"
    fi

done

