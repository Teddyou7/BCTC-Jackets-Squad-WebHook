#!/bin/bash
#CdkyeActivation.sh
#BattleMetrics - Trigger - Webhook - Action Condition
#-[OR] When any of the conditions are met.
#--Message - Contains (Regular Expression) - ^[A-Z0-9]+-RESREVE-[0-9]+-.*
#--Message - Contains (Regular Expression) - ^[A-Z0-9]+-POINTS-[0-9]+-.*
#--Message - Contains (Regular Expression) - ^[A-Z0-9]+-SIGNVIP-[0-9]+-.*
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/CdkyeActivation
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.name}}%%{{player.steamID}}%%{{msg.body}}%%1"
# }
#}
#游戏内CDK激活 20231217 Teddyou
#时间戳的末尾一位数为0是任何人可用，为1是无预留位的可用

#name
player_name=`echo $1|awk -F '%%' '{print $1}'`
#steamID
steamID=`echo $1|awk -F '%%' '{print $2}'`
#Cdkey
CdkeyInfo=`echo $1|awk -F '%%' '{print $3}'`

#ServerID
ServerID=`echo $1|awk -F '%%' '{print $4}'`

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

#判断CDK类型，关联文件列表
# 循环遍历每种CDK类型
for i in RESREVE POINTS SIGNVIP
do
    if [ $(echo $CdkeyInfo | grep -E "[A-Z0-9]+-${i}-[0-9]+-.*" | wc -l) -eq 1 ]; then
        # 根据CDK类型设置File_CDK变量
        case $i in
            RESREVE)
                File_CDK="${WBHKHOME}/date/cdkey/ReservedCDK"
				ActivationProject="预留位"
				Unit='天'
				ActivationMode=2
                ;;
            POINTS)
                File_CDK="${WBHKHOME}/date/cdkey/PointsCDK"
				ActivationProject=$PointsName
				Unit='分'
				ActivationMode=1
                ;;
            SIGNVIP)
                File_CDK="${WBHKHOME}/date/cdkey/SignVIPCDK"
				ActivationProject="签到特权"
				Unit='天'
				ActivationMode=3
                ;;
        esac
    fi
done

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $steamID)
#检测是否有效
CheckCDK=$(cat $File_CDK |grep -w $CdkeyInfo |wc -l)
if [ $CheckCDK -eq 0 ] ;then
	$CMDSH AdminWarnById $PlayerID 您使用的CDK无效，或已被使用。
	exit
fi
#提取时间戳
Value=`echo $CdkeyInfo|awk -F '-' '{print $3}'`
ReservedDAY=`echo "scale=1;${Value} / 86400"|bc`

#验证CDK渠道
CheckCDKChannel=`echo $Value | grep -oP '[0-9]{1}$'`
if [ $CheckCDKChannel -eq 1 ] ;then
        UserInfo=`cat $ReservedUserInfo |grep $steamID |wc -l`
        if [ $UserInfo -eq 1 ];then
                $CMDSH AdminWarnById $PlayerID 预留位未到期不能使用此渠道CDK！
                exit
        fi
fi

#开始处理预留位
${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$steamID" "$Value" "$ActivationMode"
echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:成功激活CDK-${CdkeyInfo}-$ActivationProject" >> $UserOperateLog/$steamID

if [ "$ActivationMode" -eq 1 ];then
		sed -i "/${CdkeyInfo}/d" $File_PointsCDKFilePath
		AccountBalance=`cat $PointsUserInfo |grep $steamID |awk -F \: '{print $2}'`
		$CMDSH AdminWarnById $PlayerID 成功激活${Value}${ActivationProject}，当前余额为${AccountBalance}${ActivationProject}
	elif [ "$ActivationMode" -eq 2 ];then
		sed -i "/${CdkeyInfo}/d" $File_ReservedCDKFilePath
		AccountBalance=`cat $ReservedUserInfo |grep $steamID |awk -F \: '{print $2}'`
		$CMDSH AdminWarnById $PlayerID 成功激活${ReservedDAY}${Unit}${ActivationProject}，最新到期时间`date -d @${AccountBalance} +"%Y/%m/%d %H:%M"`
	elif [ "$ActivationMode" -eq 3 ];then
		sed -i "/${CdkeyInfo}/d" $File_SignVIPCDKFilePath
		AccountBalance=`cat $SignVIPUserInfo |grep $steamID |awk -F \: '{print $2}'`
		$CMDSH AdminWarnById $PlayerID 成功激活${ReservedDAY}${Unit}${ActivationProject}，最新到期时间`date -d @${AccountBalance} +"%Y/%m/%d %H:%M"`
fi
