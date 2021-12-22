---
title: use strict
tags:
  - 知识
copyright: true
comments: true
date: 2019-05-08 01:13:46
categories: JS
photos:
top: 201
---

严格模式是 ES5 引入的，更好的将错误检测引入代码的方法。顾名思义，使得 JS 在更严格的条件下运行。

```js
变量必须先声明，再使用
function test(){
"use strict";
foo = 'bar'; // Error
}

不能对变量执行delete操作
var foo = "test";
function test(){}

delete foo; // Error
delete test; // Error

function test2(arg) {
delete arg; // Error
}
对象的属性名不能重复
{ foo: true, foo: false } // Error

禁用eval()

函数的arguments参数
setTimeout(function later(){
// do stuff...
setTimeout( later, 1000 );
}, 1000 );

禁用with(){}

不能修改arguments
不能在函数内定义arguments变量
不能使用arugment.caller和argument.callee。因此如果你要引用匿名函数，需要对匿名函数命名。
```

`严格模式`的优点：

1. 消除 Javascript 语法的一些不合理、不严谨之处，减少一些怪异行为;

2. 消除代码运行的一些不安全之处，保证代码运行的安全；

3. 提高编译器效率，增加运行速度；

4. 为未来新版本的 Javascript 做好铺垫。

- 注：经过测试 IE6,7,8,9 均不支持严格模式。

缺点：

现在网站的 JS 都会进行压缩，一些文件用了严格模式，而另一些没有。这时这些本来是严格模式的文件，被 merge 后，这个串就到了文件的中间，不仅没有指示严格模式，反而在压缩后浪费了字节。

---

<!--more-->

## 详细说明

1.使调试更加容易。那些被忽略或默默失败了的代码错误，会产生错误或抛出异常，因此尽早提醒你代码中的问题，你才能更快地指引到它们的源代码。

2.变量在赋值之前必须声明,防止意外的全局变量。如果没有严格模式，将值分配给一个未声明的变量会自动创建该名称的全局变量。这是 JavaScript 中最常见的错误之一。在严格模式下，这样做的话会抛出错误。

3.取消 this 值的强制转换。如果没有严格模式，引用 null 或未定义的值到 this 值会自动强制到全局变量。在严格模式下，引用 null 或未定义的 this 值会抛出错误。严格模式下，this 不会指向 window

4.不允许重复的属性名称或参数值。当检测到对象中重复命名的属性，例如：

```js
var object = {foo: "bar", foo: "baz"};

// 或检测到函数中重复命名的参数时,例如：

function foo(val1, val2, val1){}）

// 严格模式会抛出错误，因此捕捉几乎可以肯定是代码中的bug可以避免浪费大量的跟踪时间。
```

5.使 eval() 更安全。在严格模式和非严格模式下， eval() 的行为方式有所不同。最显而易见的是，在严格模式下，变量和声明在 eval() 语句内部的函数不会在包含范围内创建（它们会在非严格模式下的包含范围中被创建，这也是一个常见的问题源）。

eval()没有被移除，但它在严格模式下发生了一些变化。最大的改变是：在 eval()语句中声明的变量以及函数不会在包含域中创建。例如：

```js
(function() {

eval("var x = 10;");

// 非严格模式下，x为10
// 严格模式下，x没有声明，抛出一个错误
alert(x);
})(); 
任意由eval()创建的变量或函数仍呆在eval()里。然而，你可以通过从eval()中返回一个值的方式实现值的传递：

(function() {

var result = eval("var x = 10, y = 20; x + y");

// 严格模式与非严格模式下都能正常工作（得到30）
alert(result);
}()); 
```

6.在 delete 使用无效时抛出错误。 delete 操作符（用于从对象中删除属性）不能用在对象不可配置的属性上。当试图删除一个不可配置的属性时，非严格代码将默默地失败，而严格模式将在这样的情况下抛出异常。

7.严格模式去除了 with 语句

8.不能修改 arguments ，不能在函数内定义 arguments 变量   ，不能使用 arugment.caller 和 argument.callee。因此如果你要引用匿名函数，需要对匿名函数命名。

## 简洁说明

- 变量必须声明后再使用
- 函数的参数不能有同名属性，否则报错
- 不能使用 with 语句
- 不能对只读属性赋值，否则报错
- 不能使用前缀 0 表示八进制数，否则报错
- 不能删除不可删除的属性，否则报错
- eval 不会在它的外层作用域引入变量
- eval 和 arguments 不能被重新赋值
- arguments 不会自动反映函数参数的变化
- 不能使用 arguments.callee
- 不能使用 arguments.caller
- 禁止 this 指向全局对象
- 不能使用 fn.caller 和 fn.arguments 获取函数调用的堆栈
- 增加了保留字（比如 protected、static 和 interface）
