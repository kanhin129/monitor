#!/bin/bash
LIST='/root/gitlab-project/manager-tools/monitor/list.txt'
BOT='/root/gitlab-project/manager-tools/python_bot/zbxtg_group.py'
#GROUP='BCowtech-alert'
GROUP='james-test'
HOST=`hostname`
array_lost=()
array_lost2=()
array_rtt=()
array_rtt2=()

function get_ping_data() {
    domain=$1
    option=$2
    
    #res=`ping -c 3 "$domain" 2>&1`
    res=`ping -c 1 "$domain" 2>&1`
    
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
    
    #過濾8da3b5b2的域名
    domain=`echo $line | grep -v '8da3b5b2' |cut -d "," -f1 `

    #if [ $value = 0  ]; then
        #獲取ping loss 數值
        #lost_value=`echo $res| grep packets | cut -d "," -f 3 |  cut -d " " -f 2  | sed 's/%//g' `
        lost_value=$(get_ping_data "$domain" "lost")

        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        #if [[ $lost_value -ge 50 ]]; then
        if [[ $lost_value -ge 0 ]]; then
            #python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain Pack loss 50%"
            array_lost+=($domain)
        fi
        
        #獲取ping 平均回應時間
        #rtt_value=` echo $res| grep rtt | sed 's/^.*=//g'|cut -d "/" -f2`
        rtt_value=$(get_ping_data "$domain" "rtt")
        echo "rtt value: $domain "," $rtt_value" 
        #判斷 ping rtt ms 的回傳值,如果>=100則輸出 rtt average over 100ms 
        #if  [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 100" | bc` -eq 1 ]];then
        if  [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 0" | bc` -eq 1 ]];then
            #python $BOT "$GROUP" "From-${HOST} Ping Error" "$domain rtt average over 100ms"
            array_rtt+=($domain)

        fi

done < $LIST



function level2_check() {
    level=$1
    check_array=$2
    if [ "$level" == 'L2' ];then
        sleep 10
    elif [ "$level" == 'L3' ];then
        sleep 30
    fi

    #第二次檢測 level2
    for ((i=0; i<${#check_array[@]}; i++)); do
        domain=${check_array[$i]}
        
        #獲取ping loss 數值
        lost_value=$(get_ping_data "$domain" "lost")

        #判斷 ping pack loss 的回傳值,如果>=50則輸出 pack loss 50%
        #if [[ $lost_value -ge 50 ]]; then
        if [[ $lost_value -ge 0 ]]; then
            
            array_lost2+=($domain)
            echo "err"
        fi
        
        rtt_value=$(get_ping_data "$domain" "rtt")
        #獲取ping 平均回應時間
        #if  [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 100" | bc` -eq 1 ]];then
        if  [[ -n "$rtt_value" ]] &&  [[ `echo "$rtt_value > 0" | bc` -eq 1 ]];then
            
            array_rtt2+=($domain)
            echo "err"
        fi

    done
}

if [ -n "$array_lost" ]; then
    return=$(value_check "L2" "$array_lost")
    if [ "$return" == 'err' ];
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: ${domain}\n Status: Pack loss 50%")"
    fi

elif [ -n "$array_rtt" ]; then
    return=$(value_check "L3" "$array_rtt")
    if [ "return" == 'err' ]
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}Level2{{fire}}{{fire}}  \nDomain: ${domain}\n Status: average over 100ms")"
    fi
    
elif [ -n "$array_rtt2" ]; then
    return=$(value_check "L3" "$array_rtt")
    if [ "return" == 'err' ]
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}{{fire}}Level2{{fire}}{{fire}}{{fire}}  \nDomain: ${domain}\n Status: average over 100ms")"
    fi
    
elif [ -n "$array_rtt2" ]; then
    return=$(value_check "L3" "$array_rtt")
    if [ "return" == 'err' ]
        python $BOT "$GROUP" "From-${HOST}" "$(echo -e "Ping Error {{fire}}{{fire}}{{fire}}Level2{{fire}}{{fire}}{{fire}}  \nDomain: ${domain}\n Status: average over 100ms")"
    fi

fi
    

