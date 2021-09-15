---
title: generator生成器
tags:
  - es6
copyright: true
comments: true
date: 2018-08-21 11:49:12
categories: JS
photos:
---

生成器（ generator）是能返回一个迭代器的函数。生成器函数也是一种函数，最直观的表现就是比普通的function多了个星号*，在其函数体内可以使用yield关键字，有意思的是函数会在每个yield后暂停。

这里生活中有一个比较形象的例子。咱们到银行办理业务时候都得向大厅的机器取一张排队号。你拿到你的排队号，机器并不会自动为你再出下一张票。也就是说取票机“暂停”住了，直到下一个人再次唤起才会继续吐票。

--- 
<!-- more -->

OK。说说迭代器。当你调用一个generator时，它将返回一个迭代器对象。这个迭代器对象拥有一个叫做next的方法来帮助你重启generator函数并得到下一个值。next方法不仅返回值，它返回的对象具有两个属性：done和value。value是你获得的值，done用来表明你的generator是否已经停止提供值。继续用刚刚取票的例子，每张排队号就是这里的value，打印票的纸是否用完就这是这里的done。

- function 关键字与函数名之间有一个星号；
- 函数体内部使用 yield表达式，定义不同的内部状态；
- next 指针移向下一个状态

```javascript
// 生成器 最大的特点是可以交出函数的执行权
function *createGenerator(){
    yield 1;
    yield 2;
    yield 3;
}

// 迭代器
let iterator=createGenerator()
console.log(iterator.next().value) // 1
console.log(iterator.next().value) // 2
console.log(iterator.next().value) // 3
```

```js
function *foo(x) {
  let y = 2 * (yield (x + 1))
  let z = yield (y / 3)
  return (x + y + z)
}
let it = foo(5)
console.log(it.next())   // => {value: 6, done: false}
console.log(it.next(12)) // => {value: 8, done: false}
console.log(it.next(13)) // => {value: 42, done: true}
```
1. 首先 Generator 函数调用时它会返回一个迭代器
2. 当执行第一次 next 时，传参会被忽略，并且函数暂停在 yield (x + 1) 处，所以返回 5 + 1 = 6
3. 当执行第二次 next 时，传入的参数等于上一个 yield 的返回值，如果你不传参，yield 永远返回 undefined。此时 let y = 2 * 12，所以第二个 
yield 等于 2 * 12 / 3 = 8
4. 当执行第三次 next 时，传入的参数会传递给 z，所以 z = 13, x = 5, y = 24，相加等于 42

那生成器和迭代器又有什么用处呢？

围绕着生成器的许多兴奋点都与异步编程直接相关。异步调用对于我们来说是很困难的事，我们的函数并不会等待异步调用完再执行，你可能会想到用回调函数，（当然还有其他方案比如Promise比如Async/await）。

生成器可以让我们的代码进行等待。就不用嵌套的回调函数。使用generator可以确保当异步调用在我们的generator函数运行一下行代码之前完成时暂停函数的执行。

那么问题来了，咱们也不能手动一直调用next()方法，你需要一个能够调用生成器并启动迭代器的方法。就像这样子的：

```javascript
function run(taskDef){
  // 创建迭代器，让它在别处可用
  let task=taskDef();

  // 启动任务
  let result=task.next();

  // 递归使用函数来保持对next()的调用
  function step(){
      // 如果还有更多要做的
      if(!result.done){
        result=task.next();
        step();
      }
  }

  // 开始处理过程
  step();
}
```
生成器与迭代器最有趣、最令人激动的方面，或许就是可创建外观清晰的异步操作代码。可以不必到处使用回调函数，而是可以建立貌似同步的代码，但实际上却使用 
`yield` 来等待异步操作结束。

es6引入了 async 函数，使得异步操作变得更加方便。

async 函数是什么？一句话，它就是 Generator 函数的语法糖。

```javascript
function timeout(ms){
  return new Promise((resolve)=>{
      setTimeout(resolve,ms)
  });
}

async function asyncPrint(value,ms){
    await timeout(ms);
    console.log(value);
}

asyncPrint('hello world',50)
```

一比较就会发现，async函数就是将 Generator 函数的星号（*）替换成async，将yield替换成await，仅此而已。
async函数对 Generator 函数的改进，体现在以下四点：
- 内置执行器
- 更好的语义
- 更广的适用性
- 返回值是Promise

## 可迭代对象的特点
1. 知道如何每次访问集合中的一项，并跟踪该序列中的当前位置
2. 提供而next方法，来返回序列中的下一项(value, done)
3. 迭代器一旦被创建，可以反复调用next

```js
function makeIterator(array){
    var nextIndex = 0;
    return {
       next: function(){
           return nextIndex < array.length ?
               {value: array[nextIndex++], done: false} :
               {done: true};
       }
    };
}
// 使用 next 方法依次访问对象中的键值
var it = makeIterator(['step', 'by','step']);
console.log(it.next().value); // 'step'
console.log(it.next().value); // 'by'
console.log(it.next().value); // 'step'
console.log(it.next().value);  // undefined
console.log(it.next().done); // true
```
