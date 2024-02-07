#!/bin/bash
#AdvancedCombatInformationSwitch.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/UserInfo
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%1"
# }
#}
#高级战斗信息开关 20240131 Teddyou

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $3}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

#余额判断
CurrentBalance=$($mysql_cmd "SELECT current_balance FROM transactions WHERE steamid='$steamID' AND organization_tag='$db_tag' ORDER BY transaction_time DESC LIMIT 1;")

if [ $AdvancedCombatInformation -eq 0 ];then
	$CMDSH AdminWarn $steamID 本服务器管理员未开启高级战斗信息
	exit
fi

filename="${WBHKHOME}/date/tmp/AdvancedCombatInformation/${steamID}"
# 检查文件是否存在
if [ -f "$filename" ]; then
    AdvancedCombatInformationTimeMin=$((AdvancedCombatInformationTime / 60))
    cooldown_minutes=$AdvancedCombatInformationTimeMin
    current_time=$(date +%s)
    file_modification_time=$(stat -c %Y "$filename")
    time_difference=$((current_time - file_modification_time))
    
    # 计算时间差的小时、分钟和秒
    hours_elapsed=$((time_difference / 3600))
    minutes_elapsed=$(( (time_difference % 3600) / 60 ))
    seconds_elapsed=$((time_difference % 60))

    # 计算剩余时间
    remaining_hours=$((cooldown_minutes / 60 - hours_elapsed))
    remaining_minutes=$((cooldown_minutes % 60 - minutes_elapsed))
    remaining_seconds=$((60 - seconds_elapsed))
    if [ $remaining_seconds -eq 60 ]; then
        remaining_seconds=0
        remaining_minutes=$((remaining_minutes + 1))
    fi
    if [ $remaining_minutes -lt 0 ]; then
        remaining_minutes=$((remaining_minutes + 60))
        remaining_hours=$((remaining_hours - 1))
    fi
    if [ $remaining_hours -lt 0 ]; then
        remaining_hours=0
        remaining_minutes=0
        remaining_seconds=0
    fi
    $CMDSH AdminWarn $steamID 您已经激活了此功能，在到期之前，不能再次开通；还剩余${remaining_hours}小时${remaining_minutes}分${remaining_seconds}秒。
    exit 1
fi

#判断当前积分是否足够
if [ $(echo "$CurrentBalance >= $AdvancedCombatInformationPoints" | bc) -eq 1 ]; then
	Balance=$(${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$steamID" "del" "${AdvancedCombatInformationPoints}" "通过开启高级战斗信息消耗")
	$CMDSH AdminWarn $steamID 高级战斗信息开通成功，已扣除${AdvancedCombatInformationPoints}${PointsName}，当前剩余$Balance
else
	$CMDSH AdminWarn $steamID 高级战斗信息开通失败，需要${AdvancedCombatInformationPoints}${PointsName}，当前剩余$CurrentBalance
	exit
fi

#标记开通
touch ${WBHKHOME}/date/tmp/AdvancedCombatInformation/${steamID}
