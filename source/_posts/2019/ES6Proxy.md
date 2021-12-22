---
title: ES6Proxy
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-07-31 01:25:34
categories: JS
top: 230
photos:
---

Proxy，代理，是 ES6 新增的功能，可以理解为代理器（即由它代理某些操作）。

Proxy 对象用于定义或修改某些操作的自定义行为，可以在外界对目标对象进行访问前，对外界的访问进行改写。

Proxy 用于修改某些操作的默认行为，等同于在语言层面做出修改，所以属于一种“元编程”，即对编程语言进行编程。

---

<!--more-->

### 1. Proxy 定义

```js
var proxy = new Proxy(target, handler);
```

`new Proxy()`表示生成一个 Proxy 实例

- target：目标对象
- handler：一个对象，其属性是当执行一个操作时定义代理的行为的函数。

**注意：要实现拦截操作，必须是对 Proxy 实例进行操作，而不是针对目标对象 target 进行操作。**

首先，看个例子：

```js
let handler = {
  get: function (target, key, receiver) {
    console.log(`getter ${key}!`);
    return Reflect.get(target, key, receiver);
  },
  set: function (target, key, value, receiver) {
    console.log(`setter ${key}=${value}`);
    return Reflect.set(target, key, value, receiver);
  },
};
var obj = new Proxy({}, handler);
obj.a = 1; // setter a=1
obj.b = undefined; // setter b=undefined

console.log(obj.a, obj.b);
// getter a!
// getter b!
// 1 undefined

console.log("c" in obj, obj.c);
// getter c!
// false undefined
```

在这个例子中，proxy 拦截了 get 和 set 操作。

再看一个例子：

```js
let handler = {
  get: function (target, key, receiver) {
    return 1;
  },
  set: function (target, key, value, receiver) {
    console.log(`setting ${key}!`);
    return Reflect.set(target, key, value, receiver);
  },
};
var obj = new Proxy({}, handler);
obj.a = 5; // setting a!
console.log(obj.a); // 1
```

则由上面代码看出：**Proxy 不仅是拦截了行为，更是用自己定义的行为覆盖了组件的原始行为**。

**若`handler = {}`，则代表 Proxy 没有做任何拦截，访问 Proxy 实例就相当于访问 target 目标对象。**这里不再演示，有兴趣的可以自己举例尝试。

### 2. Proxy handler 方法（拦截方法）

- `get(target, key, receiver)`：拦截 target 属性的读取
- `set(target, key, value, receiver)`：拦截 target 属性的设置
- `has(target, key)`：拦截 `key in proxy` 的操作，并返回是否存在（boolean 值）
- `deleteProperty(target, key)`：拦截 `delete proxy[key]`的操作，并返回结果（boolean 值）
- `ownKeys(target)`：拦截`Object.getOwnPropertyName(proxy)`、`Object.getOwnPropertySymbols(proxy)`、`Object.keys(proxy)`、`for ... in`循环。并返回目标对象所有自身属性的属性名数组。注意：**`Object.keys()`的返回结果数组中只包含目标对象自身的可遍历属性**
- `getOwnPropertyDescriptor(target, key)`：拦截 `Object.getOwnPropertyDescriptor(proxy, key)`，返回属性的描述对象
- `defineProperty(target, key, desc)`：拦截`Object.defineProperty(proxy, key, desc)`、`Object.defineProperties(proxy, descs)`，返回一个 boolean 值
- `preventExtensions(target)`：拦截`Object.preventExtensions(proxy)`，返回一个 boolean 值
- `getPrototypeOf(target)`：拦截`Object.getPrototypeOf(proxy)`，返回一个对象
- `isExtensible(target)`：拦截`Object.isExtensible(proxy)`，返回一个 boolean 值
- `setPrototypeOf(target, key)`：拦截`Object.setPrototypeOf(proxy, key)`，返回一个 boolean 值。如果目标对象是函数，则还有两种额外操作可以被拦截
- `apply(target, object, args)`：拦截 Proxy 实例作为函数调用的操作，比如`proxy(...args)`、`proxy.call(object, ...args)`、`proxy.apply(...)`
- `construct(target, args)`：拦截 Proxy 实例作为构造函数调用的操作，比如`new proxy(...args)`

总共 13 个拦截方法，下面进行简要举例说明，更多可见阮一峰老师的 [《ECMAScript 6 入门》](https://link.juejin.im/?target=http%3A%2F%2Fes6.ruanyifeng.com%2F%23docs%2Fproxy)

#### 1. get，set

`get`方法用于拦截某个属性的读取操作，可以接受三个参数，依次为目标对象、属性名和 proxy 实例本身（严格地说，是操作行为所针对的对象），其中最后一个参数可选。

`set`拦截 target 属性的设置，可以接受四个参数，依次为目标对象、属性名、value 和 proxy 实例本身（严格地说，是操作行为所针对的对象），其中最后一个参数可选。

```js
let target = { foo: 1 };
let proxy = new Proxy(target, {
  get(target, key, receiver) {
    console.log(`getter ${key}!`);
    return target[key];
  },
  set: function (target, key, value, receiver) {
    console.log(`setter ${key}!`);
    target[key] = value;
  },
});

let obj = Object.create(proxy);
console.log(obj.foo);
// getter foo!
// 1
```

#### 2. has

拦截 propKey in proxy 的操作，返回一个布尔值。

```js
// 使用 has 方法隐藏某些属性，不被 in 运算符发现
var handler = {
  has(target, key) {
    if (key.startsWith("_")) {
      return false;
    }
    return key in target;
  },
};
var foo = { _name: "foo", name: "foo" };
var proxy = new Proxy(foo, handler);
console.log("_name" in proxy); // false
console.log("name" in proxy); // true
```

#### 3. ownKeys

拦截自身属性的读取操作。并返回目标对象所有自身属性的属性名数组。具体返回结果可结合 MDN [属性的可枚举性和所有权](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Enumerability_and_ownership_of_properties)

- `Object.getOwnPropertyName(proxy)`
- `Object.getOwnPropertySymbols(proxy)`
- `Object.keys(proxy)`
- `for ... in`循环

```js
let target = {
  _foo: "foo",
  _bar: "bar",
  name: "An",
};

let handler = {
  ownKeys(target) {
    return Reflect.ownKeys(target).filter((key = key.startsWith("_")));
  },
};

let proxy = new Proxy(target, handler);
for (let key of Object.keys(proxy)) {
  console.log(target[key]);
}
// "An"
```

#### 4. apply

apply 拦截 Proxy 实例作为函数调用的操作，比如函数的调用（`proxy(...args)`）、call（`proxy.call(object, ...args)`）、apply（`proxy.apply(...)`）等。

```js
var target = function () {
  return "I am the target";
};
var handler = {
  apply: function () {
    return "I am the proxy";
  },
};

var proxy = new Proxy(target, handler);

proxy();
// "I am the proxy"
```

Proxy 方法太多，这里只是将常用的简要介绍，更多请看阮一峰老师的 [《ECMAScript 6 入门》](https://link.juejin.im/?target=http%3A%2F%2Fes6.ruanyifeng.com%2F%23docs%2Fproxy)

### 和 Object.defineProperty()的对比

defineProperty 存在以下问题：

1. 不能监听数组的变化
2. 必须遍历对象的每个属性
3. 必须深层遍历嵌套的对象(vue walk 方法)

也需要嵌套

```js
let obj = {
  info: {
    name: "eason",
    blogs: ["webpack", "babel", "cache"],
  },
};
let handler = {
  get(target, key, receiver) {
    console.log("get", key);
    // 递归创建并返回
    if (typeof target[key] === "object" && target[key] !== null) {
      return new Proxy(target[key], handler);
    }
    return Reflect.get(target, key, receiver);
  },
  set(target, key, value, receiver) {
    console.log("set", key, value);
    return Reflect.set(target, key, value, receiver);
  },
};
let proxy = new Proxy(obj, handler);
// 以下两句都能够进入 set
proxy.info.name = "Zoe";
proxy.info.blogs.push("proxy");
```

### Proxy 妙用

```js
const www = new Proxy(new URL("https://www"), {
  get: function get(target, prop) {
    let o = Reflect.get(target, prop);
    if (typeof o === "function") {
      return o.bind(target);
    }
    if (typeof prop !== "string") {
      return o;
    }
    if (prop === "then") {
      return Promise.prototype.then.bind(fetch(target));
    }
    target = new URL(target);
    target.hostname += `.${prop}`;
    return new Proxy(target, { get });
  },
});
```

- 访问百度

```js
www.baidu.com.then((response) => {
  console.log(response.status);
  // ==> 200
});

const response = await www.baidu.com;
console.log(response.ok);
// ==> true
console.log(response.status);
// ==> 200
```
