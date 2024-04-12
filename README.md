## Terminal-station13 (/tg/station - Skyrat Downstream)

[![CI Suite](https://github.com/Skyrat-SS13/Skyrat-tg/workflows/CI%20Suite/badge.svg)](https://github.com/Skyrat-SS13/Skyrat-tg/actions?query=workflow%3A%22CI+Suite%22)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/Skyrat-SS13/Skyrat-tg.svg)](https://isitmaintained.com/project/Skyrat-SS13/Skyrat-tg "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/Skyrat-SS13/Skyrat-tg.svg)](https://isitmaintained.com/project/Skyrat-SS13/Skyrat-tg "Average time to resolve an issue")
![Coverage](https://img.shields.io/codecov/c/github/Skyrat-SS13/Skyrat-tg)

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| 网页                   | 链接                                           |
|---------------------------|------------------------------------------------|
| TGwiki                    | [https://tgstation13.org/wiki/Main_Page](https://tgstation13.org/wiki/Main_Page)          |
| Skyrat项目代码            | [https://github.com/Skyrat-SS13/Skyrat-tg](https://github.com/Skyrat-SS13/Skyrat-tg)    |
| SkyratWiki                | [https://wiki.skyrat13.space/index.php/Main_Page](https://wiki.skyrat13.space/index.php/Main_Page)   |


这是byond引擎下，/tg/station下游分支skyrat的下游分支.

十三号空间站是一款风格荒诞的角色扮演游戏，游戏设定在遥远的26世纪的一家公司的空间站内，在这里你将能够扮演空间站中的不同职业，从事自己感兴趣的工作，并最终意外又毫不意外地迎来毁灭.游戏内容极其丰富，在拥有几十种职业的情况下，每种职业的玩法都值得花费数十小时去探索.作为一款经典的老游戏，你也可以从中看到许多其他游戏的灵感来源.

## 下载后如何编译

在根目录下找到`BUILD.bat`，双击并等待运行结束（tgui编译完成即可）.

在根目录选找到tgstation.dme，双击运行后，从左上角菜单栏中找到Build选项并点击其下的Compile选项.

等待编译完成，在显示无错误后，根目录下生成tgstation.dmb，编译完成.

## 编译后如何主持游戏

按下Windows键+R，输入%USERPROFILE%\Documents\BYOND，找到并打开cfg文件夹中的daemon.txt，将host-port后的数字改为端口号.（仅限想要搭建多人游戏服务器的时候需要做这一步）

在根目录选找到tgstation.dme，从左上角菜单栏中找到Build选项并点击其下的Host选项（或者打开byond安装文件夹中的dreamdaemon.exe，在底下的File中选中对应的dmb文件）.

在新弹出的Dream Daemon窗口中，从左上角菜单栏中找到World选项并点击其下的Go选项.

等待游戏加载完成，点击Join即可进入游戏.

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
