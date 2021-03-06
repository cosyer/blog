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

- Mysql国内镜像：http://mirrors.sohu.com/mysql/MySQL-8.0/

下载完成后，选择一个磁盘内放置并解压。

## 设置环境变量 
1. 变量名：MYSQL_HOME
2. 变量值：E:\mysql5.7.23
3. path里添加：%MYSQL_HOME%\bin

## 初始化设置
### 创建data Uploads文件夹
### my.init文件

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

### 初始化生成data下文件(以管理员身份运行cmd)
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

## MySQL初始化root密码

- mysql默认root用户没有密码，输入mysql –u root 进入mysql

1. 进入mysql数据库
```js
use mysql;
```

2. 初始化root密码
```js
mysql>update user set password=PASSWORD('123456') where User='root';
```

`8.0+版本`
```js
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
```

## root密码忘记解决方法（Windows环境）

1. 确保MySQL服务停止

2. 打开第一个cmd窗口，进入MySQL安装目录下的bin目录

3. 跳过权限安全检查，MySQL服务运行起来后，不用输入密码就能进入数据库

例如，D:\mysql-5.5.35-win32\bin>mysqld –defaults-file=”D:\mysql-5.5.35-win32\my.ini” –console –skip-grant-tables

4. 打开第二个cmd窗口，连接MySQL

- 输入命令：mysql -uroot -p

- 出现 Enter password: 直接回车

5. 使用命令切换到mysql数据库：
```js
use mysql;
```

6. 使用命令更改root密码：
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

9. 关闭上面打开的两个cmd窗口，重新启动MySQL服务。

# mac

## 环境变量

```bash
vim ~/.bash_profile

export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/usr/local/mysql/support-files

source ~/.bash_profile 
echo $PATH
```

## MySQL服务的启停和状态的查看
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