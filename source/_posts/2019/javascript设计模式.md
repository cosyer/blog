---
title: javascript设计模式
tags:
  - 知识
copyright: true
comments: true
date: 2019-12-18 01:15:46
categories: JS
photos:
top: 201
---

## 概念

设计模式是一套被反复使用的、多数人知晓的、经过分类编目的、代码设计经验的总结。使用设计模式是为了重用代码、让代码更容易被他人理解、保证代码可靠性。 毫无疑问，设计模式于己于他人于系统都是多赢
的，设计模式使代码编制真正工程化，设计模式是软件工程的基石，如同大厦的一块块砖石一样。

## 设计原则（5 个）

### S – Single Responsibility Principle 单一职责原则

- 一个程序只做好一件事
- 如果功能过于复杂就拆分开，每个部分保持独立

### O – OpenClosed Principle 开放/封闭原则

- 对扩展开放，对修改封闭
- 增加需求时，扩展新代码，而非修改已有代码

### L – Liskov Substitution Principle 里氏替换原则

- 子类能覆盖父类
- 父类能出现的地方子类就能出现

### I – Interface Segregation Principle 接口隔离原则

- 保持接口的单一独立
- 类似单一职责原则，这里更关注接口

### D – Dependency Inversion Principle 依赖倒转原则

- 面向接口编程，依赖于抽象而不依赖于具
- 使用方只关注接口而不关注具体类的实现

## 设计模式的类型

如果从作用上来划分，JavaScript 设计模式大概分为五种设计类型：

| 创建型设计模式 | 结构型设计模式 | 行为型设计模式 | 技巧型设计模式   | 架构型设计模式 |
| :------------- | :------------- | :------------- | :--------------- | :------------- |
| 简单工厂模式   | 外观模式       | 模板方法模式   | 链模式           | 同步模块       |
| 工厂方法模式   | 适配器模式     | 观察者模式     | 委托模式         | 异步模块模式   |
| 抽象工厂模式   | 代理模式       | 状态模式       | 数据访问对象模式 | Widget 模式    |
| 建造者模式     | 装饰者模式     | 策略模式       | 节流模式         | MVC 模式       |
| 原型模式       | 桥接模式       | 职责链模式     | 简单模板模式     | MVP 模式       |
| 单例模式       | 组合模式       | 命令模式       | 惰性模式         | MVVM 模式      |
|                | 享元模式       | 访问者模式     | 参与者模式       |                |
|                |                | 中介者模式     | 等待者模式       |                |
|                |                | 备忘录模式     |                  |                |
|                |                | 迭代器模式     |                  |                |
|                |                | 解释器模式     |                  |                |

---

<!--more-->

## 第 33 章 异国战场-参与者模式

- 参与者模式：在特定的作用域中执行给定的函数,并将参数原封不动地传递。

### 事件绑定方法

```js
let A = {
  event: {},
};
// 事件模块（事件绑定方法）
A.event.on = function (dom, type, fn) {
  // 绑定 w3c 标准事件
  if (dom.addEventListener) {
    dom.addEventListener(type, fn, false);
    // 绑定 ie 标准事件
  } else if (dom.attachEvent) {
    dom.attachEvent("on" + type, fn);
    // 绑定 dom 事件
  } else {
    dom["on" + type] = fn;
  }
};
```

```js
/*上面存在的问题， addEventListener 没有办法在回调函数中传递参数， 做如下的修改*/
A.event.on2 = function (dom, tyoe, fn, data) {
  if (dom.addEventListener) {
    dom.addEventListener(
      type,
      function (e) {
        // 在dom环境中调用fn,并传递事件对象以及参数
        fn.call(dom, e, data);
      },
      false
    );
  }
  // .............
};
```

通过 call 和 apply 方法使我们在特定作用域中执行某个函数并传入参数。

### 实现 bind 方法

```js
/*
 * 上面的方法确实是解决了参数传递的问题， 但是引发了一个新的问题
 * 新的问题就是添加的是匿名函数导致事件回调函数不能移除了
 * 为了解决这个问题， 就引入了bind 闭包
 * */
let bind = function (fn, context) {
  // 闭包返回新函数
  return function () {
    // 对 fn 装饰并返回
    return fn.apply(context, arguments);
  };
};

// 对于bind 方法的测试
let demoObj = {
  title: "这是一个例子",
};
let demoFn = function () {
  console.log(this.title);
};
let bindFn = bind(demoFn, demoObj);
demoFn(); // undefined
bindFn(); // '这是一个例子'
```

bindFn 返回了结果，因为 bindFn 在执行时 demoObj 参与了进来并提供了作用域。

```js
/*
 * 实际应用
 * */
let button = document.getElementsByTagName("button")[0];
let p = document.getElementsByTagName("p")[0];
// 输出参数和 this 对象
let demoFn = function () {
  console.log(arguments, this);
};

// 当没有传入参与对象式 浏览器下 this 指向 Window
let bindFn = bind(demoFn);
button.addEventListener("click", bindFn); // [MouseEvent]  Window

// 传入button this 指向了button
bindFn = bind(demoFn, button); // [MouseEvent] <button>按钮</button>

// 传入P this 指向了P
bindFn = bind(demoFn, p); // [MouseEvent] <p>p</p>

button.removeEventListener("click", bindFn);
```

不使用实现的 bind 方法，我们也可以用原生的 bind

```js
let bindFN = demoFn.bind();
```

### 函数柯里化

```js
/*
 * 第一个需求是添加事件和移除事件已经成功了
 * 第二个需求就是函数添加额外的自定义参数
 * 这个时候就需要借助于函数柯里化了
 * 函数柯里化： 根据传递的参数不同， 让一个函数存在多种状态， 处理的是函数。
 * */
```

函数柯里化（function currying）又称部分求值。一个函数首先会接受一些参数，接受了这些参数后，

该函数并不会立即求值，而是继续返回另外一个函数，刚才传入的参数在函数形成的闭包里被保存起来。待到函数真正需要求值的时候，之前传入的参数都会被一次性用于求值。

把接受多个参数的函数变换成接受一个单一参数（最初函数的第一个参数）的函数，并且返回接受余下的参数而且返回结果的新函数。

```js
let curry = function (fn) {
  // 缓存数组的 slice 方法
  let Slice = [].slice;
  // 从第二个参数开始截取
  let args = Slice.call(arguments, 1);
  // 闭包返回新函数
  return function () {
    // arguments 类数组 转化为数组
    let addArgs = Slice.call(arguments),
      // 拼接参数
      allArgs = args.concat(addArgs);
    // 返回新函数
    return fn.apply(null, allArgs);
  };
};
// 柯里化的测试
let add = function (num1, num2) {
  return num1 + num2;
};
let add5 = function (num) {
  return add(5, num);
};
console.log(add(1, 2)); // 3
console.log(add5(6)); // 11

add5 = curry(add, 5);
console.log(add5(6)); // 11
let add7and8 = curry(add, 7, 8);
console.log(add7and8()); // 15
```

对 add 方法的多态扩展不需要再声明函数了。

### 通过柯里化重写 bind

```js
/*
 * 通过柯里化重写bind
 * */
let bind = function (fn, context) {
  let Slice = Array.prototype.slice,
    args = Slice.call(arguments, 2);
  return function () {
    let addArgs = Slice.call(arguments),
      allArgs = addArgs.concat(args);
    return fn.apply(context, allArgs);
  };
};
// 测试
let demoData1 = {
  text: "这是第一组数据",
};
let demoData2 = {
  text: "这是第二组数据",
};
bindFn = bind(demoFn, button, demoData1); // [MouseEvent, Object] <button>按钮</button>
bindFn = bind(demoFn, button, demoData1, demoData2); // [MouseEvent, Object, Object] <button>按钮</button>
```

以之前的 button 为例，我们现在能在回调函数中获取传递的自定义的数据了。

```js
let bindFn = demoFn.bind(button, demoData1); // [Object, MouseEvent] <button>按钮</button> 事件对象放后面的
```

```js
/*
 * 为了浏览器兼容性的实现， 我们需要给未提供bind方法的浏览器添加bind方法
 * */
if (Function.prototype.bind === undefined) {
  Function.prototype.bind = function (context) {
    let Slice = Array.prototype.slice,
      args = Slice.call(arguments, 1);
    return () => {
      let addArgs = Slice.call(arguments),
        allArgs = args.concat(addArgs);
      return this.apply(context, allArgs);
    };
  };
}
```

### 总结

对于函数绑定，将函数以函数指针（函数名的方式传递），使函数在被绑定对象上的作用域中执行，可以顺利访问到对象内部的数据。缺点会消耗更多的内存执行速度会稍慢。比较常用于事件，setTimeout 等异步逻辑的回调函数。

对于函数柯里化则是将接受多个参数的函数转化成接受一部分参数的新函数，余下的参数保存下来。当调用式传入的参数和保存的参数一起执行。因为要保存参数到闭包内，所以同样也会多消耗些资源。

## 第 34 章 入场模式-等待者模式

- 等待者模式: 通过对多个异步进程进行监听，来触发未来的动作。(构建简易 Promise 对象，实现状态机)

- 场景: 不能确定先后的异步逻辑，但需要等待所有异步逻辑的完成。所有成功后执行成功回调，有一个失败就执行失败的回调函数。

不需要实时监听所有异步逻辑是否完成，只需要监听注册的异步逻辑的状态发生改变时，对所有的异步逻辑的状态进行一次确认迭代。

### 接口拆分

一个等待者对象内部定义了 3 个数组，分别存储监听对象，成功回调和失败回调；1 个监控对象的类，有 2 个属性（成功状态和失败状态），2 个方法（成功和失败方法）；私有方法\_exec 来处理成功或失败的回调；3 个共有方法接口：when（监听异步逻辑）、done（添加成功回调）、fail（添加失败回调）

```js
// 等待者对象
var Waiter = function () {
  // 注册了等待对象容器
  var dfd = [];
  // 成功回调方法容器
  var doneArr = [];
  // 失败回调方法容器
  var failArr = [];
  // 缓存Array方法slice
  var _slice = Array.prototype.slice;
  // 保存当前等待者对象
  var that = this;

  // 监控对象类
  var Primise = function () {
    // 监控对象是否解决成功状态
    this.resolved = false;
    // 监控对象是否解决失败状态
    this.rejected = false;
  };
  // 监控对象类原型方法
  Primise.prototype = {
    // 解决成功
    resolve: function () {},
    // 解决失败
    reject: function () {},
  };

  // 创建监控对象
  that.Deferred = function () {
    return new Primise();
  };

  // 回调执行方法
  function _exec(arr) {}

  // 监控异步方法 参数：监控对象
  that.when = function () {};

  // 解决成功回调函数添加方法
  that.done = function () {};

  // 解决失败回调函数添加方法
  that.fail = function () {};
};
```

### 监控对象类原型方法

```js
Primise.prototype = {
  // 解决成功
  resolve: function () {
    // 设置当前监控对象解决成功
    this.resolved = true;
    // 如果没有监控对象则取消执行
    if (!dfd.length) {
      return;
    }
    // 遍历所有注册了的监控对象
    for (var i = dfd.length - 1; i >= 0; i--) {
      // 如果有任意一个监控对象没有被解决或者解决失败则返回
      if ((dfd[i] && !dfd[i].resolved) || dfd[i].rejected) {
        return;
      }
      // 清除监控对象 成功了就不需要再监控
      dfd.splice(i, 1);
    }
    // 执行解决成功回调方法
    _exec(doneArr);
  },
  // 解决失败
  reject: function () {
    // 设置当前监控对象解决失败
    this.rejected = true;
    // 如果没有监控对象则取消执行
    if (!dfd.length) {
      return;
    }
    // 清除所有监控对象
    dfd.splice(0);
    // 执行解决成功回调方法
    _exec(failArr);
  },
};
```

### 回调执行方法

```js
function _exec(arr) {
  var i = 0;
  var len = arr.length;
  // 遍历回调数组执行回调
  for (; i < len; i++) {
    try {
      // 执行回调函数
      arr[i] && arr[i]();
    } catch (e) {}
  }
}
```

### 监控异步方法 参数：监控对象

```js
that.when = function () {
  // 设置监控对象
  dfd = _slice.call(arguments);
  // 获取监控对象数组长度
  var i = dfd.length;
  // 向前遍历监控对象，最后一个监控对象的索引值为length-1
  for (--i; i >= 0; i--) {
    // 如果不存在监控对象，或者监控对象已经解决，或者不是监控对象
    if (
      !dfd[i] ||
      dfd[i].resolved ||
      dfd[i].rejected ||
      !dfd[i] instanceof Primise
    ) {
      // 清理内存，清除当前监控对象
      dfd.splice(i, 1);
    }
  }
  // 返回等待者对象
  return that;
};
```

### 解决成功回调函数添加方法

```js
that.done = function () {
  // 向成功回调函数容器中添加回调方法
  doneArr = doneArr.concat(_slice.call(arguments));
  // 返回等待者对象
  return that;
};
```

### 解决失败回调函数添加方法

```js
that.fail = function () {
  // 向失败回调函数容器中添加回调方法
  failArr = failArr.concat(_slice.call(arguments));
  // 返回等待者对象
  return that;
};
```

### 测试

```js
// 创建一个等待者对象
var waiter = new Waiter();

// 第一个彩蛋，3秒停止
var first = (function () {
  // 创建监听对象
  var dtd = waiter.Deferred();
  setTimeout(function () {
    console.log("first finish");
    // 发布解决成功问题
    dtd.resolve();
    // 发布解决失败问题
    // dtd.reject();
  }, 3000);
  // 返回监听对象
  return dtd;
})();

// 第二个彩蛋，6秒后停止
var second = (function () {
  // 创建简体你对象
  var dtd = waiter.Deferred();
  setTimeout(function () {
    console.log("second finish");
    // 发布解决成功消息
    dtd.resolve();
    // 发布解决失败问题
    // dtd.reject();
  }, 6000);
  // 返回监控对象
  return dtd;
})();

// 监听两个彩蛋的工作状态，并执行相应的成功回调函数与失败回调函数
waiter
  // 监听两个彩蛋
  .when(first, second)
  // 添加成功回调函数
  .done(
    function () {
      console.log("success");
    },
    function () {
      console.log("success again");
    }
  )
  // 添加失败回调函数
  .fail(function () {
    console.log("fail");
  });
```

### 应用场景

```js
// 封装get请求
var ajaxGet = (function (url, success, fail) {
  var xhr = new XMLHttpRequest();
  // 创建监测对象
  var dtd = waiter.Deferred();
  xhr.onload = function (event) {
    // 请求成功
    if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304) {
      success && success();
      // 请求失败
    } else {
      dtd.reject();
      fail && fail();
    }
  };
  xhr.open("get", url, true);
  xhr.send(null);
})(
  // 长轮询
  function getAjaxData() {
    // 保存当前函数
    var fn = arguments.callee;
    setTimeout(function () {
      $.get("./test.php", function () {
        console.log("轮询一次");
        // 再一次执行轮询
        fn();
      });
    }, 5000);
  }
)();
```

### 总结

等待者模式适合用于处理比较耗时的操作比如定时器操作、异步请求等。等待者模式提供了抽象非阻塞的解决方案。通过创建 Promise 对象，对应状态变化返回响应，同时监听这些响应信息，并为之提供相应的回调，根据状态执行相应的回调方法。
