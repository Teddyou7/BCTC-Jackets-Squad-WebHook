#注意，此项目中附带了一个已经编译好的WebHook程序，如果您对此程序不放心，可自行编译替换，项目地址：https://github.com/adnanh/webhook
#其使用的RCON程序也是编译好的，如果不放心可审核源码后自行编译，源码为：https://github.com/Teddyou7/BCTC-Jackets-Squad-WebHook/blob/main/bin/rcon/rcon.c
#其使用的MCRCON源码为：https://github.com/Tiiffi/mcrcon
#
#正确使用此包需要配置BattleMetrics的触发器！由触发器决定脚本调用，功能脚本注释中将会提示传参格式，或使用后续建设的文档
#
#冲锋号社区 - 战术小队 - 冲锋衣插件辅助系统
#Version 0.1.135
#2023/12/5 1:16
#Come from: -冲锋号-Teddyou
#参数设置

#WebHook根目录位置(无需修改，启动脚本会自动识别)
WBHKHOME="/home/squad/webhook"

#设置此API可从本机请求steam玩家资料，从本地获取资料请确保您的系统支持Python3[3.6.8]和jq[version 1.6]。
#https://steamcommunity.com/dev/apikey
SteamApiKey="null"

#设置steam资料请求方式，由冲锋号社区代理APIKey=1，本地请求=0，设置为0请确保您的密钥正确，否则将无法正常拉取数据。
#冲锋号社区代理目前免费使用。  http://api.bctc-squad.cn:8088/api/SteamDuration.sh?
SteamApiMODE=1
#BCTC_SteamApiKey="null"

#服务器IP
ServerIP="127.0.0.1"

#服务器RCON端口号
RconPort="21114"

#服务器RCON端口密码
RconPasswd="XXXXXX"

#WebHook启动端口
WebHookPort='9330'

#组织标识
Org="冲锋号社区"

#Steam时长本地获取规则缓存时间（分钟）
SteamDurationTmpMin=60

#小队创建广播模式，此功能关联小队创建时间查询
# 0=不广播 1=全部广播 2=不符合指定时长广播
CreatSquad_BroadcastMODE=2

#指定时长（分钟）
SLSteamDuration=6000

#增加预留位API接口,如果你使用的插件涉及到预留位的增删，则你应该设置此处。
#此功能需要由您的供应商提供，务必使用http请求，请求方法类似于：http://api.server.com/ReservedAdd?steamid=760000000
#直接在末尾添加steamID就可使用的请求。
ReservedAddApi="http://api.server.com/add?"

#删除预留位API接口,如果你使用的插件涉及到预留位的增删，则你应该设置此处。
#此功能需要由您的供应商提供，务必使用http请求，请求类似于：http://api.server.com/ReservedDel?steamid=760000000
#直接在末尾添加steamID就可使用的请求。
ReservedDelApi="http://api.server.com/del?"

#预留位CDK激活码存放路径
#注意CDK格式，BCTC-RESERVED-2592000-XXXXXX-XXXXXX-XXXXXXX
#以-分割，第一位为定制化内容，可以是你的组织简写，第三位为激活的时间戳，后方是随机的加密字符。
File_ReservedCDKFilePath="${WBHKHOME}/date/cdkey/ReservedCDK"

#积分CDK存放路径
##注意CDK格式，BCTC-POINTS-2000-XXXXXX-XXXXXX-XXXXXXX
#以-分割，第一位为定制化内容，可以是你的组织简写，第三位为激活的积分数额，后方是随机的加密字符。
File_PointsCDKFilePath="${WBHKHOME}/date/cdkey/PointsCDK"

#签到特权CDK激活码存放路径
#注意CDK格式，BCTC-SIGNVIP-2592000-XXXXXX-XXXXXX-XXXXXXX
#以-分割，第一位为定制化内容，可以是你的组织简写，第三位为激活的时间戳，后方是随机的加密字符。
File_SignVIPCDKFilePath="${WBHKHOME}/date/cdkey/SignVIPCDK"

#调用输入ServerID=serverID，定义变量CMDSH，一次性管理多实例配置；设置此多实例可无视上方配置的登录信息进行设置。
#$ServerID是服务器编号，一般以#1 #2 #3等区分，需要修改脚本自行处理此参数。
#注意！尚未针对多实例进行调试，设置后可能会存在错误！如有问题请及时联系！
#if [ "$ServerID" -eq 1 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p21114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p21114'
#elif [ "$ServerID" -eq 2 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p22114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p22114'
#elif [ "$ServerID" -eq 3 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p23114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p23114'
#elif [ "$ServerID" -eq 4 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a127.0.0.1 -P${RconPasswd} -p24114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p24114'
#elif [ "$ServerID" -eq 5 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a127.0.0.1 -P${RconPasswd} -p25114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p25114'
#elif [ "$ServerID" -eq 6 ];then
#	CMDSH='${WBHKHOME}/bin/shell/additional/Rcon.sh -a127.0.0.1 -P${RconPasswd} -p26114'
#	SQUADCMD=' -a${ServerIP} -P${RconPasswd} -p26114'
#fi

#单一实例配置
CMDSH="${WBHKHOME}/bin/shell/additional/Rcon.sh -a${ServerIP} -P${RconPasswd} -p${RconPort}"
SQUADCMD=" -a${ServerIP} -P${RconPasswd} -p${RconPort}"