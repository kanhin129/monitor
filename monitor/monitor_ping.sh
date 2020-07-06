#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
HOST=`hostname`
array_lost=()
array_rtt=()

function get_ping_data() {
    domain=$1
    option=$2
    
    res=`ping -c 3 "$domain" 2>&1`
    
    #檢查ping指令有沒有錯誤
    value=`echo $?`
    
    if [ $value = 0  ]; then
    
        if [ "$opstion" == "lost" ] ; then
            echo $res| grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g'
            
        elif [ "$option" == "rtt" ] ; then
            echo $res| grep rtt | sed 's/^.*=//g'|cut -d "/" -f2
    
        fi
    
    fi
}

while read line; do
    
    #8da3b5b2開頭是沒有開ping的域名
    domain=`echo $line | grep -v '8da3b5b2' |cut -d "," -f1 `
    
    #res=`ping -c 2 "$domain" 2>&1 | grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g' `
    #res=`ping -c 3 "$domain" 2>&1`

    #檢查ping指令有沒有錯誤
    #value=`echo $?`

    #if [ $value = 0  ]; then
        #獲取ping loss 數值
        #lost_value=`echo $res| grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g' `
        lost_value=$(get_ping_data "lost")
        
        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        if [ $lost_value -ge 50 ]; then
            #python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain Pack loss 50%"
            array_lost+=($domain)
        fi
        
        #獲取ping 平均回應時間
        #rtt_value=` echo $res| grep rtt | sed 's/^.*=//g'|cut -d "/" -f2`
        rtt_value=$(get_ping_data "rtt")
        
        #判斷 ping rtt ms 的回傳值,如果>=100則輸出 pack loss 50%
        if [ `echo "$rtt_value > 100" |bc` -eq 1 ];then
            #python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain rtt average over 100ms"
            array_rtt+=($domain)

        fi
    fi
done < $LIST



exit
function level2_check() {
    sleep 10
    check_array=$1
    
    #第二次檢測 level2
    for ((i=0; i<${#array[@]}; i++)); do
        domain=${array[$i]}
        
        #獲取ping loss 數值
        lost_value=`echo $res| grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g' `
        
        #獲取ping 平均回應時間
        rtt_value=` echo $res| grep rtt | sed 's/^.*=//g'|cut -d "/" -f2`
        
        res=`nslookup $domain | grep -i "can't find"`
        if [  -n "$res"  ];then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: $domain Parse error")"
            array2+=($domain)
        fi
    done
}


if [ -n "$array_lost" ]; then
    level2_check($array_lost)
if [ -n "$array_rtt" ]; then
    level2_check($array_rtt)
fi
    



    
    
