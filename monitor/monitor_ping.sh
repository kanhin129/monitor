#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
GROUP='BCowtech-alert'
#GROUP='james-test'
HOST=`hostname`
array_lost=()
array_rtt=()
array_lost2=()
array_rtt2=()

function get_ping_data() {
    res=$1
    option=$2
    
    if [ "$option" == "lost" ] ; then
        echo $res| grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g'
            
    elif [ "$option" == "rtt" ] ; then
        echo $res| grep rtt | sed 's/^.*=//g'|cut -d "/" -f2
        
    fi
}

while read line; do
    
    #過濾開頭 8da3b5b2e 的域名
    domain=`echo $line | grep -v '8da3b5b2' |cut -d "," -f1 `
    
    res=`ping -c 3 "$domain" 2>&1`

    #檢查ping指令有沒有錯誤
    value=`echo $?`

    if [ $value = 0  ]; then
        #獲取ping loss 數值
        lost_value=$(get_ping_data "$res" "lost")
        
        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        if [[ $lost_value -ge 50 ]]; then
            #python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain Pack loss 50%"
            array_lost+=($domain)
        fi
        
        #獲取ping 平均回應時間
        rtt_value=$(get_ping_data "$res" "rtt")
        
        #判斷 ping rtt ms 的回傳值,如果>=100則輸出 pack loss 50%
        if [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 100" | bc` -eq 1 ]];then
            #python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain rtt average over 100ms"
            array_rtt+=($domain)
        fi
    fi

done < $LIST


if [ -n "$array_lost" ]; then
    sleep 10
    #sleep 1
    
    #第二次檢測 level2
    for ((i=0; i<${#array_lost[@]}; i++)); do
        domain=${array_lost[$i]}
        res=`ping -c 3 "$domain" 2>&1`
        
        #獲取ping loss 數值
        lost_value=$(get_ping_data "$res" "lost")
        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        if [[ $lost_value -ge 50 ]]; then
        #if [[ $lost_value -ge 0 ]]; then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: ${domain}\n Status: Pack loss 50%")"
            array_lost2+=($domain)
        fi

    done

fi

if [ -n "$array_rtt" ]; then
    sleep 10
    #sleep 1

    #第二次檢測 level2
    for ((i=0; i<${#array_rtt[@]}; i++)); do
        domain=${array_rtt[$i]}
        res=`ping -c 3 "$domain" 2>&1`
    	
    	#獲取ping 平均回應時間
        rtt_value=$(get_ping_data "$res" "rtt")
        #判斷 ping rtt ms 的回傳值,如果>=100則輸出 pack loss 50%
        if [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 100" | bc` -eq 1 ]];the
        #if [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 0" | bc` -eq 1 ]];then
             python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: ${domain}\n Status: average over 100ms")"
            array_rtt2+=($domain)
        fi
    done
fi
    

if [ -n "$array_lost2" ]; then
    sleep 30
    #sleep 3
    
    #第三次檢測 level3
    for ((i=0; i<${#array_lost2[@]}; i++)); do
        domain=${array_lost2[$i]}
        res=`ping -c 3 "$domain" 2>&1`
        
        #獲取ping loss 數值
        lost_value=$(get_ping_data "$res" "lost")
        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        if [[ $lost_value -ge 50 ]]; then
        #if [[ $lost_value -ge 0 ]]; then
            python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}{{fire}}Level3{{fire}}{{fire}}{{fire}}  \nDomain: ${domain}\n Status: Pack loss 50%")"
        fi

    done
fi

if [ -n "$array_rtt2" ]; then
    sleep 30
    #sleep 3

    #第三次檢測 level3
    for ((i=0; i<${#array_rtt2[@]}; i++)); do
        domain=${array_rtt2[$i]}
        res=`ping -c 3 "$domain" 2>&1`
    	
    	#獲取ping 平均回應時間
        rtt_value=$(get_ping_data "$res" "rtt")
        #判斷 ping rtt ms 的回傳值,如果>=100則輸出 pack loss 50%
        if [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 100" | bc` -eq 1 ]];the
        #if [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 0" | bc` -eq 1 ]];then
             python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}{{fire}}Level3{{fire}}{{fire}}{{fire}}  \nDomain: ${domain}\n Status: average over 100ms")"
        fi
    done
fi
