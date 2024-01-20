#!/bin/bash
# 从之前留存玩家列表中的玩家发放福利
#PreviousReservedWelfare.sh
#管理员请求格式：发福利 [阵营ID] [小队ID] [预留位小时数]
#传入："${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
msg_body=$(echo $1|awk -F '%%' '{print $3}')
ServerID=$(echo $1|awk -F '%%' '{print $4}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)

#判断传入是否为数字
TeamID=`echo $msg_body | awk '{print $2}'`
SquadID=`echo $msg_body | awk '{print $3}'`
Hour=`echo $msg_body | awk '{print $4}'`
if grep '^[[:digit:]]*$' <<< "$TeamID";then 
	echo "$TeamID is OK." 
else 
	$CMDSH AdminWarnById $PlayerID TeamID未使用整数型数字。请求格式，以空格间隔：发福利[阵营ID][小队ID][预留位小时数]
	exit
fi 
if grep '^[[:digit:]]*$' <<< "$SquadID";then 
	echo "$SquadID is OK." 
else 
	$CMDSH AdminWarnById $PlayerID SquadID未使用整数型数字。请求格式，以空格间隔：发福利[阵营ID][小队ID][预留位小时数]
	exit
fi 
if grep '^[[:digit:]]*$' <<< "$Hour";then 
	echo "$Hour is OK." 
else 
	$CMDSH AdminWarnById $PlayerID 发放的小时数未使用整数型数字。请求格式，以空格间隔：发福利[阵营ID][小队ID][预留位小时数]
	exit
fi 
if [ -z $Hour ]; then
	$CMDSH AdminWarnById $PlayerID 未填写发放的小时数。请求格式，以空格间隔：发福利[阵营ID][小队ID][预留位小时数]
	exit
fi 


#获取玩家64IDTeam ID: 2 | Squad ID: 5 
PLAYER=(`cat $PlayerListSnapshots | grep "Team ID: $TeamID | Squad ID: $SquadID "  |awk '{print $9}'`)
PLAYERSUM=`echo ${#PLAYER[@]}`
if [ "$PLAYERSUM" -eq 0 ];then
	$CMDSH AdminWarnById $PlayerID 获取玩家列表失败，请确认你的阵营和小队ID正确，如果正确请再次尝试。
	exit
fi

#判断单个数额是否大于12
if [ $Hour -lt $GrantReservedWelfareLow ];then
	$CMDSH AdminWarnById $PlayerID 发放的人均小时数需要大于$GrantReservedWelfareLow
	exit
fi

#判断需要积分的总额度
Total=`expr $PLAYERSUM \* $Hour`
#当前账户内的积分数额
CurrentBalance=$(cat $PointsUserInfo | grep $player_steamID | awk -F \: '{print $2}' | tail -1)

#积分兑换，且自动扣款
if [ $CurrentBalance -ge $Total ];then
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$Total" "4"
	echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:使用发福利消耗${Total}积分" >> $UserOperateLog/$player_steamID
	#计算预留位时间戳
	ReservedSec=`expr $Hour \* $PointsToReserved`
else
	$CMDSH AdminWarnById $PlayerID 您当前${PointsName}为$CurrentBalance，根据指令需要消耗${Total}${PointsName}，您的${PointsName}不足。
	exit
fi

#计算实际获得小时数
result=$(echo "scale=2; $ReservedSec / 3600" | bc)
# 判断小时数是否大于48
if [ $(echo "$result > 48" | bc) -eq 1 ]; then
    # 转换为天，假设1天等于24小时
    days=$(echo "$result / 24" | bc)
    unit="天"
else
    days=$result
    unit="小时"
fi

#开始发放预留位
$CMDSH AdminBroadcast $player_name，命令校验通过，正在下发预留位，请等候提示。
sleep 1

COUNTER=0
while true
do
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "${PLAYER[$COUNTER]}" "$ReservedSec" "2"
	echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:通过发福利获取${ReservedSec}预留位" >> $UserOperateLog/${PLAYER[$COUNTER]}
	PlayerID_User=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh ${PLAYER[$COUNTER]})
	AccountBalance=`cat $ReservedUserInfo |grep ${PLAYER[$COUNTER]} |awk -F \: '{print $2}'`
	$CMDSH AdminWarnById $PlayerID_User “$player_name”已为您充值预留位${days}${unit}，到期时间：`date -d @${AccountBalance} +"%Y/%m/%d %H:%M"`
	sleep 1
	COUNTER=$((COUNTER+1))
	if [ $COUNTER -eq $PLAYERSUM ];then
		$CMDSH AdminBroadcast 系统已完成对阵营${TeamID}，小队${SquadID}，${PLAYERSUM}名玩家，发放${days}${unit}预留位，发送“info”可查预留位到期时间。
		sleep 1
		break
	fi
done

CurrentBalanceNew=$(cat $PointsUserInfo | grep $player_steamID | awk -F \: '{print $2}' | tail -1)
$CMDSH AdminWarnById $PlayerID 福利发放完毕，已扣款${Total}${PointsName}，当前余额：$CurrentBalanceNew