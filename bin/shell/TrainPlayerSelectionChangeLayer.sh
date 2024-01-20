#!/bin/bash
#TrainPlayerSelectionChangeLayer.sh
#训练服自助切换地图 20230107 Teddyou
#${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#msg_body
ChangeLayer=`echo $1|awk -F '%%' '{print $3}'`
#ServerID
ServerID=`echo $1|awk -F '%%' '{print $4}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

if [ $BCTC_TrainingChangeLayer -eq 0 ];then
    exit
fi

if [ $(cat ${WBHKHOME}/date/BasicData/HelicopterTrainingChangeLayer | grep -iw ${ChangeLayer} | wc -l) -eq 0 ];then
	$CMDSH AdminWarn "$steamID" 您选择的“${ChangeLayer}”地图不存在与预置的地图池中。
	$CMDSH AdminWarn "$steamID" 此地图可能是错误的名称，或不能确保双边存在直升机！
	exit
fi

find ${WBHKHOME}/date/tmp/TrainPlayerSelectionChangeLayer/$steamID -type f -mmin +$BCTC_TrainingChangeLayerCDTime -delete
IFDA=`ls -l ${WBHKHOME}/date/tmp/TrainPlayerSelectionChangeLayer/$steamID |wc -l`
if [ "$IFDA" -eq 1 ];then
	filename="${WBHKHOME}/date/tmp/TrainPlayerSelectionChangeLayer/$steamID"
	cooldown_minutes=$BCTC_TrainingChangeLayerCDTime
	# 获取当前时间和文件的最后修改时间
	current_time=$(date +%s)
	file_modification_time=$(stat -c %Y "$filename")
	# 计算时间差（以秒为单位）
	time_difference=$((current_time - file_modification_time))
	# 将时间差转换为分钟和秒
	minutes_elapsed=$((time_difference / 60))
	seconds_elapsed=$((time_difference % 60))
	# 计算距离设定的冷却时间还剩多少时间
	remaining_minutes=$((cooldown_minutes - minutes_elapsed))
	remaining_seconds=$((60 - seconds_elapsed))
	if [ $remaining_seconds -eq 60 ]; then
		remaining_seconds=0
		remaining_minutes=$((remaining_minutes + 1))
	fi
	# 确保剩余时间不为负数
	if [ $remaining_minutes -lt 0 ] || [ $remaining_minutes -eq 0 -a $remaining_seconds -le 0 ]; then
		remaining_minutes=0
		remaining_seconds=0
	fi
	$CMDSH AdminWarn "$steamID" 您的自助换图正在冷却中，冷却时间为${BCTC_TrainingChangeLayerCDTime}分钟.
	$CMDSH AdminWarn "$steamID" 您还需要等待${remaining_minutes}分${remaining_seconds}秒。
	$CMDSH AdminWarn "$steamID" 您上次使用自助换图是在${minutes_elapsed}分${seconds_elapsed}秒前。
	exit
fi

$CMDSH AdminBroadcast 玩家“${player_name}”，使用了自助换图功能，将在15秒后切换地图为：$ChangeLayer
sleep 5
$CMDSH AdminBroadcast 玩家“${player_name}”，使用了自助换图功能，将在10秒后切换地图为：$ChangeLayer
sleep 5
$CMDSH AdminBroadcast 玩家“${player_name}”，使用了自助换图功能，将在5秒后切换地图为：$ChangeLayer
sleep 5
$CMDSH AdminChangeLayer $ChangeLayer

touch ${WBHKHOME}/date/tmp/TrainPlayerSelectionChangeLayer/$steamID