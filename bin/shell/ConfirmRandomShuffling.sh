#!/bin/bash
#ConfirmRandomShuffling.sh
#随机打乱脚本

player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)

if [ -z "$ConfirmRandomShuffling_AdminsList" ]; then
    $CMDSH AdminWarn $player_steamID 服务器没有配置ConfirmRandomShuffling_AdminsList
    exit 1
fi

#检查人员权限是否足够
PermissionCheck=$(cat $ConfirmRandomShuffling_AdminsList | grep $player_steamID | wc -l )
if [ $PermissionCheck -eq 0 ] ;then
	$CMDSH AdminWarn $player_steamID 您的权限不足，无法进行打乱。
	exit
fi

DATE=`date +"%s"`
FILE="${WBHKHOME}/date/tmp/RconQueryCache/PlayerListSnapshots.$DATE"
#生成缓存
${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID

PlayerListSUM=$( cat $FILE | grep "Squad ID" | wc -l )
if [ $PlayerListSUM -lt 2 ];then
        $CMDSH AdminWarn $player_steamID  获取玩家数过低，可能存在异常，请重新尝试。
        exit
fi 

WC=`cat $FILE|wc -l`
PT=`expr $WC / 2`
PL=(`cat $FILE|awk '{print $2}'|shuf -n $PT`)
COUNTER=0
PLSUM=${#PL[@]}

$CMDSH AdminBroadcast 服务器随机打乱脚本已启动，即将进行打乱操作。
sleep 2
$CMDSH AdminBroadcast 打乱人数为${PT}人。

while true
do
	if [ $PT -eq 0 ];then
		break
	fi
	if [ $COUNTER -eq $PLSUM ];then
		break
	fi 
	#${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminWarnById ${PL[$COUNTER]} 您已被打乱程序选中。" ok
	${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceTeamChangeById ${PL[$COUNTER]} " ok
	COUNTER=$((COUNTER+1))
done

