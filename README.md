1. install-git-and-setup-monitor.sh:初始化腳本,安裝所需要的套件

2. backup_tools:備份使用的腳本
  - gitlab_backup.sh: gitlab 備份腳本
  - riotchat_backup.sh: 聊天系統的數據庫備份腳本

3. monitor:監控使用的腳本
  - conn_ws.py:連線websocket的程式
  - monitor_dns.sh:監控dns的腳本,須給入域名參數
    e.g. ./monitor_dns.sh domain.com
  - monitor_ping.sh:監控ping的腳本,須給入域名參數
    e.g. ./monitor_ping.sh domain.com
  - monitor_port.sh:監控port的腳本,須給入域名和port參數
    e.g. ./monitor_port.sh domain.com 443
  - monitor_websocket.sh:監控websocket的腳本,透過conn_ws.py建立連線,須給入域名參數
    e.g. ./monitor_websocket.sh wss://domain.com
  - socket_list.txt:websocket的域名清單
  - list.txt:dns,ping,port的清單

4. tools:其他用途的腳本
  - scan_mail.sh:用來掃描聊天系統email的腳本
  - update_user_status.py:用來更改帳戶停權或復原的腳本,須給入兩個參數, 1是off(停權)或on(復原),2是帳號名稱
    e.g. ./update_user_status.py on name (恢復)
         ./update_user_status.py off name (停權)
           
5. python_bot:Telegram機器人
  - zbxtg_group.py:TG發送到群組的程式
    e.g. ./zbxtg_group.py group-name subject content
  - zbxtg.py:TG發送到個人的程式
    e.g. ./zbxtg.py @name subject content
  - zbxtg_settings.py:TG Token設定檔案

