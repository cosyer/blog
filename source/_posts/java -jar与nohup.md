---
title: java -jar与nohup
tags:
  - Java
copyright: true
comments: true
date: 2018-11-13 09:30:14
categories: 知识
photos:
top: 115
---

java 程序员，经常会遇到这样一个问题，打个 jar 包，测试或者上线生产，于是乎面临的选择来了，java –jar or nohup？
下面我来扒一扒：

## java -jar a.jar &

直接启动 jar 文件，在当前会话进程中开启一个子进程来运行程序，这个子进程会随着会话进程的结束而结束。

这种情况适合短时间测试用。

## nohup java -jar a.jar &

hangup ：(挂断)，终端退出时会发送 hangup 信号来通知其关闭所有子进程。

nohup ：(不挂断，忽略挂断信号)。

nohup 的使用是十分方便的，只需在要处理的命令前加上 nohup 即可，标准输出和标准错误缺省会被重定向到 nohup.out 文件中。一般我们可在结尾加上"&"来将命令同时放入后台运行，也可用">filename2>&1"来更改缺省的重定向文件名。

这种情况适合在生产环境长时间运行。

## nodejs 应用在 linux 上运行

### 使用场景

- forever 管理多个站点，每个站点访问量不大，不需要监控。
- supervisor 是开发环境用。
- nodemon 是开发环境使用，修改自动重启。
- pm2 网站访问量比较大,需要完整的监控界面。

1. forever

```javascript
npm install -g forever
forever start index.js -o out.log -e err.log
forever list
forever stop index.js [id]
forever stopall
forever restartall
```

2. supervisor 热部署

```javascript
npm install -g supervisor
supervisor app.js // 文件有改动会立即重启node模块
```

3. nodemon

```javascript
npm install -g nodemon
nodemon app.js
```

4. nohup

```javascript
nohup node index.js &
nohup node index.js > myLog.log 2>&1 &
// npm install -g babel-cli
nohup babel-node index.js > myLog.log 2>&1 &
```

nohup 问题:

但是有时候在这一步会有问题，当把终端关闭后，进程会自动被关闭，查看 nohup.out 可以看到在关闭终端瞬间服务自动关闭。
有个操作终端时的细节：当 shell 中提示了 nohup 成功后还需要按终端上键盘任意键退回到 shell 输入命令窗口，然后通过在 shell 中输入 exit 来退出终端；
而我是每次在 nohup 执行成功后直接点关闭程序按钮关闭终端。所以这时候会断掉该命令所对应的 session，导致 nohup 对应的进程被通知需要一起 shutdown。

5. 高大上的 pm2

特性：

- 内建负载均衡（使用 Node cluster 集群模块）
- 后台运行
- 0 秒停机重载，维护升级的时候不需要停机
- 具有 Ubuntu 和 CentOS 的启动脚本
- 停止不稳定的进程（避免无限循环）
- 控制台检测
- 提供 HTTP API
- 远程控制和实时的接口 API ( Nodejs 模块,允许和 PM2 进程管理器交互 )

使用：

```javascript
npm install -g pm2
pm2 start app.js -o out.log -e err.log
pm2 stop app.js
pm2 restart app.js
pm2 list
pm2 descibe [id]
pm2 monit // 查看cpu和内存使用
pm2 logs // 实时集中log处理
pm2 web // 浏览器查看
```
