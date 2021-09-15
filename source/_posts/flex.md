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

弹性伸缩flexbox布局 

任何一个容器都可设为display:flex

行内元素 display:inline-flex

webkit内核浏览器（Safari） display:-webkit-flex; display:flex

设为flex布局以后，子元素的float、clear、vertical-align属性将失效。

--- 
<!-- more -->
## 容器的属性
### flex-direction 决定主轴的方向

flex-direction:row;  /*默认：从左到右*/

flex-direction:row-reverse;  /*从右到左*/

flex-direction:column;  /*从上到下*/

flex-direction:column-reverse;  /*从下到上*/

### flex-wrap:一条轴排列不下，如何换行

flex-wrap:nowrap;  /*默认:不换行*/

flex-wrap:wrap;  /*换行，第一行在上方*/

flex-wrap:wrap-reverse;  /*换行，第一行在下方*/

### flex-flow：上面两个的简写
flex-flow:fiex-direction flex-wrap;  /*默认 row no-wrap*/

### justify-content:主轴上的对齐方式

justify-content:flex-start;  /*默认：左对齐*/

justify-content:flex-end;  /*右对齐*/

justify-content:center;  /*居中*/

justify-content:space-between;  /*两端对齐，项目之间的间隔相同，边缘项目紧贴边框*/

justify-content:space-around;  /*项目两侧的间隔相同，所以，项目之间的间隔比项目与边框的间隔大一倍*/

### align-items:交叉轴上如何对齐

align-items:flex-start;  /*起点对齐*/

align-items:flex-end;  /*终点对齐*/

align-items:center;  /*中点对齐*/

align-items:baseline;  /*项目的第一行文字的基线对齐*/

align-items:stretch;  /*默认：项目未设高度或auto，占满整个容器高度*/

### align-content：多根轴线的对齐方式，只有一根轴线时，不起作用。

aling-content:flex-start;  /*与交叉轴的起点对齐*/

aling-content:flex-end;  /*与交叉轴的终点对齐*/

aling-content:center;  /*与交叉轴的中点对齐*/

aling-content:space-between;  /*与交叉轴两端对齐，轴线之间的间隔平均分布。*/

aling-content:space-around;  /*每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍*/

aling-content:stretch;  /*默认：轴线占满整个交叉轴*/

## 项目的属性

### order:定义项目的排列顺序。数值越小，排列越靠前，默认为0。

order:1;

order:99;

order:-1;   

/*-1 1 99的顺序排列*/

### flex-grow：定义项目的放大比例，默认为0，即如果存在剩余空间，也不放大。

flex-grow: <number>; /* default 0 */

如果所有项目的flex-grow属性都为1，则它们将等分剩余空间（如果有的话）。

如果一个项目的flex-grow属性为2，其他项目都为1，则前者占据的剩余空间将比其他项多一倍。

### flex-shrink:定义了项目的缩小比例，默认为1，即如果空间不足，该项目将缩小。

flex-shrink: <number>; /* default 1 */

如果所有项目的flex-shrink属性都为1，当空间不足时，都将等比例缩小。

如果一个项目的flex-shrink属性为0，其他项目都为1，则空间不足时，前者不缩小。

负值对该属性无效。

### flex-basis:定义了在分配多余空间之前，项目占据的主轴空间（main size）。浏览器根据这个属性，计算主轴是否有多余空间。它的默认值为auto，即项目的本来大小。

flex-basis: <length> | auto; /* default auto */

它可以设为跟width或height属性一样的值（比如350px），则项目将占据固定空间。

### flex: 1 是flex-grow, flex-shrink 和 flex-basis的简写，默认值为0 1 auto。后两个属性可选。分别对应的是 flex 元素的占位、缩放、容器宽高。

flex: none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]

### align-self属性允许单个项目有与其他项目不一样的对齐方式，可覆盖align-items属性。默认值为auto，表示继承父元素的align-items属性，如果没有父元素，则等同于stretch。

align-self: auto | flex-start | flex-end | center | baseline | stretch;

## react-native使用flex布局注意点

- 样式对象需要驼峰式写法
- React Native中的Flexbox的工作原理和web上的CSS基本一致，当然也存在少许差异。

首先是默认值不同：flexDirection的默认值是column而不是row，而flex也只能指定一个数字值。

## 扩展阅读：
[w3cplus指南](http://www.w3cplus.com/css3/a-guide-to-flexbox-new.html)
[Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)
[思维图](http://blog.csdn.net/magneto7/article/details/70854472)
[可视化练习1](https://buptsteve.github.io/flex-playground/)
[可视化练习2](https://react-medellin.github.io/flexbox-playground/)
[可视化练习3](https://www.flexbox.aweutist.dev/showcase.html)
[可视化练习4](https://vikram-rajput.github.io/flexbox-playground/)
