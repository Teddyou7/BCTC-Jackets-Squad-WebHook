
欢迎使用此项目，此项目由冲锋号社区发起，我将其命名为冲锋衣项目，是以服务器辅助和娱乐为主的插件，当前正在对原有功能的重构，进行开发；冲锋号社区门户群：703511605

在启动之前请前往 ./cfg/config.sh 修改配置文件，配置您的服务器IP、端口、Rcon密码、社区标识等信息。

首次启动请使用bash命令启动。

```
bash ./start.sh
```

你需要正确配置触发器，当前提交的README.md版本并不是正确的，你需要查看bin下的trigger路径的文件去相应的地方进行配置，还需要使用mysql8,整个插件系统只能运行在Linux系统的centos下，需要在系统额外安装jq，用以解析json。
整个插件想要用起来需要有一定的Linux基础

## 拉取数据包
我并未单独的只上传在Github，而是拥有自己的SVN库，考虑到实际的编写和上传需求，在没有完成新的功能的测试和上线之前，我并不会上传到Github仓库。

但是SVN的版本也能确保能够正常使用，因为在调试完成之前不会修改关键的配置项。
```
svn co svn://svn.bctc-squad.cn/BCTC-Jackets-Squad-WebHook

User : guest
Psswd: (未设置密码，留空回车即可)
```
## 如何配置我的BattleMetrics？

提问：为何要配置BattleMetrics？

回答：此插件系统严重依赖于BM面板的触发器能力。

### 配置方法

打开 PlayerMessage.sh 看到以下的注释信息；这些信息就是配置的方法。

```
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
```

根据以上提示，添加触发器 “Trigger Type” 选择 “Player Message”

然后添加一个 “Actions” 选择 “Webhook” 参考以下截图进行配置。

![配置方法示例](https://s11.ax1x.com/2023/12/17/pi5yChF.png)

### 注意事项

多数shell文件中并没有提及Message触发关键词，可根据实际情况定义，或根据以下的建议信息配置，注意！如果需要配置多条的Message关键词应该选择[OR]模式。

## 已完成开发的功能
* 详见UpdateLog.txt

Version 2.0.146-2024/2/7 17:48

1、修改数据库分析程序，改为高并发模式，不再是顺序执行，防止过度等待的问题。


Version 2.0.146-2024/2/6 16:31

1、修复玩家喇叭功能的部分BUG。

2、优化历史地图的提示文案。

3、支持特定气运获得积分。

4、修复积分跳边冷却未生效的BUG。

5、重构OP随选功能，支持主动触发。

6、增加以下配置function_config

#额外奖励积分的气运

DailyFortuneFate="财运"

#额外奖励积分冷却时间（分钟）

DailyFortuneFateCD=720

#额外奖励积分数额

DailyFortuneFatePoints="8.88"

#随机选择管理员功能开关 0=关

RandomlySelectAdministratorsSwitch=1

Version 2.0.141-2024/2/5 23:48

1、修复因关闭大喇叭导致小喇叭不可用的问题。

2、增加历史地图查询功能

3、增加积分跳边功能

4、优化自动更新程序，增加自动完善配置文件的能力。

5、增加启动时版本信息广播。

6、增加以下配置function_config

#历史地图开关 0=关

HistoricalMapSwitch=1

#历史地图显示地图数量

HistoricalMapNumber=5

#积分跳边开关 0=关

ChangeCampSwitch=1

#积分跳边触发词汇（默认通用强制词汇为 !tb ）

ChangeCampName='积分跳边'

#积分跳边费用，支持小数（小数使用引号）

ChangeCampPoints="8.88"

#积分跳边冷却时间(分钟)

ChangeCampCD=10

#是否开启玩家喇叭喊话功能 0=关

PlayerSpeakerSwitch=1



Version 2.0.138-2024/2/4 17:43

1、修复管理员飞天摄像头启动不能正确入库的问题。

2、修复因随机打乱关闭导致摄像头监察邮件无法正常发送的问题。



Version 2.0.137-2024/2/4 2:21

1、增加docker启动的兼容性

2、解决docker入库的字符集导致汉字乱码的问题。



Version 2.0.133-2024/2/3 20:12

1、增加以下配置db_config

#数据库连接端口

db_port="3306"

mysql_cmd="mysql -h $db_host -P $db_port -u $db_user -D $db_name -s -N -e "

2、修复积分CDK激活不正确回显的BUG



Version 2.0.130-2024/2/2 3:52

1、增加启动时数据库表检查。

2、增加每日运势功能。

3、牛子长度支持强制刷新。

4、优化部分脚本逻辑，部分扣费参数开始支持小数。

5、增加头条热搜功能。

6、增加以下配置function_config

#牛子长度每次收费

NiuZiChangDuPoints=0

#提前更换牛子每次收费 （换新的牛子会长一点）

NewNiuZiChangDuPoints=5

#是否开启每日运势查询 0=关

DailyFortuneSwitch=1

#单次查询费用（积分）

DailyFortunePoints="0.5"

#是否开启每日头条 0=关

HotSearchSwitch=1

#单次查询费用（积分，支持小数）

HotSearchPoints="0.2"



Version 2.0.125-2024/2/1 23:54

1、增加每小时抽奖功能。

2、增加以下配置function_config

#每小时抽奖功能，抽奖模式 0=关 1=仅能够抽中预留位 2=仅能够抽中积分 3=积分与预留位随机中奖一个 4=积分与预留位均能中奖

HourlyLotterySwitch=3

#服务器最低玩家数 当服务器内玩家数低于这个数值的时候任何人不可抽奖

HourlyLotteryPlayersMin=10

#抽奖用户在线时间限制（秒）

HourlyLotterySessionDurationMin=600

#抽奖难度 数值越高越难中奖

HourlyLotteryDifficulty=8000

#服务器在线人数档位抽奖难度配置

#0-20人难度

Difficulty20=0

#20-40人难度

Difficulty40=15

#40-60人难度

Difficulty60=28

#60-80人难度

Difficulty80=77

#80-100人难度

Difficulty100=120

#奖项难度设置（5个等级）

#30天预留位

WinningLevelReserved1=5

#14天预留位

WinningLevelReserved2=40

#7天预留位

WinningLevelReserved3=140

#3天预留位

WinningLevelReserved4=200

#1天预留位

WinningLevelReserved5=850

#888积分

WinningLevelPoints1=3

#388积分

WinningLevelPoints2=30

#188积分

WinningLevelPoints3=150

#88积分

WinningLevelPoints4=300

#20积分

WinningLevelPoints5=550

#安慰奖难度

WinningLevelComfort=5000

#安慰奖积分数额 （可使用小数，但小数点最多两位数） 

HourlyLotteryComfort="0.38"

#抽奖未中奖文案调用方式 0=本地 1=网络API文案（https://tenapi.cn/v2/yiyan）

HourlyLotteryCopywriting=1

#是否使用防沉迷系统 0=关 （此功能触发需要玩家主动发送消息，通过BM传入参数判断在线时长）

PreventAddiction=1

#防沉迷触发底线 持续在线大于多少秒

PreventAddictionOnline=10800

#防沉迷提醒冷却间隔(分钟)

PreventAddictionCD=5

3、优化启动提示信息，优化启动脚本检查逻辑。

4、增加防沉迷提醒



Version 2.0.119-2024/1/31 21:11

1、OP随机选择增加保护，除非只有一个OP在线，否则避免重复选中的问题。

2、修复少量的BUG。



Version 2.0.118-2024/1/31 12:37

1、正式启用数据库进行战斗数据查询。

2、通过视图表去分隔用户的战斗数据。

3、新增插件版本查询。

4、实现KD查询功能

5、实现高级战斗信息吐出，支持显示到期剩余时间

6、新增以下配置：function_config

#是否开启KD查询 0=关

UserKDinfo=0

#KD查询每次消耗积分数额

UserKDinfoPoints=5

#KD查询口令（不能包含空格）

UserKDinfoToken="kd"

#是否开启高级战斗信息 0=关

#高级战斗信息会实时提示开启人的战斗数据，以警告的形式，反馈伤害数值、击倒、被谁击倒或命中。 0=关

AdvancedCombatInformation=0

#高级战斗信息每次激活积分

AdvancedCombatInformationPoints=100

#高级战斗信息单次激活后授权的秒数，时间未道不能加时，建议不超过一天；单位为秒。

AdvancedCombatInformationTime=86400

#高级战斗信息激活口令（不能包含空格）

AdvancedCombatInformationToken="激活高级战斗信息"

#是否开启票差打乱，本功能打开状态会导致“确认结束打乱”功能失效 0=关

TicketsGapConfirmRandomShufflingIf=0

#票数差距大小

TicketsGapNumber=200

#票差打乱是否屏蔽侵攻模式 0=否

TicketsGapInvasionShufflingIf=1

#是否开启随机选择OP值班功能 0=关 (需要配置Admins_User_B)

AdministratorRandomlySelects=0

#天气主动查询功能开关 0=关

RealTimeWeather=1

#是否隐藏省市位置 1=是

RealTimeWeatherCity=1

#单次查询积分消耗

RealTimeWeatherPoints=10

#是否检查飞天后落地参战 0=关

AdminCamCheck=1

#检查完成后处理方式 1=踢出服务器，且邮件通知  2=ban出服务器（1天），且邮件通知  3=仅邮件通知（附件添加相关日志）

AdminCamCheckProcessingMethod=3

#通知邮箱地址（仅支持配置一个,但是可以配置邮箱组进行自动转发）

AdminCamNoticeMail="support@bctc-squad.cn"

7、降低了Rcon失败后重新尝试的次数

8、增加识别到游戏结束后进行随机打乱的功能，触发命令：确认结束打乱

9、增加票差自动打乱功能,支持过滤侵攻模式。

10、增加启动脚本的自动关闭功能，识别$1是否为stop，否则结束进程。

11、增加抽取OP值班功能。

12、增加实时气象信息查询功能。

13、增加摄像头启用后落地检查，支持生成数据进行邮件通知分析

14、修复数个BUG。



Version 1.1.115-2024/1/22 22:06

1、解决了从日志获取数据"\r"异常导致不能正确入库的BUG。

2、修复大量入库的问题。

3、解决用户加入入库信息昵称不准确的问题，增加eosid字段，优化伤害日志的昵称匹配机制，但是仍存在用户在对局中更换前缀无法匹配准确steamid的问题。

4、变更小队创建信息teamid获取的模式，从数据库查询改为文件查询。



Version 1.1.110-2024/1/21 15:38

1、解决建队时间查询的BUG。

2、支持上局战绩查询和当前查询。(数据库数据，暂未对外查询)

3、优化玩家信息入库的问题

4、建队广播现在只会回复steam时长，取消对社区时长广播的支持。



Version 1.1.100-2024/1/21 5:48

1、插件引入数据库管理，支持数据库为mysql8

cfh路径增加文件，db_config.sh 增加如下参数

#组织标签，此标签控制玩家数据

db_tag="bctc"

#服务器表前缀，此表用来记录战斗数据

db_server="bctc1_"

#数据库连接地址

db_host="127.0.0.1"

#数据库连接用户

db_user="bctc"

#数据库连接密码

db_password="xxxxxxx"

#数据库database

db_name="jackets"

function_config.sh增加如下配置

#是否开启积分兑换预留位功能 0=关

PointsActivationReservedIf=1

#签到积分是否为定额积分，非定额留空，定额填写定额数字

SignInPOINTS=''

#是否限制签到玩家数，比如大于这个数值(非暖服的状态)就不可以签到了

SignInMaxPlayers=''

2、积分开始采用数据库管理，因记账的特殊性，存在数据锁死机制。

3、开始从日志收集基础数据，包括伤害、击杀、击倒、拯救、摄像头、小队创建、地图切换、玩家加入信息。

4、为配合小队创建，的teamid查询，制成初始的图层信息数据库。

5、优化ConfirmRandomShuffling随机打乱处理逻辑。

6、CdkyeActivation连接数据库

7、GrantReservedWelfare连接数据库

8、SignIn连接数据库

9、SnatchingRedEnvelopes连接数据库

10、UserInfo连接数据库



Version 1.0.80-2024/1/11 20:39

1、发布能够通过Web设置插件参数的能力，基于PHP实现，由于普通用户权限无法绕过的权限问题，nginx需要手动修改本地nginx和重启nginx。（尚未实现）



Version 1.0.64-2024/1/11 2:43

1、增加游戏内的随机打乱功能

2、增加配置项

#随机打乱所需要的权限等级

ConfirmRandomShuffling_AdminsList=$Admins_User_S



Version 1.0.61-2024/1/9 12:27

1、调整游戏时长查询为组织时间，而不是单个服务器的时间。



Version 1.0.60-2024/1/7 20:20

1、新增如下配置

#是否开启冲锋号社区直升机公开训练服模式-结束时时间倍数控制 0=关 此功能在认证服务器不要开启！

BCTC_LogSquadGameEventsIf=0 

#对局结束时刻的时间倍数，可调整为 0-20 ,注意，如果调整为 0 ，那么时间将会暂停！ 直到管理员重新刷入新的 AdminSlomo

EndMatchTimeMultiplier="0.5"



Version 1.0.55-2024/1/6 0:35

1、新增如下配置

#功能包括：开局跳过等待准备时间、放开所有限制、跳过结算界面

#是否开启冲锋号社区直升机公开训练服模式-开局跳过并解除所有限制 0=关

BCTC_TrainingMatchIf=0

#是否开启冲锋号社区直升机公开训练服模式-击杀检测及炮手位检查自动踢出 0=关

BCTC_TrainingActualDamageIf=0

#是否开启冲锋号社区直升机公开训练服模式-炮手位检查自动踢出 0=关

BCTC_TrainingTurretIf=0

#是否开启冲锋号社区直升机公开训练服模式-玩家身份自助切换地图 0=关

BCTC_TrainingChangeLayer=0

#是否开启冲锋号社区直升机公开训练服模式-玩家身份自助切换地图冷却时间（每个玩家冷却分钟）

BCTC_TrainingChangeLayerCDTime=60

2、增加训练模式



Version 1.0.43-2024/1/3 18:39

1、取消 BM API 转向使用 Steam API 获取更准确的 Steam 用户信息

2、修复一个重大的CDK激活BUG，问题会导致签到特权和积分CDK激活后能够二次激活。



Version 1.0.41-2024/1/3 02:24

1、增加配置项

#是否上传大喇叭联动 1=是 0=否 //此处配置只能关闭本服务器的大喇叭发送，但是仍会收到其他服务器的大喇叭，此问题或在后续解决。

PlayerGroupSpeakerIf=1

2、新增大喇叭跨服联动功能。

3、修复一个大小喇叭的多余字符输出BUG



Version 1.0.28-2023/12/28 22:28

1、增加配置项，优化配置灵活性

#积分名称

PointsName="积分"

#气象广播时候的服务器名称

WeatherBroadcastServerNname="本服务器"

#牛子长度留存分钟数

NiuZiChangDuTimeTmp=432

#是否开启牛子长度娱乐功能 不开启=0

NiuZiChangDuIf=1

2、增加牛子长度获取。

3、修复游戏内CDK激活的错误回显

4、优化发福利功能的错误提示文字信息。

5、增加发红包的积分红包分支。



Version 1.0.15-2023/12/28 0:33

1、版本号正式定义为1.0正式版本，目前仍只推出先锋测试版本，尚未提供稳定版本。

2、修复一个重大BUG和数个小BUG。

3、新增PlayersJoinTheBroadcast.sh - 玩家加入服务器广播。 配置：${WBHKHOME}/date/BasicData/PlayersJoinTheBroadcast



Version 0.1.170-2023/12/25 22:30

1、修复签到模式的问题。

2、修复查询小队员的非队长使用功能的问题。

3、修正玩家ID缓存错误的问题。

4、优化发福利的提示文案，根据实际发放数额，回复天数或小时。

5、新增发红包与抢红包的功能。

6、新增以下配置：

#发红包功能

#是否开启发红包的功能 0=不开启 1=开启

HandOutRedEnvelopesStart=1

#发红包红包的最低单个红包使用积分

HandOutRedEnvelopesLow=12

#抢得红包处理方式 1=直充预留位 2=直充积分

SnatchingRedEnvelopesMod=1

#红包过期时间，分钟

RedEnvelopesBecomeDue=4320

#每次抢红包间隔时间，分钟

RedEnvelopesCooldown=20

#VIP名称

ServerVipNname="VIP"

7、优化启动脚本软连接逻辑。

8、修正天气预报广播错误玩家的BUG。



Version 0.1.168-2023/12/25 13:15

1、优化启动脚本，自动生成软连接，方便前端管理。

2、修改更新日志字符集。

3、修正签到的日志不会被正确记录的BUG。

4、优化发福利的提示，修正发福利的玩家回显时间错误。



Version 0.1.165-2023/12/25 12:38

1、优化大小喇叭的发送信息。

2、新增PlayerListSnapshots.sh - 用于留存当前对战的玩家信息，方便后续福利发放。 触发器：玩家清单 wjqd

3、config.sh文件新增以下配置：

#权限列表文件 写入64ID即可

Admins_User_S="${WBHKHOME}/date/BasicData/Admins_S"

Admins_User_A="${WBHKHOME}/date/BasicData/Admins_A"

Admins_User_B="${WBHKHOME}/date/BasicData/Admins_B"

Admins_User_C="${WBHKHOME}/date/BasicData/Admins_C"

#玩家快照所需要的权限等级 PlayerListSnapshots

PlayerListSnapshots_AdminsList=$Admins_User_S

#当前玩家列表快照留存路径-3小时缓存

PlayerListSnapshots=${WBHKHOME}/date/tmp/PlayerListSnapshots/PlayerListSnapshots.tmp

#发福利功能最低发放限制(单位：积分)

GrantReservedWelfareLow=12

4、新增对当前玩家发福利功能 GrantReservedWelfare.sh 触发器：ffl 发福利

5、新增对快照玩家列表发福利功能 PlayerListSnapshots.sh  触发器 ：上局福利 sjfl



Version 0.1.161-2023/12/24 23:12

1、增加PlayerMessage.sh，玩家消息集中管控转发系统，简化BM配置方法。

2、增加积分兑换功能，命令为：兑换 dh

3、适配其他脚本的转发接收处理流程。

4、config.sh文件新增以下配置：

#积分兑换预留位最低数值

PointsActivationReservedLow=20

#玩家小喇叭消耗积分

PlayerServerSpeakerPoints=10

#玩家大喇叭消耗积分

PlayerGroupSpeakerPoints=30

5、解决了一些小问题。

6、增加大小喇叭喊话的功能，命令为：chat.s chat.g 小喇叭 大喇叭

7、增加日志查询能力，可解析玩家加入信息，对于VIP用户给出当前的气象信息。


Version 0.1.147-2023/12/24 12:50

1、修正积分激活返回错误的问题。

2、增加config.sh配置文件关键信息，建议重新安装，备份数据。

3、增加自动更新程序。

4、增加多种签到成功后的触发模式。

5、增加优化框架内容，增加Rcon重连正则，增加用户信息缓存。



Version 0.1.142-2023/12/17 18:38

1、发布3个新的功能。

SignIn.sh - 签到功能

UserInfo - 玩家信息查询

CdkyeActivation - CDK激活程序

2、解决了一些小问题。

3、增加数个additional辅助脚本，涉及预留位的删除、权限同步、权限积分统一增删接口等。

4、预置了一个远程权限同步程序。



Version 0.1.136-2023/12/5 1:58

内容：

1、发布2个新的功能。

CreatSquadBroadcast - 小队创建播报

CreatSquadTime - 小队创建时间查询

2、修正本地的玩家时长查询会缓存一小时未公开的玩家资料的问题，未公开资料的玩家将不会生成缓存，以方便等候玩家公开个人资料快速生效。



Version 0.1.133-2023/11/30 23:31

内容：

1、发布一个新的功能。

涉及：SteamStatisticsDuration - Steam统计时长查询



Version 0.1.122-2023/10/31 20:20

内容：

1、发布一个新的功能。

涉及：TeamDuration.sh-查询小队员游戏时长

2、解决了一些小问题。

3、修改部分文字描述。



Version 0.1.115-2023/10/31 13:23

内容：

1、发布的第一个对外版本。

2、完成基础框架构建和基本启动能力。

3、完成附属项目构建。

涉及：Rcon.sh、RconQueryCache.sh、SteamDuration.sh、TimedSchedule.sh

4、发布首个功能。

涉及：AverageGameDuration.sh-对局平均时长查询



## 其他资料

* [访问冲锋号社区](https://bctc-squad.cn/)

* [BattleMetrics触发器传参汉化20231130](https://docs.qq.com/sheet/DY1BuUkpuVGRMSHh4)

