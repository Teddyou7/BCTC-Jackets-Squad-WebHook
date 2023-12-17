#!/bin/bash
# 积分增加和预留位续费集中接口
# UserQuotaAllocation.sh
# 传入参数 $1 steamid $2 增加时间戳或积分数额 $3 增加模式{1=增加积分}{2=增加预留位时间戳}{3=增加签到特权时间戳}

steamid=$1
quota=$2
addmode=$3

# 加载配置文件
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

# 更新用户信息的函数
updateUserInfo() {
    local userInfoFile=$1
    local steamid=$2
    local quota=$3
    local useTimeStamp=$4  # 是否基于当前时间戳计算 yes or no
    local userExists=`cat $userInfoFile | grep $steamid | wc -l`
	local currentRemaining=`cat $userInfoFile | grep $steamid | awk -F \: '{print $2}'`
	
    if [ $userExists -eq 1 ]; then
        local added=$quota
		added=`expr $currentRemaining + $quota`
        sed -i "/${steamid}/d" $userInfoFile
        echo "${steamid}:${added}" >> $userInfoFile
    else
        local added=$quota
        if [ "$useTimeStamp" = "yes" ]; then
            local timeStamp=`date +%s`
            added=`expr $timeStamp + $quota`
        fi
        echo "${steamid}:${added}" >> $userInfoFile
    fi
}

# 根据不同模式处理
case $addmode in
    1)
        # 增加积分
        updateUserInfo $PointsUserInfo $steamid $quota "no"
        ;;
    2)
        # 增加预留位时间戳
        if [ `cat $ReservedUserInfo | grep $steamid | wc -l` -eq 0 ]; then
            echo "Admin=${steamid}:BCTC-Auto-Res" >> $RemoteAdminList
        fi
        updateUserInfo $ReservedUserInfo $steamid $quota "yes"
        ;;
    3)
        # 增加签到特权时间戳
        updateUserInfo $SignVIPUserInfo $steamid $quota "yes"
        ;;
    *)
        # 其他模式
        # 根据需求可以在这里添加更多模式的处理
        ;;
esac
