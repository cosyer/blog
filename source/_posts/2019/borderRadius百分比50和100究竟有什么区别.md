---
title: borderRadius百分比50和100究竟有什么区别
tags:
  - 知识
copyright: true
comments: true
date: 2019-04-01 00:39:52
categories: CSS
top: 190
photos:
---

border-radius 的值是百分比的话，就相当于盒子的宽度和高度的百分比。我们知道在一个正方形内做一个面积最大的圆形，这个圆的半径就为正方形边长的一半。所

以 border-radius 为 50%时，则会形成圆。那么可能有人就会问，border-radius 为 100%时，对应圆的半径长度不就是正方形的宽高么，这种情况下，为什么还是会

形成一个和值为 50%一样的圆形呢？

---

<!--more-->

其实这是 W3C 对于[重合曲线](https://www.w3.org/TR/css-backgrounds-3/#corner-overlap)有这样的规范：如果两个相邻角的半径和超过了对应的

盒子的边的长度，那么浏览器要重新计算保证它们不会重合。下面我们假定一个宽

高为 100px 的正方形 A。此时设置 border-top-left-radius=100%；则正方形 A 会变成一个半径为 100px 的四分之一圆弧。

![radius1](http://cdn.mydearest.cn/blog/images/radius1.png)

然后我们再给 border-top-right-radius=100%。此时相邻的角的半径已经超过了对应的盒子的边的长度。浏览器需要重新计算。重新计算的规则是同时缩放两

个圆角的半径知道他们刚好符合这个方形。

建议使用 border-radius = 50% 来避免浏览器不必要的计算。值得注意的是在涉及到与圆角相关动画的情况下，值为 50%和 100%，在动画效果上会有不同。

## 示例代码

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>动画效果差异</title>
  </head>
  <style>
    div {
      width: 100px;
      height: 100px;
      margin-bottom: 10px;

      transition: border-radius 3s;
    }
    .half {
      border-radius: 50%;
      background: #000;
    }
    .full {
      border-radius: 100%;
      background: #f00;
    }

    .box1:hover div {
      border-radius: 0;
    }
    .wrap {
      width: 100px;
      height: 250px;
      border: 1px solid red;
      cursor: pointer;
    }

    .box2 .half {
      border-radius: 0;
      background: #000;
    }

    .box2 .full {
      border-radius: 0;
      background: #f00;
    }
    .box2:hover .half {
      border-radius: 50%;
    }
    .box2:hover .full {
      border-radius: 100%;
    }
  </style>
  <body>
    <div class="wrap box1">
      <div class="half"></div>
      <div class="full"></div>
    </div>

    <div class="wrap box2">
      <div class="half"></div>
      <div class="full"></div>
    </div>
    <p>将鼠标移到红框内</p>
  </body>
</html>
```
