#!/bin/bash
#SignIn.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/SignIn
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%{{player.sessionDuration}}%%{{server.players}}%%1"
# }
#}
#签到功能 20231215 Teddyou

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#在服时长
sessionDuration=`echo $1|awk -F '%%' '{print $3}'`
#玩家数量
players=`echo $1|awk -F '%%' '{print $4}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $5}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

#今日日期
DATE=`date +"%Y%m%d"`
UserSignLogFiles="$UserSignLogFile/$DATE"

#初始化
ls $UserSignLogFiles
if [ $? -ne 0 ];then
  >> $UserSignLogFiles
fi

process_signin() {
    local steamID=$1
    local INT=$2
    local privilege=$3
    local extra_hours=$4
    local extra_points=$5
    local privilege_msg=$6

    echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:通过每日签到获得${INT}积分" >> $UserOperateLog/${ServerID}
    ${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$steamID" "${INT}" "1"

    if [ "$privilege" -ne 0 ]; then
        echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:特权签到${SignVipNumber}次，额外获得${extra_hours}小时预留位与${extra_points}积分。" >> $UserOperateLog/${ServerID}
        ${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$steamID" "${extra_points}" "1"
        ${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$steamID" "$((extra_hours * 3600))" "2"
		Balance=`cat $PointsUserInfo |grep $steamID |awk -F \: '{print $2}'`
        $CMDSH AdminBroadcast $player_name，签到获得${INT}积分，${privilege_msg}；当前已特权签到${SignVipNumber}次，已有${Balance}积分。
    else
		Balance=`cat $PointsUserInfo |grep $steamID |awk -F \: '{print $2}'`
        $CMDSH AdminBroadcast $player_name，完成签到获得${INT}积分，您已签到${SignNumber}次，当前已有${Balance}积分。
    fi
}

#是否为签到特权用户
SignVIP=`cat $SignVIPUserInfo | grep $steamID | wc -l`

#在服时长判断是否可以签到20分钟
SignSessionDurationMinMinut=`echo "scale=1;${SignSessionDurationMin} / 60"|bc`
sessionDurationIF=0
if [ $sessionDuration -le $SignSessionDurationMin ];then
  sessionDurationIF=1
fi

#生成签到次数
SignNumber_tmp=`cat $UserSignLogFile/* | grep -w $steamID |wc -l`
SignVipNumber_tmp=`cat $UserSignLogFile/* | grep -w "$steamID:VIP" |wc -l`
SignNumber=$((SignNumber_tmp+1))
SignVipNumber=$((SignVipNumber_tmp+1))

WhetherSign=`cat $UserSignLogFiles |grep $steamID |wc -l`
if [ "$WhetherSign" -ne 0 ];then
	$CMDSH AdminBroadcast $player_name，您今天已经签过到了。
	exit
fi
#在服务器时长判断
if [ "$sessionDurationIF" -eq 1 ];then
	if [ "$SignVIP" -eq 0 ];then
		$CMDSH AdminBroadcast $player_name，签到失败，需要保持服务器在线${SignSessionDurationMinMinut}分钟以上。
		exit
	fi
	fi
#根据当前服务器内人数，生成随机积分
if [ "$players" -le 20 ];then
	INT=`echo $[RANDOM%5+25]`
	elif [ "$players" -le 40 ];then
	INT=`echo $[RANDOM%5+20]`
	elif [ "$players" -le 55 ];then
	INT=`echo $[RANDOM%5+15]`
	elif [ "$players" -le 75 ];then
	INT=`echo $[RANDOM%7+8]`
	elif [ "$players" -gt 75 ];then
	INT=`echo $[RANDOM%5+3]`
fi

#已签到标记
echo "$steamID" >> $UserSignLogFiles
#签到特权处理区
# 签到特权处理区和普通用户签到处理区
if [ "$SignVIP" -ne 0 ]; then
    if [ "$SignVipNumber" -ge 360 ]; then
        process_signin "$steamID" "$INT" 1 48 48 "签到特权⑥额外获得48小时预留位与48积分"
    elif [ "$SignVipNumber" -ge 180 ]; then
        process_signin "$steamID" "$INT" 1 48 30 "签到特权⑤额外获得48小时预留位与30积分"
    elif [ "$SignVipNumber" -ge 96 ]; then
        process_signin "$steamID" "$INT" 1 48 24 "签到特权④额外获得48小时预留位与24积分"
    elif [ "$SignVipNumber" -ge 36 ]; then
        process_signin "$steamID" "$INT" 1 42 18 "签到特权③额外获得42小时预留位与18积分"
    elif [ "$SignVipNumber" -ge 14 ]; then
        process_signin "$steamID" "$INT" 1 36 12 "签到特权②额外获得36小时预留位与12积分"
    else
        process_signin "$steamID" "$INT" 1 30 6 "签到特权①额外获得30小时预留位与6积分"
    fi
else
    process_signin "$steamID" "$INT" 0 0 0 ""
fi
