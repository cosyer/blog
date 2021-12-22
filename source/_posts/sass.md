---
title: Sass学习笔记
tags:
  - Sass
copyright: true
comments: true
date: 2018-09-01 17:03:52
categories: CSS
top: 103
photos:
---

### 简介

Sass 是一款强化 CSS 的辅助工具，它在 CSS 语法的基础上增加了变量 (variables)、嵌套 (nested rules)、混合 (mixins)、导入 (inline imports) 等高级功能，这些拓展令 CSS 更加强大与优雅。

---

<!--more-->

### 导入

```javascript
@import "reset.css"; // css
@import "index"; // sass
```

### 变量

```javascript
// 普通变量
$fontSize:16px;

// 默认变量
$baseLineHeight: 1.5 !default;

// 覆盖默认变量，需要写在 !default 前面
$baseLineHeight: 1.7;
$baseLineHeight: 1.5 !default;

// 一维 list
$px: (5px 10px 20px 30px);

// 二维 list
$px: (5px 10px)
     (20px 30px);
// 或者
$pxs: 5px 10px, 20px 30px;

// Map 类似对象
$heading: (
    h1: 2em,
    h2: 1.5em,
    h3: 1.2em
);
```

### 插值

插值使用 #{}

```javascript
// Variables
$mySelector: banner;

// .banner
.#{mySelector} {
    font-weight: bold;
    line-height: 40px;
    margin: 0 auto;
}
```

### 跳出嵌套

@at-root (without: rule| all | media)

```javascript
// 跳出普通的嵌套
.demo {
    animation: motion 3s infinite;

    @at-root {
        @keyframes motion {
          ...
        }
    }
}

// 跳出 media 嵌套
@media print {
    .parent2{
        color:#f00;

        @at-root (without: media) {
            .child2 {
                width:200px;
            }
        }
    }
}
```

### 混合(mixin)

使用 @mixin 声明混合，可以传递参数，参数名以$符号开始，多个参数以逗号分开，也可以给参数设置默认值。
@mixin 通过 @include 来调用。
混合器中不仅可以包含属性，也可以包含 css 规则，包含选择器和选择器中的属性，也可以使用 & 上下文。

为便于书写，@mixin 可以用 = 表示，而 @include 可以用 + 表示

```javascript
// 无参数
@mixin block {
    display: block;
}

// css 规则，注意上下文
@mixin no-bullets {
    list-style: none;
    li {
        list-style-image: none;
        list-style-type: none;
        margin-left: 0px;
    }
}

// 带参数
@mixin opacity($opacity: 50) {
    opacity: $opacity / 100;
    filter: alpha(opacity=$opacity);
}

// 多个参数
@mixin horizontal-line($border: 1px dashed #ccc, $padding: 10px){
    border-bottom: $border;
    padding-top: $padding;
    padding-bottom: $padding;
}

@include horizontal-line($padding: 15px);

// 多组值参数
@mixin box-shadow($shadow...) {
    -webkit-box-shadow:$shadow;
    box-shadow:$shadow;
}

@include box-shadow(
    0 2px 2px rgba(0, 0, 0, 0.3),
    0 3px 3px rgba(0, 0, 0, 0.2)
);
```

#### @Content

@content 它可以使 @mixin 接受一整块样式，接受的样式从 @content 开始。

```javascript
@mixin max-screen($res) {
    @media only screen and ( max-width: $res ) {
        @content; // body { color: red }
    }
}

@include max-screen(480px) {
    body { color: red } // 这里就i @content 引用的内容
}
```

## 继承

选择器继承可以让选择器继承另一个选择器的所有样式，并联合声明。使用选择器的继承，要使用关键词 @extend，后面紧跟需要继承的选择器。
继承可以继承默认的元素属性，比如让一个 div 继承 a，那么这 div 看起来就好像 a 一样。

```javascript
// 继承现有的标签，或类
h1{
    border: 4px solid #ff9aa9;
}
.speaker{
    @extend h1;
    border-width: 2px;
}
```

## 占位选择器%

可以定义占位选择器 %，如果不调用则不会有任何多余的 css 代码。

```javascript
%block {
    display: block;
}

.box {
    @extend %block;
}
```

## 函数

sass 定义了很多函数可供使用，当然你也可以自己定义函数，以@fuction 开始。

使用最多的是颜色函数：
颜色函数中又以 lighten 减淡和 darken 加深为最，
其调用方法为 lighten($color, $amount) 和 darken($color, $amount)
它们的第一个参数都是颜色值，第二个参数都是百分比。

```javascript
@function pxToRem($px) {
    @return $px / $baseFontSize * 1rem;
}
body {
    color: lighten($gray, 10%); // 直接使用
}
div {
    font-size: pxToRem(16px);
    color: darken($gray, 10%);
}
```

## @if 判断

@if 可一个条件单独使用，也可以和 @else 结合多条件使用

```javascript
$big: false;
p {
    @if $big == false {
        margin: 10px;
    }
    @else {
        margin: 10px auto;
    }
}
```

## 三目判断

语法为：if($condition, $if_true, $if_false) 。三个参数分别表示：条件，条件为真的值，条件为假的值。

```javascript
$min: 20;
p {
    color: if($min > 10, red, blue); // blue
}
```

## for 循环

for 循环有两种形式，分别为：@for $var from [start] through [end] 和 @for $var from [start] to [end]。
关键字 through 表示包括 end 这个数，而 to 则不包括 end 这个数。

```javascript
@for $i from 1 through 3 {
    .item-#{$i} { width: 2em * $i; }
}
```

## @each 循环

语法为：@each $var in [list or map]

```javascript
$headings: (h1: 2em, h2: 1.5em, h3: 1.2em);
@each $header, $size in $headings {
    #{$header} {
        font-size: $size;
    }
}
```
