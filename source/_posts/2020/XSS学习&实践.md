---
title: XSS学习&实践
tags:
  - 前端
copyright: true
comments: true
date: 2020-06-24 01:13:10
categories: 工具
top: 104
photos:
---

`web安全`一直是开发中不可忽视的一部分。而xss作为web开发中最常见的攻击手段，防范是必然的。基于web浏览器tricks，JavaScript的发展，npm等开源项目漏
洞，web注入等会让开发者越来越防不胜防。

## 插入执行标签
- script
- img onerror触发
- iframe srcdoc触发

## 标签等提前闭合(截断)
- 如在富文本, input, textarea, 可编辑div等，[0x01](https://xss.haozi.me/#/0x01)，[0x02](https://xss.haozi.me/#/0x02)
- style标签
```js
<style>
</style ><script>alert(1)</script>
</style>
```
- 注释提前闭合
```js
--!><script>alert(1)</script>
```

---
<!--more-->

- input type重写
input的type，在type之前可以重写为image，通过onerror注入

## ES6 tag标签
```js
<script>alert`1`</script>
```

## 转义字符仍可执行
- script标签可执行 base64的html代码片段
- onerror可执行 转义为 html 10进制， 16进制的代码片段
- url转义为 html 10进制， 16进制 仍可执行, url的定义可获取其他域下的资源文件
```js
scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]
```

## svg不闭合也执行
## 正则替换不靠谱
- 正则替换
- 正则命中
- 追加执行，正则替换失效

## 防护
- 配置安全头
- xss监控
- 服务端白名单过滤
