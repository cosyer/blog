---
title: Python
tags:
  - 知识
copyright: true
comments: true
date: 2023-02-22 15:17:36
categories: 知识
photos:
top: 120
---

## 安装
> https://www.python.org/downloads/

## Python2和Python3

1. 系统自带的Python2会在 /usr/bin/，且没有pip，最好环境不要动

2. 环境变量的加载顺序/etc/profile /etc/paths ~/.bash_profile ~/.bash_login ~/.profile ~/.bashrc

```bash
python2 -V

python3 -V

# 一般自装的都会在 /usr/local/bin 下查看软链接

# which 查看软连接位置

rm -rf /usr/local/bin/pip

ln -s pip真实路径 /usr/local/bin/pip
```

## 镜像源
- 中国科学技术大学：https://pypi.mirrors.ustc.edu.cn/simple
- 豆瓣：http://pypi.douban.com/simple/
- 阿里云：http://mirrors.aliyun.com/pypi/simple/
- 中国科学技术大学：http://pypi.mirrors.ustc.edu.cn/simple/
- 华中科技大学：http://pypi.hustunique.com/
- 山东理工大学：http://pypi.sdutlinux.org/ 山东理工大学
- 百度：https://simple.baidu.com/pypi/simple

```bash
# 直接使用
pip3 install numpy -i https://pypi.tuna.tsinghua.edu.cn/simple

# 全局配置
mkdir ~/.pip
vim ~/.pip/pip.conf

[global]

index-url = https://pypi.tuna.tsinghua.edu.cn/simple

[install]

trusted-host = https://pypi.tuna.tsinghua.edu.cn

# 查看
pip3 config list
```
