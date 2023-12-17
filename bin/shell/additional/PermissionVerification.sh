#!/bin/bash
#PermissionVerification.sh
#通过对比计时系统和权限列表的信息，进行补差，保持信息一致
#仅针对$RemoteAdminList的权限授予
#
source $(echo $(cd `dirname $0`; pwd) | sed 's/bin\/shell\/additional//g')/cfg/config.sh

Permission_file() {
	local PermissionFile=$1
	local Permission=$2
	#逐行处理预留位列表
	UserSteamID=($(cat $PermissionFile | awk -F ':' '{print $1}'))
	for I in ${!UserSteamID[@]}
	do
		WC1=$(grep "Admin=${UserSteamID[${I}]}:${Permission}" $RemoteAdminList | wc -l)
		if [[ ${WC1} -ne 0 ]];then
			continue
		else
			echo "Admin=${UserSteamID[${I}]}:${Permission}" >> $RemoteAdminList
		fi
	done
	AdminsSteamID=($(cat $RemoteAdminList | grep -e "Admin=[0-9]*:${Permission}" | awk -F ':' '{print $1}' | awk -F '=' '{print $2}' ))
	for I in ${!AdminsSteamID[@]}
	do
		WC2=$(grep "${AdminsSteamID[${I}]}" $PermissionFile | wc -l)
		if [[ ${WC2} -ne 0 ]];then
			continue
		else
			sed -i "/${AdminsSteamID[${I}]}:${Permission}/d" $RemoteAdminList
		fi
	done
}

while true; do
    # 处理 ReservedUserInfo 文件
    Permission_file $ReservedUserInfo "BCTC-Auto-Res"

    sleep 600
done
