#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
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
        array+=($line)
    fi
done < $LIST

sleep 10

#第二次檢測 level2
for ((i=0; i<${#array[@]}; i++)); do
    domain=${array[$i]}
    res=`nslookup $domain | grep -i "can't find"`
    if [  -n "$res"  ];then
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "DNS Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: "$domain Parse error")"
        echo "$ws_domain" >> $tmp_file
        array2+=($ws_domain)
    fi
done

#第三次檢測 level3
for((i=0; i<${#array2[@]}; i++)); do
    domain=${array2[$i]}
    res=`nslookup $domain | grep -i "can't find"
    if [  -n "$res"  ];then
        ppython $BOT "$GROUP" "From-${HOST}" "$(echo -e "DNS Error {{fire}}{{fire}}{{fire}}Leve3{{fire}}{{fire}}{{fire}}  \nDomain: "$domain Parse error")"
    fi
done