#!/bin/bash
#PlayerListSnapshots.sh
#留存当前玩家列表，方便之后福利发放

player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
ServerID=$(echo $1|awk -F '%%' '{print $3}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)

#检查人员权限是否足够
PermissionCheck=$(cat $PlayerListSnapshots_AdminsList | grep $player_steamID | wc -l )
if [ $PermissionCheck -eq 0 ] ;then
	$CMDSH AdminWarnById $PlayerID 您的权限不足，无法对当前对局人员留存快照。
	exit
fi

DATE=`date +"%s"`
FILE="${WBHKHOME}/date/tmp/RconQueryCache/PlayerListSnapshots.$DATE"
#生成缓存
${WBHKHOME}/bin/shell/additional/RconQueryCache.sh ListPlayers $FILE $ServerID

PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)
PlayerList=$( cat $FILE | grep "Squad ID" | wc -l )

$CMDSH AdminWarnById $PlayerID 已留存人数为：${PlayerList}，如果实际人数差异较大，请再次发起此功能！