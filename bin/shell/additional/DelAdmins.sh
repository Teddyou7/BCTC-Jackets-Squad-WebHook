#!/bin/bash
#DelAdmins.sh
#权限自动清理系统
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

# 处理文件的函数
process_file() {
    local file=$1
    local update_remote_admin_list=$2
    local steamid_array=(`cat $file`)

    local counter=0
    local steamid_sum=${#steamid_array[@]}

    while [ $counter -lt $steamid_sum ]
    do
        local steamid_player=`echo ${steamid_array[$counter]} | awk -F ':' '{print $1}'`
        local book_time_stamp=`echo ${steamid_array[$counter]} | awk -F ':' '{print $2}'`
        local date_time_stamp=`date +%s`

        if [ $date_time_stamp -gt $book_time_stamp ]; then
            sed -i "/${steamid_player}/d" $file
            if [ "$update_remote_admin_list" = "yes" ]; then
                sed -i "/${steamid_player}/d" $RemoteAdminList
            fi
        fi

        counter=$((counter+1))
    done
}

# 定期处理两个文件
while true; do
    # 处理 ReservedUserInfo 文件
    process_file $ReservedUserInfo "yes"

    # 处理 SignVIPUserInfo 文件
    process_file $SignVIPUserInfo "no" # 或 "yes"，取决于是否在 $RemoteAdminList 中删除这个 steamid

    sleep 600
done
