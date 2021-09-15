---
title: EventLoop
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-06-16 12:38:46
categories: JS
photos:
top: 240
---

## 描述事件队列的过程？

- js是单线程的，会出现阻塞问题，因此有了任务队列的出现
- 主线程同步执行任务，异步的工作一般会交给其他线程完成，然后回调函数会放到任务队列中
- 等候主线程执行完毕后再执行任务队列中的操作

![event-queue](http://cdn.mydearest.cn/blog/images/event-queue.png)

> 同步任务指的是，在主线程上排队执行的任务，只有前一个任务执行完毕，才能执行后一个任务；

> 异步任务指的是，不进入主线程、而进入"任务队列"（task queue）的任务，只有"任务队列"通知主线程，某个异步任务可以执行了，该任务才会进入主线程执行。只要异步任务有了运行结果，就在"任务队列"之
中放置一个事件。

![task-queue](http://cdn.mydearest.cn/blog/images/task-queue.png)
任务队列中存着的是异步任务，这些异步任务一定要等到执行栈清空后才会执行。

同步就是发出一个请求后什么事都不做，一直等待请求返回后才会继续做事；异步就是发出请求后继续去做其他事，这个请求处理完成后会通知你，这时候就可以处理这个回应了。

---
<!--more-->

## 什么是宏任务什么是微任务？
script(宏任务) - 清空微任务队列 - 执行一个宏任务 - 清空微任务队列 - 执行一个宏任务， 如此往复。
1.先执行script里的同步代码（此时是宏任务）。碰到异步任务，放到任务队列。
2.查找任务队列有没有微任务，有就把此时的微任务全部按顺序执行 （这就是为什么promise会比setTimeout先执行，因为先执行的宏任务是同步代码，setTimeout被放进任务队列了，setTimeout又是宏任务，在它之前先得执行微任务(就比如promise)）。
3.执行一个宏任务（先进到队列中的那个宏任务），再把这次的宏任务和微任务放到任务队列。
4.一直重复2、3步骤

当满足执行条件时，宏任务(macroTask) 和 微任务(microTask) 会各自被放入对应的队列：宏队列(Macrotask Queue) 和 微队列(Microtask Queue) 中等待执行。
先执行同步任务，然后所有微任务，一个宏任务，所有微任务，一个宏任务...

![macro-micro](http://cdn.mydearest.cn/blog/images/macro-micro.png)

## 哪些是宏任务哪些是微任务？

### 宏任务(优先级由高到低)
- 主线程同步代码
- setTimeout
- setImmediate node无
- setInterval
- requestAnimationFrame node无
- I/O
- UI rendering

### 微任务(优先级由高到低)
- process.nextTick 浏览器无
- Promise.then
- Object.observe(该方法已废弃)
- MutationObserver node无

### 微任务的意义
减少更新时的渲染次数
因为根据HTML标准，会在宏任务执行结束之后，在下一个宏任务开始执行之前，UI都会重新渲染。如果在microtask中就完成数据更新，当 macro-task结束就可以得到最新的UI了。如果新建一个 macro-task来做数据更新的话，那么渲染会执行两次。

### 事件循环
![eventloop](http://cdn.mydearest.cn/blog/images/eventloop.png)

js引擎存在monitoring process进程，会持续不断的检查主线程执行栈是否为空，一旦为空就会去Event Queue那里检查是否有等待被调用的函数。这个过程是循环不断的，所以整个的这种运行机制又称为Event 
Loop（事件循环）

1. 整体的script(作为第一个宏任务)开始执行的时候，会把所有代码分为两部分：“同步任务”、“异步任务”；
2. 同步任务会直接进入主线程依次执行；
4. 异步任务会再分为宏任务和微任务；
5. 宏任务进入到Event Table中，并在里面注册回调函数，每当指定的事件完成时，Event Table会将这个函数移到Event Queue中；
6. 微任务也会进入到另一个Event Table中，并在里面注册回调函数，每当指定的事件完成时，Event Table会将这个函数移到Event Queue中；
7. 当主线程内的任务执行完毕，主线程为空时，会检查微任务的Event Queue，如果有任务，就全部执行，如果没有就执行下一个宏任务；
上述过程会不断重复，这就是Event Loop事件循环；

![summary-loop](http://cdn.mydearest.cn/blog/images/summary-loop.png)

**精炼**事件循环是指: 执行一个宏任务，然后执行清空微任务列表，循环再执行宏任务，再清微任务列表。

### Node 的 Event Loop: 6个阶段
- Timers: 定时器 Interval Timoout 回调事件，将依次执行定时器回调函数
- Pending: 一些系统级回调将会在此阶段执行
- Idle,prepare: 此阶段"仅供内部使用"
- Poll: IO回调函数，这个阶段较为重要也复杂些，
- Check: 执行 setImmediate() 的回调
- Close: 执行 socket 的 close 事件回调

### 区别总结
![eventloop-diff](http://cdn.mydearest.cn/blog/images/eventloop-diff.png)
```js
setTimeout(()=>{
    console.log('timer1')
    Promise.resolve().then(function() {
        console.log('promise1')
    })
}, 0)
setTimeout(()=>{
    console.log('timer2')
    Promise.resolve().then(function() {
        console.log('promise2')
    })
}, 0)
```
> 浏览器端运行结果：timer1=>promise1=>timer2=>promise2
![navigator-eventloop](http://cdn.mydearest.cn/blog/images/navigator-eventloop.png)

Node端运行结果分两种情况：

如果是node11版本一旦执行一个阶段里的一个宏任务(setTimeout,setInterval和setImmediate)就立刻执行微任务队列，这就跟浏览器端运行一致，最后的结果
为timer1=>promise1=>timer2=>promise2

如果是node10及其之前版本：要看第一个定时器执行完，第二个定时器是否在完成队列中。

如果是第二个定时器还未在完成队列中，最后的结果为timer1=>promise1=>timer2=>promise2
如果是第二个定时器已经在完成队列中，则最后的结果为timer1=>timer2=>promise1=>promise2(下文过程解释基于这种情况下)

1. 全局脚本（main()）执行，将2个timer依次放入timer队列，main()执行完毕，调用栈空闲，任务队列开始执行；
2. 首先进入timers阶段，执行timer1的回调函数，打印timer1，并将promise1.then回调放入microtask队列，同样的步骤执行timer2，打印timer2；
3. 至此，timer阶段执行结束，event loop进入下一个阶段之前，执行microtask队列的所有任务，依次打印promise1、promise2

![node-eventloop](http://cdn.mydearest.cn/blog/images/node-eventloop.png)

### 结论
- Node端，microtask 在事件循环的各个阶段之间执行
```js
loop.forEach((阶段) => {
    阶段全部任务();
    nextTick全部任务();
    microTask全部任务();
});
loop = loop.next;
}
```


- 浏览器端，microtask 在事件循环的 macrotask 执行完之后执行
```js
while (true) {
    宏任务队列.shift();
    微任务队列全部任务();
}
```

### 练习题
```js
console.log(1)
setTimeout(()=>{
    console.log(2)
}, 0)
var promise = new Promise(function(resolve, reject) {
    console.log(3)
    resolve();
})
promise.then(function(){
    console.log(4)
})
console.log(5)
// 13542

console.log(1)
setTimeout(()=>{
    console.log(2)
},0)

var intervalId = setInterval(function(){
    console.log(3)
}, 0)
setTimeout(function(){
    console.log(10)
    new Promise(function(resolve){
        console.log(11)
        resolve()
    }).then(()=>{
        console.log(12)
    }).then(()=>{
        console.log(13)
        clearInterval(intervalId)
    })
}, 0)
Promise.resolve().then(()=>{
    console.log(7)
}).then(()=>{
    console.log(8)
})
console.log(9)
// 1 9 7 8 2 3 10 11 12 13

setTimeout(()=>{
    console.log(1)
}, 0);

new Promise((resolve, reject)=>{
    console.log(2);
    resolve();
}).then(()=>{
    console.log(3);
}).then(()=>{
    console.log(4);
});

process.nextTick(()=>{
    console.log(5);
});

console.log(6);
// 2 6 5 3 4 1
```

```js
console.log(1);

setTimeout(()=>{
    console.log(2);   
    new Promise((resolve,reject)=>{
    console.log(3);
    resolve()
}).then(res=>{
    console.log(4); 
})
})

new Promise((resolve,reject)=>{
    resolve()
}).then(res=>{
    console.log(5); 
}).then(res=>{
    console.log(6);
    
})

new Promise((resolve,reject)=>{
    console.log(7);
    resolve()
}).then(res=>{
    console.log(8); 
}).then(res=>{
    console.log(9);
    
})

setTimeout(()=>{
    console.log(10);   
    new Promise((resolve,reject)=>{
    console.log(11);
    resolve()
}).then(res=>{
    console.log(12); 
})
})

console.log(13);
// 1 7 13 5 8 6 9 2 3 4 10 11 12
```

```js

async function async1() {
    console.log('async1 start');
    await async2();
    console.log('async1 end');
}

async function async2() {
    console.log('async2');
}

console.log('script start');

setTimeout(function() {
    console.log('setTimeout');
}, 0)

async1();

new Promise(function(resolve) {
    console.log('promise1');
    resolve();
}).then(function() {
    console.log('promise2');
});

console.log('script end');

// script start

// async1 start

// async2

// promise1

// script end

// async1 end

// promise2

// setTimeout
```

## 参考
[浏览器与Node的事件循环(Event Loop)有何区别?](https://juejin.im/post/5c337ae06fb9a049bc4cd218)
