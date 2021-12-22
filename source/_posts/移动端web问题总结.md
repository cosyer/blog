---
title: 移动端web问题总结（长期更新）
tags:
  - 知识
copyright: true
comments: true
date: 2018-08-21 10:14:35
categories: 知识
top: 107
photos:
---

## meta 基础知识

### H5 页面窗口自动调整到设备宽度，并禁止用户缩放页面

```javascript
<meta
  name="viewport"
  content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"
/>
```

## ios 竖屏拍照上传，图片被旋转问题

```js
// 1.通过第三方插件exif-js获取到图片的方向
// 2.new一个FileReader对象，加载读取上传的图片
// 3.在fileReader的onload函数中，得到的图片文件用一个Image对象接收
// 4.在image的onload函数中，利用步骤1中获取到的方向orientation，通过canvas旋转校正，重新绘制一张新图
// 注意iPhone有3个拍照方向需要处理，横屏拍摄，home键在左侧，竖屏拍摄，home建上下
// 5.将绘制的新图转成Blob对象，添加到FormData对象中，然后进行校正后的上传操作
// 代码有点杂，待整理后上传，网上应该是可以找到的
```

## ios：DOM 元素固定一边，另一边滚动，滚动很卡的问题

```js
// (横向滚动用的多些)简单粗暴的办法，样式添加如下属性
-webkit-overflow-scrolling: touch;
```

## 部分手机第三方输入法会将页面网上挤的问题

```js
// 特定需求页面，比如评论页面，输入框在顶部之类的
const interval = setInterval(function () {
  document.body.scrollTop = 0;
}, 100);
// 注意关闭页面或者销毁组件的时候记得清空定时器
clearInterval(interval);
```

## iPhoneX 适配

```
// 1.viewport meta 标签增加属性viewport-fit=cover
<meta name="viewport" content="width=device-width, viewport-fit=cover, xxxx">
// 2.body元素增加样式
body {
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
}
// 3.如有fixed底部的元素，也增加上面样式
xxx {
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
  background-color: #fff; // 记得添加background-color，不然会出现透明镂空的情况
}
```

## 某些机型不支持 video 标签的 poster 属性，特别是安卓

```js
用图片元素 <img />来代替poster
播放前显示<img />，隐藏 <video />
播放后显示<video />，隐藏 <img />
```

## CSS 透明度颜色设置问题

```
Android部分不支持 hex写法，推荐用rgba的写法
#0000009c --> rgba(0, 0, 0, 0.61)
```

## flex 对低版本的 ios 和 Android 的支持问题

```js
// 使用postcss的autoprefixer插件，自动添加浏览器内核前缀，
// 并且增加更低浏览器版本的配置，自动添加flex老版本的属性和写法
autoprefixer({
    browsers: [
        'iOS >= 6',     // 特殊处理支持低版本IOS
        'Safari >= 6',  // 特殊处理支持低版本Safari
    ],
}),
```

## ios 页面回退到长列表出现灰色遮挡问题

```
方案1：对列表数据进行缓存，比如redux之类的用法。
方案2：回退时，跳到页面顶部。
const timer = setTimeout(() => {
    window.scrollTo(0, 1);
    window.scrollTo(0, 0);
}, 0);
```

## ios 日期转换 NAN 的问题

```
将日期字符串的格式符号替换成'/'。
栗子：'yyyy-MM-dd'.replace(/-/g, '/')
```

## react 未知错误异常，导致页面崩溃，空白

```
React 16.x 增加了componentDidCatch() 生命周期方法
捕获全局异常来进行页面的友好提示
```

## 移动端适配

- 媒体查询
- px2rem
- flexible
- flex
- grid
- 百分比
