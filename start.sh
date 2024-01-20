#!/bin/bash
echo "BCTC-Jackets Restart!"

#cfg_update
DIR=$(echo $(cd `dirname $0`; pwd))
SEDN=`cat ${DIR}/cfg/config.sh -n |grep WBHKHOME= |awk '{print $1}'|head -1`
DIR_tmp=${DIR//\//\\\/}
sed -i ''"${SEDN}"'s/.*/WBHKHOME='"${DIR_tmp}"'/' ${DIR}/cfg/config.sh
source $(echo $(cd `dirname $0`; pwd))/cfg/config.sh
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/cfg/webhook.json
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/cfg/RemoteAdmins.json
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/nginx/html/submitConfig.php
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/nginx/html/getConfig.php
sed -i 's/PathWaitingForCompletion/'"${DIR_tmp}"'/' ${DIR}/nginx/nginx.conf

sed -i 's/PathWaitingForNginxPort/'"${NginxStartPort}"'/' ${DIR}/nginx/nginx.conf
sed -i 's/PathWaitingForPhpFpmPort/'"${PHPFPMPort}"'/' ${DIR}/nginx/nginx.conf

if command -v htpasswd >/dev/null 2>&1; then
    echo "htpasswd check ok!"
else
    echo "htpasswd 未安装或不在 PATH 中，请先安装 "
	exit 2
fi

# 检查php-fpm命令是否存在
if command -v php-fpm >/dev/null 2>&1; then
    echo "php-fpm 命令存在。"

    # 检查php-fpm服务状态
    php_fpm_status=$(systemctl is-active php-fpm)
    if [ "$php_fpm_status" = "active" ]; then
        echo "php-fpm 服务正在运行。"

        # 检查是否监听端口9000
        if netstat -nutlp | grep ":${PHPFPMPort} " >/dev/null; then
            echo "php-fpm 设定端口被监听 ${PHPFPMPort}"
        else
            echo "php-fpm 设定端口没有被监听 ${PHPFPMPort}"
			exit 3
        fi
    else
        echo "php-fpm 服务未运行。状态：$php_fpm_status"
		exit 3
    fi
else
    echo "php-fpm 未安装或不在 PATH 中。"
	exit 3
fi

htpasswd -cb ${WBHKHOME}/nginx/htpasswd $NginxLoginUser $NginxLoginPass

[ ! -e "${WBHKHOME}/cfg/function_config.sh" ] && ln -s "${WBHKHOME}/nginx/html/function_config.sh" "${WBHKHOME}/cfg/function_config.sh" 2>&1 &

#赋予执行权限
chmod +x -R ${WBHKHOME}/bin/
chmod +x ${WBHKHOME}/start.sh
chmod +x ${WBHKHOME}/update.sh
chmod +x ${WBHKHOME}/webhook
chmod +x ${WBHKHOME}/cfg/
chmod +x ${WBHKHOME}/nginx

#创建路径
mkdir -p ${WBHKHOME}/logs/RconLog
mkdir -p ${WBHKHOME}/logs/user
mkdir -p ${WBHKHOME}/logs/webhook
mkdir -p ${WBHKHOME}/date/SignIn
mkdir -p ${WBHKHOME}/date/tmp/AverageGameDuration
mkdir -p ${WBHKHOME}/date/tmp/RconQueryCache
mkdir -p ${WBHKHOME}/date/tmp/SteamDuration
mkdir -p ${WBHKHOME}/date/tmp/CreatSquadInfo
mkdir -p ${WBHKHOME}/date/tmp/PlayerListSnapshots
mkdir -p ${WBHKHOME}/date/tmp/SnatchingRedEnvelopesCooldown
mkdir -p ${WBHKHOME}/date/tmp/RedEnvelopePool
mkdir -p ${WBHKHOME}/date/tmp/layerGameID
mkdir -p ${WBHKHOME}/date/tmp/TrainPlayerSelectionChangeLayer
mkdir -p ${WBHKHOME}/ManagePanel
mkdir -p ${WBHKHOME}/ManagePanel/权限列表
mkdir -p ${WBHKHOME}/ManagePanel/CDK配置
mkdir -p ${WBHKHOME}/ManagePanel/用户计费计时
mkdir -p ${WBHKHOME}/ManagePanel/系统配置文件
mkdir -p ${WBHKHOME}/date/txt
mkdir -p ${WBHKHOME}/date/user

#关联管理配置
[ ! -e "${WBHKHOME}/ManagePanel/权限列表/权限列表-S" ] && ln -s "${WBHKHOME}/date/BasicData/Admins_S" "${WBHKHOME}/ManagePanel/权限列表/权限列表-S" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/权限列表/权限列表-A" ] && ln -s "${WBHKHOME}/date/BasicData/Admins_A" "${WBHKHOME}/ManagePanel/权限列表/权限列表-A" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/权限列表/权限列表-B" ] && ln -s "${WBHKHOME}/date/BasicData/Admins_B" "${WBHKHOME}/ManagePanel/权限列表/权限列表-B" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/权限列表/权限列表-C" ] && ln -s "${WBHKHOME}/date/BasicData/Admins_C" "${WBHKHOME}/ManagePanel/权限列表/权限列表-C" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/系统配置文件/玩家加入播报" ] && ln -s "${WBHKHOME}/date/BasicData/PlayersJoinTheBroadcast" "${WBHKHOME}/ManagePanel/系统配置文件/玩家加入播报" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/CDK配置/预留位激活CDK" ] && ln -s "${WBHKHOME}/date/cdkey/ReservedCDK" "${WBHKHOME}/ManagePanel/CDK配置/预留位激活CDK" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/CDK配置/积分充值CDK" ] && ln -s "${WBHKHOME}/date/cdkey/PointsCDK" "${WBHKHOME}/ManagePanel/CDK配置/积分充值CDK" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/CDK配置/签到特权CDK" ] && ln -s "${WBHKHOME}/date/cdkey/SignVIPCDK" "${WBHKHOME}/ManagePanel/CDK配置/签到特权CDK" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/用户日志" ] && ln -s "${WBHKHOME}/logs/user" "${WBHKHOME}/ManagePanel/用户日志" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/用户计费计时/预留位到期信息" ] && ln -s "${WBHKHOME}/date/user/ReservedUserInfo.ini" "${WBHKHOME}/ManagePanel/用户计费计时/预留位到期信息" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/用户计费计时/签到特权到期信息" ] && ln -s "${WBHKHOME}/date/user/SignVIPUserInfo.ini" "${WBHKHOME}/ManagePanel/用户计费计时/签到特权到期信息" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/用户计费计时/积分信息" ] && ln -s "${WBHKHOME}/date/user/PointsUserInfo.ini" "${WBHKHOME}/ManagePanel/用户计费计时/积分信息" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/系统配置文件/配置文件" ] && ln -s "${WBHKHOME}/cfg/config.sh" "${WBHKHOME}/ManagePanel/系统配置文件/配置文件" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/系统配置文件/更新日志" ] && ln -s "${WBHKHOME}/UpdateLog.txt" "${WBHKHOME}/ManagePanel/系统配置文件/更新日志" 2>&1 &
[ ! -e "${WBHKHOME}/ManagePanel/系统配置文件/PlayerMessage触发器配置" ] && ln -s "${WBHKHOME}/bin/trigger/PlayerMessage.sh" "${WBHKHOME}/ManagePanel/系统配置文件/PlayerMessage触发器配置" 2>&1 &

#验证SteamAPI是否可用。
steamid='76561198000000000'
if [ $SteamApiMODE -eq 0 ];then
	echo "正在验证SteamAPI可用性。"
	curl -s "http://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1/?key=${SteamApiKey}&steamid=${steamid}" > ${WBHKHOME}/date/tmp/SteamDuration/${steamid}
	TMP_SteamAPIAccess=`cat ${WBHKHOME}/date/tmp/SteamDuration/${steamid} | grep "Access is denied." | wc -l`
	if [ $TMP_SteamAPIAccess -eq 1 ];then
		echo "启动失败，SteamAPI不可使用，请修改"
		exit 9
	fi
	echo "SteamAPI可用。"
fi

#主程序启动
cd ${WBHKHOME}
kill -9 `ps -ef|grep ${WBHKHOME} |grep -v grep|awk '{print $2}'` > /dev/null 2>&1 
mv ${WBHKHOME}/log ${WBHKHOME}/logs/webhook/`date +"%Y%m%d%H%M%S"`.log
nohup ${WBHKHOME}/webhook -port ${WebHookPort} -hotreload -hooks ${WBHKHOME}/cfg/webhook.json -verbose >> ${WBHKHOME}/log 2>&1 &
echo "WebHook startup completed!"

#nginx启动
#kill -9 $(cat ${WBHKHOME}/nginx/nginx.pid)
#nginx -c ${WBHKHOME}/nginx/nginx.conf

#其他启动项目
nohup ${WBHKHOME}/bin/shell/additional/TimedSchedule.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/shell/additional/DelAdmins.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/shell/additional/PermissionVerification.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/shell/additional/DuplicateCheck.sh > /dev/null 2>&1 &
echo "Additional startup completed!"

nohup ${WBHKHOME}/bin/trigger/LogSquadGameEvents.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/trigger/StartLoadingDestination.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/trigger/TrainingTurretTick.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/trigger/TrainingActualDamageTick.sh > /dev/null 2>&1 &
nohup ${WBHKHOME}/bin/trigger/UserIpPut.sh > /dev/null 2>&1 &
echo "Auto Trigger startup completed!"

#RemoteAdminList远程权限系统启动，此处默认不启动。
#服务器安装其他http服务可将py程序的启动注释，使用ln -s链接指向$RemoteAdminList文件即可！
#nohup python3 ${WBHKHOME}/bin/python/http_file_server.py ${WBHKHOME}/cfg/RemoteAdmins.json >> ${WBHKHOME}/logs/webhook/http_file_server.log 2>&1 &
#echo "RemoteAdmins startup completed!"
#echo "RemoteAdminsURL: http://127.0.0.1:27088/AdminInfo"

# 初始化进度条
echo -n "Loading "
# 设定进度条长度
progress_length=20
for ((i=0; i<$progress_length; i++)); do
    echo -n '#'
    sleep 0.1  
done
echo " Done!"

echo "------------------------------------------"
echo "$(cat ${WBHKHOME}/Version)"
echo "Welcome to the BCTC-Jackets system!"
echo "Web: https://bctc-squad.cn"
echo "Discord: https://discord.gg/DAnEG7gkpt"
echo "KOOK: https://kook.top/LNOL0y"
echo "QQgroup: 703511605"
echo "SupportMail： support@bctc-squad.cn"
echo "------------------------------------------"
echo "LoginURL： http://127.0.0.1:${NginxStartPort}/"
echo "User： ${NginxLoginUser}"
echo "Pass： ${NginxLoginPass}"
echo "Please manually start Nginx： nginx -s reload"

#交互程序，作用不大
#bash ${WBHKHOME}/bin/shell/additional/InteractiveManager.sh