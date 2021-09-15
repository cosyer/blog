---
title: 使用 Async/Await 让你的代码更简洁
tags:
  - promise
copyright: true
comments: true
date: 2018-06-11 01:30:51
categories: JS
top: 107
photos:
---

Async/Await是一种允许我们像构建没有回调函数的普通函数一样构建Promise的新语法。以往的异步方法无外乎回调函数和`Promise`。但是Async/Await建立于[Promise](https://mydearest.cn/createPromise.html)之上。

---
<!-- more -->

## Async/Await语法
### async关键字(放置在一个函数前面)。

```javascript
async function f() {
    return 1
    // return Promise.resolve(1)
}
f().then(value) // 1
```

async修饰过的函数总是返回一个promise，如果代码中有return <非promise>语句，JavaScript会自动把返回的这个value值包装成promise的resolved值。
### await关键字(只能在async函数内部使用)
关键词await可以让JavaScript进行等待，直到一个promise执行并返回它的结果，JavaScript才会继续往下执行。

```javascript
function timeout(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

async function asyncPrint(value, ms) {
    await timeout(ms);
    console.log(value);
}

asyncPrint('hello world', 50);
```

### 错误处理(使用try-catch捕获)可以给每个 await 后的 Promise 增加 catch 方法；也可以将 await 的代码放在 try...catch 中
```javascript
async function f() {
    try {
        let response = await fetch('http://no-such-url')
    } catch (err) {
        alet(err) // TypeError: failed to fetch 也能捕获多行语句 类似链式Promise最后的单个catch函数
    }
}
f()
```

如果我们不使用try-catch，然后async函数f()的调用产生的promise变成reject状态的话，我们可以添加.catch去处理它：

```javascript
async function f() {
    let response = await fetch('http://no-such-url')
}
// f()变成了一个rejected的promise
f().catch(alert) // TypeError: failed to fetch
```

```js
async function getData() {
  try {
    if (true) {
      throw Error("Catch me if you can");
    }
  } catch (err) {
    console.log(err.message);
  }
}
getData()
  .then(() => console.log("I will run no matter what!"))
  .catch(() => console.log("Catching err"));
```
throw 抛出的错误永远不会触发**getData()**的catch方法。

```js
async function getData() {
  try {
    if (true) {
      return Promise.reject("Catch me if you can");
    }
  } catch (err) {
    console.log(err.message);
  }
}
```

### 结合Promise.all
async/await能够与Promise.all友好的协作，当我们需要等待多个promise时，我们可以将他们包装在Promise.all中然后使用await：

```javascript
// 直到数组全部返回结果
let results = await Promise.all([
   fetch(url1),
   fetch(url2),
   ...
])
```

## 简单实现async函数
```js
function spawn(genF) {
    return new Promise(function(resolve, reject) {
        const gen = genF();
        function step(nextF) {
            let next;
            try {
                next = nextF();
            } catch (e) {
                return reject(e);
            }
            if (next.done) {
                return resolve(next.value);
            }
            Promise.resolve(next.value).then(
                function(v) {
                    step(function() {
                        return gen.next(v);
                    });
                },
                function(e) {
                    step(function() {
                        return gen.throw(e);
                    });
                }
            );
        }
        step(function() {
            return gen.next(undefined);
        });
    });
}
```

## Promises 组合：Promise.all，Promise.allSettled， Promise.any
- Promise API 提供了许多将Promise组合在一起的方法。 其中最有用的是Promise.all，它接受一个Promises数组并返回一个Promise。 如果参数中 promise 有一个失败（rejected），此实例回调失败（reject），失败原因的是第一个失败 promise 的结果。

- Promise.race(iterable) 方法返回一个 promise，一旦迭代器中的某个promise解决或拒绝，返回的 promise就会解决或拒绝。

- 较新版本的V8也将实现两个新的组合：Promise.allSettled和Promise.any。 Promise.any仍然处于提案的早期阶段：在撰写本文时，仍然没有浏览器支持它。

Promise.any可以表明任何Promise是否fulfilled。 与 Promise.race的区别在于Promise.any不会拒绝即使其中一个Promise被拒绝。

无论如何，两者中最有趣的是 Promise.allSettled，它也是 Promise 数组，但如果其中一个Promise拒绝，它不会短路。 当你想要检查Promise数组是否全部已解决时，它是有用的，无论最终是否拒绝，可以把它想象成Promise.all 的反对者。

## 总结

随着单页JavaScript web程序的兴起和对NodeJS的广泛采用，如何优雅的处理并发对于JavaScript开发人员来说比任何以往的时候都显得更为重要。

JS引擎是单线程的，这意味着运行函数只有一个调用堆栈。这一限制是JS异步本质的基础:所有需要时间的操作都必须由外部实体(例如浏览器)或回调函数负责。

`Async/Await`缓解了许多因为控制流问题而导致bug遍地的这个困扰着JavaScript代码库数十年的问题，并且几乎可以保证让任何异步代码块变的更精炼，更简单，更自信。