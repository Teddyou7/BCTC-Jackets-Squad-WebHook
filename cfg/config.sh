#注意，此项目中附带了一个已经编译好的WebHook程序，如果您对此程序不放心，可自行编译替换，项目地址：https://github.com/adnanh/webhook
#其使用的RCON程序也是编译好的，如果不放心可审核源码后自行编译，源码为：https://github.com/Teddyou7/BCTC-Jackets-Squad-WebHook/blob/main/bin/rcon/rcon.c
#其使用的MCRCON源码为：https://github.com/Tiiffi/mcrcon
#
#正确使用此包需要配置BattleMetrics的触发器！由触发器决定脚本调用，功能脚本注释中将会提示传参格式，或使用后续建设的文档
#
#冲锋号社区 - 战术小队 - 冲锋衣插件辅助系统
#Come from: -冲锋号-Teddyou
#参数设置 - source $(echo $(cd `dirname $0`; pwd))/cfg/config.sh

#WebHook根目录位置
WBHKHOME="/home/squad/webhook"

#读取系统配置
source ${WBHKHOME}/cfg/system_config.sh

#读取API配置
source ${WBHKHOME}/cfg/api_config.sh

#读取插件系统配置
source ${WBHKHOME}/cfg/function_config.sh

#读取数据库配置
source ${WBHKHOME}/cfg/db_config.sh