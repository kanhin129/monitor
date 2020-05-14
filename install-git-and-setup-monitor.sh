#!/bin/bash


script_path='/opt/manager-tools/monitor'

#安裝git
function SystemName() {
    source /etc/os-release
    case $ID in
        centos|fedora|rhel)
            yum install epel-release
            yum install -y nc bc nodejs git vim bind-utils
            npm install -g wscat
            #安装n
            npm install -g n
            # 安装nodejs版本
            n latest
            #安裝pip
            yum install -y python-pip
            #安裝python requests
            pip install requests websocket_client
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
#SystemName

echo "*/5 * * * * root ${script_path}/monitor_dns.sh" >> /etc/crontab
echo "*/5 * * * * root ${script_path}/mmonitor_ping.sh" >> /etc/crontab
echo "*/5 * * * * root ${script_path}/monitor_port.sh" >> /etc/crontab
echo "*/5 * * * * root ${script_path}/monitor_websocket.sh" >> /etc/crontab

