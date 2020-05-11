#!/bin/bash
LIST='./list.txt'

while read line; do 
    
    domain=`echo $line | cut -d "," -f1`
    echo $domain
    res=`nslookup $domain | grep -i "can't find"`
    #判斷 nslookup 回傳值,如果有 grep 到 server can't find 字串,則解析失敗
    if [  -n "$res"  ];then
        echo "$domain Parse error"
    fi

done < $LIST
