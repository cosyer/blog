---
title: 如何理解JS闭包
tags:
  - 闭包
copyright: true
comments: true
date: 2018-06-11 02:24:51
categories: JS
top: 107
photos:
---

{% centerquote %} 
JavaScript中的函数运行在它们被定义的作用域里，而不是它们被执行的作用域里。
{% endcenterquote %} 

在JS中函数作为普通对象进行传递

--- 
<!-- more -->
## 什么是闭包?(属于一种特殊的作用域，称为 静态作用域)
简单来说，闭包是指可以访问另一个函数作用域变量的函数，一般是定义在外层函数中的内层函数。(函数和声明该函数的词法环境的组合)子函数所在的父函数的作用域不会被释放。

## 为什么需要闭包？
使用闭包主要是为了设计私有的变量和方法。闭包的优点可以避免全局变量的污染，让变量始终保存在内存中，缺点是会常驻内存，增大内存的使用
量，使用不当会造成内存泄漏。

## 特点
1. 定义外层函数，封装被保护的局部变量。 
2. 定义内层函数，执行对外部函数变量的操作。 
3. 外层函数返回内层函数的对象，并且外层函数被调用，结果保存在一个全局的变量中。

## 特性
1. 函数嵌套函数，内层函数被返回。
2. 函数内部可以引用外部的参数和变量，以及外部函数能访问的所有变量和函数。但是，外部函数却不能够访问定义在内部函数中的变量和函数。
3. 参数和变量不会被垃圾回收机制回收。

## 实例
```javascript
var add = (function () {
    var counter = 0;
    return function () {return counter += 1;}
})();
add();
add();
add();
// add()调用过后应当销毁其变量，但其内层函数被返回了，并且还保留着对变量的引用，所以没有销毁还保留在内存当中。
```

```javascript
var arr=['one','two','three']
for(var i =0;i<arr.length;i++){
setTimeout(function(){
  console.log(i)
},i*1000)
}
// 打印3次3 执行setTimeout时for循环已经结束此时的i的值为3
```

```javascript
var arr=['one','two','three']
for(var i =0;i<arr.length;i++){
// 匿名闭包 封闭每个变量
(function(index){
  setTimeout(function(){
  console.log(arr[index])
},index*1000)
})(i)
} 
// one two three
```

避免使用过多的闭包，可以用let关键词，每个闭包都绑定了块作用域的变量，这意味着不再需要额外的闭包。

```javascript
var arr=['one','two','three']
for(let i =0;i<arr.length;i++){
setTimeout(function(){
  console.log(arr[i])
},i*1000)
}
```

```javascript
// setTimeout(code, milliseconds, param1, param2, ...)
// setTimeout(function, milliseconds, param1, param2, ...)
var i = 0
while (i++ < 3) {
  setTimeout(console.log, 0, i)
}
// 1 2 3 这个也是闭包
```

## 经典问题
多个子函数的[[scope]]都是同时指向父级，是完全共享的。因此当父级的变量对象被修改时，所有子函数都受到影响。

解决:
- 变量可以通过 函数参数的形式 传入，避免使用默认的[[scope]]向上查找
- 使用setTimeout包裹，通过第三个参数传入
- 使用 块级作用域，让变量成为自己上下文的属性，避免共享
