#!/bin/bash
cd /home/centos
##參數1 2d or 3d
##參數2 路徑加檔案名
option=$1
#version=`echo $2 | cut -d "/" -f4 | cut -d "." -f1`
version=`echo $2 | cut -d "." -f1`
path_list='/root/gitlab-project/manager-tools/tools/path_list.txt'
zip_path='/home/centos'
array=()

##color
RED='\033[0;32;31m'
GREEN='\033[0;32;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

function update() {
    ##丟進來的$1等於list的每一行
    data=$1
    ##擷取 path 字串
	path=`echo $data | cut -d ',' -f1`
    ##擷取2d or 3d 字串
	value=`echo $data | cut -d ',' -f2`
    ##擷取地區字串
	location=`echo $data | cut -d ',' -f3`
    ##擷取裝置字串
	device=`echo $data | cut -d ',' -f4`
    echo "ll $path"
    
    ##刪除舊檔案
	printf "${RED}Delete $option $location $device ${NC} \n"
	rm -rf ${path}/*
    
    ##複製檔案
	printf "${YELLOW}Copying  $option $location $device ${NC} \n"
  	cp -r /home/centos/${version}/desktop/* ${path}

    ##完成
    printf "${GREEN}Copy complete $option $location $device${NC} \n\n"
}

##判斷option version 有沒有輸入,任一個沒輸入就跳出
if [ ! -n "$option" ] || [ ! -n "$version" ]; then
    echo "Not input option or version"
	exit 1

##判斷option
elif [ "$option" == "2d" ]; then
    ##解壓縮
    tar xf "$zip_path/$version.zip"  
    
    if [ -d "$version" ]; then

        ##根據option 抓取 list 清單,並加入array
	    path=`cat $path_list | grep $option`
        array+=($path)

        for ((i=0; i<${#array[@]}; i++)); do
            update ${array[$i]}

        done
        echo "2D Down"

        ##刪除解壓縮後的檔案
        rm -rf "$version"

    else
        echo "File parse error"
    fi
    

##判斷option                    
elif [ "$option" == "3d" ]; then
    ##解壓縮,3D版本因為檔名多3D兩個字,解出來的檔名又少了3D兩個字,所以用下ˋ面的方式重新定義
    version=`tar xvf "$zip_path/$version.zip" | tail -n 1 | cut -d "/" -f1`

    if [ -d "$version" ]; then
        ##根據option 抓取 list 清單,並加入array
        path=`cat $path_list | grep $option`
        array+=($path)

        for ((i=0; i<${#array[@]}; i++)); do
            update ${array[$i]}
 
        done
        echo "3D Down"      

        ##刪除解壓縮後的檔案                                                             
        rm -rf "$version"

    else
        echo "File parse error"
    fi


else
    echo "Input Error"
    exit 1
fi
