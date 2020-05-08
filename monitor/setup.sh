#!/bin/bash

#安裝必要套件

#抓取git目錄位置
git-monitor-location=`pwd`

#寫入排程
echo "*/5 * * * * root $pwd/腳本-1.sh"
echo "*/5 * * * * root $pwd/腳本-2.sh"

