---
title: HTML5中的Web Notification桌面通知
tags:
  - 工具
copyright: true
comments: true
date: 2020-05-06 14:27:55
categories: 工具
photos:
---

Web Notifications 技术使页面可以发出通知，通知将被显示在页面之外的系统层面上。能够为用户提供更好的体验，即使用户忙于其他工作时也可以收到来自页面的消息通知，例如一个新邮件的提醒，或者一个在线聊天室收到的消息提醒等等。

> PS：除了IE外，各大现代浏览器都对这个桌面推送有了基本的支持。

---
<!--more-->

## 开始
要创建一个消息通知，非常简单，直接使用 window 对象下面的Notification类即可，代码如下：
```js
var n = new Notification("桌面推送", {
	icon: 'img/icon.png',
	body: '这是我的第一条桌面通知。',
    image:'img/1.jpg'
});
```

> PS：消息通知只有通过Web服务访问该页面时才会生效，如果直接双击打开本地文件，是没有任何效果的。也就是说你的文件需要使用服务器的形式打开，而不是直接使用浏览器打开本地文件。

## 语法
```js
let myNotification = new Notification(title, options);
```
- title：定义一个通知的标题，当它被触发时，它将显示在通知窗口的顶部。

- options（可选）对象包含应用于通知的任何自定义设置选项。

常用的选项有：

- body: 通知的正文，将显示在标题下方。

- tag: 类似每个通知的ID，以便在必要的时候对通知进行刷新、替换或移除。

- icon: 显示通知的图标

- image: 在通知正文中显示的图像的URL。

- data: 您想要与通知相关联的任意数据。这可以是任何数据类型。

- renotify: 一个 Boolean 指定在新通知替换旧通知后是否应通知用户。默认值为false，这意味着它们不会被通知。

- requireInteraction: 表示通知应保持有效，直到用户点击或关闭它，而不是自动关闭。默认值为false。

当这段代码执行时，浏览器会询问用户，是否允许该站点显示消息通知，如下图所示：

![notification](http://cdn.mydearest.cn/blog/images/notification.png)

只有用户点击了允许，授权了通知，通知才会被显示出来。

## 授权

**如何获取到用户点击的是“允许”还是“阻止”呢？**

window的 Notification实例有一个 requestPermission 函数用来获取用户的授权状态：
```js
// 首先，我们检查是否具有权限显示通知
// 如果没有，我们就申请权限
if (window.Notification && Notification.permission !== "granted") {
    Notification.requestPermission(function (status) {
    // status是授权状态。
    // 如果用户点击的允许，则status为'granted'
    // 如果用户点击的禁止，则status为'denied'
    
    // 这将使我们能在 Chrome/Safari 中使用 Notification.permission
    if (Notification.permission !== status) {
            Notification.permission = status;
        }
    });
}
```
> 注意：如果用户点击了授权右上角的关闭按钮，则status的值为default。

之后，我们只需要判断 status 的值是否为granted，来决定是否显示通知。

## 通知事件
但是单纯的显示一个消息框是没有任何吸引力的，所以消息通知应该具有一定的交互性，在显示消息的前前后后都应该有事件的参与。

Notification一开始就制定好了一系列事件函数，开发者可以很方面的使用这些函数处理用户交互：

有：onshow,onclick,onerror,onclose。
```js
var n = new Notification("桌面推送", {
	icon: 'img/icon.png',
	body: '这是我的第一条桌面通知。'
});
 
//onshow函数在消息框显示时触发
//可以做一些数据记录及定时关闭消息框等
n.onshow = function() {
	console.log('显示消息框');
	//5秒后关闭消息框
	setTimeout(function() {
		n.close();
	}, 3000);
};
 
//消息框被点击时被调用
//可以打开相关的视图，同时关闭该消息框等操作
n.onclick = function() {
	console.log('点击消息框');
	// 打开相关的视图
	n.close();
};
 
//当有错误发生时会onerror函数会被调用
//如果没有granted授权，创建Notification对象实例时，也会执行onerror函数
n.onerror = function() {
	console.log('消息框错误');
	// 做些其他的事
};
 
//一个消息框关闭时onclose函数会被调用
n.onclose = function() {
	console.log('关闭消息框');
	//做些其他的事
};
```

## 项目实例
[pwa版旅游站点H5](https://github.com/cosyer/pwa-tour)
