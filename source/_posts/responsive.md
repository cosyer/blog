---
title: 响应式网页设计
tags:
  - 前端
copyright: true
comments: true
date: 2018-06-20 01:33:47
categories: CSS
top: 107
photos:
---

## 什么是响应式网站

响应式布局是Ethan Marcotte在2010年5月份提出的一个概念，简而言之，就是一个网站能够兼容多个终端——而不是为每个终端做一个特定的版本。这个概念是为解决移动互联网浏览而诞生的。Web设计应该做到根据不同设备环境自动响应及调整。当然响应式Web设计不仅仅是关于屏幕分辨率自适应以及自动缩放的图片等等，它更像是一种对于设计的全新思维模式；我们应当向下兼容、移动优先。

--- 
<!--more -->

## 背景

1. PC互联网加速向移动端迁移
2. 移动端入口
3. 开发成本低，门槛低
4. 跨平台和终端且不需要分配子域，1页面适配多终端

- PC – http://qzone.com
- Mobile – http://m.qzone.com
- 响应式：PC & Mobile – http://qzone.com 无需跳转
5. 无需安装成本，迭代更新容易

![setup](http://cdn.mydearest.cn/blog/images/setup.png)

如我们需要兼容不同屏幕分辨率、清晰度以及屏幕定向方式竖屏(portrait)、横屏(landscape)，怎样才能做到让一种设计方案满足所有情况？
那么我们的布局应该是一种弹性的栅格布局，不同尺寸下弹性适应，如以下页面中各模块在不同尺寸下的位置：

![responsive-layout](http://cdn.mydearest.cn/blog/images/responsive-layout.png)

那么我们要怎么做？
- Meta标签定义

1. 使用 viewport meta 标签在手机浏览器上控制布局
```html
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1" />
```

2. 通过快捷方式打开时全屏显示
```html
<meta name="apple-mobile-web-app-capable" content="yes" />
```

3. 隐藏状态栏
```html
<meta name="apple-mobile-web-app-status-bar-style" content="blank" />
```

4. iPhone会将看起来像电话号码的数字添加电话连接，应当关闭
```html
<meta name="format-detection" content="telephone=no" />
```

## 优点

- 面对不同分辨率设备灵活性强
- 能够快捷解决多设备显示适应问题

## 缺点

- 兼容各种设备工作量大，效率低下
- 代码累赘，会出现隐藏无用的元素，加载时间加长
- 其实这是一种折中性质的设计解决方案，多方面因素影响而达不到最佳效果
- 一定程度上改变了网站原有的布局结构，会出现用户混淆的情况

## 栗子🌰

```css
/* Extra small devices (phones, 600px and down) */
@media only screen and (max-width: 600px) {
    .example {background: red;}
}

/* Small devices (portrait tablets and large phones, 600px and up) */
@media only screen and (min-width: 600px) {
    .example {background: green;}
}

/* Medium devices (landscape tablets, 768px and up) */
@media only screen and (min-width: 768px) {
    .example {background: blue;}
} 

/* Large devices (laptops/desktops, 992px and up) */
@media only screen and (min-width: 992px) {
    .example {background: orange;}
} 

/* Extra large devices (large laptops and desktops, 1200px and up) */
@media only screen and (min-width: 1200px) {
    .example {background: pink;}
}
```

## 实战

谷歌教程用HTML5以及CSS3的媒体查询完成了一个响应式布局的demo，大家可以用不同的尺寸的设备，查看不同分辨率下的表现。也可以在控制台模拟各种设备，欢迎大家提出意见。

在线地址：[http://dir.mydearest.cn/responsive/](http://dir.mydearest.cn/responsive/)
