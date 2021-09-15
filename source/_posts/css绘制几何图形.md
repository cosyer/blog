---
title: css绘制几何图形
tags:
  - 布局
copyright: true
comments: true
date: 2018-08-14 15:04:09
categories: CSS
top: 107
photos:
---

CSS能够生成各种形状。正方形和矩形很容易，因为它们是 web 的自然形状。添加宽度和高度，就得到了所需的精确大小的矩形。添加边框半径，你就可以把这个形状变成圆形，足够多的边框半径，你就可以把这些矩形变成圆形和椭圆形。

我们还可以使用 CSS 伪元素中的 `::before` 和 `::after`，这为我们提供了向原始元素添加另外两个形状的可能性。通过巧妙地使用定位、转换和许多其他技巧，我们可以只用一个 HTML 元素在 CSS 中创建许多形状。

虽然我们现在大都使用字体图标或者svg图片，似乎使用 CSS 来做图标意义不是很大，但怎么实现这些图标用到的一些技巧及思路是很值得我们学习。

---
<!--more-->

### 圆
```css
div {
width: 100px;
height: 100px;
border-radius: 50px; 
/* 注意宽高相同圆角为一半 50%/100%都可以*/
}
```

### 四个不同方向的半圆
```css
.top
{
  width: 100px;
  height: 50px;
  border-radius: 50px 50px 0 0;
}
.right {
  width: 50px;
  height: 100px;
  border-radius: 0 50px 50px 0;
}
.bottom {
  width: 100px;
  height: 50px;
  border-radius: 0 0 50px 50px;
}
.left {
  width: 50px;
  height: 100px;
  border-radius: 50px 0 0 50px;
}
```

--- 
<!-- more -->

### 四分之一圆
```css
{
  width:50px;
  height:50px;
  border-radius:50px 0 0 0;
}
```

## 椭圆
```css
{
  width: 150px;
  height: 100px;
  border-radius: 50%; 
}
```

### 菱形
```css
.quarter-ellipse{
    width: 100px;
    height: 50px;
    background: pink;
    transform: skew(-20deg);
    text-align: center;
    line-height: 50px;
}
```

### 三角形
```css
/* 上三角 */
#triangle-up {
    width: 0;
    height: 0;
    border-left: 50px solid transparent;
    border-right: 50px solid transparent;
    border-bottom: 100px solid lightblue;
}
/* 下三角 */
#triangle-down {
    width: 0;
    height: 0;
    border-left: 50px solid transparent;
    border-right: 50px solid transparent;
    border-top: 100px solid lightblue;
}
/* 左三角 */
#triangle-left {
    width: 0;
    height: 0;
    border-top: 50px solid transparent;
    border-right: 100px solid lightblue;
    border-bottom: 50px solid transparent;
}
/* 右三角 */
#triangle-right {
    width: 0;
    height: 0;
    border-top: 50px solid transparent;
    border-left: 100px solid lightblue;
    border-bottom: 50px solid transparent;
}
/* 左上角 */
#triangle-topleft {
    width: 0;
    height: 0;
    border-top: 100px solid lightblue;
    border-right: 100px solid transparent;
}
/* 右上角 */
#triangle-topright {
    width: 0;
    height: 0;
    border-top: 100px solid lightblue;
    border-left: 100px solid transparent; 
}
/* 左下角 */
#triangle-bottomleft {
    width: 0;
    height: 0;
    border-bottom: 100px solid lightblue;
    border-right: 100px solid transparent;
}
/* 右下角 */
#triangle-bottomright {
    width: 0;
    height: 0;
    border-bottom: 100px solid lightblue;
    border-left: 100px solid transparent;
}
```

### 箭头
```css
#curvedarrow {
  position: relative;
  width: 0;
  height: 0;
  border-top: 9px solid transparent;
  border-right: 9px solid red;
  transform: rotate(10deg);
}
#curvedarrow:after {
  content: "";
  position: absolute;
  border: 0 solid transparent;
  border-top: 3px solid red;
  border-radius: 20px 0 0 0;
  top: -12px;
  left: -9px;
  width: 12px;
  height: 12px;
  transform: rotate(45deg);
}
```

### 梯形
```css
#trapezoid {
  border-bottom: 100px solid red;
  border-left: 25px solid transparent;
  border-right: 25px solid transparent;
  height: 0;
  width: 100px;
}
```

### 六角星
```css
#star-six {
  width: 0;
  height: 0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-bottom: 100px solid red;
  position: relative;
}
#star-six:after {
  width: 0;
  height: 0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-top: 100px solid red;
  position: absolute;
  content: "";
  top: 30px;
  left: -50px;
}
```

### 五角星
```css
#star-five {
  margin: 50px 0;
  position: relative;
  display: block;
  color: red;
  width: 0px;
  height: 0px;
  border-right: 100px solid transparent;
  border-bottom: 70px solid red;
  border-left: 100px solid transparent;
  transform: rotate(35deg);
}
#star-five:before {
  border-bottom: 80px solid red;
  border-left: 30px solid transparent;
  border-right: 30px solid transparent;
  position: absolute;
  height: 0;
  width: 0;
  top: -45px;
  left: -65px;
  display: block;
  content: '';
  transform: rotate(-35deg);
}
#star-five:after {
  position: absolute;
  display: block;
  color: red;
  top: 3px;
  left: -105px;
  width: 0px;
  height: 0px;
  border-right: 100px solid transparent;
  border-bottom: 70px solid red;
  border-left: 100px solid transparent;
  transform: rotate(-70deg);
  content: '';
}
```

### 五边形
```css
#pentagon {
  position: relative;
  width: 54px;
  box-sizing: content-box;
  border-width: 50px 18px 0;
  border-style: solid;
  border-color: red transparent;
}
#pentagon:before {
  content: "";
  position: absolute;
  height: 0;
  width: 0;
  top: -85px;
  left: -18px;
  border-width: 0 45px 35px;
  border-style: solid;
  border-color: transparent transparent red;
}
```

### 六边形
```css
#hexagon {
  width: 100px;
  height: 55px;
  background: red;
  position: relative;
}
#hexagon:before {
  content: "";
  position: absolute;
  top: -25px;
  left: 0;
  width: 0;
  height: 0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-bottom: 25px solid red;
}
#hexagon:after {
  content: "";
  position: absolute;
  bottom: -25px;
  left: 0;
  width: 0;
  height: 0;
  border-left: 50px solid transparent;
  border-right: 50px solid transparent;
  border-top: 25px solid red;
}
```

### 八边形
```css
#octagon {
  width: 100px;
  height: 100px;
  background: red;
  position: relative;
}
#octagon:before {
  content: "";
  width: 100px;
  height: 0;
  position: absolute;
  top: 0;
  left: 0;
  border-bottom: 29px solid red;
  border-left: 29px solid #eee;
  border-right: 29px solid #eee;
}
#octagon:after {
  content: "";
  width: 100px;
  height: 0;
  position: absolute;
  bottom: 0;
  left: 0;
  border-top: 29px solid red;
  border-left: 29px solid #eee;
  border-right: 29px solid #eee;
}
```

### 爱心💗
```css
#heart {
  position: relative;
  width: 100px;
  height: 90px;
}
#heart:before,
#heart:after {
  position: absolute;
  content: "";
  left: 50px;
  top: 0;
  width: 50px;
  height: 80px;
  background: red;
  border-radius: 50px 50px 0 0;
  transform: rotate(-45deg);
  transform-origin: 0 100%;
}
#heart:after {
  left: 0;
  transform: rotate(45deg);
  transform-origin: 100% 100%;
}
```

### 无穷大（莫比乌斯环）
```css
#infinity {
  position: relative;
  width: 212px;
  height: 100px;
  box-sizing: content-box;
}
#infinity:before,
#infinity:after {
  content: "";
  box-sizing: content-box;
  position: absolute;
  top: 0;
  left: 0;
  width: 60px;
  height: 60px;
  border: 20px solid red;
  border-radius: 50px 50px 0 50px;
  transform: rotate(-45deg);
}
#infinity:after {
  left: auto;
  right: 0;
  border-radius: 50px 50px 50px 0;
  transform: rotate(45deg);
}
```

### 钻石
```css
#cut-diamond {
  border-style: solid;
  border-color: transparent transparent red transparent;
  border-width: 0 25px 25px 25px;
  height: 0;
  width: 50px;
  box-sizing: content-box;
  position: relative;
  margin: 20px 0 50px 0;
}
#cut-diamond:after {
  content: "";
  position: absolute;
  top: 25px;
  left: -25px;
  width: 0;
  height: 0;
  border-style: solid;
  border-color: red transparent transparent transparent;
  border-width: 70px 50px 0 50px;
}
```

### 吃豆人
```css
#pacman {
  width: 0px;
  height: 0px;
  border-right: 60px solid transparent;
  border-top: 60px solid red;
  border-left: 60px solid red;
  border-bottom: 60px solid red;
  border-top-left-radius: 60px;
  border-top-right-radius: 60px;
  border-bottom-left-radius: 60px;
  border-bottom-right-radius: 60px;
}
```

### 对话泡泡
```css
#talkbubble {
  width: 120px;
  height: 80px;
  background: red;
  position: relative;
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px;
  border-radius: 10px;
}
#talkbubble:before {
  content: "";
  position: absolute;
  right: 100%;
  top: 26px;
  width: 0;
  height: 0;
  border-top: 13px solid transparent;
  border-right: 26px solid red;
  border-bottom: 13px solid transparent;
}
```

### 太极
```css
#yin-yang {
  width: 96px;
  box-sizing: content-box;
  height: 48px;
  background: #eee;
  border-color: red;
  border-style: solid;
  border-width: 2px 2px 50px 2px;
  border-radius: 100%;
  position: relative;
}
#yin-yang:before {
  content: "";
  position: absolute;
  top: 50%;
  left: 0;
  background: #eee;
  border: 18px solid red;
  border-radius: 100%;
  width: 12px;
  height: 12px;
  box-sizing: content-box;
}
#yin-yang:after {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  background: red;
  border: 18px solid #eee;
  border-radius: 100%;
  width: 12px;
  height: 12px;
  box-sizing: content-box;
}  
```

### 放大镜
```css
#magnifying-glass {
  font-size: 10em;
  display: inline-block;
  width: 0.4em;
  box-sizing: content-box;
  height: 0.4em;
  border: 0.1em solid red;
  position: relative;
  border-radius: 0.35em;
}
#magnifying-glass:before {
  content: "";
  display: inline-block;
  position: absolute;
  right: -0.25em;
  bottom: -0.1em;
  border-width: 0;
  background: red;
  width: 0.35em;
  height: 0.08em;
  transform: rotate(45deg);
}
```

### 月亮
```css
#moon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  box-shadow: 15px 15px 0 0 red;
}  
```

### 虚线
```css
.dotted-line{
    border: 1px dashed transparent;
    background: linear-gradient(white,white) padding-box, repeating-linear-gradient(-45deg,#ccc 0, #ccc .25em,white 0,white .75em);
}
```

## 气泡框
使用绝对定位进行三角形覆盖，实现气泡框突出部分。
```html
<style>
.bubble-tip {
  width: 100px;
  height: 30px;
  line-height: 30px;
  margin-left: 10px;
  border: 1px solid #c5c5c5;
  border-radius: 4px;
  position: relative;
  background-color: #fff;
}
.bubble-tip::before {
  content: "";
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 10px 10px 10px 0;
  border-color: transparent #ffffff transparent transparent;
  position: absolute;
  top: 5px;
  left: -10px;
  z-index: 2;
}
.bubble-tip::after {
  content: "";
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 10px 10px 10px 0;
  border-color: transparent #c5c5c5 transparent transparent;
  position: absolute;
  top: 5px;
  left: -11px;
  z-index: 1;
}
</style>
<div class="bubble-tip"></div>
```

## 卡券贴
在CSS3当中，background添加了`background-size`属性，控制背景图片的大小，配合`background-position`属性，可以在一个背景下面展示多张图片。详见[background-MDN](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background)。

background-size: cover;使背景图像完全覆盖背景区域。也可以js获取图片宽高再比较一下，再决定往哪个方向居中。

卡券贴的核心是使用透明白色径向渐变radial-gradient，分别让4张背景图中的左下角、右下角、右上角和左下角出现缺省，再利用drop-shadow实现元素阴影，从而达到效果。

radial-gradient语法如下：
```css
radial-gradient(shape size at position, start-color, ..., last-color)
```

```html
<style>
.coupon{
  width: 200px;
  height: 80px;
  background: radial-gradient(circle at right bottom, transparent 10px, #ffffff 0) top right / 50% 40px no-repeat,
    radial-gradient(circle at left bottom, transparent 10px, #ffffff 0) top left / 50% 40px no-repeat,
    radial-gradient(circle at right top, transparent 10px, #ffffff 0) bottom right / 50% 40px no-repeat,
    radial-gradient(circle at left top, transparent 10px, #ffffff 0) bottom left / 50% 40px no-repeat;
  filter: drop-shadow(3px 3px 3px #c5c5c5);
}
</style>

<div class="coupon"></div>
```

## 图片切角
```css
background: url(image.png);
  mask:
      linear-gradient(135deg, transparent 15px, #fff 0)
      top left,
      linear-gradient(-135deg, transparent 15px, #fff 0)
      top right,
      linear-gradient(-45deg, transparent 15px, #fff 0)
      bottom right,
      linear-gradient(45deg, transparent 15px, #fff 0)
      bottom left;
  mask-size: 50% 50%;
  mask-repeat: no-repeat;
```

## 1px高的线条
```html
<div style="height:1px;overflow:hidden;background:red"></div>
```
