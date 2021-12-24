---
title: Mac左右滚动误触返回
tags:
  - mac
copyright: true
comments: true
date: 2021-12-24 10:15:48
categories: 知识
top: 110
photos:
---

## 问题描述

如果 Mac 设置了触控板如下所示，在浏览器中（这里指的是 Chrome，其他的没有验证）浏览页面的时候，双指不仅可以可以控制左右滚动，而且可以控制前进后退。

![](https://cdn.jsdelivr.net/gh/cosyer/images/vue-blog/scroll.png)

> 这很容易造成`误触`的情况，比如一个表单，填写了很多的内容，在一个表格中左右滚动的时候，返回了前一个页面，页面中填了很多的东西就会不见...

![](https://cdn.jsdelivr.net/gh/cosyer/images/vue-blog/scene.png)

## 问题分析

浏览器的滚动溢出行为-边界触发就是滚动到`超过`滚动区域的水平边界时才会触发

## 解决方案

1. 关闭触摸板的这个设置

2. 新开页面`target="_blank"`这样就没有前一页可返回了

3. js 阻止返回事件(超过边界阻止事件)

```js
const element = document.getElementsByClassName("container")[0];
element.addEventListener(
  "mousewheel",
  function (event) {
    // 滚动到右边的最大宽度
    var maxX = this.scrollWidth - this.offsetWidth;

    // 如果这个事件看起来要滚动到元素的边界之外，要阻止它
    // 其中一个是滚动到最左边，一个是滚动到最右边
    if (
      this.scrollLeft + event.deltaX < 0 ||
      this.scrollLeft + event.deltaX > maxX
    ) {
      // 阻止事件
      event.preventDefault();
    }
  },
  false
);
```

4. overscroll-behavior-x

- 这个 CSS 属性用来控制当滚动到区域的水平边界时的浏览器行为。

```css
/* 设置容器 */
.container {
  /* contain也可以 */
  overscroll-behavior-x: none;
}
```

5. touch-action(基于移动端开发)

- touch-action 用于设置触摸屏用户如何操纵元素的区域 (例如，浏览器内置的缩放功能)。默认情况下，平移（滚动）和缩放手势由浏览器专门处理。 设置 none，当触控事件发生在元素上时，不进行任何操作。
