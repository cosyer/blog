---
title: JavaScript 中 this 的详解
date: 2018-06-08 16:58:32
tags:
  - 前端
  - es6
categories: JS
---

## this 的指向

`this` 是 js 中定义的关键字， 它的指向并不是在函数定义的时候确定的，而是在调用的时候确定的。换句话说，函数的调用方式决定了 this 指向。在实际应用中，`this`的指向大致可以分为以下四种情况。

> this的指向在函数定义的时候是确定不了的，只有函数执行的时候才能确定this到底指向谁(取决于函数的调用位置)，实际上this的最终指向的是那个调用它的对象(函数的直接调用者);

---
<!-- more -->
### 作为普通函数调用(直接调用)：函数名()
当函数作为一个普通函数被调用，`this`指向全局对象。在浏览器里，全局对象就是 window。

```javascript
window.name = 'cosyer';
function getName(){
    console.log(this.name);
}
getName();                   // cosyer
```
可以看出，此时`this`指向了全局对象 window。(NodeJS的全部对象是global)
在ECMAScript5的严格模式下，这种情况`this`已经被规定不会指向全局对象了，而是undefined。

```javascript
'use strict';
function fun(){
    console.log(this);
}
fun();                      // undefined
```
### 作为对象的方法调用
当函数作为一个对象里的方法被调用，`this`指向该对象

```javascript
var obj = {
    name : 'cosyer',
    getName : function(){
        console.log(this.name);
    }
}

obj.getName();              // cosyer
```
如果把对象的方法赋值给一个变量，再调用这个变量：

```javascript
var obj = {
    fun1 : function(){
        console.log(this);
    }
}
var fun2 = obj.fun1;
fun2();                     // window
```
此时调用 fun2 方法 输出了 window 对象，说明此时`this`指向了全局对象。给 fun2 赋值，其实是相当于：

```javascript
var fun2 = function(){
    console.log(this);
}
```
可以看出，此时的`this`已经跟 obj 没有任何关系了。这时 fun2 是作为普通函数调用。

### 作为构造函数调用
js中没有类，但是可以从构造器中创建对象，并提供了`new`运算符来进行调用该构造器。构造器的外表跟普通函数一样，大部分的函数都可以当做构造器使用。当构造函数被调用时，`this`指向了该构造函数实例化出来的对象。

```javascript
var Person = function(){
    this.name = 'cosyer';
}
var obj = new Person();
console.log(obj.name);      // cosyer
```
如果构造函数显式的返回一个对象(function或者object)，那么`this`则会指向该对象。

```javascript
var Person = function(){
    this.name = 'cosyer';
    return {
        name : 'chenyu'
    }
}
var obj = new Person();
console.log(obj.name);      // chenyu
```
如果该函数不用`new`调用，当作普通函数执行，那么`this`依然指向全局对象。

### call() 或 apply() 调用 Function.prototype.bind()将当前函数绑定到指定对象绑定返回新函数之后再进行调用(间接调用、显示绑定)
通过调用函数的 call() 或 apply() 方法可动态的改变`this`的指向。

```javascript
var obj1 = {
    name : 'cosyer',
    getName : function(){
        console.log(this.name);
    }
}
var obj2 = {
    name : 'chenyu'
}

obj1.getName();             // cosyer
obj1.getName.call(obj2);    // chenyu
obj1.getName.apply(obj2);   // chenyu
```
**简单的实现bind方法**

```javascript
const obj = {};

function test() {
    console.log(this === obj);
}

// 自定义的函数，模拟 bind() 对 this 的影响
function myBind(func, target) {
    return function() {
        return func.apply(target, arguments); // 第一个参数为函数运行的this指向
    };
}

const testObj = myBind(test, obj);
test();     // false
testObj();  // true
```
从上面的示例可以看到，首先，通过闭包，保持了 target，即绑定的对象；然后在调用函数的时候，对原函数使用了 apply 方法来指定函数的 this。

不过使用 apply 和 call 的时候仍然需要注意，如果目录函数本身是一个绑定了 this 对象的函数，那 apply 和 call 不会像预期那样执行

```javascript
const obj = {};

function test() {
    console.log(this === obj);
}

// 绑定到一个新对象，而不是 obj
const testObj = test.bind({});
test.apply(obj);    // true

// 期望 this 是 obj，即输出 true
// 但是因为 testObj 绑定了不是 obj 的对象，所以会输出 false
testObj.apply(obj); // false
```

## 一道this练习题
```javascript
var length = 10;
function fn() {
    console.log(this.length)
};
var obj = {
    length: 5, 
    method: function (fn) {
        fn();
        arguments[0](); // this被绑定到arguments上，而arguments确实存在一个length属性，并且值为2
        fn.call(obj, 12);
    }
};
obj.method(fn, 1);
// 10 2 5
```

1. 默认绑定
2. 隐式绑定
3. 显示绑定
4. new绑定
> 默认绑定就是什么都匹配不到的情况下，非严格模式this绑定到全局对象window或者global,严格模式绑定到undefined;
> 隐式绑定就是函数作为对象的属性，通过对象属性的方式调用，这个时候this绑定到对象;
> 显示绑定就是通过bind、apply和call调用的方式;
> new绑定就是通过new操作符时将this绑定到当前新创建的对象中

优先级： new>显示>隐式>默认

## 箭头函数 
{% note info %}
箭头函数的引入有两个方面的作用：一是更简短的函数书写，二是对`this`的词法解析。
在箭头函数出现之前，每个新定义的函数都有其自己的`this`值（例如，构造函数的`this`指向了一个新的对象；严格模式下的函数的`this`值为 undefined；如果函数是作为对象的方法被调用的，则其`this`指向了那个调用它的对象）。在面向对象风格的编程中，这会带来很多困扰。
{% endnote %}

### ES6 的箭头函数 ()=>，指向与一般function定义的函数不同，比较容易绕晕，箭头函数`this`的定义：箭头函数中的`this`是在定义函数的时候绑定，而不是在执行函数的时候绑定。本质来说箭头函数没有自己的`this`，它的`this`是派生而来的。箭头函数会捕获其所在上下文的`this`值，作为自己的`this`值，即它会根据外层(函数或者全局)作用域继承 this(直接外层函数)。

箭头函数将this指向其封闭的环境(也称“词法作用域”)。

### 基础语法
```javascript
// 等价于: => { return expression; } 
(param1, param2, …, paramN) => { statements }
(param1, param2, …, paramN) => expression

// 如果只有一个参数，圆括号是可选的:
(singleParam) => { statements }
singleParam => { statements }

// 无参数或者多参数的箭头函数需要使用圆括号或者下划线:
() => { statements } _ => { statements }
```
### 高级语法
```javascript
// 只返回一个对象字面量,没有其他语句时, 应当用圆括号将其包起来:
params => ({foo: bar})

// 支持 Rest parameters 和 default parameters:
(param1, param2, ...rest) => { statements }
(param1 = defaultValue1, param2, …, paramN = defaultValueN) => { statements }

// 支持参数列表中的解构赋值
var f = ([a, b] = [1, 2], c=3 ) => a + b + c;
f(); // 6
```

### 箭头函数不可以使用arguments对象，super或new.target
arguments对象在函数体内不存在，如果要用的话，可以用rest参数代替

### 箭头函数没有原型
```javascript
var Foo = () => {};

console.log(Foo.prototype); // undefined
```
### 箭头函数无法构造函数
```javascript
var Foo = () => {};

var foo = new Foo(); // TypeError: Foo is not a constructor
```
### 箭头函数无法使用yield
yield 关键字通常不能在箭头函数中使用（除非是嵌套在允许使用的函数内）。因此，箭头函数不能用作生成器。

### 箭头函数或者组件上绑定事件的时候this.xxx.bind(this)，这样会生成新函数，推荐constructor里bind() garbage collection(垃圾回收机制)，除非使用purecomponent只进行浅比较。
