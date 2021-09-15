---
title: js判断数据类型
tags:
  - 整理
copyright: true
comments: true
date: 2018-10-31 14:28:15
categories: 知识
photos:
top: 115
---

## typeof
> typeof一般只能返回如下几个结果：number,boolean,string,function,object,undefined字符串

> 对于Array,null等特殊对象使用typeof一律返回object，这正是typeof的局限性。

> typeof表示是对某个变量类型的检测，基本数据类型除了null都能正常的显示为对应的类型，引用类型除了函数会显示为'function'，其它都显示为object。

```javascript
var fn = new Function ('a', 'b', 'return a + b')

typeof fn // function
```

## instanceof 
> instanceof适用于检测对象，它是基于原型链运作的。

> instanceof 运算符用来测试一个对象在其原型链中是否存在一个构造函数的 prototype 属性。换种说法就是如果左侧的对象是右侧对象的实例， 则表达式返回true, 否则返回false 。

> instanceof对基本数据类型检测不起作用，因为基本数据类型没有原型链。可以准确的判断复杂数据类型。

```javascript
[1, 2, 3] instanceof Array // true 
/abc/ instanceof RegExp // true 
({}) instanceof Object // true 
(function(){}) instanceof Function // true

// 基于constructor 
a.constructor === Array; 
// 基于Object.prototype.isPrototypeOf 
Array.prototype.isPrototypeOf(a); 
// 4.基于getPrototypeOf 
Object.getPrototypeOf(a) === Array.prototype; 
```

## Object.prototype.toString.call

可以检测各种数据类型，推荐使用。

```javascript
Object.prototype.toString.call([]); // => [object Array] 
Object.prototype.toString.call({}); // => [object Object] 
Object.prototype.toString.call(''); // => [object String] 
Object.prototype.toString.call(new Date()); // => [object Date] 
Object.prototype.toString.call(1); // => [object Number] 
Object.prototype.toString.call(function () {}); // => [object Function] 
Object.prototype.toString.call(/test/i); // => [object RegExp] 
Object.prototype.toString.call(true); // => [object Boolean] 
Object.prototype.toString.call(null); // => [object Null] 
Object.prototype.toString.call(); // => [object Undefined]
```

```javascript
let isType = type => obj => {
  return Object.prototype.toString.call( obj ) === '[object ' + type + ']';
}
 
var isString = isType( 'String' ); 
var isArray = isType( 'Array' ); 
var isNumber = isType( 'Number' );

console.log( isArray( [ 1, 2, 3 ] ) ); //true
```

## constructor
constructor也不是保险的，因为constructor属性是可以被修改的，会导致检测出的结果不正确。

```js
console.log([].constructor === Array)   // true
function a() {}
console.log(a.constructor === Function)   // true
console.log(12.constructor === Number)  // true
console.log('22'.constructor === String)  // true
console.log([] .constructor ===  Array)   // true
console.log({a: 1}.constructor ===  Object) // true
console.log(true.constructor === Boolean) // true
console.log(json.constructor === Object) // true
console.log((new Date()).constructor === Date)   // true
console.log(reg.constructor ===  RegExp) //true
console.log(error.constructor === Error) // true
```
