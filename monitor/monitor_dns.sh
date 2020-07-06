#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
#GROUP='james-test'
HOST=`hostname`
array=()
array2=()

#第一次檢測 level1
while read line; do
    domain=`echo $line | cut -d "," -f1`
    res=`nslookup $domain | grep -i "can't find"`
    #判斷 nslookup 回傳值,如果有 grep 到 server can't find 字串,則解析失敗
    if [  -n "$res"  ];then
        #python $BOT "$GROUP" "From-${HOST} DNS Error" "$domain Parse error"
        array+=($domain)
    fi
done < $LIST

#判斷arrya是否為空,有值才繼續執行
if [ -n "$array" ];then
    sleep 10

    #第二次檢測 level2
    for ((i=0; i<${#array[@]}; i++)); do
        domain=${array[$i]}
        res=`nslookup $domain | grep -i "can't find"`
        if [  -n "$res"  ];then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "DNS Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: $domain Parse error")"
            array2+=($domain)
        fi
    done
fi

#判斷arrya2是否為空,有值才繼續執行
if [ -n "$array2" ];then
    sleep 30

    #第三次檢測 level3
    for ((i=0; i<${#array2[@]}; i++)); do
        domain=${array2[$i]}
        res=`nslookup $domain | grep -i "can't find"`
        if [  -n "$res"  ];then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "DNS Error {{fire}}{{fire}}{{fire}}Level3{{fire}}{{fire}}{{fire}}  \nDomain: $domain Parse error")"
        fi
    done
fi
