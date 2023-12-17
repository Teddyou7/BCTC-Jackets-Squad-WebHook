
欢迎使用此项目，此项目由冲锋号社区发起，我将其命名为冲锋衣项目，是以服务器辅助和娱乐为主的插件，当前正在对原有功能的重构，进行开发；冲锋号社区门户群：703511605

在启动之前请前往 ./cfg/config.sh 修改配置文件，配置您的服务器IP、端口、Rcon密码、社区标识等信息。

首次启动请使用bash命令启动。

```
bash ./start.sh
```

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

只有这个路径下的shell文件需要配置，你需要给每一项进行配置 {ROOT}/bin/shell 

例如，打开 CdkyeActivation.sh 看到以下的注释信息；这些信息就是配置的方法。

```
#BattleMetrics - Trigger - Webhook - Action Condition
#[AND] When all conditions are met.
#-Is Squad Leader - Equal (=) - True
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
```

根据以上提示，添加触发器 “Trigger Type” 选择 “Player Message”

然后添加一个 “Actions” 选择 “Webhook” 参考以下截图进行配置。

![配置方法示例](https://s11.ax1x.com/2023/12/17/pi5yChF.png)

### 注意事项

多数shell文件中并没有提及Message触发关键词，可根据实际情况定义，或根据以下的建议信息配置，注意！如果需要配置多条的Message关键词应该选择[OR]模式。

## 已完成开发的功能
* AverageGameDuration.txt - 平均时长查询功能 
建议的触发关键词：avg、平均时长
![平均时长查询功能](https://z1.ax1x.com/2023/12/01/pirOCE6.jpg)

* TeamDuration.sh - 小队员时长查询功能
建议的触发关键词：查询小队员、cxxdy
![小队员时长查询功能](https://z1.ax1x.com/2023/12/01/pirOA8e.jpg)

* SteamStatisticsDuration - Steam统计时长查询
建议的触发关键词：游戏时长、练习时长
![Steam统计时长查询](https://z1.ax1x.com/2023/12/01/pirOEgH.jpg)

* CreatSquadBroadcast - 小队创建播报

![小队创建播报](https://z1.ax1x.com/2023/12/05/pi61Eb4.png)

小队创建播报支持两种模式，需要在 ./cfg/config.sh 中修改模式和参数。
```
#小队创建广播模式，此功能关联小队创建时间查询
# 0=不广播 1=全部广播 2=不符合指定时长广播（忽略steam时长不可查）
CreatSquad_BroadcastMODE=2
#指定时长（分钟）
SLSteamDuration=6000
```

* CreatSquadTime - 小队创建时间查询
建议的触发关键词：squad、建队信息

此功能启用需要正确配置CreatSquadBroadcast功能，以确保本地能正确生成建队信息的缓存，否则此功能将会出现错误！

此功能支持灵活查询一至三个小队，游戏内用例：squad [Squad ID1] [Squad ID2] [Squad ID3]

![小队创建时间查询](https://z1.ax1x.com/2023/12/05/pi611KO.jpg)

* SignIn - 玩家签到功能
建议的触发关键词：签到、qd

此功能可以让玩家通过签到的方法获取积分。

* UserInfo - 玩家信息查询
建议的触发关键词：信息、info

玩家可以通过此功能查询自己的各项余额

* CdkyeActivation - CDK激活程序

通过此插件可以激活CDK，所有的CDK均在此处进行处理

CDK激活可以根据时间戳末尾数值来确定激活模式：0是任何人可用，1是无预留位的可用

这样可以防止特定活动渠道的CDK被同一玩家激活。

## 注意项
* 本项目随时更新，请及时更新！包括./cfg/config.sh文件，也可能存在新增配置项目，但是在更新过程中，会放入一些开发到一半的内容，但是一些可配置项目是开发调测完成的内容。
* 本项目严重依赖BattleMetrics的WebHook进行数据处理，请阅读BattleMetrics-Config中的帮助信息Help.txt进行配置

## 其他资料
* [访问冲锋号社区](https://bctc-squad.cn/)
* [BattleMetrics触发器传参汉化20231130](https://docs.qq.com/sheet/DY1BuUkpuVGRMSHh4)
