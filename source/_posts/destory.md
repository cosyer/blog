---
title: 有趣的摧毁页面
tags:
  - 优化
copyright: true
comments: true
date: 2018-06-20 01:14:13
categories: JS
top: 107
photos:
---

食用方法

使用【上下左右键】来控制飞行器的运动

使用【空格键】来发射导弹

<a href="javascript:var%20KICKASSVERSION='2.0'; var%20s%20=%20document.createElement('script'); s.type='text/javascript'; document.body.appendChild(s); s.src='//hi.kickassapp.com/kickass.js'; void(0);"> 点击开始摧毁 </a>

---

<!--more -->

引入 JS 代码

```javascript
<a
  href="javascript:var%20KICKASSVERSION='2.0'; 
var%20s%20=%20document.createElement('script'); 
s.type='text/javascript'; document.body.appendChild(s); 
s.src='//hi.kickassapp.com/kickass.js'; void(0);"
>
  {" "}
  点击开始摧毁{" "}
</a>
```

页面崩溃

- plan A

```javascript
var total = "";
for (var i = 0; i < 10000; i++) {
  total = total + i.toString();
  history.pushState(0, 0, total);
}

while (true) {
  console.log("hello world");
}

function fn() {
  fn();
}
fn();
```

- plan B (BitInt 出现后，不用死循环也能实现 CPU 100% 的效果)

```js
9n ** (9n ** 9n) > 0;
```

转动吧，风扇！！！

## localstorage 撑爆电脑硬盘

html5 的本地存储，相信大家都不陌生。将数据以二进制文件形式存储到本地，在当前应用得非常广泛。
windows 下的 chrome，localStorage 存储于 C:\Users\xxx\AppData\Local\Google\Chrome\User Data\Default\Local Storage 文件夹中。但如果任由网页无限写文件，对用户硬盘的伤害可想而知，因而浏览器对其做了大小限制。

对于一个域名+端口，PC 端的上限是 5M-10M 之间，移动端是则不大于 2.5M。

详情请见[作为一个前端，可以如何机智地弄坏一台电脑？](http://litten.me/2015/07/06/hack-in-localstorage/)
