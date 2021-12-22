---
title: JS执行顺序-函数声明提升、匿名函数、函数表达式
tags:
  - 知识
copyright: true
comments: true
date: 2018-06-13 17:06:49
categories: JS
top: 107
photos:
---

{% centerquote %}
JS 是按照`代码块`进行 编译、执行 的。
{% endcenterquote %}

---

<!-- more -->

## script 标签区分代码块

```javascript
<script>
  alert('代码块一');
</script>
<script>
  alert('代码块二');
</script>
```

## 关于函数(声明式函数、赋值型（函数表达式）函数、匿名函数、自执行函数)

### 函数提升

`声明函数与赋值函数的区别在于： 在 JS 的预编译期间，声明式函数会被先提取出来，然后才按照顺序执行 JS代码。`

```javascript
A(); // 'A '
function A() {
  console.log("A");
}

B(); // error， B is not a function
var B = function () {
  console.log("B");
};
```

### 匿名函数（没有名字的函数）

```javascript
function() {} // 匿名函数
```

### 自执行函数

```javascript
(function() {
  console.log(3);
})();

// 带参数
(function(num){
  console.log(num);
})(3); // 3

// 没有括号会报错 如下
function() {
  console.log(3);
}();
```

原因如下：

- function {}()其实这是一个函数声明。
- JS 运行的时候，会对函数声明进行预编译，然后在执行其他语句。
- 也就是说 function(){}先被预编译了。然后 JS 看见了()。JS 一脸懵逼，这不得报错吗。
- 而匿名函数实际上是一个语句，正常执行。

自执行函数的标识也可以是

```javascript
!function(){}()      (function(){})()
~function(){}()      void function(){}()
```

## 预编译期和执行期

{% note info %}
JS 的解析分为两个阶段：预编译 和 执行期。
{% endnote %}

- 预编译期间：对本代码块中的所有声明变量和函数进行处理(类似于 C 语言的编译) ，但需要注意，1.此时处理函数的只是 声明式函数 2.变量也只是进行了声明但是没有进行初始化和赋值
- 编译期间：从上到下编译代码块。

### 函数声明提前且后来居上覆盖

```javascript
getName(); // 6
function getName() { alert (5);}
var getName = function () { alert (4);};
function getName() { alert (6);}

---
var getName = function () { alert (4);};
function getName() { alert (6);}
getName(); // 4 函数声明都被提升了，表达式会覆盖掉
```

### 练习题

```javascript
function Foo() {
  // 全局变量
  getName = function () {
    alert(1);
  };
  return this;
}
Foo.getName = function () {
  alert(2);
};
Foo.prototype.getName = function () {
  alert(3);
};
var getName = function () {
  alert(4);
};
function getName() {
  alert(5);
} // 函数提升 JavaScript永远不会有函数重载

//请写出以下输出结果：
Foo.getName(); // 2
getName(); // 4
Foo().getName(); // 1 覆盖了函数表达式
getName(); // 1
new Foo.getName(); // 2 new (Foo.getName)()
new Foo().getName(); // 3 (new Foo()).getName();
```

## ES6 之前，JS 没有变量作用域。只有 函数作用域 和 全局作用域。

```javascript
{
  var a = 3;
}
console.log(a); // 3
---
{
  let a = 3;
}
console.log(a); // error
```
