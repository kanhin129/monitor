#!/bin/bash


script_path='/opt/manager-tools/monitor'

#安裝git
function SystemName() {
    source /etc/os-release
    case $ID in
        centos|fedora|rhel)
            yum install -y nc bc nodejs git
            npm install -g wscat
            npm install -g n
            ;;

        debian|ubuntu|devuan)
            apt install -y nc bc nodejs
            npm install -g wscat
            npm install -g
            ln -s /usr/local/bin/wscat /usr/bin/
            ;;
        *)
            exit 1
            ;;
    esac
}

#執行安裝指令
SystemName

echo "*/5 * * * * root ${script_path}/monitor_dns.sh" >> /etc/crontab
echo "*/5 * * * * root ${script_path}/mmonitor_ping.sh" >> /etc/crontab
echo "*/5 * * * * root ${script_path}/monitor_port.sh" >> /etc/crontab
echo "*/5 * * * * root ${script_path}/monitor_websocket.sh" >> /etc/crontab

