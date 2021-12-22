---
title: js函数柯里化
tags:
  - 整理
copyright: true
comments: true
date: 2018-11-22 09:25:48
categories: 知识
photos:
top: 121
---

### 函数柯里化定义

函数柯里化（function currying）又称部分求值。一个 currying 的函数首先会接受一些参数，接受了这些参数后，

该函数并不会立即求值，而是继续返回另外一个函数，刚才传入的参数在函数形成的闭包里被保存起来。待到函数真正需要求值的时候，之前传入的参数都会被一次性用于求值。

把接受多个参数的函数变换成接受一个单一参数（最初函数的第一个参数）的函数，并且返回接受余下的参数而且返回结果的新函数。

顾名思义，柯里化其实本身是固定一个可以预期的参数，并返回一个特定的函数，处理批特定的需求。这增加了函数的适用性，但同时也降低了函数的适用范围。

```javascript
function add(x, y) {
  return x + y;
}
// 函数只传入一个参数的时候实现加法
function curry(x) {
  return function (y) {
    return x + y;
  };
}
var add2 = curry(1);
add2(1); // 2 即curry(1)(1)
```

---

<!-- more -->

### 函数柯里化实践

```javascript
// 通过以上简单介绍我们大概了解了，函数柯里化基本是在做这么一件事情：只传递给函数一部分参数来调用它，让它返回一个函数去处理剩下的参数。用公式表示就是我们要做的事情其实是

fn(a,b,c,d)=>fn(a)(b)(c)(d)；

fn(a,b,c,d)=>fn(a，b)(c)(d)；

fn(a,b,c,d)=>fn(a)(b，c，d)；

......

// 再或者这样：

fn(a,b,c,d)=>fn(a)(b)(c)(d)()；

fn(a,b,c,d)=>fn(a)；fn(b)；fn(c)；fn(d)；fn()；
```

> 通用的函数柯里化版本

```javascript
// 这里需要传入长度
function curry(fn, length, ary) {
  length = length || fn.length;
  ary = ary || []; //记录所有传入的参数
  var slice = Array.prototype.slice;
  return function () {
    if (arguments.length < length) {
      Array.prototype.push.apply(ary, slice.call(arguments)); //每次把参数合并到ary数组中
      return curry(fn, length - arguments.length, ary); //把还需传参的长度和已有参数数组传入curry，递归调用
    } else {
      return fn.apply(this, ary.concat(slice.call(arguments))); //调用求职函数，记得把此次传入的参数合并到ary数组再计算
    }
  };
}

let total = function () {
  let total = 0;
  [].slice.call(arguments).forEach((item) => {
    total += item;
  });
  return total;
};
let fn = curry(total, 4);
fn(1)(2)(3)(4); //10
fn(1, 2)(3)(4); //10
```

```javascript
// 这里是无参数时开始计算所有的cost
var currying = function (fn) {
  var args = [];

  return function () {
    if (arguments.length === 0) {
      return fn.apply(this, args);
    } else {
      [].push.apply(args, arguments);
      return arguments.callee;
    }
  };
};
var cost = (function () {
  var money = 0;

  return function () {
    for (var i = 0, l = arguments.length; i < l; i++) {
      money += arguments[i];
    }
    return money;
  };
})();

var cost = currying(cost); //转化为currying函数

cost(100); //未真正求值
cost(200); //未真正求值
cost(300); //未真正求值

console.log(cost()); //求值并输出：600
```

```javascript
// 和toString().valueOf()时计算和是一样的道理
function add(num) {
  var _add = function (args) {
    num += args;
    return arguments.callee;
  };
  // (function foo(args){num+=args return foo;})
  var _add = function foo(args) {
    num += args;
    return foo;
  };
  _add.toString = _add.valueOf = function () {
    return num;
  };
  return _add;
}
```

### 为了减少函数传参，同时将一些固定参数私有化

```javascript
function curry(fn, args) {
  // 获取函数需要的参数长度
  let length = fn.length;

  args = args || [];

  return function () {
    let subArgs = args.slice(0);

    // 拼接得到现有的所有参数
    for (let i = 0; i < arguments.length; i++) {
      subArgs.push(arguments[i]);
    }

    // 判断参数的长度是否已经满足函数所需参数的长度
    if (subArgs.length >= length) {
      // 如果满足，执行函数
      return fn.apply(this, subArgs);
    } else {
      // 如果不满足，递归返回科里化的函数，等待参数的传入
      return curry.call(this, fn, subArgs);
    }
  };
}
```

```js
// es6实现
function curry(fn, ...args) {
  return fn.length <= args.length ? fn(...args) : curry.bind(null, fn, ...args);
}
```

### 函数柯里化的优点

1. 延迟计算
   可以传递需要的参数，等到何时想要结果，再一并计算。

2. 参数复用
   有些参数相同，只需要传递一遍即可，不需要每次都传，太繁琐。
