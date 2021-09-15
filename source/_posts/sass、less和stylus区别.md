---
title: Sass、Less和Stylus区别
tags:
  - Sass
  - Less
  - Stylus
copyright: true
comments: true
date: 2018-12-19 23:26:52
categories: CSS
top: 140
photos:
---

在前端界，有三大 CSS 预处理器，分别是 SASS(SCSS), Less, Stylus。
本文便总结下 Sass、Less CSS、Stylus这三个预处理器的区别和各自的基本语法。

> 我永远喜欢Stylus :>

## 什么是CSS预处理器

CSS 预处理器是一种语言用来为 CSS 增加一些编程的的特性，无需考虑浏览器的兼容性问题，例如你可以在 CSS 中使用变量、简单的程序逻辑、函数等等在编程语言中的一些基本技巧，可以让CSS 更见简洁，适应性更强，代码更直观等诸多好处。

## 基本语法比较

### Sass和Less
首先 Sass 和 Less 都使用的是标准的 CSS 语法，因此如果可以很方便的将已有的 CSS 代码转为预处理器代码，默认 Sass 使用 .scss 扩展名，而 Less 使用 .Less 扩展名。
```css
/* style.scss or style.Less */
h1 {
  color: #0982C1;
}
```
另一种也是最早的 Sass 语法格式，被称为缩进格式 (Indented Sass) 通常简称 "Sass"，是一种简化格式。它使用 “缩进” 代替 “花括号” 表示属性属于某个选择器，用 “换行” 代替 “分号” 分隔属性，很多人认为这样做比 SCSS 更容易阅读，书写也更快速。缩进格式也可以使用 Sass 的全部功能，只是与 SCSS 相比个别地方采取了不同的表达方式。
```css
/* style.Sass */
h1
  color: #0982c1
```

而 Stylus 支持的语法要更多样性一点，它默认使用 .styl 的文件扩展名。可以随意地书写。
```css
/* style.styl */
h1 {
  color: #0982C1;
}
/* 省略花括号 */
h1
  color: #0982C1;
/* 省略花括号和分号 */
h1
  color #0982C1
```

---
<!--more-->

### 变量声明
1. Sass
> Sass变量必须是以$开头的，然后变量和值之间使用冒号（：）隔开，和css属性是一样的。
2. Less
>  Less变量都是用@开头的。
3. Stylus
>  Stylus对变量是没有任何约束，可以是以$开头，或者任何的字符，而且与变量之间可以用冒号，空格隔开。

### 嵌套
```css
section {
  margin: 10px;
  nav {
    height: 25px;
    a {
      color: #0982C1;
      &:hover {
        text-decoration: underline;
      }
    }
  }
} 
/* 使用“&”符号来引用父选择器。 */
```

### 运算符
```css
body {
  margin: (14px/2);
  top: 50px + 100px;
  right: 80 * 10%;
}
```

### 颜色函数
- Sass
```css
lighten($color, 10%); /* 返回的颜色在$color基础上变亮10% */
darken($color, 10%);  /* 返回的颜色在$color基础上变暗10% */
saturate($color, 10%);   /* 返回的颜色在$color基础上饱和度增加10% */
desaturate($color, 10%); /* 返回的颜色在$color基础上饱和度减少10% */
grayscale($color);  /* 返回$color的灰度色*/
complement($color); /* returns complement color of $color */
invert($color);     /* 返回$color的反相色 */
mix($color1, $color2, 50%); /* mix $color1 with $color2 with a weight of 50% */ 
```

- Less
```css
lighten(@color, 10%); /* 返回的颜色在@color基础上变亮10% */
darken(@color, 10%);  /* 返回的颜色在@color基础上变暗10%*/
saturate(@color, 10%);   /* 返回的颜色在@color基础上饱和度增加10% */
desaturate(@color, 10%); /* 返回的颜色在@color基础上饱和度降低10%*/
spin(@color, 10);  /* 返回的颜色在@color基础上色调增加10 */
spin(@color, -10); /* 返回的颜色在@color基础上色调减少10 */
mix(@color1, @color2); /* 返回的颜色是@color1和@color2两者的混合色 */  
```

- Stylus
```css
lighten(color, 10%); /* 返回的颜色在'color'基础上变亮10% */
darken(color, 10%);  /* 返回的颜色在'color'基础上变暗10% */
saturate(color, 10%);   /* 返回的颜色在'color'基础上饱和度增加10% */
desaturate(color, 10%); /* 返回的颜色在'color'基础上饱和度降低10% */  
```

### css预处理器处理属性前缀
```css
 @mixin border-radius($values) {
  -webkit-border-radius: $values;
     -moz-border-radius: $values;
          border-radius: $values;
}
div {
  @include border-radius(10px);
} 
```

### 导入 (Import)
很多 CSS 开发者对导入的做法都不太感冒，因为它需要多次的 HTTP 请求。但是在 CSS 预处理器中的导入操作则不同，它只是在语义上包含了不同的文件，但最终结果是一个单一的 CSS 文件，如果你是通过 @ import “file.css”; 导入 CSS 文件，那效果跟普通的 CSS 导入一样。
```css
/* file.{type} */
body {
  background: #EEE;
}
```

```css
@import "reset.css";
@import "file.{type}";
p {
  background: #0982C1;
} 
```

- 转译出的css
```css
@import "reset.css";
body {
  background: #EEE;
}
p {
  background: #0982C1;
}  
```

### 混合（Mixins）
Mixins是预处器中的函数。当某段CSS样式经常要用到多个元素中，这样就需要重复的写多次。Mixins是一个公认的选择器，还可以在Mixins中定义变量或者是默认参数。
- Sass @mixin声明 @include调用
```css
@mixin error($borderWidth: 2px) {
  border: $borderWidth solid #F00;
  color: #F00;
}
.generic-error {
  padding: 20px;
  margin: 4px;
  @include error(); //这里调用默认 border: 2px solid #F00;
}
.login-error {
  left: 12px;
  position: absolute;
  top: 20px;
  @include error(5px); //这里调用 border:5px solid #F00;
}
```

- Less
```css
.error(@borderWidth: 2px) {
  border: @borderWidth solid #F00;
  color: #F00;
}
.generic-error {
  padding: 20px;
  margin: 4px;
  .error(); //这里调用默认 border: 2px solid #F00;
}
.login-error {
  left: 12px;
  position: absolute;
  top: 20px;
  .error(5px); //这里调用 border:5px solid #F00;
}
```

- Stylus 像函数一样
```css
error(borderWidth= 2px) {
  border: borderWidth solid #F00;
  color: #F00;
}
.generic-error {
  padding: 20px;
  margin: 4px;
  error(); 
}
.login-error {
  left: 12px;
  position: absolute;
  top: 20px;
  error(5px); 
}
```

- example Sass3d文本
```css
@mixin text3d($color) {
  color: $color;
  text-shadow: 1px 1px 0px darken($color, 5%),
               2px 2px 0px darken($color, 10%),
               3px 3px 0px darken($color, 15%),
               4px 4px 0px darken($color, 20%),
               4px 4px 2px #000;
}

h1 {
  font-size: 32pt;
  @include text3d(#0982c1);
}
```

### 继承（Inheritance）
在多个元素应用相同的样式时，我们在CSS通常都是这样写：
```css
p,
ul,
ol {
  /* 样式写在这 */
} 
```

- Sass和Stylus @extend
```css
.block {
  margin: 10px 5px;
  padding: 2px;
}
p {
  @extend .block; /* 继承.block所有样式 */
  border: 1px solid #EEE;
}
```

- Less
LESS支持的继承和Sass与Stylus不一样,他不是在选择器上继承，而是将Mixins中的样式嵌套到每个选择器里面。这种方法的缺点就是在每个选择器中会有重复的样式产生。
```css
 .block {
  margin: 10px 5px;
  padding: 2px;
}
p {
  .block; /* 继承 '.block'中的样式 */
  border: 1px solid #EEE;
}
```

### if语句
- Sass
```css
.mixin (@color) when (lightness(@color) > 30%) {
    background-color: black;
}
.mixin (@color) when (lightness(@color) =<; 30%) {
    background-color: white;
}
```

- Less
```css
@if lightness($color) > 30% {
    background-color: black;
}

@else {
    background-color: white;
}
```

- Stylus
```css
if lightness(color) > 30%
    background-color black
else
    background-color white
```
### loop
- Sass
```css
@for $i from 1px to 3px {
    .border-#{i} {
        border: $i solid blue;
    }
}
```

- Less
```css
.loop(@counter) when (@counter > 0){
    .loop((@counter - 1));

    .border-@{counter} {
        border: 1px * @counter solid blue;
    }
}
```

- Stylus
```css
for num in (1..3)
    .border-{num}
        border 1px * num solid blue
```

### 作用域
- Sass
Sass中不存在什么全局变量.
```css
$color: black;
.scoped {
  $bg: blue;
  $color: white;
  color: $color; /*白色*/
  background-color:$bg;
}
.unscoped {
  color:$color;/*白色*/
}	
```

- Less
LESS中的作用域和其他程序语言中的作用域非常的相同，他首先会查找局部定义的变量，如果没有找到，会像冒泡一样，一级一级往下查找，直到根为止。
```css
@color: black;
.scoped {
  @bg: blue;
  @color: white;
  color: @color; /*白色*/
  background-color:@bg;
}
.unscoped {
  color:@color; /*黑色*/
}
```

- Stylus
Stylus虽然起步比较晚，但其作用域的特性和LESS一样，可以支持全局变量和局变量。会向上冒泡查找，直到根为止。

## 总结
Less 从语言特性的设计到功能的健壮程度和另外两者相比都有一些缺陷，但用 Less 可以满足大多数场景的需求。
但相比另外两者，基于 Less 开发类库会复杂得多，实现的代码会比较脏，能实现的功能也会受到 DSL 的制约。
比 Stylus 语义更清晰、比 Sass 更接近 CSS 语法，使得刚刚转用 CSS 预编译的开发者能够更平滑地进行切换。
Sass 在三者之中历史最久，也吸收了其他两者的一些优点。
从功能上来说 Sass 大而全，语义明晰但是代码很容易显得累赘。
主项目基于 Ruby 可能也是一部分人不选择它的理由（Less 开始也是基于 Ruby 开发，后来逐渐转到 Less.js 项目中）。
Sass 有一个「事实标准」库——Compass，于是对于很多开发者而言省去了选择类库的烦恼，对于提升开发效率也有不小的帮助。
Stylus 的语法非常灵活，很多语义都是根据上下文隐含的。
基于 Stylus 可以写出非常简洁的代码，但对使用团队的开发素养要求也更高，更需要有良好的开发规范或约定。
总的来说，三种预处理器百分之七八十的功能是类似的。Less 适合帮助团队更快地上手预处理代码的开发，而 Sass 和 Stylus 的差异更在于口味。