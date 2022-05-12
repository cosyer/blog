---
title: linux安装mongodb及常见命令
tags:
  - 数据库
copyright: true
comments: true
date: 2019-07-20 14:20:40
categories: 工具
photos:
top: 260
---

{% fi http://cdn.mydearest.cn/blog/images/mongodb.jpg, MongoDB, MongoDB %}

## MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。

<!--more-->

## 安装、配置

```shell
## 下载 http://dl.mongodb.org/dl/linux/
curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.6.5.tgz

## 解压
tar -zxvf mongodb-linux-x86_64-3.6.5.tgz

## 移动到指定目录
mv mongodb-linux-x86_64-3.6.5/ /usr/local/mongodb

## MongoDB 的可执行文件位于 bin 目录下，所以可以将其添加到 PATH 路径中：当前终端有效(可跳过)
export PATH=/usr/local/mongodb/bin:$PATH

## 到根目录创建文件夹 或者mongodb下
mkdir data
mkdir data/db
mkdir data/log

## vim /etc/profile 添加到全局命令
export PATH=/usr/local/mongodb/bin:$PATH

## 如果有多个
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:/usr/local/mongodb/bin:$PATH

## 保存，退出，然后运行
source /etc/profile
```

```shell
## mongodb.conf
dbpath=/usr/local/mongodb/data/db
logpath=/usr/local/mongodb/data/log/mongodb.log
bind_ip=0.0.0.0
fork=true
```

```shell
## 查看
ps aux | grep -v grep | grep mongod
## 关闭
ps -ef|grep mongod
kill -9 xxx

## 后台启动 开启用户认证
nohup mongod --auth -f /usr/local/mongodb/mongodb.conf > myLog.log 2>&1 &

nohup mongod -f /usr/local/mongodb/mongodb.conf > myLog.log 2>&1 &
```

## brew 安装

```shell
brew tap mongodb/brew
brew install mongodb-community@4.4

# 启动
brew services start mongodb-community@4.4

# 停止
brew services stop mongodb-community@4.4

# 停止
db.adminCommand({ "shutdown" : 1 })
```

- 配置文件：/usr/local/etc/mongod.conf
- 日志文件路径：/usr/local/var/log/mongodb
- 数据存放路径：/usr/local/var/mongodb

### 常见命令

#### 设置用户和命令

```shell
## 权限登录
mongo admin -u cosyer -p xxx

## 创建管理员
mongo

use admin

db.createUser(
  {
    user: "testuser",
    pwd: "testpassword",
    roles: [ { role: "readWriteAnyDatabase", db: "admin" } ]
  }
)

## 认证登录
db.auth("admin", "password")

## 显示当前系统用户
db.system.users.find()

## 删除用户(删除用户的时候需要切换到用户管理的数据库才可以删除)
db.dropUser("testuser")

## 修改密码
db.addUser('testUser','111')

db.changeUserPassword('tank2','test')

## 修改用户权限
db.updateUser("cosyer",{roles:[ {role:"root",db:"admin"} ]})
```

## 权限说明
Read：允许用户读取指定数据库
readWrite：允许用户读写指定数据库
dbAdmin：允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
userAdmin：允许用户向system.users集合写入，可以找指定数据库里创建、删除和管理用户
clusterAdmin：只在admin数据库中可用，赋予用户所有分片和复制集相关函数的管理权限。
readAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读权限
readWriteAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读写权限
userAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的userAdmin权限
dbAdminAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的dbAdmin权限。
root：只在admin数据库中可用。超级账号，超级权限

#### mongoose 账号密码连接

```js
// mongodb://admin:123456@localhost:27017 //有用户名密码的情况
mongoose.connect("mongodb://user:pwd@111.231.121.29/ticket", {
  authSource: "admin",
  useMongoClient: true,
});
```

#### 导入导出表字段

```js
mongoexport -d book -c books -o books.json --type json

mongoimport -d book -c books --file /home/mongodump/articles.json --type json
```

#### 备份恢复数据库

```js
mongodump -h 127.0.0.1 -d book -o D:\iview-book-admin\static\js

mongorestore -h dbhost -d book --dir D:\iview-book-admin\static\js\book
```

### 可视化工具

- https://robomongo.org/download

## 安装 java

- https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html

## 安装 node
```bash
curl -O https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.gz

wget https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.gz

tar -xzvf node-v16.14.2-linux-x64.tar.gz

mv ./node-v16.14.2-linux-x64 /usr/local/node

vi /etc/profile
# 最后加上这句话：export PATH=$PATH:/usr/local/node/bin
# 让新加的配置生效：source /etc/profile

# 配软连接：
# 相当于全局变量，在任何文件夹都能查看版本信息
ln -s /usr/local/node/bin/node /usr/local/bin/
ln -s /usr/local/node/bin/npm /usr/local/bin/
```

## 卸载node
```bash
 -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}
```
