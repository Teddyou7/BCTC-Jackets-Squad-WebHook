#!/bin/bash
#SnatchingRedEnvelopes.sh
#抢红包功能
#传入："${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
msg_body=$(echo $1|awk -F '%%' '{print $3}')
ServerID=$(echo $1|awk -F '%%' '{print $4}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

#检查过期的红包和玩家
find ${WBHKHOME}/date/tmp/SnatchingRedEnvelopesCooldown -type f -mmin +$RedEnvelopesCooldown -delete
find ${WBHKHOME}/date/tmp/RedEnvelopePool -type f -mmin +$RedEnvelopesBecomeDue -delete

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh ${player_steamID})

RedPacket=`find ${WBHKHOME}/date/tmp/RedEnvelopePool -type f | shuf -n 1`

if [ -z $RedPacket ]; then
	$CMDSH AdminWarnById $PlayerID 当前无人派发红包或已被抢完。
	exit
fi 

#计算剩余红包数量
RedPs=`ls -l ${WBHKHOME}/date/tmp/RedEnvelopePool | wc -l`
RedPSF=`expr $RedPs \- 2`

IFDA=`ls -l ${WBHKHOME}/date/tmp/SnatchingRedEnvelopesCooldown/$player_steamID |wc -l`
if [ "$IFDA" -eq 1 ];then
	$CMDSH AdminBroadcast $player_name，抢红包失败，您在${RedEnvelopesCooldown}分钟内抢过红包。\(当前还剩${RedPs}个红包\)
	exit
fi

#设置冷却计时
touch ${WBHKHOME}/date/tmp/SnatchingRedEnvelopesCooldown//$player_steamID

#发红包的人%%预留位时间戳
VAL1=`cat $RedPacket|awk -F '%%' '{print $1}'`
VAL2=`cat $RedPacket|awk -F '%%' '{print $2}'`

#删除红包
rm -rf $RedPacket

#计算实际获得小时数
result=$(echo "scale=2; $VAL2 / ${PointsToReserved} " | bc)
# 判断小时数是否大于48
if [ $(echo "$result > 48" | bc) -eq 1 ]; then
    # 转换为天，假设1天等于24小时
    days=$(echo "$result / 24" | bc)
    unit="天"
else
    days=$result
    unit="小时"
fi

Points=$(echo "scale=0; $VAL2 / ${PointsToReserved}" | bc)
if [ "$SnatchingRedEnvelopesMod" -eq 1 ];then
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$VAL2" "2"
	AccountBalance=`cat $ReservedUserInfo |grep ${player_steamID} |awk -F \: '{print $2}'`
	$CMDSH AdminBroadcast $player_name，抢到“${VAL1}”的红包获得${days}${unit}预留位，到期时间：`date -d @${AccountBalance} +"%Y/%m/%d %H:%M"`\(当前还剩${RedPSF}个红包\)
	echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:通过抢红包（${VAL1}）获得${VAL2}秒预留位" >> $UserOperateLog/$player_steamID
else
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$Points" "1"
	AccountBalance=`cat $PointsUserInfo |grep ${player_steamID} |awk -F \: '{print $2}'`
	$CMDSH AdminBroadcast $player_name，抢到“${VAL1}”的红包获得${Points}${PointsName}，当前余额：${AccountBalance}\(当前还剩${RedPSF}个红包\)
fi
