---
title: 深入理解instanceof
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-03-08 21:55:30
categories: JS
photos:
top: 160
---

在 JS 中，大家通常用`typeof`来判断基本类型，`instanceof`来判断引用类型。

## typeof

> typeof 一般只能返回如下几个结果：number,boolean,string,function,object,undefined 字符串

> 对于 Array,null 等特殊对象使用 typeof 一律返回 object，而函数返回 function 这正是 typeof 的局限性。

> 在判断除 Object 类型的对象(基本类型)时比较方便。

## instanceof

> object instanceof constructor

> instanceof 运算符用来测试一个对象在其原型链中是否存在一个构造函数的 prototype 属性。

> 换种说法就是左侧的对象是否是右侧对象的实例。

## 相关练习

```javascript
"123" instanceof String; // true
let str = new String("123");
str instanceof String; // true
```

---

<!--more-->

```javascript
// 都是Object的实例 true
console.log({} instanceof Object);
console.log([] instanceof Array);
console.log([] instanceof Object);
console.log(function () {} instanceof Function);
console.log(function () {} instanceof Object);
```

```javascript
function Foo() {}
function BFoo() {}
Foo.prototype = new BFoo();
let foo = new Foo();
console.log(foo instanceof Foo); // true
console.log(foo instanceof BFoo); // true
```

```javascript
console.log(String instanceof String); // flase
console.log(String instanceof Object);
console.log(String instanceof Function);
console.log(Object instanceof Object);
console.log(Function instanceof Function);
console.log(Function instanceof Object);

function Foo() {}
function BFoo() {}
Foo.prototype = new BFoo();
console.log(Foo instanceof Function);
console.log(Foo instanceof Foo);
```

## instanceof 实现

```javascript
function instance_of(L, R) {
  //L 表示左边的object，R 表示右边的constructor
  const R_P = R.prototype; // 取 R 的显式原型
  L = L.__proto__; // 取 L 的隐式原型,并且可能会顺着原型链重新赋值
  while (true) {
    if (L === null) return false;
    if (R_P === L)
      // 这里重点：严格比较 true
      return true;
    L = L.__proto__;
  }
}
```

## 重点解析

![原型链](https://user-images.githubusercontent.com/25027560/37870377-2bc8211a-3007-11e8-92a0-04fa96aabf13.png)

- \_\_proto\_\_ 属性，指向了创建该对象的构造函数的原型

- 所有 JS 对象都有 \_\_proto\_\_ 属性，除了 Object.prototype.\_\_proto\_\_ === null

- 注意 Object(),它是由 function 生成的，所以它的**proto**属性指向了 function 的构造器 Function 的原型 Function.prototype

- 注意构造器 Function,它是唯一一个 prototype 和**proto**指向相同的对象

- 一般来说，我们日常自行创建的构造器 Foo 的**proto**属性指向 function 的构造器 Function 的原型 Function.prototype，但是构造器的原型对象 Foo.prototype 的**proto**属性是直接指向 Object.prototype 对象的
