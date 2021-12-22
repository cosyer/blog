---
title: flex布局
tags:
  - 布局
copyright: true
comments: true
date: 2018-07-05 21:04:18
categories: CSS
photos:
---

芮 rui 四声

浏览器前缀 -webkit/chrome、safari -moz/firefox -ms/ie -o/opera

弹性伸缩 flexbox 布局

任何一个容器都可设为 display:flex

行内元素 display:inline-flex

webkit 内核浏览器（Safari） display:-webkit-flex; display:flex

设为 flex 布局以后，子元素的 float、clear、vertical-align 属性将失效。

---

<!-- more -->

## 容器的属性

### flex-direction 决定主轴的方向

flex-direction:row; /_默认：从左到右_/

flex-direction:row-reverse; /_从右到左_/

flex-direction:column; /_从上到下_/

flex-direction:column-reverse; /_从下到上_/

### flex-wrap:一条轴排列不下，如何换行

flex-wrap:nowrap; /_默认:不换行_/

flex-wrap:wrap; /_换行，第一行在上方_/

flex-wrap:wrap-reverse; /_换行，第一行在下方_/

### flex-flow：上面两个的简写

flex-flow:fiex-direction flex-wrap; /_默认 row no-wrap_/

### justify-content:主轴上的对齐方式

justify-content:flex-start; /_默认：左对齐_/

justify-content:flex-end; /_右对齐_/

justify-content:center; /_居中_/

justify-content:space-between; /_两端对齐，项目之间的间隔相同，边缘项目紧贴边框_/

justify-content:space-around; /_项目两侧的间隔相同，所以，项目之间的间隔比项目与边框的间隔大一倍_/

### align-items:交叉轴上如何对齐

align-items:flex-start; /_起点对齐_/

align-items:flex-end; /_终点对齐_/

align-items:center; /_中点对齐_/

align-items:baseline; /_项目的第一行文字的基线对齐_/

align-items:stretch; /_默认：项目未设高度或 auto，占满整个容器高度_/

### align-content：多根轴线的对齐方式，只有一根轴线时，不起作用。

aling-content:flex-start; /_与交叉轴的起点对齐_/

aling-content:flex-end; /_与交叉轴的终点对齐_/

aling-content:center; /_与交叉轴的中点对齐_/

aling-content:space-between; /_与交叉轴两端对齐，轴线之间的间隔平均分布。_/

aling-content:space-around; /_每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍_/

aling-content:stretch; /_默认：轴线占满整个交叉轴_/

## 项目的属性

### order:定义项目的排列顺序。数值越小，排列越靠前，默认为 0。

order:1;

order:99;

order:-1;

/_-1 1 99 的顺序排列_/

### flex-grow：定义项目的放大比例，默认为 0，即如果存在剩余空间，也不放大。

flex-grow: <number>; /_ default 0 _/

如果所有项目的 flex-grow 属性都为 1，则它们将等分剩余空间（如果有的话）。

如果一个项目的 flex-grow 属性为 2，其他项目都为 1，则前者占据的剩余空间将比其他项多一倍。

### flex-shrink:定义了项目的缩小比例，默认为 1，即如果空间不足，该项目将缩小。

flex-shrink: <number>; /_ default 1 _/

如果所有项目的 flex-shrink 属性都为 1，当空间不足时，都将等比例缩小。

如果一个项目的 flex-shrink 属性为 0，其他项目都为 1，则空间不足时，前者不缩小。

负值对该属性无效。

### flex-basis:定义了在分配多余空间之前，项目占据的主轴空间（main size）。浏览器根据这个属性，计算主轴是否有多余空间。它的默认值为 auto，即项目的本来大小。

flex-basis: <length> | auto; /_ default auto _/

它可以设为跟 width 或 height 属性一样的值（比如 350px），则项目将占据固定空间。

### flex: 1 是 flex-grow, flex-shrink 和 flex-basis 的简写，默认值为 0 1 auto。后两个属性可选。分别对应的是 flex 元素的占位、缩放、容器宽高。

flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]

### align-self 属性允许单个项目有与其他项目不一样的对齐方式，可覆盖 align-items 属性。默认值为 auto，表示继承父元素的 align-items 属性，如果没有父元素，则等同于 stretch。

align-self: auto | flex-start | flex-end | center | baseline | stretch;

## react-native 使用 flex 布局注意点

- 样式对象需要驼峰式写法
- React Native 中的 Flexbox 的工作原理和 web 上的 CSS 基本一致，当然也存在少许差异。

首先是默认值不同：flexDirection 的默认值是 column 而不是 row，而 flex 也只能指定一个数字值。

## 扩展阅读：

[w3cplus 指南](http://www.w3cplus.com/css3/a-guide-to-flexbox-new.html)
[Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)
[思维图](http://blog.csdn.net/magneto7/article/details/70854472)
[可视化练习 1](https://buptsteve.github.io/flex-playground/)
[可视化练习 2](https://react-medellin.github.io/flexbox-playground/)
[可视化练习 3](https://www.flexbox.aweutist.dev/showcase.html)
[可视化练习 4](https://vikram-rajput.github.io/flexbox-playground/)
