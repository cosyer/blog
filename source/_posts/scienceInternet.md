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

## {% fi http://cdn.mydearest.cn/blog/images/shadowsocks.jpg, Shadowsocks, Shadowsocks %}

<!-- more -->

{% note info %}

快速搭建 Shadowsocks

{% endnote %}

## [购买 Vultr 服务器](https://www.vultr.com/)

### Vultr 服务器价格

Vultr 服务器按小时计费,最低 0.004 美元/h,算起来 2.5 美元/月，且 destory 掉服务器是不收费的，所以不用担心如果暂时没有使用还一直扣费的问题。

最低价格的服务器是 512M 的内存，每个月 500G 的流量，只能说 99%的情况下完全够用了！

![introduce](http://cdn.mydearest.cn/blog/images/vultr.png)

## 买好中意的地区节点服务器之后，windows 系统可以用 Xshell ssh 连接到服务器，并执行以下搭建 ss 脚本命令

```javascript

wget --no-check-certificate -O shadowsocks.sh
https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh

chmod +x shadowsocks.sh

./shadowsocks.sh 2>&1 | tee shadowsocks.log

```

接着按照提示输入密码，端口和加密方式，如下图：

![ss1](http://cdn.mydearest.cn/blog/images/ss1.png)

![ss2](http://cdn.mydearest.cn/blog/images/ss1.png)

选择加密方式 7(aes-256-cfb)。

然后可以去听首歌~，成功安装之后有你配置的信息显示，记住这些信息。

## 安装 ss 客户端，配置好上面的服务器配置信息，就可以开心地玩耍了。Chrome 插件推荐使用 Proxy SwitchySharp 来管理和切换代理配置非常好用。

Windows 客户端(代理端口默认 1080)
https://github.com/shadowsocks/shadowsocks-windows/releases

Ubuntu
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5

Mac 客户端(代理端口默认 1086)

https://github.com/shadowsocks/ShadowsocksX-NG/releases

Android 客户端

https://github.com/shadowsocks/shadowsocks-android/releases
