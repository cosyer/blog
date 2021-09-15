---
title: elasticsearch、redis部署
tags:
  - 数据库
copyright: true
comments: true
date: 2020-09-18 11:14:08
categories: 工具
photos:
---

# skywalking

##  预安装JDK

[Linux系统（Centos yum）下安装Java环境](https://www.cnblogs.com/cosyer/p/7827995.html)

## elasticsearch

### 官网下载 https://www.elastic.co/cn/downloads/elasticsearch

### 解压
```bash
# 解压
tar -zxvf elasticsearch-6.1.0.tar.gz

# 配置 config/elasticsearch.yml
cluster.name: myskywalking
path.data: /opt/data/es/data
path.logs: /opt/data/es/logs
bootstrap.memory_lock: false
network.host: 193.160.59.45

# 单机运行
./bin/elasticsearch -V

# 后台运行
./bin/elasticsearch -d

# 访问
http://127.0.0.1:9200
```

### 常见问题
1. 需要非root用户启动

2. 【报错】max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144] 内存过小
解决:
```bash
# 1.sudo vi /etc/sysctl.conf 文件最后添加一行
#    vm.max_map_count=262144
# 2.加载设置好的系统参数
#    sudo sysctl -p
```

---
<!--more-->

## 下载 skywalking https://github.com/apache/skywalking (对于5.0版本的Skywalking要求ES的版本也为5.x)
```bash
# 解压
tar -xvzf apache-skywalking-apm-incubating-5.0.0-GA.tar.gz -C /usr/local/

# 修改配置 /usr/local/apache-skywalking-apm-incubating/config/application.yml 
host: 本机ip

# 修改skywalking-webapp配置文件
listOfServers: 本机ip:10800

# 启动
sh /usr/local/apache-skywalking-apm-incubating/bin/startup.sh

# 访问
http://127.0.0.1:8080
```

# eureka
```bash
# 启动
nohup java -jar clustereureka-0.0.1-SNAPSHOT-ui.jar --spring.profiles.active=cluster2 > eureka_log.log &

# 修改
jar xvf clustereureka-0.0.1-SNAPSHOT.jar
# 修改里面的jar包
jar xvf spring-cloud-netflix-eureka-server-2.1.0.RELEASE.jar
# 重新打包
jar -cfM0 clustereureka-0.0.1-SNAPSHOT.jar ./
# /BOOT-INF/classes 
application-cluster1.yml  application-cluster2.yml  application-cluster3.yml 对应修改hostname，defaultZone其他注册中心地址

# 访问
http://127.0.0.1:7072
```

# redis-stat
## 预安装redis
```bash
# 下载
wget http://download.redis.io/releases/redis-4.0.8.tar.gz

# 解压
tar xzvf redis-4.0.8.tar.gz

# 安装
cd redis-4.0.8
make
cd src
make install PREFIX=/usr/local/redis

# 移动配置文件
cp ./redis.conf /usr/local/redis/bin/

# 配置redis为后台启动 /usr/local/redis/redis.conf 
将daemonize no 改成daemonize yes

# 启动
./redis-server redis.conf

redis-server &

# 加入开机启动
vi /etc/rc.local //在里面添加内容：/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf (意思就是开机调用这段开启redis的命令)

# 将redis-cli,redis-server拷贝到bin下，让redis-cli指令可以在任意目录下直接使用
cp /usr/local/redis/bin/redis-server /usr/local/bin/
cp /usr/local/redis/bin/redis-cli /usr/local/bin/

# 访问
/usr/local/redis/bin/redis-cli
```

## 下载 https://github.com/junegunn/redis-stat
```bash
# 启动 不支持nohup后台启动
screen java -jar redis-stat-0.4.14.jar --server

# 访问
http://127.0.0.1:63790
```

# nginx
## 下载 https://nginx.org/download/
```bash
# 一键安装上面四个依赖
yum -y install gcc pcre-devel zlib-devel openssl openssl-devel

# 解压
tar -zxvf nginx-1.9.9.tar.gz

# 进入nginx目录
cd nginx-1.9.9

# 配置
./configure --prefix=/usr/local/nginx

# make
make
make install

# cd到刚才配置的安装目录/usr/loca/nginx/
./sbin/nginx -t

# 正常情况的信息输出：
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful

# 启动
./sbin/nginx

# 访问
http://127.0.0.1:80

# 无法访问 80端口没有开启。no
firewall-cmd --query-port=80/tcp

# 开启80端口
firewall-cmd --add-port=80/tcp --permanent

# 重启防火墙
systemctl restart firewalld

# 配置开机自启动
vim /etc/rc.d/rc.local

/usr/local/nginx/sbin/nginx

# 重启nginx
/usr/local/nginx/sbin/nginx -s reload
```
