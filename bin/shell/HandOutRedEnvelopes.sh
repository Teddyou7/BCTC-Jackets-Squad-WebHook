#!/bin/bash
#HandOutRedEnvelopes.sh
#发红包功能
#设置语言环境
export LANG=en_US.UTF-8
#传入："${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
msg_body=$(echo $1|awk -F '%%' '{print $3}')
ServerID=$(echo $1|awk -F '%%' '{print $4}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

#判断功能是否启动
if [ $HandOutRedEnvelopesStart -eq 0 ];then
	PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)
	$CMDSH AdminWarnById $PlayerID 服务器管理员已禁用了“发红包”功能！
	exit
fi

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh ${player_steamID})
#判断传入是否为数字
NUM=`echo $msg_body | awk '{print $2}'`
INT=`echo $msg_body | awk '{print $3}'`

if grep '^[[:digit:]]*$' <<< "$NUM";then 
  echo "$NUM is OK." 
else 
  $CMDSH AdminWarnById $PlayerID 红包个数未使用整数型数字，格式为：发红包 [红包数量] [单个红包数额]
  exit
fi 

if grep '^[[:digit:]]*$' <<< "$INT";then 
  echo "$INT is OK." 
else 
  $CMDSH AdminWarnById $PlayerID 单个红包数额未使用整数型数字，格式为：发红包 [红包数量] [单个红包数额]
  exit
fi 

if [ -z $INT ]; then
  $CMDSH AdminWarnById $PlayerID 未填单个红包数额，格式为：发红包 [红包数量] [单个红包数额]
  exit
fi 

#判断单个红包数额是否大于设定值
if [ $INT -lt $HandOutRedEnvelopesLow ];then
  $CMDSH AdminWarnById $PlayerID 单个红包数额需要大于${HandOutRedEnvelopesLow}
  exit
fi

#判断需要积分的总额度
Total=`expr $NUM \* $INT`
#当前账户内的积分数额
CurrentBalance=$($mysql_cmd "SELECT current_balance FROM transactions WHERE steamid='$player_steamID' AND organization_tag='$db_tag' ORDER BY transaction_time DESC LIMIT 1;")

#积分兑换，且自动扣款
if [ $(echo "$CurrentBalance >= $Total" | bc) -eq 1 ]; then
	#${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$Total" "4"
	#echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:使用发红包消耗${Total}${PointsName}" >> $UserOperateLog/$player_steamID
	${WBHKHOME}/bin/shell/additional/transaction_manager.sh "$player_steamID" "del" "${Total}" "通过发红包消耗"
	#计算预留位时间戳
	ReservedSec=`expr $INT \* $PointsToReserved`
	#标记积分兑换预留位开始处理
else
	$CMDSH AdminWarnById $PlayerID 您的积分不足，当前为$CurrentBalance，按照您的请求，需要${Total}${PointsName}。
	exit
fi
echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:通过发红包扣除${Total}积分" >> $UserOperateLog/$player_steamID

#开始处理红包池
DATE=`date +%s`
for I in `seq $NUM`
do 
	echo "${player_name}%%${ReservedSec}" > ${WBHKHOME}/date/tmp/RedEnvelopePool/${DATE}.$player_steamID.$I
done

#$CMDSH AdminBroadcast ${player_name}，使用${Total}${PointsName}发放${NUM}个预留位红包，输入“抢红包”可获取预留位。

if [ "$SnatchingRedEnvelopesMod" -eq 1 ];then
	$CMDSH AdminBroadcast ${player_name}，使用${Total}${PointsName}发放${NUM}个预留位红包，输入“抢红包”可获取预留位。
else
	$CMDSH AdminBroadcast ${player_name}，使用${Total}${PointsName}发放${NUM}个${PointsName}红包，输入“抢红包”可获取${PointsName}。
fi
