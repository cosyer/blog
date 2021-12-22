---
title: ES6Reflect对象
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-05-02 02:31:52
categories: JS
top: 201
photos:
---

## 介绍

Reflect 是一个内置的对象，它提供拦截 JavaScript 操作的方法。这些方法与处理器对象的方法相同。Reflect 不是一个函数对象，因此它是不可构造的。

Reflect 这个对象在新版本的 chrome 是支持的， ff 比较早就支持 Proxy 和 Reflect 了，要让 node 支持 Reflect 可以安装[harmony-reflect](https://github.com/tvcutsem/harmony-reflect/);

Reflect 不是构造函数， 要使用的时候直接通过 Reflect.method()调用， Reflect 有的方法和 Proxy 差不多， 而且多数 Reflect 方法原生的 Object 已经重新实现了。

与大多数全局对象不同，Reflect 没有构造函数。你不能将其与一个 new 运算符一起使用，或者将 Reflect 对象作为一个函数来调用。Reflect 的所有属性和方法都是静态的（就像 Math 对象）。

---

<!--more-->

## 为什么使用

- 更加有用的返回值

Reflect 有一些方法和 ES5 中 Object 方法一样样的， 比如： Reflect.getOwnPropertyDescriptor 和 Reflect.defineProperty, 不过, Object.defineProperty(obj, name, desc)执行成功会返回 obj， 以及其它原因导致的错误， Reflect.defineProperty 只会返回 false 或者 true 来表示对象的属性是否设置上了，

```js
try {
  Object.defineProperty(obj, name, desc);
  // property defined successfully
} catch (e) {
  // possible failure (and might accidentally catch the wrong exception)
}
```

可以重构成

```js
if (Reflect.defineProperty(obj, name, desc)) {
  // success
} else {
  // failure
}
```

- 函数操作

```js
name in obj; // Reflect.has(obj, name)
delete obj[name]; // Reflect.deleteProperty(obj, name)
```

- 更加可靠的函数式执行方式： 在 ES 中， 要执行一个函数 f，并给它传一组参数 args， 还要绑定 this 的话， 要这么写：

```js
f.apply(obj, args); // apply有可能被篡改
Function.prototype.apply.call(f, obj, args); // Reflect.apply(f, obj, args)
```

- 可变参数形式的构造函数

```js
var obj = new F(...args);
var obj = Reflect.construct(F, args);
```

- 控制访问器或者读取器的 this

```js
obj.name;
obj["name"];
Reflect.get(obj, name, wrapper);
Reflect.set(obj, name, value, wrapper);
```

访问器中不想使用自己的方法，而是想要重定向 this 到 wrapper：

```js
var  obj = {
    set foo(value){
        return this.bar();
    }
    bar(){
        console.log(1)
    }
}

var wrapper = {
    bar(){
        console.log(2)
    }
}
Reflect.set(obj, "foo", "value", wrapper)
```

- 避免直接访问**proto**

### Reflect.apply

Reflect.apply 其实就是 ES5 中的 Function.prototype.apply() 替身， 执行 Reflect.apply 需要三个参数

第一个参数为： 需要执行的函数；
第二个参数为： 需要执行函数的上下文 this；
第三个参数为： 是一个数组或者伪数组， 会作为执行函数的参数；

### Reflect.construct

Reflect.construct 其实就是实例化构造函数，通过传参形式的实现， 执行的方式不同， 效果其实一样， construct 的第一个参数为构造函数， 第二个参数由参数组成的数组或者伪数组， 第三个参数为一个超类， 新元素会继承这个超类；

```js
var Fn = function (arg) {
  this.args = [arg];
};
console.log(new Fn(1), Reflect.construct(Fn, [1])); // 输出是一样的

var d = Reflect.construct(Date, [2019, 5, 2]);
d instanceof Date; // true
d.getFullYear(); // 2019
```

### Reflect.defineProperty

Reflect.defineProperty 返回的是一个布尔值， 通过直接赋值的方式把属性和属性值添加给对象返回的是一整个对象， 如果添加失败会抛错；

```js
var obj = {};
if (Reflect.defineProperty(obj, "x", { value: 7 })) {
  console.log("added success");
} else {
  console.log("添加失败");
}
```

### Reflect.deleteProperty

Reflect.deleteProperty 和 Reflect.defineProperty 的使用方法差不多， Reflect.deleteProperty 和 delete obj.xx 的操作结果是一样， 区别是使用形式不同：一个是操作符，一个是函数调用；

```js
Reflect.deleteProperty(Object.freeze({ foo: 1 }), "foo"); // false
delete Object.freeze({ foo: 1 }).foo; //输出：false；
```

### Reflect.get

这个方法的有两个必须的参数： 第一个为 obj 目标对象， 第二个为属性名对象， 第三个是可选的，是作为读取器的上下文(this);

```js
var obj = {};
obj.foo = 1;
console.log(obj.foo); //输出：1;
console.log(Reflect.get(obj, "foo")); //输出：1;
```

### Reflect.getOwnPropertyDescritptor

获取属性描述

```js
Reflect.getOwnPropertyDescriptor({ x: "hello" }, "x");
//也可以这样获取：
Object.getOwnPropertyDescriptor({ x: "1" }, "x");
//这两个的区别是一个会包装对象， 一个不会：
Reflect.getOwnPropertyDescriptor("hello", 0); //抛出异常
Object.getOwnPropertyDescriptor("hello", 0); //输出： {value: "h", writable: false, enumerable: true, configurable: false}
```

### Reflect.getPrototypeOf

同 Object.getPrototypeOf

### Reflect.has

同 in

```js
Reflect.has({ x: 0 }, "x"); //输出： true；
```

### Reflect.isExtensible

```js
// 现在这个元素是可以扩展的；
var empty = {};
Reflect.isExtensible(empty); // === true

// 使用preventExtensions方法， 让这个对象无法扩展新属性；
Reflect.preventExtensions(empty);
Reflect.isExtensible(empty); // === false

// 这个对象无法扩展新属性， 可写的属性依然可以改动
var sealed = Object.seal({});
Reflect.isExtensible(sealed); // === false

// 这个对象完全被冻结了
var frozen = Object.freeze({});
Reflect.isExtensible(frozen); // === false
```

### Reflect.ownKeys

返回对象的 keys

```js
console.log(Reflect.ownKeys({ a: 0, b: 1, c: 2, d: 3 })); //输出 ：["a", "b", "c", "d"]
console.log(Reflect.ownKeys([])); // ["length"]
```

reflect.ownKeys 的排序是根据: 先显示数字， 数字根据大小排序，然后是 字符串根据插入的顺序排序， 最后是 symbol 类型的 key 也根据插入插入顺序排序;

### Reflect.set

```js
var obj = {};
Reflect.set(obj, "prop", "value"); // 输出：true
console.log(obj.prop); // 输出："value"

var obj = {};
Reflect.set(obj); // 输出：true
// 相当于 Reflect.set(obj, undefined, undefined);
```

### Reflect.setPrototypeOf

修改对象的\_\_proto\_\_属性

```js
Reflect.setPrototypeOf({}, Object.prototype); // 输出true

// 给该对象数组[[Prototype]] 为null.
Reflect.setPrototypeOf({}, null); // true
// 此时的obj.__proto__为undefined

//把对象冻结以后重新设置[[prototype]]
Reflect.setPrototypeOf(Object.freeze({}), null); // false

// 如果原型链循环依赖的话就会返回false.
var target = {};
var proto = Object.create(target);
Reflect.setPrototypeOf(target, proto); // false
```
