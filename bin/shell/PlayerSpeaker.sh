#!/bin/bash
#PlayerSpeaker.sh
#积分激活预留位功能
#传入："${player_name}%%${player_steamID}%%${msg_body}%%${ServerID}"
player_name=$(echo $1|awk -F '%%' '{print $1}')
player_steamID=$(echo $1|awk -F '%%' '{print $2}')
msg_body=$(echo $1|awk -F '%%' '{print $3}')
ServerID=$(echo $1|awk -F '%%' '{print $4}')

source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell//g')/cfg/config.sh

SpeakerMode=$(echo $msg_body | awk '{print $1}')
PlayerID=$(${WBHKHOME}/bin/shell/additional/PlayerGameID.sh $player_steamID)
CurrentBalance=$(cat $PointsUserInfo | grep $player_steamID | awk -F \: '{print $2}' | tail -1)

if [[ "$SpeakerMode" == "chat.s" ]] || [[ "$SpeakerMode" == "小喇叭" ]]; then
	#判断为小喇叭
	SpeakerPoints=$PlayerServerSpeakerPoints
	
	if [[ "$SpeakerMode" == "chat.g" ]]; then
		Chat="${msg_body/chat.s /}"
	else
		Chat="${msg_body/小喇叭 /}"
	fi
elif [[ "$SpeakerMode" == "chat.g" ]] || [[ "$SpeakerMode" == "大喇叭" ]]; then
	#判断为大喇叭
	SpeakerPoints=$PlayerGroupSpeakerPoints
	Chat="${msg_body/chat.g /}"
	if [[ "$SpeakerMode" == "chat.g" ]]; then
		Chat="${msg_body/chat.g /}"
	else
		Chat="${msg_body/大喇叭 /}"
	fi
else
	$CMDSH AdminWarnById $PlayerID 请使用正确命令，小喇叭/chat.s 或 大喇叭/chat.g [喊话内容]
fi

if [ -z "$Chat" ]; then
	$CMDSH AdminWarnById $PlayerID 您未输入喊话的内容，请使用空格隔开。
	exit
fi

if [ $PlayerGroupSpeakerIf -ne 1 ];then
	$CMDSH AdminWarnById $PlayerID 功能未开启，本服务器并未接入大喇叭联动系统
	exit
fi
#判断当前积分是否足够
if [ $CurrentBalance -ge $SpeakerPoints ];then
	${WBHKHOME}/bin/shell/additional/UserQuotaAllocation.sh "$player_steamID" "$SpeakerPoints" "4"
	echo "`date +"%Y/%m/%d %H.%M.%S"`:`date +%s`:使用喇叭喊话：$msg_body" >> $UserOperateLog/$player_steamID
	Balance=$(cat $PointsUserInfo | grep $player_steamID | awk -F \: '{print $2}' | tail -1)
	$CMDSH AdminWarnById $PlayerID 喇叭功能使用成功，已扣除${SpeakerPoints}${PointsName}，当前剩余$Balance
	if [ $PlayerServerSpeakerPoints -eq $SpeakerPoints ];then
		$CMDSH AdminBroadcast [小喇叭]$player_name：$Chat
		sleep 1
	else
		#$CMDSH AdminBroadcast [大喇叭-来自“$Org”]$player_name：$Chat
		#转化编码
		UrlEncodeIn="${player_name}BCTC!2023${Org}BCTC!2023${Chat}"
		UrlEncodePut=$(python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))" "$UrlEncodeIn")
		curl http://42.193.48.240:24080/cgi-bin/GroupSpeaker.sh?$UrlEncodePut
		sleep 1
	fi
else
	$CMDSH AdminWarnById $PlayerID 喇叭功能使用失败，需要${SpeakerPoints}${PointsName}，当前剩余$Balance
fi
