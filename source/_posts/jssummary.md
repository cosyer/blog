---
title: JavaScript整理总结
date: 2018-06-21 19:37:27
tags:
  - 整理
categories: JS
---

JS 的相关知识点比较繁杂，特此开篇整理一波，方便回顾总结查阅。

- 运行在宿主环境环境中，比如浏览器或 node 环境
- 不用预编译，直接解释执行代码
- 是弱类型语言，较为灵活
- 与操作系统无关，跨平台的语言
- 脚本语言，解释性语言

---

<!--more -->

## 概念

JavaScript 是一门跨平台、面向对象、基于原型的轻量级动态脚本语言。

与 java 的对比：

| JavaScript                                                                         | Java                                                                                   |
| :--------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------- |
| 面向对象。不区分对象类型。通过原型机制继承，任何对象的属性和方法均可以被动态添加。 | 基于类系统。分为类和实例，通过类层级的定义实现继承。不能动态增加对象或类的属性或方法。 |
| 变量类型不需要提前声明(动态类型)。                                                 | 变量类型必须提前声明(静态类型)。                                                       |
| 不能直接自动写入硬盘。                                                             | 可以直接自动写入硬盘。                                                                 |

## 变量声明

### var(存在变量提升)

声明一个变量，可赋一个初始化值。

### let(let 同一变量在同一作用域不能同时声明)

声明一个块作用域的局部变量，可赋一个初始化值。

### const(const 声明时必须赋初始值,也不可以在脚本运行时重新声明)

声明一个块作用域的只读的命名常量。
const 声明创建一个值的只读引用。但这并不意味着它所持有的值是不可变的，只是变量标识符不能重新分配。
如 const a=[1,2,3] a[1]=4; const b={} b.name="1" 数组元素和对象属性不受保护。

## 变量的作用域

在所有函数之外声明的变量，叫做全局变量，因为它可被当前文档中的任何其他代码所访问。在函数内部声明的变量，叫做局部变量，因为它只能在该函数内部访问。全区变量是全局对象的属性，在浏览器中可以用 window.xx 或 xx 来访问。

```javascript
if (true) {
  var a = 5;
}
console.log(a); // 5 使用let声明块级则是undefined
```

## 变量提升

JavaScript 变量的另一特别之处是，你可以引用稍后声明的变量而不会引发异常。这一概念称为变量声明提升(hoisting)；
var ok ; let 和 const 则不会存在变量提升

```javascript
1.
console.log(x === undefined); // true
var x = 3;

2.
var myvar = "my value";

(function() {
  console.log(myvar); // undefined
  var myvar = "local value";
})();

1.1 也可写作
var x;
console.log(x === undefined); // true
x = 3;

2.1
var myvar = "my value";

(function() {
  var myvar;
  console.log(myvar); // undefined
  myvar = "local value";
})();
```

## 函数提升

声明函数的 3 种方式：

```javascript
function foo(){} // 函数声明 存在函数提升且大于变量提升
var foo=function (){} // 函数表达式 var foo=function foo1(){} 函数名可写
new Function("参数1","参数2",...,"参数n","函数体"); // 使用Function构造函数
```

从作用域上来说，函数声明式和函数表达式使用的是局部变量，而 Function()构造函数却是全局变量。

```js
var name = "我是全局变量 name";

// 声明式
function a() {
  var name = "我是函数a中的name";
  return name;
}
console.log(a()); // 打印: "我是函数a中的name"

// 表达式
var b = function () {
  var name = "我是函数b中的name";
  return name; // 打印: "我是函数b中的name"
};
console.log(b());

// Function构造函数
function c() {
  var name = "我是函数c中的name";
  return new Function("return name");
}
console.log(c()()); // 打印："我是全局变量 name"，因为Function()返回的是全局变量 name，而不是函数体内的局部变量。
```

从执行效率上来说，Function()构造函数的效率要低于其它两种方式，尤其是在循环体中，因为构造函数每执行一次都要重新编译，并且生成新的函数对象。

此时的 3 种递归调用自身的方式

- foo()
- foo1()
- arguments.callee()

现在已经不推荐使用 arguments.callee()；
原因：访问 arguments 是个很昂贵的操作，因为它是个很大的对象，每次递归调用时都需要重新创建。影响现代浏览器的性能，还会影响闭包。

## 数据类型 8 种

### 原始类型

- Boolean
- null
- undefined
- String
- Number 标识范围 -2^53~2^53 数字均为双精度浮点类型
  - 实质是一个 64 位的浮点数。使用 53 位表示小数位，10 位表示指数位，1 位表示符号位。
- Symbol(它的实例是唯一且不可改变)
- bigint

Object 是 JavaScript 中所有对象的父对象（object、array、function）

两种类型的区别是：存储位置不同；
原始数据类型直接存储在栈(stack)中的简单数据段，占据空间小、大小固定，属于被频繁使用数据，所以放入栈中存储；
引用数据类型存储在堆(heap)中的对象,占据空间大、大小不固定,如果存储在栈中，将会影响程序运行的性能；引用数据类型在栈中存储了指针，该指针指向堆中该实体的起始地址。当解释器寻找引用值时，会首先
检索其在栈中的地址，取得地址后从堆中获得实体

数据封装类对象：Object、Array、Boolean、Number 和 String
其他对象：Function、Arguments、Math、Date、RegExp、Error

为什么 x=0.1 能得到 0.1？
恭喜你到了看山不是山的境界。因为 mantissa 固定长度是 52 位，再加上省略的一位，最多可以表示的数是 2^53=9007199254740992，对应科学计数尾数是

9.007199254740992，这也是 JS 最多能表示的精度。它的长度是 16，所以可以使用 toPrecision(16) 来做精度运算，超过的精度会自动做凑整处理。

不仅 JavaScript，所有遵循 IEEE 754 规范的语言都是如此；

`在JavaScript中，所有的Number都是以64-bit的双精度浮点数存储的，在用二进制存储时会存在精度误差；`

`原因：计算机不能精确表示0.1， 0.2这样的浮点数，计算时使用的是带有舍入误差的数，但不是所有的浮点数在计算机内部都存在舍入误差，比如0.5就没有舍入误差`

双精度的浮点数在这 64 位上划分为 3 段，而这 3 段也就确定了一个浮点数的值，64bit 的划分是“1-11-52”的模式，具体来说：

1.就是 1 位最高位（最左边那一位）表示符号位，0 表示正，1 表示负；

2.11 位表示指数部分；52 位表示尾数部分，也就是有效域部分

任何原始类型都有字面量形式，可以不被变量所存储。

JavaScript 语言有"垃圾回收"功能，所以在使用引用类型的时候无需担心内存分配。但是为了防止"内存泄漏"还是应该在不实用对象的时候将该对

象的引用赋值为 null。让"垃圾回收"器在特定的时间对那一块内存进行回收。

64 位浮点数：1 位符号位 + 52 位整数位 + 11 位小数位，如果符号位为 1，其他各位均为 0，那么这个数值会被表示成"-0"。同理还可以表示"+0"

```js
// 二进制构造-0
// 首先创建一个8位的ArrayBuffer
const buffer = new ArrayBuffer(8);
// 创建DataView对象操作buffer
const dataView = new DataView(buffer);

// 将第1个字节设置为0x80，即最高位为1
dataView.setUint8(0, 0x80);

// 将buffer内容当做Float64类型返回
console.log(dataView.getFloat64(0)); // -0
```

- 判断+-0

```js
0 === -0; // true
// Object.is(-0, 0)返回false，Object.is(NaN, NaN)返回true
// 早期es利用1/-0为-Infinity的特点来判断
function isNegativeZero(num) {
  return num === 0 && 1 / num < 0;
}
```

- Object.is()方法的 polyfill

```js
if (!Object.is) {
  Object.is = function (x, y) {
    // SameValue algorithm
    if (x === y) {
      // Steps 1-5, 7-10
      // Steps 6.b-6.e: +0 != -0
      return x !== 0 || 1 / x === 1 / y;
    } else {
      // Step 6.a: NaN == NaN
      return x !== x && y !== y;
    }
  };
}
```

### 原始封装类型

```js
var a = "qwer";
var firstChar = a.chatAt(0);
console.log(firstChar); // q
```

在 js 引擎中发生了

```js
var a = "qwer";
var temp = new String(a);
var firstChar = temp.chatAt(0);
temp = null;
console.log(firstChar); // q
```

```js
0.10000000000000000555.toPrecision(16)
// 返回 0.1000000000000000，去掉末尾的零后正好为 0.1

// 但你看到的 `0.1` 实际上并不是 `0.1`。不信你可用更高的精度试试：
0.1.toPrecision(21) = 0.100000000000000005551
```

`"getters"/"setters"`可以想象一个给定的字符串就像一个附加了一堆方法和属性的对象。当访问数组的长度时，你只需调用相应的 getter。setter 函数用于设置操作:

```js
var array = {
  value: ["Hello", 89, false, true],
  push: function (element) {
    //
  },
  shift: function () {
    //
  },
  get length() {
    // gets the length
  },
  set length(newLen) {
    // sets the length
  },
};

// Getter call
var len = array.length;

// Setter call
array.length = 50;
```

### 对象 Object

Object 是 JS 中最重要的类型，因此几乎所有其他实体都可以从中派生。 例如，函数和数组是专用对象。 JS 中的对象是键/值对的容器。

对象被定义为“无序属性的集合，其属性可以包含基本值，对象或者函数”。

只有 null 和 undefined 无法拥有方法

Function Array Number Boolean String Date Math RegExp 类

```javascript
typeof null === 'object' // true
null instanceof Object // false
null instanceof null // error

// 不同的对象在底层都表示为二进制
// 在JavaScript中二进制前三位为0的话都会被判断为object类型
// null的二进制表示全是0，自然前三位也是0
// 所以 typeof null === “object”

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

[]+[] // ""
[]+{} // "[object Object]"
{}+[] // 0

!+[]+[]+![] // "truefalse"

Math.max() // -Infinity
Math.min() // Infinity
```

> 构造函数 Array(..) 不要求必须带 new 关键字。不带时，它会被自动补上。 因此 Array(1,2,3) 和 new Array(1,2,3) 的效果是一样的

## MDN 基本数据类型的定义

> 除 Object 以外的所有类型都是不可变的（值本身无法被改变）。例如，与 C 语言不同，JavaScript 中字符串是不可变的
> （译注：如，JavaScript 中对字符串的操作一定返回了一个新字符串，原始字符串并没有被改变）。我们称这些类型的值为“原始值”。

```javascript
var a = "string";
a[0] = "a";
console.log(a); // string
```

我们通常情况下都是对一个变量重新赋值，而不是改变基本数据类型的值。在 js 中是没有方法是可以改变布尔值和数字的。
倒是有很多操作字符串的方法，但是这些方法都是返回一个新的字符串，并没有改变其原有的数据。

### 引用数据类型

引用类型（object）是存放在堆 heap 内存中的，变量实际上是一个存放在栈内存的指针，这个指针指向堆内存中的地址。每个空间大小不一样，要根据情况开进行特定的分配。

### 传值和传址

了解了基本数据类型与引用类型的区别之后，我们就应该能明白传值与传址的区别了。
在我们进行赋值操作的时候，基本数据类型的赋值（=）是在内存中新开辟一段栈内存，然后再将值赋值到新的栈中。例如:

```javascript
var a = 10;
var b = a;

a++;
console.log(a); // 11
console.log(b); // 10
```

所以说，基本类型的赋值的两个变量是两个独立相互不影响的变量。

但是引用类型的赋值是传址。只是改变指针的指向，例如，也就是说引用类型的赋值是对象保存在栈中的地址的赋值，这样的话两个变量就指向同一个对象，因此两者之间操作互相有影响。例如：

```javascript
var a = {}; // a保存了一个空对象的实例
var b = a; // a和b都指向了这个空对象

a.name = "jozo";
console.log(a.name); // 'jozo'
console.log(b.name); // 'jozo'

b.age = 22;
console.log(b.age); // 22
console.log(a.age); // 22

console.log(a == b); // true
```

## 字面量

字面量是由语法表达式定义的常量

- 数组字面量(Array literals) []
- 布尔字面量(Boolean literals) true/false
- 浮点数字面量(Floating-point literals) 3.14
- 整数(Intergers) 5
- 对象字面量(Object literals) {}
- RegExp literals 一个正则表达式是字符被斜线（译注：正斜杠“/”）围成的表达式 /a+b/
  RegExp.test() RegExp.exec() string.match()
- 字符串字面量(String literals) "1212" '1212'
  JavaScript 会自动将字符串字面值转换为一个临时字符串对象，调用该方法，然后废弃掉那个临时的字符串对象。你也能用对字符串字面值使用类似

```javascript
String.length的属性：
console.log("John's cat".length)
```

```javascript
var obj={
  say:funciton(){

  },
  // 简写
  say(){

  }
}
```

十进制整数字面量由一串数字序列组成，且没有前缀 0。
八进制的整数以 0（或 0O、0o）开头，只能包括数字 0-7。
十六进制整数以 0x（或 0X）开头，可以包含数字（0-9）和字母 a~f 或 A~F。
二进制整数以 0b（或 0B）开头，只能包含数字 0 和 1。

## 模板字符串

```javascript
var name = "Bob",
  time = "today";
`Hello ${name}, how are you ${time}?`;
```

## 布尔环境的假值

- false
- undefined
- null
- 0
- NaN
- 空字符串（""）

## try-catch

如果 finally 块返回一个值，该值会是整个 try-catch-finally 流程的返回值，不管在 try 和 catch 块中语句返回了什么：

```javascript
function f() {
  try {
    console.log(0);
    throw "bogus";
  } catch (e) {
    console.log(1);
    return true; // this return statement is suspended
    // until finally block has completed
    console.log(2); // not reachable
  } finally {
    console.log(3);
    return false; // overwrites the previous "return"
    console.log(4); // not reachable
  }
  // "return false" is executed now
  console.log(5); // not reachable
}
f(); // console 0, 1, 3; returns false
```

## for of 和 for in 循环

- for in 更适合对象，遍历数组和对象
- for of 适合遍历数组，遍历没有 Symbol.iterator 属性的对象是会报错的

```javascript
let arr = [3, 5, 7];
arr.foo = "hello";

for (let i in arr) {
  console.log(i); // logs "0", "1", "2", "foo"
}

// 所有可枚举的属性名
for (let i of arr) {
  console.log(i); // logs "3", "5", "7" // 注意这里没有 hello
}

// for in 的循环顺序 => 遍历首先数字的可以接着按照创建顺序遍历
// 对象数字键名会转成字符串 对象的key值只有string和symbol类型
// 排序规则同样适用于下列API：
// Object.entries
// Object.values
// Object.keys
// Object.getOwnPropertyNames
// Reflect.ownKeys

var a = { 1: 1, name: "cosyer", 2: 2 };
for (let i in a) {
  if (a.hasOwnProperty(i)) {
    console.log(i);
  }
}
// 1 2 name
```

## 嵌套函数和闭包

一个闭包是一个可以自己拥有独立的环境与变量的的表达式。

- 内部函数包含外部函数的作用域。
- 内部函数只可以在外部函数中访问。
- 内部函数可以访问外部函数的参数和变量，但是外部函数却不能使用它的参数和变量。

## 多层嵌套函数

函数可以被多层嵌套。例如，函数 A 可以包含函数 B，函数 B 可以再包含函数 C。B 和 C 都形成了闭包，所以 B 可以访问 A，C 可以访问 B 和 A。因此，闭包可以包含多个作用域；他们递归式的包含了所有包含它的函数作用域。这个称之为作用域链。

```javascript
function A(x) {
  function B(y) {
    function C(z) {
      console.log(x + y + z);
    }
    C(3);
  }
  B(2);
}
A(1); // logs 6 (1 + 2 + 3)
```

在这个例子里面，C 可以访问 B 的 y 和 A 的 x。这是因为：

1. B 形成了一个包含 A 的闭包，B 可以访问 A 的参数和变量
2. C 形成了一个包含 B 的闭包
3. B 包含 A，所以 C 也包含 A，C 可以访问 B 和 A 的参数和变量。换言之，C 用这个顺序链接了 B 和 A 的作用域

反过来却不是这样。A 不能访问 C，因为 A 看不到 B 中的参数和变量，C 是 B 中的一个变量，所以 C 是 B 私有的。

## 作用域链解释说明

当同一个闭包作用域下两个参数或者变量同名时，就会产生命名冲突。更近的作用域有更高的优先权，所以最近的优先级最高，最远的优先级最低。这就是作用域链。链的第一个元素就是最里面的作用域，最后一个元素便是最外层的作用域。

`全局函数无法查看局部函数的内部细节，但局部函数可以查看其上层的函数细节，直至全局细节。 当需要从局部函数查找某一属性或方法时，如果当前作用域没有找到，就会上溯到上层作用域查找， 直至全局函数，这种组织形式就是作用域链。`

```javascript
function outside() {
  var x = 5;
  function inside(x) {
    return x * 2;
  }
  return inside;
}

outside()(10); // returns 20 instead of 10
```

命名冲突发生在 return x 上，inside 的参数 x 和 outside 变量 x 发生了冲突。这里的作用域链是{inside, outside, 全局对象}。因此 inside 的 x 具有最高优先权，返回了 20（inside 的 x）而不是 10（outside 的 x）。

## 闭包

JavaScript 允许函数嵌套，并且内部函数可以访问定义在外部函数中的所有变量和函数，以及外部函数能访问的所有变量和函数。但是，外部函数却不能够访问定义在内部函数中的变量和函数。这给内部函数的变量提供了一定的安全性。此外，由于内部函数可以访问外部函数的作用域，因此当内部函数生存周期大于外部函数时，外部函数中定义的变量和函数将的生存周期比内部函数执行时间长。当内部函数以某一种方式被任何一个外部函数作用域访问时，一个闭包就产生了。

```javascript
var pet = function (name) {
  //外部函数定义了一个变量"name"
  var getName = function () {
    //内部函数可以访问 外部函数定义的"name"
    return name;
  };
  //返回这个内部函数，从而将其暴露在外部函数作用域
  return getName;
};
myPet = pet("Vivie");

myPet(); // 返回结果 "Vivie"
```

## arguments 对象

函数的实际参数会被保存在一个类似数组的 arguments 对象中。

```javascript
arguments[i]; // 访问
```

arguments 变量只是 ”类数组对象“，并不是一个数组。称其为类数组对象是说它有一个索引编号和 length 属性。尽管如此，它并不拥有全部的 Array 对象的操作方法。

## 函数参数(默认参数、剩余参数(rest))

剩余参数语法允许将不确定数量的参数表示为数组

```javascript
function multiply(a, b = 1,...[1,2,3]) {
  return a*b;
}
```

## 箭头函数

箭头函数总是匿名的
引入箭头函数的原因

1. 更简洁的语法
2. 捕捉闭包上下文的 this 值

```javascript
function Person() {
  this.age = 0;

  setInterval(() => {
    this.age++; // |this| properly refers to the person object
  }, 1000);
}

var p = new Person();
```

## 扩展语句

适用于对象，数组

```javascript
function f(x, y, z) {}
var args = [0, 1, 2];
f(...args);
```

## 临时对象

你可以在 String 字面值上使用 String 对象的任何方法—JavaScript 自动把 String 字面值转换为一个临时的 String 对象, 然后调用其相应方法,最后丢弃销毁此临时对象.在 String 字面值上也可以使用 String.length 属性.

```javascript
var s1 = "2 + 2"; // Creates a string literal value
var s2 = new String("2 + 2"); // Creates a String object
eval(s1); // Returns the number 4
eval(s2); // Returns the string "2 + 2"
Number(null); // 0
```

## 数组方法

### concat() 连接两个数组并返回一个新的数组。

```javascript
var myArray = new Array("1", "2", "3");
myArray = myArray.concat("a", "b", "c");
// myArray is now ["1", "2", "3", "a", "b", "c"]
```

### join() 将数组的所有元素连接成一个字符串。

```javascript
var myArray = new Array("Wind", "Rain", "Fire");
var list = myArray.join(" - "); // list is "Wind - Rain - Fire"
```

### push() 在数组末尾添加一个或多个元素，并返回数组操作后的长度。

```javascript
var myArray = new Array("1", "2");
myArray.push("3"); // myArray is now ["1", "2", "3"]
```

### pop() 从数组移出最后一个元素，并返回该元素。

```javascript
var myArray = new Array("1", "2", "3");
var last = myArray.pop();
// myArray is now ["1", "2"], last = "3"
```

### shift() 从数组移出第一个元素，并返回该元素。

```javascript
var myArray = new Array("1", "2", "3");
var first = myArray.shift();
// myArray is now ["2", "3"], first is "1"
```

### unshift()在数组开头添加一个或多个元素，并返回数组的新长度。

```javascript
var myArray = new Array("1", "2", "3");
myArray.unshift("4", "5");
// myArray becomes ["4", "5", "1", "2", "3"]
```

### slice(开始索引，结束索引) 从数组提取一个片段，并作为一个新数组返回。

```javascript
var myArray = new Array("a", "b", "c", "d", "e");
myArray = myArray.slice(1, 4); // until index 3, returning [ "b", "c", "d"]
```

slice 方法可以用来将一个类数组（Array-like）对象/集合转换成一个新数组。只需将该方法绑定到这个对象上。 一个函数中的 arguments 就是一个类数组对象的例子。

```javascript
Array.prototype.slice.call({ 0: 1, 1: 3, length: 2 });
```

### splice(index, count_to_remove, addElement1, addElement2, ...)从数组移出一些元素，（可选）并替换它们。

```javascript
var myArray = new Array("1", "2", "3", "4", "5");
myArray.splice(1, 3, "a", "b", "c", "d");
// myArray is now ["1", "a", "b", "c", "d", "5"]
```

### reverse() 颠倒数组元素的顺序：第一个变成最后一个，最后一个变成第一个。

```javascript
var myArray = new Array("1", "2", "3");
myArray.reverse();
// transposes the array so that myArray = [ "3", "2", "1" ]
```

### sort() 给数组元素排序。

```javascript
var arr = [2, 1, 3];
arr.sort(); // [1,2,3]
```

sort() 也可以带一个回调函数来决定怎么比较数组元素。这个回调函数比较两个值，并返回 3 个值中的一个：

- 如果 a 小于 b ，返回 -1(或任何负数) 降序
- 如果 a 大于 b ，返回 1 (或任何正数) 升序
- 如果 a 和 b 相等，返回 0。

### indexOf(searchElement[, fromIndex]) 在数组中搜索 searchElement 并返回第一个匹配的索引。

```javascript
var a = ["a", "b", "a", "b", "a"];
console.log(a.indexOf("b")); // logs 1
// Now try again, starting from after the last match
console.log(a.indexOf("b", 2)); // logs 3
console.log(a.indexOf("z")); // logs -1, because 'z' was not found
```

### lastIndexOf(searchElement[, fromIndex]) 和 indexOf 差不多，但这是从结尾开始，并且是反向搜索。

### forEach() 循环数组 不定的顺序 不能用 break,return false 跳出循环遍历

遍历都不会修改原来的基本类型（只能返回新数组）引用类型可以。

### map() 循环数组返回新数组

```javascript
var a1 = ["a", "b", "c"];
var a2 = a1.map(function (item) {
  return item.toUpperCase();
});
console.log(a2); // logs A,B,C
```

### find() 找到满足条件的第一个元素

### filter() 循环数组返回符合条件的元素

```javascript
var a1 = ["a", 10, "b", 20, "c", 30];
var a2 = a1.filter(function (item) {
  return typeof item == "number";
});
console.log(a2); // logs 10,20,30
```

### every() 循环数组 如果全部元素满足条件则返回 true 否则返回 false

### some() 循环数组 只要有一项满足条件则返回 true 全部不满足返回 false

### reduce() 迭代 使用回调函数 callback(firstValue, secondValue) 把数组列表计算成一个单一值 reduceRight() 从右边开始

```javascript
var a = [10, 20, 30];
var total = a.reduce(function(first, second) { return first + second; }, 0);
console.log(total) // Prints 60

[3,2,1].reduce(Math.pow) // 9
[].reduce(Math.pow) // error
```

### 填充 fill/splice

```javascript
var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.fill("cosyer", 2, 4); // 开始和结束索引
fruits.splice(2, 2, "cosyer", "cosyer"); // splice方法需要手动添加多个
// ["Banana", "Orange", "cosyer", "cosyer"]
```

### copyWithin

```javascript
var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.copyWithin(2, 0); // Banana,Orange,Banana,Orange
// copyWithin(target, start, end);
```

### entries 一个数组的迭代对象，该对象包含数组的键值对

```javascript
var a = ["a", "b", "c"];
var iterator = a.entries();
console.log(iterator); // Array Iterator{}
console.log(iterator.next().value); // [0,'a']
for (let a of iterator) {
  console.log(a);
}
//[0,'a']
//[1,'b']
//[2,'c']
// keys返回键() values()返回值
```

## Map 简单的键值对集合(字典的数字结构类似对象，键可以是各种类型的值)

```javascript
var sayings = new Map();
sayings.set("dog", "woof");
sayings.set("cat", "meow");
sayings.set("elephant", "toot");
sayings.size; // 3
sayings.get("fox"); // undefined
sayings.has("bird"); // false
sayings.delete("dog");
sayings.has("dog"); // false

for (var [key, value] of sayings) {
  console.log(key + " goes " + value);
}
// "cat goes meow"
// "elephant goes toot"

sayings.clear();
sayings.size; // 0
```

new Map() 参数可以是一个数组或者其他 iterable 对象，其元素或为键值对，或为两个元素的数组。 每个键值对都会添加到新的 Map。null 会被当做 undefined。

```js
const set = new Set([
  ["foo", 1],
  ["bar", 2],
]);
const m1 = new Map(set);
m1.get("foo"); // 1

const m2 = new Map([["baz", 3]]);
const m3 = new Map(m2);
m3.get("baz"); // 3
```

### WeakMap（类似 Map，只接受对象作为键名（null 除外），WeakMap 的键名所指向的对象，不计入垃圾回收机制）

**Object 和 Map 的比较**

1. 一般地，objects 会被用于将字符串类型映射到数值。Object 允许设置键值对、根据键获取值、删除键、检测某个键是否存在。而 Map 具有更多的优势。
2. Object 的键均为 Strings 类型，在 Map 里键可以是任意类型。
3. 必须手动计算 Object 的尺寸，但是可以很容易地获取使用 Map 的尺寸。
4. Map 的遍历遵循元素的插入顺序。
5. Object 有原型，所以映射中有一些缺省的键。（可以理解为 map = Object.create(null)）。

如果键在运行时才能知道，或者所有的键类型相同，所有的值类型相同，那就使用 Map。
如果需要将原始值存储为键，则使用 Map，因为 Object 将每个键视为字符串，不管它是一个数字值、布尔值还是任何其他原始值。
如果需要对个别元素进行操作，使用 Object。

## Set 集合(类似数组，成员的值都是唯一且无序的)

```javascript
var mySet = new Set();
mySet.add(1);
mySet.add("some text");
mySet.add("foo");

mySet.has(1); // true
mySet.delete("foo");
mySet.size; // 2
mySet.clear(); // 清空集合

for (let item of mySet) console.log(item);
// 1
// "some text"

mySet2 = new Set([1, 2, 2, 4]);
Array.from(mySet2); // [1,2,3] 常用来去重

// argument对象（类数组）转成数组
// Array.from({0:111,1:222,2:333,length:3}) [111,222,333]
```

### WeakSet（类似 Set，成员都是对象，弱引用）

WeakSet 对象中储存的对象值都是被弱引用的，即垃圾回收机制不考虑 WeakSet 对该对象的应用，如果没有其他的变量或属性引用这个对象值，则这个对象将会被垃圾回收掉（不考虑该对象还存在于 WeakSet 中），所以，WeakSet 对象里有多少个成员元素，取决于垃圾回收机制有没有运行，运行前后成员个数可能不一致，遍历结束之后，有的成员可能取不到了（被垃圾回收了），WeakSet 对象是无法被遍历的（ES6 规定 WeakSet 不可遍历），也没有办法拿到它包含的所有元素。

**Array 和 Set 的比较**

1. 数组中用于判断元素是否存在的 indexOf 函数效率低下。
2. Set 对象允许根据值删除元素，而数组中必须使用基于下标的 splice 方法。
3. 数组的 indexOf 方法无法找到 NaN 值。
4. Set 对象存储不重复的值，所以不需要手动处理包含重复值的情况。
5. 数组是特殊的对象,对象是关联数组 字符串是特殊的数组
6. 方括弧取值为动态判定[]，数字非有效的 js 标识符

## setter 和 getter (get set 修饰 function)

```javascript
var o = {
  a: 7,
  get b() {
    return this.a + 1;
  },
  set c(x) {
    this.a = x / 2
  }
};

console.log(o.a); // 7
console.log(o.b); // 8 取b值时调用
o.c = 50;         // 给c设置值调用
console.log(o.a); // 25
-----------------------
var o = {
  a: 7,
  b:function(){
    return this.a + 1;
  }
};

console.log(o.b()); // 8
```

## 访问所有可枚举对象属性

1. for in 无序
2. Object.keys() 不包括原型的属性名数组
3. Object.getOwnPropertyNames()

## Symbol(原始数据类型) 不可枚举的 符号类型

- 应用于对象的属性,Symbol 类型的属性具有一定的隐藏性。

```javascript
var  myPrivateMethod  = Symbol(); // 不能使用new Symbol()创建，它是一个不完整的类属于基本类型
this[myPrivateMethod] = function() {...};
```

for in 和 Object.getOwnPropertyNames()访问不到，只能通过 myPrivateMethod 或者 Object.getOwnPropertySymbols()来访问

```javascript
Symbol("foo") !== Symbol("foo"); // true
const foo = Symbol();
const bar = Symbol();
typeof foo === "symbol"; // true
typeof bar === "symbol"; // true
let obj = {};
obj[foo] = "foo";
obj[bar] = "bar";
JSON.stringify(obj); // {}
Object.keys(obj); // []
Object.getOwnPropertyNames(obj); // []
Object.getOwnPropertySymbols(obj); // [ foo, bar ]

Symbol.for("foo"); // 创建一个 symbol 并放入 symbol 注册表中，键为 "foo"
Symbol.for("foo"); // 从 symbol 注册表中读取键为"foo"的 symbol
Symbol.for("bar") === Symbol.for("bar"); // true，证明了上面说的

// 创建一个 symbol 并放入 Symbol 注册表，key 为 "foo"
var globalSym = Symbol.for("foo");
Symbol.keyFor(globalSym); // "foo"
```

```js
let name = Symbol("name");
let obj = {
  age: 22,
  [name]: "Joh",
};

console.log(Object.keys(obj)); // 打印不出 类型为Symbol的[name]属性

// 使用for-in也打印不出 类型为Symbol的[name]属性
for (var k in obj) {
  console.log(k);
}

// 使用 Object.getOwnPropertyNames 同样打印不出 类型为Symbol的[name]属性
console.log(Object.getOwnPropertyNames(obj));

// 使用 Object.getOwnPropertySymbols 可以
var key = Object.getOwnPropertySymbols(obj)[0];
console.log(obj[key]); // Joh
```

- 使用 Symbol.iterator 迭代器来逐个返回数组的单项

```js
et arr = ['a', 'b', 'c'];
var iterator = arr[Symbol.iterator]();
// next 方法返回done表示是否完成
console.log(iterator.next()); // {value: "a", done: false}
console.log(iterator.next()); // {value: "b", done: false}
console.log(iterator.next()); // {value: "c", done: false}
console.log(iterator.next()); // {value: undefined, done: true}
console.log(iterator.next()); // {value: undefined, done: true}
```

## Proxy 代理

`let p= new Proxy(target,handler)`

- target
  用 Proxy 包装的目标对象（可以是任何类型的对象，包括原生数组，函数，甚至另一个代理）。

- handler
  一个对象，其属性是当执行一个操作时定义代理的行为的函数。

```javascript
// 设置缺省值
let handler = {
  get: function (target, name) {
    return name in target ? target[name] : 37;
  },
};

let p = new Proxy({}, handler);

p.a = 1;
p.b = undefined;

console.log(p.a, p.b); // 1, undefined

console.log("c" in p, p.c); // false, 37

// 转发代理
let target = {};
let p = new Proxy(target, {});

p.a = 37; // 操作转发到目标

console.log(target.a); // 37. 操作已经被正确地转发

// demo
let book = { name: "《ES6基础系列》", price: 56 };
let proxy = new Proxy(book, {
  get: function (target, property) {
    if (property === "name") {
      return "《入门到懵逼》";
    } else {
      return target[property];
    }
  },
  set: function (target, property, value) {
    if (property === "price") {
      target[property] = 56;
    }
  },
});
```

## 生成器 generator

function\* 来修饰 GeneratorFunction 函数

```javascript
function* idMaker() {
  var index = 0;
  while (true) yield index++;
}

var gen = idMaker();

console.log(gen.next().value); // 0
console.log(gen.next().value); // 1
console.log(gen.next().value); // 2
// ...
```

对象实现迭代行为

```javascript
var myIterable = {};
myIterable[Symbol.iterator] = function* () {
    yield 1;
    yield 2;
    yield 3;
};

for (let value of myIterable) {
    console.log(value);
}
// 1
// 2
// 3

or
[...myIterable]; // [1, 2, 3]
```

## 3 行实现 Promise

```javascript
function Promise(fn) {
  this.then = (cb) => (this.cb = cb);
  this.resolve = (data) => this.cb(data);
  fn(this.resolve);
}
// 使用
new Promise((resolve) => {
  setTimeout(() => {
    resolve("延时执行");
  }, 1000);
}).then((data) => {
  console.log(data);
});

function Promise(fn) {
  var value = null,
    callbacks = []; //callbacks为数组，因为可能同时有很多个回调

  this.then = function (onFulfilled) {
    callbacks.push(onFulfilled);
  };

  function resolve(value) {
    callbacks.forEach(function (callback) {
      callback(value);
    });
  }

  fn(resolve);
}
```

- 简单版

```js
function myPromise(constructor) {
  let self = this;
  self.status = "pending";
  // resolved时候的值
  self.value = undefined;
  // rejected时候的值
  self.reason = undefined;
  // 存放成功回调的数组
  self.onResolveCallbacks = [];
  // 存放失败回调的数组
  self.onRejectedCallbacks = [];
  function resolve(value) {
    if (self.status === "pending") {
      self.value = value;
      self.status = "resolved";
      self.onResolveCallbacks.forEach((cb) => cb(self.value));
    }
  }
  function reject(reason) {
    if (self.status === "pending") {
      self.reason = reason;
      self.status = "rejected";
      self.onRejectedCallbacks.forEach((cb) => cb(self.value));
    }
  }
  // 捕获构造异常
  try {
    constructor(resolve, reject);
  } catch (e) {
    reject(e);
  }
}

myPromise.prototype.then = function (onFulfilled, onRejected) {
  // let self = this;
  // switch(self.status) {
  //     case "resolved":
  //         resolved(self.value);
  //         break;
  //     case "rejected":
  //         rejected(self.reason);
  //         break;
  //     default:

  // 如果成功和失败的回调没有传，表示这个then没有任何逻辑，只负责把值往后抛
  onFulfilled =
    typeof onFulfilled == "function" ? onFulfilled : (value) => value;
  onRejected =
    typeof onRejected == "function"
      ? onRejected
      : (reason) => {
          throw reason;
        };
  let self = this;
  let promise2;
  // 实现链式调用，每一种状态都要返回的是一个promise实例
  if (self.status == "resolved") {
    // 如果promise状态已经是成功态，onFulfilled直接取值
    return (promise2 = new Promise(function (resolve, reject) {
      setTimeout(function () {
        // 保证返回的promise是异步
        try {
          onFulfilled(self.value);
        } catch (e) {
          //  如果执行成功的回调过程中出错，用错误原因把promise2 reject
          reject(e);
        }
      });
    }));
  }
  if (self.status == "rejected") {
    return (promise2 = new Promise(function (resolve, reject) {
      setTimeout(function () {
        try {
          onRejected(self.reason);
        } catch (e) {
          reject(e);
        }
      });
    }));
  }
  if (self.status === "pending") {
    return (promise2 = new Promise(function (resolve, reject) {
      // pending 状态时就会把所有的回调函数都添加到实例中的两个堆栈中暂存，等状态改变后依次执行，其实这个过程就是观察者模式
      self.onResolveCallbacks.push(function () {
        setTimeout(function () {
          try {
            onFulfilled(self.value);
          } catch (e) {
            reject(e);
          }
        });
      });
      self.onRejectCallbacks.push(function () {
        setTimeout(function () {
          try {
            onRejected(self.reason);
          } catch (e) {
            reject(e);
          }
        });
      });
    }));
  }
};
```

## 现一个函数，将一个字符串中的空格替换成“%20”

```javascript
function convertSpace2percent20(str) {
  return str.replace(/\s+?/g, "%20"); //开启非贪婪模式
}

convertSpace2percent20("hellow world");
// "hellow%20world"
```

## var obj = { 1: "Hello", 2: "World" }打印 Hello World

```javascript
var obj = {
  1: "Hello",
  2: "World",
};

var str = "";

// 方法1
for (var i = 1; i < 3; i++) {
  str += obj[i] + " "; //注意不能使用obj.i
}

// 方法2
for (var key of Object.keys(obj)) {
  str += obj[key] + " ";
}

// 方法3
for (let i in obj) {
  str += obj[i] + " ";
}

// 方法4
Object.values(obj).join(" ");
```

## 循环

- while - 只要指定的条件成立，则循环执行代码块
- do...while - 首先执行一次代码块，然后在指定的条件成立时重复这个循环
- for - 循环执行代码块指定的次数
- foreach - 根据数组中每个元素来循环代码块

### forEach 等函数的第二个参数的用法

forEach 函数用得平时用得比较多，但是从来没想到 forEach 函数还有第二个参数。

简单点来说，就是我们可以直接使用第二个参数来指定函数里的 this 的值，而不需要使用箭头函数或者在外面定义 var that = this;等操作。

```javascript
var obj = {
  name: "小明",
  say: function () {
    console.log(this.name); // "小明"
  },
  think: function () {
    var arr = [1];
    arr.forEach(function (item) {
      console.log(this); // window
    });
    console.log("---------");
    arr.forEach(function (item) {
      console.log(this); // obj
    }, this);
  },
};

obj.say();
obj.think();

[3, 2, 4, 1].sort((a, b) => {
  return a > b ? 1 : -1; // return a-b
});
```

## 数组扁平化(将多维数组展开为一维数组)

```javascript
//  es6 递归+判断是不是数组 也可以使用reduce进行遍历
const flattenES6 = (arr) => {
  let result = [];
  arr.forEach((item, i, arr) => {
    if (Array.isArray(item)) {
      result = result.concat(flattenES6(item));
    } else {
      result.push(arr[i]);
    }
  });
  return result;
};
console.log(flattenES6([1, [2, [3, [4]], 5]]));

// some+concat
Array.prototype.flat02 = function () {
  let arr = this;
  while (arr.some((item) => Array.isArray(item))) {
    arr = [].concat(...arr);
  }
  return arr;
};

// toString方法
const flattenES6 = (arr) =>
  arr
    .toString()
    .split(",")
    .map((item) => +item);
console.log(flattenES6([1, [2, [3, [4]], 5]]));

// ...
var entries = [1, [2, 5], [6, 7], 9];
var flat_entries = [].concat(...entries);

// flat方法 返回新数组，不会改变原数组
[1, 2, [3, 4]]
  .flat()
  [
    // [1, 2, 3, 4] 默认拉平一层

    (1, 2, [3, [4, 5]])
  ].flat(2)
  [
    // [1, 2, 3, 4, 5] 拉平两层的嵌套数组

    (1, [2, [3]])
  ].flat(Infinity)
  [
    // Infinity无论多少层都拉平

    // flatMap()方法对原数组的每个成员执行一个函数，相当于执行Array.prototype.map(),然后对返回值组成的数组执行flat()方法。该方法返回一个新数组，不改变原数组
    // 相当于 [[2, 4], [3, 6], [4, 8]].flat() flatMap()只能展开一层数组
    (2, 3, 4)
  ].flatMap((x) => [x, x * 2]);
// [2, 4, 3, 6, 4, 8]
```

## 自定义错误类型

```javascript
// ES6
class CustomError extends Error {
  constructor(message) {
    super(message);
    this.name = "CustomError";
  }
}

// ES5
function CustomError(message) {
  this.name = "CustomError";
  this.message = message;
  Error.captureStackTrace(this, CustomError);
}

CustomError.prototype = new Error();
CustomError.prototype.constructor = CustomError;

// img标签来埋点处理错误日志
function logError(msg) {
  const img = new Image();
  img.src = `/log?${encodeURIComponent(msg)}`;
}
```

## 命令式编程和声明式编程

- 纯粹性：纯函数不改变除当前作用域以外的值;
- 数据不可变性: Immutable

```javascript
// 反面示例
let a = 0;
const add = (b) => (a = a + b); // 两次 add(1) 结果不一致

// 正确示例
const add = (a, b) => a + b;
```

- 函数柯里化 将多个入参的函数转化成 1 个入参的函数

```javascript
const add = (a) => (b) => (c) => a + b + c;
add(1)(2)(3);
```

问题：sum(2, 3)实现 sum(2)(3)的效果

```js
// 闭包
function sub_curry(fn) {
  let args = [].slice.call(arguments, 1);
  return function () {
    return fn.apply(this, args.concat([].slice.call(arguments)));
  };
}

function curry(fn, length) {
  // 初始化时赋值为fn的形参个数，用以标示剩余需要传入参数的个数
  length = length || fn.length;

  const slice = Array.prototype.slice;

  return function () {
    if (arguments.length < length) {
      const combined = [fn].concat(slice.call(arguments));
      // length - arguments.length用以计数当前已传入的参数
      return curry(sub_curry.apply(this, combined), length - arguments.length);
    } else {
      return fn.apply(this, arguments);
    }
  };
}

function add(a, b) {
  return a + b;
}
var sum = curry(add);
```

- 偏函数 将多个入参的函数转化成两部分(返回一个包含预处理参数的新函数)

```javascript
const add = (a) => (b, c) => a + b + c;
add(1)(2, 3);
```

- 组合函数

```javascript
const add = (x) => x + x;
const mult = (x) => x * x;

const addAndMult = (x) => add(mult(x));
```

## 实现 bind 函数

```javascript
// 第一种: 借助 call/apply
Function.prototype.bind1 = function (context) {
  const self = this;
  return function () {
    return self.call(context);
  };
};

// 测试:
const obj = {
  value: "cosyer",
};
function testBind() {
  console.log(this.value);
}
const resultBind = testBind.bind1(obj);
resultBind(); // cosyer

// 第二种: 借助 arguments
Function.prototype.bind2 = function (context) {
  const arr = Array.prototype.slice.call(arguments, 1);
  const self = this;
  return function () {
    const restArr = Array.prototype.slice.call(arguments);
    return self.apply(context, arr.concat(restArr));
  };
};

// 考虑到原型链 因为在new 一个bind过生成的新函数的时候，必须的条件是要继承原函数的原型
Function.prototype.bind2New = function (context) {
  var arr = Array.prototype.slice.call(arguments, 1);
  var self = this;
  var bound = function () {
    restArr = restArr.concat(Array.prototype.slice.call(arguments));
    return self.apply(context, restArr);
  };
  var F = function () {};
  // 这里需要一个寄生组合继承
  F.prototype = context.prototype;
  bound.prototype = new F();
  // bound.prototype = Object.create(context.prototype);
  return bound;
};
// 这种方式的实现其实是函数柯里化的变版

// 比如在监听事件时可以这样子用:

dom.addEventListener("click", fn.bind(this));
// 进行如下测试:

const obj2 = {
  value: "cosyer",
};
function testBind2(age, gender) {
  console.log(this.value); // cosyer
  console.log(age); // 23
  console.log(gender); // male
}
const resultBind2 = testBind2.bind2(obj2, 23);
resultBind2("male");

// 第三种: 区分环境, 是普通调用还是 new 调用
Function.prototype.bind3 = function (context) {
  const arr = Array.prototype.slice.call(arguments, 1);
  const self = this;
  return function () {
    const restArr = Array.prototype.slice.call(arguments);
    return self.apply(this !== windows ? this : context, arr.concat(restArr));
  };
};

// 测试: 使用 new 以后 this 会指向 newObj
const obj3 = {
  value: "cosyer",
};
function testBind3(age, gender) {
  console.log(this.value);
  console.log(age);
  console.log(gender);
}
const resultBind3 = testBind3.bind3(obj3, 23, "male");
const newObj = new resultBind3();
```

## call 函数的实现

```javascript
// 对象属性指向函数并调用
// 将函数引用到对象里
// 调用函数
// 删除对象里的函数
Function.prototype.call1 = function (context, ...args) {
  let key = Symbol("KEY");
  // 把函数当成对象的某个成员,(成员名唯一:防止修改原始对象的结构值)
  context[key] = this;
  let result = context[key](...args); // ...args
  delete context[key];
  return result;
};

const obj = {
  value: "cosyer",
};

function testCall() {
  console.log(this.value);
}

const resultCall = testCall.call1(obj); // cosyer

// 传入函数的实现
Function.prototype.call2 = function (context) {
  const arr = Array.prototype.slice.call(arguments, 1);

  context.fn = this; // this 指向实例
  context.fn(...arr);
  delete context.fn;
};

// 测试:
const obj2 = {
  value: "cosyer",
};

function testCall2(age) {
  console.log(this.value, age); // cosyer 23
}

const resultCall = testCall2.call2(obj2, 23);
```

## 稀疏数组

```javascript
var ary = [0, 1, 2];
ary[10] = 10;
ary.filter(function (x) {
  return x === undefined;
}); // []
// 3 - 9 都是没有初始化的'坑'!, 这些索引并不存在与数组中. 在 array 的函数调用的// 时候是会跳过这些'坑'的.
```

## switch 严格比较

```javascript
function showCase(value) {
  switch (value) {
    case "A":
      console.log("Case A");
      break;
    case "B":
      console.log("Case B");
      break;
    case undefined:
      console.log("undefined");
      break;
    default:
      console.log("Do not know!");
  }
}
showCase(new String("A")); // 'Do not know!'
// switch 是严格比较, String 实例和 字符串不一样.

function showCase2(value) {
  switch (value) {
    case "A":
      console.log("Case A");
      break;
    case "B":
      console.log("Case B");
      break;
    case undefined:
      console.log("undefined");
      break;
    default:
      console.log("Do not know!");
  }
}
showCase2(String("A")); // 'Case A'
// String 不仅是个构造函数 直接调用返回一个字符串哦.
```

## 为什么 JS 是单线程的

> 与用途有关，JavaScript 的主要用途是与用户互动，以及操作 DOM
> 假定 JavaScript 同时有两个线程，一个线程在某个 DOM 节点上添加内容，另一个线程删除了这个节点，这时浏览器应该以哪个线程为准？

为了利用多核 CPU 的计算能力，HTML5 提出 Web Worker 标准，允许 JavaScript 脚本创建多个线程，但是子线程完全受主线程控制，且不得操作 DOM。所以，这个新标准并没有改变 JavaScript 单线程的本质。

## 去重总集篇

1. Set

```javascript
[...new Set([1, 1, 2, 3])];
Array.from(new Set([1, 1, 2, 3]));
```

2. filter

```javascript
[1, 1, 2, 3].filter((element, index, array) => {
  return array.indexOf(element) === index;
});
```

3. Map

```javascript
var set = new Set()[(1, 1, 2, 3)].filter((item) => {
  return !set.has(item) && set.add(item);
});
// 一个道理
var map = new Map();
[1, 1, 2, 3].filter((item, index) => {
  return !map.has(item) && map.set(item, index);
});
```

4. 基础

```js
// 不使用es6,考虑到（ie6-8）indexOf兼容性问题
// 对象容器
function unique(arr) {
  var ret = [];
  var hash = {};

  for (var i = 0; i < arr.length; i++) {
    var item = arr[i];
    // typeof 区分 1 与 ‘1’
    var key = typeof item + item;
    if (hash[key] !== 1) {
      ret.push(item);
      hash[key] = 1;
    }
  }
  return ret;
}

// 数组
function unique(arr) {
  const temp = [];
  arr.forEach((item) => {
    if (temp.indexOf(item) === -1) {
      temp.push(item);
    }
  });
  return temp;
}
```

5. reduce

```js
function unique(arr) {
  return arr.reduce((pre, cur) => {
    !pre.includes(cur) && pre.push(cur);
    return pre;
  }, []);
}
```

## 2 对象

```javascript
(2).toString(); // '2'
(2).toString()[(1, 2, 3)]; // '2' // [3]
```

## 递归运用斐波那契数列 js 实现

```js
function* fibo() {
  let [pre, curr] = [0, 1];
  for (;;) {
    yield curr;
    [pre, curr] = [curr, pre + curr];
  }
}
for (let i of fibo()) {
  if (i > 10000) {
    break;
  }
  console.log(i);
}
// 实现10000以内的数列
```

爬楼梯问题
初始在第一级，到第一级有 1 种方法(s(1) = 1)，到第二级也只有一种方法(s(2) = 1)， 第三级(s(3) = s(1) + s(2))

```js
function cStairs(n) {
  if (n === 1 || n === 2) {
    return 1;
  } else {
    return cStairs(n - 1) + cStairs(n - 2);
  }
}
```

## arguments 对象的 length 属性显示实参的个数，函数的 length 属性显示形参的个数。

## 在不改变原数组的前提下，添加或删除某个元素

- concat

```js
let arr = [1, 2, 3, 4];
let newArr = [].concat(0, arr);
```

- 扩展运算符

```js
let arr = [1, 2, 3, 4];
let newArr = [0, ...arr];
```

- reduce

```js
let arr = [1, 2, 3, 4],
  newArr = arr.reduce(
    (acc, cur) => {
      acc.push(cur);
      return acc;
    },
    [0]
  );
```

- slice

```js
let arr = [1, 2, 3, 4],
  newArr = arr.slice(0, -1);
```

### 总结·归纳

- 不修改原数组
- slice
- concat
- forEach
- map
- every
- some
- filter
- reduce
- reduceRight
- keys
- values
- entries
- includes
- find
- findIndex
- flat
- flatMap

- 修改原数组
- splice
- pop
- push
- shift
- unshift
- sort
- reverse
- fill
- copyWithin

## polyfill(腻子)

polyfill 是“在旧版浏览器上复制标准 API 的 JavaScript 补充”,可以动态地加载 JavaScript 代码或库，在不支持这些标准 API 的浏览器中模拟它们。

- 常用的方案
  > html5shiv、Geolocation、Placeholder
