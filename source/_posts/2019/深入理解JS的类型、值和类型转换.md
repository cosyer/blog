---
title: 深入理解JS的类型、值和类型转换
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-03-05 22:44:52
categories: JS
top: 107
photos:
---

## 一、七种内置类型和常见引用类型
![精简](https://user-images.githubusercontent.com/25027560/37508449-123fc606-292e-11e8-9cf8-9667338b9ac4.png)

![复杂](https://user-images.githubusercontent.com/25027560/37508456-1c2c0648-292e-11e8-94d7-541f20942869.png)

---
<!--more-->
 
## 二、特殊的`null`
用`typeof`来检查上述七种类型时，返回的是对应的类型字符串值
 
```js
typeof null === 'ogject' // true
```
 
`null`是唯一一个用`typeof`检测会返回`object`的**基本类型值**（注意‘基本’两字）
 
不同的对象在底层都表示为二进制
在JavaScript中二进制前三位为0的话都会被判断为object类型
null的二进制表示全是0，自然前三位也是0
所以 typeof null === “object”
 
## 三、引用类型的子类型：typeof [引用类型] === what ?
上面的图中虽然列出了七种引用类型，但是
`typeof ‘引用类型’ === ‘object’ `一定成立吗？
 
不，还有一种情况：`typeof ‘某些引用类型’ === ‘function’`

```js
typeof Function; // 'function'
typeof new Function(); // 'function'
typeof function() {}; // 'function'

typeof Array; // 'function'
typeof Array(); // 'object'
typeof new Array(); // 'object'
typeof []; // 'object'

typeof Boolean; // "function"
typeof Boolean(); // "boolean"
typeof new Boolean(); // "object"

typeof Math; // 'object'
typeof Math(); // Math is not a function
typeof new Math(); // Math is not a constructor
```

### 1、引用类型中的函数
先看前三句，原来typeof除了能判断`基本类型`和`object`之外，还能判断`function`类型，函数也属于对象

### 2、引用类型的子类型
拿`Array`举例子

```js
typeof Array; // 'function'
typeof Array(); // 'object'
typeof new Array(); // 'object'
typeof []; // 'object'
```

`Array`是个构造函数，所以直接打印出function
但构造出来的`Array()`却又是另一回事了，构造出来的结果是个数组，自然属于引用类型，所以也就打印出了`‘object’`

构造函数 Array(..) 不要求必须带 new 关键字。不带时，它会被自动补上。 因此 Array(1,2,3) 和 new Array(1,2,3) 的效果是一样的

### 3、引用类型中的基本包装类型
```js
typeof Boolean; // "function"
typeof Boolean(); // "boolean"
typeof new Boolean(); // "object"
```

`Boolean`是个构造函数，第一句没问题
`Boolean()`直接执行，得出了布尔值，所以得到了`‘boolean’`

而new出来的是个Boolean对象，具体来说就是：`通过构造函数创建出来的是封装了基本类型值的封装对象`

这里用`String`来举个例子吧，看到了吗，一个封装对象
![封装对象](https://user-images.githubusercontent.com/25027560/37508489-350e6e80-292e-11e8-81f2-3124d28d219e.png)

但是，不推荐使用这种封装对象，举个例子

```js
var a = new Boolean(false);
if (!a) {
  console.log('Oops'); // false
}
```

a是个对象，对象永远是真。

### 4、Math到底是什么？
Math和Global（浏览器中替代为window）都是内置的对象，并不是引用类型的一种

```js
typeof Math; // 'object'
typeof Math(); // Math is not a function
typeof new Math(); // Math is not a constructor
```

既不是函数，也不是构造器。

## 四、typeof的安全防范机制
首先，我们需要知道`underfined`和`undeclared`的区别
未定义与未声明

但是，对于typeof来说，这两者都一样，返回的都是underfined

```js
var a;
typeof a; // 'underfined'
typeof b; // 'underfined'
```

很明显，我们知道b就是undeclared（未声明的），但在typeof看来都是一样

这个特性，可以拿来做些什么呢？

举个简单的例子，在程序中使用全局变量 DEBUG 作为“调试模式”的开关。在输出调试信 息到控制台之前，我们会检查 DEBUG 变量是否已被声明。顶层的全局变量声明 var DEBUG = true 只在 debug.js 文件中才有，而该文件只在开发和测试时才被加载到浏览器，在生产环 境中不予加载。

问题是如何在程序中检查全局变量 DEBUG 才不会出现 ReferenceError 错误。这时 typeof 的 安全防范机制就成了我们的好帮手:

```js
// 这样会抛出错误
if (DEBUG) {
  console.log('Debugging is starting');
}
// 这样是安全的
if (typeof DEBUG !== 'undefined') {
  console.log('Debugging is starting');
}
```

这不仅对用户定义的变量(比如 DEBUG)有用，对内建的 API 也有帮助:

```js
if (typeof atob === "undefined") {
         atob = function() { /*..*/ };
}
```

## 五、值
这一part引用自[一、内存空间详解 · Sample GitBook](https://yangbo5207.github.io/wutongluo/ji-chu-jin-jie-xi-lie/yi-3001-nei-cun-kong-jian-xiang-jie.html)

JS的执行上下文生成之后，会创建一个叫做变量对象的特殊对象，JS的基础类型都保存在变量对象中

严格意义上来说，变量对象也是存放于堆内存中，但是由于变量对象的特殊职能，我们在理解时仍然需要将其于堆内存区分开来。

但引用数据类型的值是保存在堆内存中的对象。JavaScript不允许直接访问堆内存中的位置，因此我们不能直接操作对象的堆内存空间。

在操作对象时，实际上是在操作对象的引用而不是实际的对象。因此，引用类型的值都是按引用访问的。

这里的引用，我们可以理解为保存在变量对象中的一个地址，该地址与堆内存的实际值相关联。

![3719a7f3-3915-4719-93d8-7629fa5b47bb](https://user-images.githubusercontent.com/25027560/37508497-409cd7fa-292e-11e8-8bc4-a62effd0f3c8.png)


而为什么基础数据类型存在栈中，而引用数据类型存在堆中呢?

- 堆比栈大，栈比堆速度快。
- 基础数据类型比较稳定，而且相对来说占用的内存小。
- 引用数据类型大小是动态的，而且是无限的。
- 堆内存是无序存储，可以根据引用直接获取。

## 六、强制类型转换
《you don’t know JS》中 第一部分第4章

类型转换发生在静态类型语言的编译阶段，而强制类型转换则发生在动态类型语言的运行时(runtime)。

然而在 JavaScript 中通常将它们统称为强制类型转换，我个人则倾向于用“隐式强制类型转换”(implicit coercion)和“显式强制类型转换”(explicit coercion)来区分。

### 1、抽象值操作
介绍显式和隐式强制类型转换之前，我们需要先掌握字符串、数字和布尔值之间类型转换的基本规则

1️⃣**ToString**
toString() 可以被显式调用，或者在需要字符串化时自动调用

null 转换为 "null"，undefined 转换为 "undefined"，true 转换为 "true"。
数字的字符串化则遵循通用规则
极小和极大的 数字使用指数形式:

```js
// 1.07 连续乘以七个 1000
var a = 1.07 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000 * 1000;
// 七个1000一共21位数字 
a.toString(); // "1.07e21"
```

数组的默认 toString() 方法经过了重新定义，将所有单元字符串化以后再用 "," 连接起 来

```js
var a = [1,2,3];
 a.toString(); // "1,2,3"
```

2️⃣ **ToNumber**
其中 true 转换为 1，false 转换为 0。undefined 转换为 NaN，null 转换为 0。
处理失败 时返回 NaN(处理数字常量失败时会产生语法错误)

3️⃣ **ToBoolean**
先看什么是假值

```
• undefined
• null
• false
• +0、-0 和 NaN
• ""
```
假值的布尔强制类型转换结果为 false。
从逻辑上说，假值列表以外的都应该是真值(truth)

```js
var a = new Boolean(false);
var b = new Number(0);
var c = new String('');

var d1 = Boolean( a && b && c );
var d2 = a && b && c;
```

![63754230-e3da-4363-a04d-cccca7030a15](https://user-images.githubusercontent.com/25027560/37508500-49f02fd2-292e-11e8-929b-168ea4309baf.png)

如果假值对象并非封装了假值的对象，那它究竟是什么?
值得注意的是，虽然 JavaScript 代码中会出现假值对象，但它实际上并不属于 JavaScript 语言的范畴。
浏览器在某些特定情况下，在常规 JavaScript 语法基础上自己创建了一些外来(exotic) 值，这些就是“假值对象”。
假值对象看起来和普通对象并无二致(都有属性，等等)，但将它们强制类型转换为布尔 值时结果为 false。

**真值就是假值列表之外的值**

```js
var a = 'false';
var b = '0';
var c = "''";
var d1 = Boolean(a && b && c);
var d2 = a && b && c
```

![985c49a4-061f-42fe-978c-83f7724d8867](https://user-images.githubusercontent.com/25027560/37508506-4e686bd8-292e-11e8-881b-81d56ac71281.png)


```js
var a = "0";
var b = [];
var c = {};
var d = "";
var e = 0;
var f = null;
var g;
Boolean( a ); // true  特别注意这个，字符串0和空字符串不一样
Boolean( b ); // true
Boolean( c ); // true
Boolean( d ); // false  和第一个比，空字符串是false
Boolean( e ); // false
Boolean( f ); // false
Boolean( g ); // false
```

### 2、显式类型转换

```js
// 字符串转换
var a = 42;
var b = String(a);
// 数字转换
var c = '3.14';
var d = Number(c);
// 布尔值转换
var e = [];
var f = Boolean(e)
```

### 3、隐式强制类型转换
1️⃣字符串和数字之间的隐式转换

```js
var a = '42';
var b = '0';
var c = 42;
var d = 0;
a + b; // "420" 这个地方，注意一下
c + d; // 42
```

```js
console.log([] + {}); // [object object]
console.log({} + []); // ?这会是多少呢？
```

《you don’t know JS 》中5.1.3章节是这样说的

还有一个坑常被提到(涉及强制类型转换，参见第 4 章)
[] + {}; // "[object Object]"
{} + []; // 0
表面上看 + 运算符根据第一个操作数([] 或 {})的不同会产生不同的结果，实则不然。 第一行代码中，{} 出现在 + 运算符表达式中，因此它被当作一个值(空对象)来处理。第
4 章讲过 [] 会被强制类型转换为 ""，而 {} 会被强制类型转换为 "[object Object]"。
但在第二行代码中，{} 被当作一个独立的空代码块(不执行任何操作)。代码块结尾不需 要分号，所以这里不存在语法上的问题。最后 + [] 将 [] 显式强制类型转换(参见第 4 章) 为 0。

但目前的chrome浏览器控制台是这样的
![034d7fa4-b144-4028-a346-0a52a3ab7faa](https://user-images.githubusercontent.com/25027560/37508514-5698c8fc-292e-11e8-9220-52136c53d5c4.png)


{} 其实应该当成一个代码块，而不是一个 Object，当你在console.log使用的时候，{} 被当成了一个 Object
![8c597cc9-d2e2-4a51-ad8c-dd1a25ac27db](https://user-images.githubusercontent.com/25027560/37509112-ef5b653e-2930-11e8-8456-824fd66271da.png)

2️⃣ 隐式强制类型转换为布尔值
下面的情况会发生 布尔值隐式强制类型转换。

* (1)if (..)语句中的条件判断表达式。
* (2)for ( .. ; .. ; .. )语句中的条件判断表达式(第二个)。
* (3) while (..) 和 do..while(..) 循环中的条件判断表达式。
* (4)? :中的条件判断表达式。
* (5) 逻辑运算符 ||(逻辑或)和 &&(逻辑与)左边的操作数(作为条件判断表达式)。

3️⃣ || 与 &&
就一句话，理解了就万岁，称之为“操作数选择器”

```js
a || b;
// 大致相当于(roughly equivalent to): a ? a : b;
a && b;
// 大致相当于(roughly equivalent to): a ? b : a;
```

### 4、== 与 ===
- 常见的误区是“== 检查值是否相等，=== 检查值和类型是否相等”
- 正确的解释是:“== 允许在相等比较中进行强制类型转换，而 === 不允许。