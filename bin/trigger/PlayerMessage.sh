#!/bin/bash
#PlayerMessage.sh
#BattleMetrics - Trigger - WebHook - URL
#http://127.0.0.1:9000/hooks/PlayerMessage
#BattleMetrics - Trigger - WebHook - Body
#{
#  "msgtype": "val",
#  "text":{
#  "content":"{{player.steamID}}%%{{player.name}}%%{{player.sessionDuration}}%%{{player.server.timePlayed}}%%{{player.org.timePlayed}}%%1%%{{server.players}}%%{{player.teamID}}%%{{msg.body}}" 
# }
#}
#
#传入参数解析
player_steamID=$(echo $1|awk -F '%%' '{print $1}')
player_name=$(echo $1|awk -F '%%' '{print $2}')
player_sessionDuration=$(echo $1|awk -F '%%' '{print $3}')
player_server_timePlayed=$(echo $1|awk -F '%%' '{print $4}')
player_org_timePlayed=$(echo $1|awk -F '%%' '{print $5}')
ServerID=$(echo $1|awk -F '%%' '{print $6}')
server_players=$(echo $1|awk -F '%%' '{print $7}')
player_teamID=$(echo $1|awk -F '%%' '{print $8}')

msg_body=$(echo $1|awk -F '%%' '{print $9}')
#忽略匹配大小写
shopt -s nocasematch
#恢复大小写匹配
#shopt -u nocasematch

#载入初始配置
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/trigger//g')/cfg/config.sh

# 使用if语句和正则表达式匹配触发条件
if [[ $msg_body =~ 游戏时长 ]] || [[ $msg_body =~ yxsc ]] || [[ $msg_body =~ 练习时长 ]] ; then
    #游戏时长主动查询
	${WBHKHOME}/bin/shell/SteamStatisticsDuration.sh "${player_steamID}%%${player_name}%%${player_sessionDuration}%%${player_server_timePlayed}%%${player_org_timePlayed}%%${ServerID}"
elif [[ $msg_body =~ 查询小队员 ]] || [[ $msg_body =~ cxxdy ]]; then
	# 小队时长查询接口，队长调用，返回自己小队所有人的时长信息。
	${WBHKHOME}/bin/shell/TeamDuration.sh "${player_name}%%${player_steamID}%%${ServerID}"
elif [[ $msg_body =~ ^[A-Z0-9]+-RESREVE-[0-9]+-.* ]] || \
	[[ $msg_body =~ ^[A-Z0-9]+-POINTS-[0-9]+-.* ]] || \
	[[ $msg_body =~ ^[A-Z0-9]+-SIGNVIP-[0-9]+-.* ]] ; then
    # CDK激活
    ${WBHKHOME}/bin/shell/CdkyeActivation.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ ^info ]] || [[ $msg_body =~ 信息 ]]; then
	# 个人剩余额度查询
	${WBHKHOME}/bin/shell/UserInfo.sh "${player_name}%%${player_steamID}%%${ServerID}"
elif [[ $msg_body =~ 签到 ]] || [[ $msg_body =~ ^qd ]]; then
	# 签到功能
	${WBHKHOME}/bin/shell/SignIn.sh  "${player_name}%%${player_steamID}%%${player_sessionDuration}%%${server_players}%%${ServerID}"
elif [[ $msg_body =~ ^avg ]] || [[ $msg_body =~ 平均时长 ]]; then
	# 对局平均时长查询
	${WBHKHOME}/bin/shell/AverageGameDuration.sh "${player_name}%%${player_steamID}%%${ServerID}"
elif [[ $msg_body =~ 兑换 ]] || [[ $msg_body =~ ^dh ]]; then
	# 积分兑换预留位
	${WBHKHOME}/bin/shell/PointsActivationReserved.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ 玩家清单 ]] || [[ $msg_body =~ ^wjqd ]]; then
	# 对当前已有的玩家进程保存，方便之后福利发放，留存时间3小时
	${WBHKHOME}/bin/shell/PlayerListSnapshots.sh "${player_name}%%${player_steamID}%%${ServerID}"
elif [[ $msg_body =~ 发福利 ]] || [[ $msg_body =~ ^ffl ]]; then
	# 对当前对局中的固定小队发放福利
	${WBHKHOME}/bin/shell/GrantReservedWelfare.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ 上局福利 ]] || [[ $msg_body =~ ^sjfl ]]; then
	# 从之前留存玩家列表中的玩家发放福利
	${WBHKHOME}/bin/shell/PreviousReservedWelfare.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ chat ]] || [[ $msg_body =~ 喇叭 ]]; then
	# 玩家喇叭喊话功能
	${WBHKHOME}/bin/shell/PlayerSpeaker.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ 发红包 ]] || [[ $msg_body =~ ^fhb ]]; then
	# 发红包功能
	${WBHKHOME}/bin/shell/HandOutRedEnvelopes.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ 抢红包 ]] || [[ $msg_body =~ ^qhb ]]; then
	# 抢红包的功能
	${WBHKHOME}/bin/shell/SnatchingRedEnvelopes.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
elif [[ $msg_body =~ 建队时间 ]] || [[ $msg_body =~ ^squad ]]; then
	# 建队时间查询
	${WBHKHOME}/bin/shell/CreatSquadTime.sh "${player_name}%%${player_steamID}%%${player_teamID}%%${msg_body}%%${ServerID}" 
elif [[ $msg_body =~ 牛子长度 ]] || [[ $msg_body =~ ^nzcd ]] || [[ $msg_body =~ ^牛至 ]]; then
	# 牛子长度
	${WBHKHOME}/bin/shell/NiuZiChangDu.sh "${player_name}%%${player_steamID}%%${ServerID}" 
elif [[ $msg_body =~ ^[A-Za-z0-9]{4,12}_[A-Za-z]{2,12}_[Vv][0-9]{1,2}$ ]]; then
	# 训练服自助切换地图
	${WBHKHOME}/bin/shell/TrainPlayerSelectionChangeLayer.sh "${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}" 
elif [[ $msg_body =~ [Kk][Aa]\ ?[Xx][Ii][Aa][Oo]\ ?[Rr][Ee][Nn] ]] || [[ $msg_body =~ 卡小人 ]] || [[ $msg_body =~ ^kxr ]]; then
	# 直接处理卡小人问题
	${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceTeamChange ${player_steamID}" ok
	${WBHKHOME}/bin/rcon/mcrcon -H ${ServerIP} -P ${RconPort} -p "${RconPasswd}" "AdminForceTeamChange ${player_steamID}" ok
elif [[ $msg_body =~ 确认随机打乱 ]]; then
	# 训练服自助切换地图
	${WBHKHOME}/bin/shell/ConfirmRandomShuffling.sh "${player_name}%%${player_steamID}%%${ServerID}"
else
    # 默认情况
    echo "No regex matched for $msg_body"
fi
