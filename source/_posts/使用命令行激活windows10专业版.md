---
title: 使用命令行激活windows10专业版
tags:
  - windows10激活
copyright: true
comments: true
date: 2018-12-03 01:29:48
categories: 知识
photos:
top: 127
---

以管理员的身份运行cmd

1. 先卸载密钥
```bash
slmgr.vbs /upk
```
- 此时弹出窗口显未“已成功卸载了产品密钥”。

2. 安装密钥
```bash
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
```
- 弹出窗口提示：“成功的安装了产品密钥”。

3. 设置计算机名
```bash
slmgr /skms cosyer的个人电脑
```
- 弹出窗口提示：“密钥管理服务计算机名成功的设置为cosyer的个人电脑”。

---
<!-- more -->

4. 激活密钥
```bash
slmgr /ato
```
- 此时将弹出窗口提示：“成功的激活了产品”。

如果第4步未能成功地激活，则重复执行第3步、第4步，且将第3步的语句修改为以下几个之一，需要一个一个进行尝试。

```bash
“slmgr /skms 110.noip.me”
“slmgr /skms kms.lotro.cc”
“slmgr /skms mhd.kmdns.net”
“slmgr /skms xykz.f3322.org”
“slmgr /skms 106.186.25.239”
“slmgr /skms 3rss.vicp.net:20439”
“slmgr /skms 45.78.3.223”
“slmgr /skms kms.chinancce.com”
“slmgr /skms kms.didichuxing.com”
“slmgr /skms skms.ddns.net”
“slmgr /skms franklv.ddns.net”
“slmgr /skms 192.168.2.8”
```