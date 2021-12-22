---
title: es6函数新特性
tags:
  - es6
copyright: true
comments: true
date: 2018-06-08 19:35:58
categories: JS
photos:
---

1. 设置函数默认值
2. 结合解构赋值默认值使用
3. 利用 rest(...变量名)传入任意参数

---

<!-- more -->

## ...rest 和扩展运算符

rest 参数（…变量名），用于获取函数的多余参数，rest 参数搭配的变量是一个数组，该变量将多余的参数放入其中。

```javascript
function foo(...y) {
  console.log(y); // [1,2,3,4]
}
foo(1, 2, 3, 4);
```

## 利用扩展运算符（…数组）替代数组的 apply 方法

在 es5 中，需要用 apply 将数组转化为函数参数，在 es6 中就不需要这种方式了，可以使用…来代替

```javascript
function f(x, y, z) {
  console.log(x + " " + y + " " + z);
}
var args = [1, 2, 3];
// f.apply(null, args)
f(...args);
```

数组 push 的例子：

```javascript
var arr1 = [0, 1, 2];
var arr2 = [3, 4, 5];
var arr3 = arr1.concat(arr2);
console.log(arr3); //[ 0, 1, 2, 3, 4, 5 ]

var arr4 = arr1.push(arr2);
console.log(arr1); //[ 0, 1, 2, [ 3, 4, 5 ] ]
```

如果想使用 arr1.push 方法的话，就需要用 apply 传 arr2 了

```javascript
var arr4 = Array.prototype.push.apply(arr1, arr2); //[ 0, 1, 2, 3, 4, 5 ]
```

如果使用扩展运算符的话，就简单一些了

```javascript
var arr4 = arr1.push(...arr2);
```

## name 属性

函数的 name 属性可以返回函数名

```javasctrpt
function abc(){
    console.log(abc.name)
}
abc() // 'abc'
```

## 函数的静态变量和函数

```javascript
function Box() {}

Box.num = 12; //静态变量
Box.fn = function () {}; //静态函数

console.log(Box.num); //12
console.log(Box.fn); //function(){}
console.log(typeof Box.fn); //function

var t = new Box();
console.log(t.num); //undefined
console.log(t.fn); //undefined
console.log(typeof t.fn); //undefined
```

静态变量和静态函数是 Box 对象的属性和方法，不属于实例。

## 函数的实例函数和变量

```javascript
function Box() {
  this.a = []; //实例变量
  this.fn = function () {}; //实例方法
}

console.log(Box.a); //undefined
console.log(Box.fn); //undefined
console.log(typeof Box.fn); //undefined

var t = new Box();
var t2 = new Box();

console.log(t.a); //[]
console.log(t2.a); //[]
t.a.push(1); // t.a [1]
console.log(t2.a); //[]

console.log(typeof t.fn);
```

每个实例都有一套实例属性和实例方法，互不影响。

原型上的属性和方法，是实例共用的。

## 函数传参

### 基本类型 (基本类型的变量复制)

```javascript
var count = 10;
function num(num1) {
  num1 = 1;
  return num1;
}
var result = num(count);
console.log(result); //1
console.log(count); //10，并未变成1
```

### 引用类型

```javascript
var person = {
  name: "Tom",
};
function obj(peo) {
  peo.name = "Jerry";
  return peo;
}
var result = obj(person);
console.log(result.name); // Jerry
console.log(person.name); // Jerry
```

```javascript
var person = {
  name: "Tom",
};
function obj(peo) {
  peo = {
    name: "Jerry",
  };
  return peo;
}
var result = obj(person);
console.log(result.name); // Jerry
console.log(person.name); // Tom
```

person 传递给函数中的 peo，但在函数内部 peo 又指向了一个新对象，所以 result.name 是新对象的值，person 还是指向原对象，所以并没有改变。

ECMAScript 中所有函数的参数都是按值传递的。 ——《JS 高程》

我们可以把 ECMAScript 函数的参数想象成局部变量，在向参数传递基本类型的值时，被传递的值被复制给一个局部变量。

在向函数传递引用类型时，会把这个值在内存中的地址复制给一个局部变量，因此这个局部变量的变化会反映在函数的外部。

即使在函数内部修改了参数的值，但原始的引用仍然保持未变。

## 尾调用优化

### 介绍

尾调用指某个函数的最后一步是调用另一个函数。

### demo

```javascript
function f(x) {
  let y = g(x);
  return y;
} //不是尾调用，因为最后一步返回了y，不是调用函数

function f(x) {
  return g(x) + 1;
} //不是尾调用，因为最后一步是加一，不是调用函数

function f(x) {
  g(x);
} //不是尾调用，因为函数的最后一步是一个默认的return undefined；

function f(x) {
  return g(x);
} //是尾调用
```

### 为什么尾调用

函数调用会在内存形成一个“调用记录”，又称“调用帧”。每形成一个调用帧就会占用一定的内存，假如有一个函数 A 里面调用了函数 B，函数 B 里面又调用了函数 C，以此类推。

在不是尾调用的情况下，因为 js 是单线程同步的，所以只有当函数 B 执行完毕才会执行函数 A 的 return 语句（函数没写 return 会有一个默认的 return undefiend；），此时函数 B 的调用帧才会消失。但事实上，只有当函数 B 执行到 return 语句时才会执行完毕，而在函数 B 执行 return 之前会先调用函数 C，所以当这种函数调用越来越多的时候，形成的调用帧也会越来越多占用的内存就会越来越大。俗话说精满自溢，内存也会有溢出的时候是吧，这就不行了！所以要用尾调用！

尾调用由于是函数的最后一步操作，所以不需要保留外层函数的调用帧，只要直接用内层函数的调用帧，取代外层函数的调用帧就可以了。

比如在执行递归的时候就可以利用尾调用达到优化内存的目的。函数调用自身，称为递归。如果尾调用自身，就称为尾递归。

递归非常耗费内存，因为需要同时保存成千上百个调用帧，很容易发生“栈溢出”。但对于尾递归来说，由于只存在一个调用帧，所以永远不会发生“栈溢出”错误。

```javascript
// 递归 计算n的阶乘，最多需要保存n个调用记录，复杂度 O(n)
function factorial(n) {
  if (n === 1) return 1;
  return n * factorial(n - 1);
}
factorial(5); //120

// 改成尾递归，只保留一个调用记录，复杂度 O(1)
function factorial(n, total) {
  if (n === 1) return total;
  return factorial(n - 1, n * total);
}
factorial(5, 1); //120
```

## 函数声明覆盖

```javascript
function foo() {
  console.log("foo");
}

var foo = 1;
// 1 如果foo不赋值 则打印函数
```
