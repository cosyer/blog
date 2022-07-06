---
title: 安装mysql
tags:
  - mysql
copyright: true
comments: true
date: 2020-06-23 17:05:10
categories: 工具
top: 104
photos:
---

# windows

## 安装包下载

- 下载地址：https://dev.mysql.com/downloads/mysql/

- Mysql 国内镜像：http://mirrors.sohu.com/mysql/MySQL-8.0/

下载完成后，选择一个磁盘内放置并解压。

## 设置环境变量

1. 变量名：MYSQL_HOME
2. 变量值：E:\mysql5.7.23
3. path 里添加：%MYSQL_HOME%\bin

## 初始化设置

### 创建 data Uploads 文件夹

### my.init 文件

```js
[mysqld]
port=3306
character_set_server=utf8
basedir=E:\mysql5.7.23
datadir=E:\mysql5.7.23\data
server-id=1
sql_mode=NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
lower_case_table_names=1
innodb_file_per_table = 1
log_timestamps=SYSTEM

log-error   = error.log
slow_query_log = 1
slow_query_log_file = slow.log
long_query_time = 5
log-bin = binlog
binlog_format = row
expire_logs_days = 15
log_bin_trust_function_creators = 1
secure-file-priv=E:\mysql5.7.23\Uploads

[client]
default-character-set=utf8
```

---

<!--more-->

### 初始化生成 data 下文件(以管理员身份运行 cmd)

```js
mysqld --initialize-insecure
```

### 安装服务

```js
mysqld --install mysql8
```

### 启动和停止

```js
net start mysql8
net stop mysql8
```

## MySQL 初始化 root 密码

- mysql 默认 root 用户没有密码，输入 mysql –u root 进入 mysql

1. 进入 mysql 数据库

```js
use mysql;
```

2. 初始化 root 密码

```js
mysql>update user set password=PASSWORD('123456') where User='root';
```

`8.0+版本`

```js
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
```

## root 密码忘记解决方法（Windows 环境）

1. 确保 MySQL 服务停止

2. 打开第一个 cmd 窗口，进入 MySQL 安装目录下的 bin 目录

3. 跳过权限安全检查，MySQL 服务运行起来后，不用输入密码就能进入数据库

例如，D:\mysql-5.5.35-win32\bin>mysqld –defaults-file=”D:\mysql-5.5.35-win32\my.ini” –console –skip-grant-tables

4. 打开第二个 cmd 窗口，连接 MySQL

- 输入命令：mysql -uroot -p

- 出现 Enter password: 直接回车

5. 使用命令切换到 mysql 数据库：

```js
use mysql;
```

6. 使用命令更改 root 密码：

```js
UPDATE user SET Password=PASSWORD('123456') where USER='root';
```

7. 刷新权限：

```js
FLUSH PRIVILEGES;
```

8. 退出：

```js
quit;
```

9. 关闭上面打开的两个 cmd 窗口，重新启动 MySQL 服务。

# mac

## 环境变量

```bash
vim ~/.bash_profile

export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/mysql/support-files

source ~/.bash_profile
echo $PATH
```

## MySQL 服务的启停和状态的查看

```bash
# 启动
sudo mysql.server start

# 停止
sudo mysql.server stop

# 重启
sudo mysql.server restart

# 服务状态
sudo mysql.server status
```

## mac 偏好设置 mysql 图标重启后才有

## 安装 redis

```bash
brew install redis

# Homebrew安装的软件会默认在/usr/local/Cellar/路径下
# redis的配置文件redis.conf存放在/usr/local/etc路径下

# 方式一：使用brew帮助我们启动软件
brew services start redis
# 方式二
redis-server /usr/local/etc/redis.conf

# 查看服务进程
ps axu | grep redis

# redis-cli连接服务
## 交互模式
redis-cli -h 127.0.0.1 -p 6379

## redis-cli
redis-cli

## PING
PING

# 关闭redis
redis-cli shutdown

# 强制关闭
sudo pkill redis-server

# 设置key-value
SET name cosyer

GET  name

DEL name

EXISTS name

# 创建列表
LPUSH list cosyer
LPUSH list admin

# 查询指定index元素
LINDEX list -1

# 创建集合 无重复数据
SADD name cosyer

## 可关联分数
ZADD name 1 cosyer

# 订阅消息
SUBSCRIBE name

# 发送消息
PUBLISH name "cosyer"

```

## LNMP 环境安装 oneinstack

```bash
cd  /root/oneinstack
grep dbrootpwd options.conf #显示数据库root密码

./reset_db_root_password.sh -f #重置密码
```

## mysql5.6和8.0版本sql 8.0 => 5.6(Unknown collation: 'utf8mb4_0900_ai_ci')
1. 把文件中的所有的utf8mb4_0900_ai_ci替换为utf8_general_ci
2. 以及utf8mb4替换为utf8
