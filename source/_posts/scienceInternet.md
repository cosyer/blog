---
title: 不能说的秘密
tags:
  - 未知
copyright: true
comments: true
date: 2018-06-07 10:21:24
categories: 工具
photos:
---

{% fi http://cdn.mydearest.cn/blog/images/shadowsocks.jpg, Shadowsocks, Shadowsocks %}
---
<!-- more -->

{% note info %}

快速搭建Shadowsocks

{% endnote %}

## [购买Vultr服务器](https://www.vultr.com/)

### Vultr服务器价格

Vultr服务器按小时计费,最低0.004美元/h,算起来2.5美元/月，且destory掉服务器是不收费的，所以不用担心如果暂时没有使用还一直扣费的问题。

最低价格的服务器是512M的内存，每个月500G的流量，只能说99%的情况下完全够用了！

![introduce](http://cdn.mydearest.cn/blog/images/vultr.png)

## 买好中意的地区节点服务器之后，windows系统可以用Xshell ssh连接到服务器，并执行以下搭建ss脚本命令

```javascript

wget --no-check-certificate -O shadowsocks.sh
https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
 
chmod +x shadowsocks.sh
 
./shadowsocks.sh 2>&1 | tee shadowsocks.log

```

接着按照提示输入密码，端口和加密方式，如下图：

![ss1](http://cdn.mydearest.cn/blog/images/ss1.png)

![ss2](http://cdn.mydearest.cn/blog/images/ss1.png)

选择加密方式7(aes-256-cfb)。

然后可以去听首歌~，成功安装之后有你配置的信息显示，记住这些信息。

## 安装ss客户端，配置好上面的服务器配置信息，就可以开心地玩耍了。Chrome插件推荐使用Proxy SwitchySharp来管理和切换代理配置非常好用。

Windows客户端(代理端口默认1080)
https://github.com/shadowsocks/shadowsocks-windows/releases

Ubuntu 
sudo add-apt-repository ppa:hzwhuang/ss-qt5 
sudo apt-get update 
sudo apt-get install shadowsocks-qt5

Mac客户端(代理端口默认1086)

https://github.com/shadowsocks/ShadowsocksX-NG/releases

Android客户端

https://github.com/shadowsocks/shadowsocks-android/releases