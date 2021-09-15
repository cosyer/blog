---
title: Docker
tags:
  - 解决方案
copyright: true
comments: true
date: 2020-06-01 16:31:45
categories: 工具
photos:
---

Docker，是一款现在最流行的 软件容器平台，提供了软件运行时所依赖的环境。

## 物理机
硬件环境，真实的 计算机实体，包含了例如物理内存，硬盘等等硬件；

## 虚拟机:
在物理机上 模拟出一套硬件环境和操作系统，应用软件可以运行于其中，并且毫无感知，是一套隔离的完整环境。本质上，它只是物理机上的一份运行文件。

## 为什么需要虚拟机？

### 环境配置与迁移
在软件开发和运行中，环境依赖一直是一个很头疼的难题，比如你想运行 node 应用，那至少环境得安装 node 吧，而且不同版本，不同系统都会影响运行。解决的办法就是我们的包装包中直接包含运行环境的安装，让同一份环境可以快速复制到任意一台物理机上。

### 资源利用率与隔离
通过硬件模拟，并包含一套完整的操作系统，应用可以独立运行在虚拟机中，与外界隔离。并且可以在同一台物理机上，开启多个不同的虚拟机启动服务，即一台服务器，提供多套服务，且资源完全相互隔离，互不影响。不仅能更好提高资源利用率率，降低成本，而且也有利于服务的稳定性。

### 传统虚拟机的缺点

#### 资源占用大
由于虚拟机是模拟出一套完整系统，包含众多系统级别的文件和库，运行也需要占用一部分资源，单单启动一个空的虚拟机，可能就要占用 100+MB 的内存了。
 
#### 启动缓慢
同样是由于完整系统，在启动过程中就需要运行各种系统应用和步骤，也就是跟我们平时启动电脑一样的耗时。

#### 冗余步骤多
系统有许多内置的系统操作，例如用户登录，系统检查等等，有些场景其实我们要的只是一个隔离的环境，其实也就是说，虚拟机对部分需求痛点来说，其实是有点过重的。

## Linux 容器
Linux 中的一项虚拟化技术，称为 Linux 容器技术(LXC)。它在进程层面模拟出一套隔离的环境配置，但并没有模拟硬件和完整的操作系统。因此它完全规避了传统虚拟机的缺点，在启动速度，资源利用上远远优于虚拟机；

---
<!--more-->

## Docker

Docker 就是基于 Linux 容器的一种上层封装，提供了更为简单易用的 API 用于操作 Docker，属于一种`容器解决方案`。
基本概念: 在 Docker 中，有三个核心的概念:

### 镜像 (Image):

1. 从原理上说，镜像属于一种`root 文件系统`，包含了一些系统文件和环境配置等，可以将其理解成一套`最小操作系统`。为了让镜像轻量化和可移植，Docker 采用了`Union FS 的分层存储模式`。将文件系统分成一层一层的结构，逐步从底层往上层构建，每层文件都可以进行继承和定制。这里从前端的角度来理解:`镜像就类似于代码中的 class，可以通过继承与上层封装进行复用`。
2. 从外层系统看来，一个镜像就是一个 Image`二进制文件`，可以任意迁移，删除，添加；`镜像是容器的基石，不包含任何动态数据。`

### 容器 (Container):

1. 镜像是一份静态文件系统，无法进行运行时操作，就如class，如果我们不进行实例化时，便无法进行操作和使用。因此`容器可以理解成镜像的实例(镜像运行的实体)`，即`new 镜像()`，这样我们便可以创建、修改、操作容器；一旦创建后，就可以简单理解成一个轻量级的操作系统，可以在内部进行各种操作，例如运行 node 应用，拉取 git 等；
2. 基于镜像的分层结构，容器是`以镜像为基础底层`，在上面封装了一层`容器的存储层`；

- 存储空间的生命周期与容器一致；
- 该层存储层会随着容器的销毁而销毁；
- 尽量避免往容器层写入数据；

3. 容器中的数据的持久化管理主要由两种方式:

- 数据卷 (Volume): 一种可以在多个容器间共享的特殊目录，其处于容器外层，并不会随着容器销毁而删除；
- 挂载主机目录: 直接将一个主机目录挂载到容器中进行写入；

4. 容器运行着真正的应用进程。有着初建、运行、停止、暂停和删除5种状态。本质上是在主机上运行的一个进程，但容器有自己独立的命名空间隔离和资源
限制。

### 仓库 (Repository):

1. 为了便于镜像的使用，Docker 提供了类似于 git 的仓库机制，在仓库中包含着各种各样版本的镜像。官方服务是 Docker Hub；
2. 可以快速地从仓库中拉取各种类型的镜像，也可以基于某些镜像进行自定义，甚至发布到仓库供社区使用；

### 安装
- linux
> curl -sSL https://get.docker.com/ | sh或者wget -qO- https://get.docker.com/ | sh

```bash
curl https://get.docker.com/ > install-docker.sh # 下载安装脚本
sh install-docker.sh # 执行安装脚本
```

- Mac
https://download.docker.com/mac/stable/Docker.dmg

- windows
https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe

### 第一个 docker 项目
接下来我们搭建一个能够托管静态文件的 Nginx 服务器，容器运行程序，而容器哪来的呢？容器是镜像创建出来的。那镜像又是哪来的呢？

镜像是通过一个 Dockerfile 打包来的，它非常像我们前端的package.json文件。

```
Dockerfile: 类似于“package.json”
 |
 V
Image: 类似于“Win7纯净版.rar”
 |
 V
Container: 一个完整操作系统
```

#### 创建文件
```
hello-docker
  |____index.html
  |____Dockerfile
```
- index.html
```html
<h1>Hello docker</h1>
```

- Dockerfile
```
FROM nginx

COPY ./index.html /usr/share/nginx/html/index.html

EXPOSE 80
```

#### 打包镜像
```bash
cd hello-docker/ # 进入刚刚的目录
docker image build ./ -t hello-docker:1.0.0 # 打包镜像
```
此时遇到问题`Docker 安装后 报 Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running? `

```bash
systemctl daemon-reload
sudo service docker restart
sudo service docker status (should see active (running))
```
然后重新运行 `docker image build ./ -t hello-docker:1.0.0` 命令。这条命令的意思是基于路径./（当前路径）打包一个镜像，镜像的名字是hello-docker，版本号是1.0.0。该命令会自动寻找
Dockerfile来打包出一个镜像。

解读下Dockerfile的内容：
- FROM nginx：基于哪个镜像
- COPY ./index.html /usr/share/nginx/html/index.html：将宿主机中的./index.html文件复制进容器里的/usr/share/nginx/html/index.html
- EXPOSE 80：容器对外暴露80端口

> 注意！Docker 中的选项（Options）放的位置非常有讲究，docker --help image和docker image --help是完全不同的命令

#### 配置国内镜像源
在 Linux 环境下，我们可以通过修改 /etc/docker/daemon.json ( 如果文件不存在，你可以直接创建它 ) 这个 Docker 服务的配置文件达到效果。
- Docker中国官方镜像加速
```
{
    "registry-mirrors": [
        "https://registry.docker-cn.com"
    ]
}
```
- 网易163镜像加速
```
{
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```
- 中科大镜像加速
```
{
    "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]     
}
```
- 直接下载站点镜像
> docker pull hub.c.163.com/library/tomcat:latest  //复制站点链接用 pull 下来

然后重启 docker 让配置生效
```bash
sudo systemctl restart docker
```

通过 docker info 来查阅当前注册的镜像源列表，验证我们配置的镜像源是否生效
```bash
sudo docker info
```

#### 运行容器
```bash
docker container create -p 9000:80 hello-docker:1.0.0 # 根据镜像创建容器
docker container start xxx # xxx 为上一条命令运行得到的结果
```

然后在浏览器打开ip:9000，就能刚刚自己写的index.html内容。

在上边第一个命令中，我们使用docker container create来创建基于hello-docker:1.0.0镜像的一个容器，使用-p来指定端口绑定——将容器中的80端口绑定在宿主机的9000端口。执行完该命令，会返回一个容器ID
而第二个命令，则是启动这个容器启动后，就能通过访问本机的9000端口来达到访问容器内80端口的效果了

> Tips: 你可以使用docker container ls来查看当前运行的容器
当容器运行后，可以通过如下命令进入容器内部：
```bash
docker container exec -it xxx /bin/bash # xxx 为容器ID
```

原理实际上是启动了容器内的/bin/bash，此时你就可以通过bash shell与容器内交互了。就像远程连接了SSH一样

#### 退出容器
```bash
exit # 直接退出

ctrl + p + q # 退出不停止
```

#### 制作镜像
```bash
docker commit -m='message' -a='cosyer' containerId hello-docker:1.0.1
```

#### DockerFile
- FROM：这个镜像依赖谁（基础镜像）
- MAINTAINER：这个镜像是谁写的（维护者的信息）
- RUN：构建镜像需要运行的命令
- ADD：步骤：copu 文件，会自动解压
- WORKDIR：设置当前工作目录
- VOLUME：设置券，挂载主机目录
- EXPOSE： 暴露端口
- CMD：指定这个容器启动的时候要运行的命令 只有最后一个会生效，可被替代
- ENTRYPOINT：指定这个容器启动的时候要运行的命令，可以追加命令
- ONBUILD：当构建一个被继承 DockerFile 这个时候就会运行 ONBUILD 的命令，触发指令
- COPY：类似 ADD 将我们的文件拷贝到镜像中
- ENV：构建镜像的时候设置环境变量

#### 发布镜像
- docker login
- docker tag imageId message
- docker push imageId

#### 重命名镜像
```bash
docker tag busybox:latest mybusybox:latest
```

#### 总结
1. 写一个 Dockerfile
2. 使用docker image build来将Dockerfile打包成镜像
3. 使用docker container create来根据镜像创建一个容器
4. 使用docker container start来启动一个创建好的容器

```bash
# images
docker pull image
docker images # 查看所有镜像
docker image ls
docker images | grep busybox
docker rmi imageId -f # 强制删除镜像
docker rmi -f \$(docker images -aq) # 小技巧删除所有镜像
docker image rm

# container
docker ps # 查看运行容器
-a 列出历史
-n 列出最近
-q 只显示编号
docker rm containerId # 删除容器
docker rmi -f \$(docker ps -aq) # 小技巧删除所有容器
docker start id # 启动容器
docker restart id #重启容器
docker stop id # 停止当前运行的容器
docker kill id # 强制停止当前运行容器
docker inspect containerId # 查看容器基本信息
docker logs containerId # 查看容器日志
docker exec -it containerId /bin/bash # 进入容器
docker attach # 本机输入到容器中
docker cp 本机路径 容器id:文件路径 # 主机内容拷贝到容器
docker cp 容器id:文件路径 本机路径 # 容器拷贝内容到主机
```

![docker](http://cdn.mydearest.cn/blog/images/docker.png)

```bash
iptables --list | grep DOCKER

iptables -t nat -nvL

sysctl net.ipv4.ip_forward  

firewall-cmd --state

vi /etc/sysctl.conf

docker rm -f `docker ps -a -q`

docker inspect my-nginx9|grep IPAddress

docker container run --name nginxserver -d -p 80:80 nginx

172.17.0.2:80
```

- 遇到了centos7系统docker 宿主机不能访问容器问题，unbantu系统没问题
```bash
#停止docker
systemctl stop docker
#关闭docker0
ip link set dev docker0 down
#删除docker0网桥
brctl delbr docker0
#防火墙设置,后来发现这一步不用执行可以
iptables -t nat -F POSTROUTING
#增加docker0 网桥
brctl addbr docker0
#增加网卡
ip addr add 172.16.10.1/24 dev docker0
#启用网卡
ip link set dev docker0 up
#重启docker服务
systemctl restart docker
```

#### 三种网络模式
- bridge(桥接)
- host(主机模式与宿主机共享网络)
- none(不配置网络)
```bash
# 自定义网络
docker network create --driver bridge --subnet 192.168.3.0/16 --gateway 192.168.3.1 mynet

# 查看网络列表
docker network ls
# 删除网络
docker neteork rm id
```

### SPA应用静态站点迁移
之前的步骤：
1. 本地`npm run build`打包静态文件
2. 手动FTP传输到服务器
3. git push更新github

自动化CI：
1. 执行git push
2. 自动检测到 github 有代码更新，自动打包出一个 Docker 镜像
3. CI 编译完成后，SSH 登录 VPS，删掉现有容器，用新镜像创建一个新容器

好处：
1. 不必再手动 FTP 上传文件
2. 当进行修改错别字这样的简单操作时，可以免测。改完直接git push，而不必本地npm run build

#### travis
免费的CI资源[travis](https://www.travis-ci.org/)，需要在[/hub.docker.com](https://hub.docker.com/)注册账号。
使用 Github 登录 Travis CI 后，在左边点击+加号添加自己的 Github 仓库后，需要移步到 Setting 为项目添加DOCKER_USERNAME和DOCKER_PASSWORD环境变量。这样保证我们可以秘密的登录 Docker Hub 而
不被其他人看到自己的密码。

```
language: node_js
node_js:
  - "12"
services:
  - docker

before_install:
  - npm install

script:
  - npm run build
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - docker build -t cosyer/hello-docker:1.0.0 .
  - docker push cosyer/hello-docker:1.0.0
```

然后需要添加 Dockerfile 文件来描述如何打包 Docker 镜像。
按照.travis.yml的命令次序，在打包镜像时，npm run build已经执行过了，项目产出已经有了。不必在 Docker 容器中运行npm install和npm run build之类的，直接复制文件即可：

```
FROM nginx

COPY ./dist/ /usr/share/nginx/html/
COPY ./vhost.nginx.conf /etc/nginx/conf.d/hello-docker.conf

EXPOSE 80
```
将不访问文件的请求全部重定向到/index.html，处理history路由`vhost.nginx.conf`
```
server {
    listen 80;
    server_name localhost;
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        proxy_set_header Host $host;

        if (!-f $request_filename) {
          rewrite ^.*$ /index.html break;
        }

    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

### nginx反向代理
宿主机`/etc/nginx/conf.d/vhost.conf`
```
server {
    listen 80;
    server_name pea3nut.info;

    location / {
        proxy_pass http://127.0.0.1:8082;
    }
}
```
配置的意思是，监听来自 80 端口的流量，若访问域名是mydearest.cn（替换为你自己的域名），则全部转发到http://127.0.0.1:8082中

### nodejs站点迁移(express)
之前的步骤：
1. 本地修改好 Ejs 或者其他文件
2. 手动通过 FTP 上传到服务器
3. 在服务器端重启 Nodejs 进程。若有 npm 包依赖改动，需要在VP S服务器上手动执行npm install
4. git push更新 Github 源码

> Tips: 你可能发现了 Dockerfile 中的ENTRYPOINT命令必须指定一个前台进程。若你的 Nodejs 应用是使用 PM2 进行保护的，你需要替换pm2 start app.js为pm2-docker app.js

### docker-compose  
docker-compose 是 Docker 官方提供的一个 Docker 管理工具。

docker-compose 和 Docker 差不多，也是只要一份文件就能跑起来。docker-compose 主要的作用就是能够让你不必手敲那么多 Docker 命令

- 安装
```bash
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

- 目录
建立一个目录，然后在目录中建立docker-compose.yml，内容如下：
```bash
version: "3.7" # 这个是配置文件的版本，不同的版本号声明方式会有细微的不同
services:
    info:
        container_name: hello-docker
        image: cosyer/hello-docker:1.0.0
        ports:
            - "8082:80"
        restart: on-failure
```

- 启动
```bash
docker-compose up info
```
docker-compose 会帮我们自动去拉镜像，创建容器，将容器中的80端口映射为宿主机的8082端口。restart字段还要求 docker-compose 当发现容器意外挂掉时
重新启动容器，类似于 pm2，所以你不必再在容器内使用 pm2

如果想要更新一个镜像创建新容器，只需要：
```bash
docker-compose pull info
docker-compose stop info
docker-compose rm info
docker-compose up -d info # -d 代表后台运行
```
