---
title: 微前端qiankun从搭建到部署的实践
tags:
  - qiankun
copyright: true
comments: true
date: 2022-4-15 15:39:48
categories: 前端
top: 107
photos:
---

## npm-run-all
npm-run-all 提供了多种运行多个命令的方式，常用的有以下几个：

```bash
--parallel: 并行运行多个命令，例如：npm-run-all --parallel lint build
--serial: 多个命令按排列顺序执行，例如：npm-run-all --serial clean lint build:**
--continue-on-error: 是否忽略错误，添加此参数 npm-run-all 会自动退出出错的命令，继续运行正常的
--race: 添加此参数之后，只要有一个命令运行出错，那么 npm-run-all 就会结束掉全部的命令
```

## qiankun概念
