---
title: JavaScript深入之执行上下文
tags:
  - 前端
copyright: true
comments: true
date: 2018-06-13 17:06:49
categories: JS
top: 107
photos:
---

**执行上下文(EC)就是当前JavaScript代码被解析和执行是所在环境的抽象概念，JavaScript中运行任何的代码都是在执行上下文中运行。**

## 变量/函数提升(函数及变量的声明都将被提升到函数的最顶部，且函数声明在变量声明上边)

```javascript
if(!("a" in window)){ // false
    var a=1;
}
console.log(a) // undefined
// if(o.x){} // 不能判断属性存不存在 假值undefine,null,false," ",0或NaN
```

```javascript
function foo() {
    console.log('foo1');
}

foo();  // foo2

function foo() {
    console.log('foo2');
}

foo(); // foo2
---
var getName = function () { alert (4);};
function getName() { alert (5);}
getName(); // 4
---
function getName() { alert (5);}
var getName = function () { alert (4);};
function getName() { alert (6);}
getName(); // 4
```
函数表达式执行的优先级==!主要原因是函数声明都被提前了，所以函数表达式在最后会覆盖。

JavaScript 引擎并非一行一行地分析和执行程序，而是一段一段地分析执行。插槽slot
可执行代码的类型：全局代码、函数代码、eval代码。
JavaScript 引擎创建了执行上下文栈（Execution context stack，ECS）来管理执行上下文

--- 
<!-- more -->

- 作用域：作用域是定义变量的区域，它有一套访问变量的规则，这套规则来管理浏览器引擎如何在当前作用域以及嵌套的作用域中根据变量（标识符）进行变量查找。

- 作用域链：作用域链的作用是保证对执行环境有权访问的所有变量和函数的有序访问，通过作用域链，我们可以访问到外层环境的变量和函数。

## 分为三个部分
- 变量对象(VO)
- 作用域链
- this 指向

### 变量对象
变量对象，是执行上下文中的一部分，可以抽象为一种 数据作用域，其实也可以理解为就是一个简单的对象，它存储着该执行上下文中的所有变量和函数声明(不包含函数表达式)。
> 活动对象 (AO): 当变量对象所处的上下文为 active EC 时，称为活动对象。

### 作用域链(访问到父级甚至全局的变量)
执行上下文中还包含作用域链。理解作用域之前，先介绍下作用域。作用域其实可理解为该上下文中声明的 `变量和声明的作用范围`。可分为 全局作用域、块级作用域 
和 函数作用域

- 声明提前: 一个声明在函数体内都是可见的, 函数优先于变量
- 非匿名自执行函数，函数变量为 只读 状态，无法修改
```js
let foo = function() { console.log(1) };
(function foo() {
    foo = 10  // 由于foo在函数中只为可读，因此赋值无效
    console.log(foo)
}())
```

## 执行上下文的类型，主要有三类：

- 全局执行上下文：这是默认的，最基础的执行上下文。不在任何函数中的代码都位于全局执行上下文中。共有两个过程：1.创建有全局对象，在浏览器中这个全局对象就是window对象。2.将this指针指向这个全局对象。一个程序中只能存在一个执行上下文。

- 函数执行上下文：每次调用函数时，都会为该函数创建一个新的执行上下文。每个函数都拥有自己的执行上下文，但是只有在函数被调用的时候才会被创建。一个程序中可以存在多个函数执行上下文，这些函数执行上下文按照特定的顺序执行一系列步骤。

- eval执行上下文

## 调用栈
调用栈，具有LIFO（Last in, First out 后进先出）结构，用于存储在代码执行期间创建的所有执行上下文。

为了模拟执行上下文栈的行为，让我们定义执行上下文栈是一个数组：

```javascript
ECStack = [];
```

试想当 JavaScript 开始要解释执行代码的时候，最先遇到的就是全局代码，所以初始化的时候首先就会向执行上下文栈压入一个全局执行上下文，我们用 globalContext 表示它，并且只有当整个应用程序结束的时候，ECStack 才会被清空，所以程序结束之前， ECStack 最底部永远有个 globalContext：

```javascript
ECStack = [
    globalContext
];
```

现在 JavaScript 遇到下面的这段代码了：

```javascript
function fun3() {
    console.log('fun3')
}

function fun2() {
    fun3();
}

function fun1() {
    fun2();
}

fun1();
```

当执行一个函数的时候，就会创建一个执行上下文，并且压入执行上下文栈，当函数执行完毕的时候，就会将函数的执行上下文从栈中弹出。知道了这样的工作原理，让我们来看看如何处理上面这段代码：

```javascript
// 伪代码

// fun1()
ECStack.push(<fun1\> functionContext);

// fun1中竟然调用了fun2，还要创建fun2的执行上下文
ECStack.push(<fun2\> functionContext);

// 擦，fun2还调用了fun3！
ECStack.push(<fun3\> functionContext);

// fun3执行完毕
ECStack.pop();

// fun2执行完毕
ECStack.pop();

// fun1执行完毕
ECStack.pop();

// javascript接着执行下面的代码，但是ECStack底层永远有个globalContext
```

```js
function a() {
    var value = 'local scope'
    function b() {
        console.log(value)
    }
    return b()
}
a()
function a() {
    var value = 'local scope'
    function b() {
        console.log(value)
    }
    return b
}
a()()
```
分析如下👁：
```js
// a()执行的时候，创建执行上下文入栈
ECsatck.push(<fun\> a)
// 函数a遇到b可执行函数，执行b函数创建可执行上下文入栈
ECstack.push(<fun\> b)
// 后进先出原则b执行完出栈
ECstack.pop()
// a执行完出栈
ECstack.pop()

第二段代码

// a()执行的时候，创建执行上下文入栈
ECsatck.push(<fun\> a)
// a执行完后返回了b函数，注意这里没有直接执行而是直接返回了b,所有没有创建b函数的上下文，a执行完直接出栈
ECstack.pop() //a出栈
// 在外部返回的b函数被执行， 创建b的执行上下文，压入栈，
ECstack.push(<fun\> b)
// b执行完出栈
ECstack.pop()
```

## 调用栈执行的顺序
- 创建全局上下文(global EC)

- 每个函数的创建，函数执行上下文，外部环境的引用及 this，会push到执行栈顶层

- 函数调用时，函数执行上下文被激活，成为 active EC, 开始执行函数中的代码，caller 被挂起

- 函数执行结束后会从堆栈中弹出pop，并且它的执行上下文被垃圾收集回收(闭包除外)。控制权交还全局上下文 (caller)，继续执行

- 当调用堆栈为空时，它将从事件队列中获取事件

当浏览器加载某些JS代码时，JS引擎会逐行读取并执行以下步骤：
- 将变量和函数的声明放入全局内存(堆)中
- 将函数的调用放入调用堆栈
- 创建全局执行上下文，在其中执行全局函数
- 创建多个本地执行上下文(如果有内部变量或嵌套函数)

每个异步函数在被放入调用堆栈之前必须通过回调队列，但这个工作是谁做的呢，那就是事件循环(Event Loop)。

事件循环只有一个任务:它检查调用堆栈是否为空。如果回调队列中(Callback Queue)有某个函数，并且调用堆栈是空闲的，那么就将其放入调用堆栈中。

## 全局对象
{% note info %}

全局对象是预定义的对象，作为 JavaScript 的全局函数和全局属性的占位符。通过使用全局对象，可以访问所有其他所有预定义的对象、函数和属性。

{% endnote %}

{% note info %}

例如，当JavaScript 代码引用 parseInt() 函数时，它引用的是全局对象的 parseInt 属性。全局对象是作用域链的头，还意味着在顶层 JavaScript 代码中声明的所有变量都将成为全局对象的属性。

{% endnote %}

```javascript
// 在浏览器客户端 全局对象就是window对象
// 通过this引用
this === window  // true
this.window === window // true
this instanceof Object // true 是通过Object构造函数实例出来的对象
Math.random() 
this.Math.random() // 预定义了一些函数和属性

// window指向自身
var a=1;
a // 1
this.a // 1
window.a // 1 
this.window.a // 1
```

## 函数声明>变量声明

```javascript
console.log(foo); // 打印函数

function foo(){
    console.log("foo");
}

var foo = 1;
```
执行上下文时，首先会处理函数声明，其次会处理变量声明，如果如果变量名称跟已经声明的形式参数或函数相同，则变量声明不会干扰已经存在的这类属性。
