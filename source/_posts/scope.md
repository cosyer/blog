---
title: JavaScript深入之作用域
tags:
  - 作用域
copyright: true
comments: true
date: 2018-06-12 21:43:41
categories: JS
top: 107
photos:
---

## 作用域

作用域是我们可以有效访问变量或函数的区域，包含全局作用域、函数作用域、块级作用域（ES6） 三种；

JavaScript 采用词法作用域(lexical scoping)，也就是静态作用域。它的作用域是指在词法分析阶段就确定了，不会改变。而与词法作用域相对的是动态作用域，

函数的作用域是在函数调用的时候才决定的。

**函数的作用域在函数定义的时候就决定了，函数的作用域基于函数创建的位置。**

---
<!-- more -->

```javascript
var value=1
function print(){
  console.log(value)
}
function foo(){
  var value=2
  print()
}
foo() // value 1 如果是动态作用域则是2
```
静态作用域是产生闭包的关键，即它在代码写好之后就被静态决定它的作用域了。

- 动态域的函数中遇到既不是形参也不是函数内部定义的局部变量的变量时，到函数调用的环境去查询
在 JS 中，关于 this 的执行是基于动态域查询的，下面这段代码打印出 1，如果按静态作用域的话应该会打印出 2
```js
var foo = 1;

var obj = {
  foo: 2,
  bar: function() {
    console.log(this.foo);
  }
};

var bar = obj.bar;
bar();
```

我们再来看两道题：

```javascript
var scope = "global scope";
function checkscope(){
    var scope = "local scope";
    function f(){
        return scope;
    }
    return f();
}
checkscope();
```

```javascript
var scope = "global scope";
function checkscope(){
    var scope = "local scope";
    function f(){
        return scope;
    }
    return f;
}
checkscope()();
```
两道题的执行结果都是 "local scope"

JavaScript 函数的执行用到了作用域链，这个作用域链是在函数定义的时候创建的。嵌套的函数 f() 定义在这个作用域链里，其中的变量 scope 一定是局部变量，不管何时何地执行函数 f()，这种绑定在执行 f() 时依然有效。

```javascript
var name="999999"
var b = {
name :"The Window",
object:{
　　　　name : "My Object",
　　　　getNameFunc : function(){
　　　　　　return function(){
                return this.name
              }
　　　　}
　　}
}
console.log(b.object.getNameFunc()()) // 999999
---
var name="999999"
var b = function(){
var name = "The Window";
　　var object = {
　　　　name : "My Object",
　　　　getNameFunc : function(){
 
　　　　　　return function(){
　　　　　　　　return this.name;
　　　　　　};
　　　　}
　　};
　console.log(object.getNameFunc()())
}
b() // 999999
```

## 作用域链
作用域链：作用域也是一组用于查找变量的规则。如果变量在当前作用域中不存在，它将向外部作用域中查找并搜索，如果该变量不存在，它将再次查找直到到达全局作用
域，如果找到，则可以使用它，否则引发错误，这种查找过程也称为作用域链。
