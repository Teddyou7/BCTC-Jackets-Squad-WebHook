
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

## 已完成开发的功能
* AverageGameDuration.txt - 平均时长查询功能

![平均时长查询功能](https://z1.ax1x.com/2023/12/01/pirOCE6.jpg)
* TeamDuration.sh - 小队员时长查询功能

![小队员时长查询功能](https://z1.ax1x.com/2023/12/01/pirOA8e.jpg)

* SteamStatisticsDuration - Steam统计时长查询

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

此功能启用需要正确配置CreatSquadBroadcast功能，以确保本地能正确生成建队信息的缓存，否则此功能将会出现错误！

![小队创建时间查询](https://z1.ax1x.com/2023/12/05/pi611KO.jpg)

## 注意项
* 本项目随时更新，请及时更新！包括./cfg/config.sh文件，也可能存在新增配置项目，但是在更新过程中，会放入一些开发到一半的内容，但是一些可配置项目是开发调测完成的内容。
* 本项目严重依赖BattleMetrics的WebHook进行数据处理，请阅读BattleMetrics-Config中的帮助信息Help.txt进行配置

## 其他资料
* [访问冲锋号社区](https://bctc-squad.cn/)
* [BattleMetrics触发器传参汉化20231130](https://docs.qq.com/sheet/DY1BuUkpuVGRMSHh4)
