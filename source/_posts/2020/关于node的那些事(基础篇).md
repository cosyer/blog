---
title: 关于node的那些事(基础篇)
tags:
  - NodeJS
copyright: true
comments: true
date: 2020-06-21 23:41:55
categories: Node
photos:
---

## 👨提问：最近Deno很火，会不会替代node的替代品，学node是不是没有前途？
> 莫慌，Node依旧是社区热捧的服务器端 JavaScript 运行环境，Deno的出现其实本质上是完善现阶段的Node（新轮子），包括原生支持TS、安全性、支持ES 
Module浏览器模块、等特征。万变不离其宗，虽然有了Deno，将来可能就不需要 Node.js，但是新事物总是需要不断推演和考验后，所以这一点而言，Node短时间内很
难被替换，毕竟背后依附着强大社区的支撑。

## node 如何获取命令行传来的参数？
> process.argv。process是一个全局变量，它提供当前 Node.js 进程的有关信息，而process.argv 属性则返回一个数组，数组中的信息包括启动Node.js进程时的命令行参数。

- process.argv[0] : 返回启动Node.js进程的可执行文件所在的绝对路径
- process.argv[1] : 为当前执行的JavaScript文件路径
- process.argv.splice(2) : 移除前两者后，剩余的元素为其他命令行参数(也就是我们自定义部分)

```js
"script": {
    "serve": "node test.js arg1 arg2 arg3"
}

// test.js
const arguments = process.argv.splice(2) // [arg1, arg2, arg3]

// 结合commander
commander.parse(process.argv)
```

---
<!--more-->

## 为什么要用node（基于v8引擎运行在服务端的JS运行环境）
> 总结起来node有以下几个特点:简单强大，轻量可扩展．简单体现在node使用的是javascript，json来进行编码，人人都会；强大体现在非阻塞IO,可以适应分块传输数据，较慢的网络环境，尤其擅长
高并发访问；轻量体现在node本身既是代码，又是服务器，前后端使用统一语言;可扩展体现在可以轻松应对多实例，多服务器架构，同时有海量的第三方应用组件。

- 全局对象
process、console、Buffer

**基于事件驱动和无阻塞适合高并发的场景，统一语言**

## 怎么看 nodejs 可支持高并发
nodejs 其实并不是真正的单线程架构，因为 nodejs 还有I/O线程存在（网络I/O、磁盘I/O），这些I/O线程是由更底层的 libuv 处理，这部分线程对于开发者来
说是透明的。 JavaScript 代码永远运行在V8上，是单线程的。异步通过一次次循环事件队列来实现的。

- 单线程架构的优势和劣势：
  - 优势：
1. 单线程就一个线程在玩，省去了线程间切换的开销
2. 还有线程同步的问题，线程冲突的问题的也不需要担心

  - 劣势：

1. 劣势也很明显，现在起步都是 4 核，单线程没法充分利用 cpu 的资源
2. 单线程，一旦崩溃，应用就挂掉了，大家调试脚本也知道一旦执行过程报错了，本次调试就直接结束了
3. 因为只能利用一个 cpu ，一旦 cpu 被某个计算一直占用， cpu 得不到释放，后续的请求就会一直被挂起，直接无响应了

## node有哪些相关的文件路径？
> Node 中的文件路径有 __dirname, __filename, process.cwd(), ./ 或者 ../

- __dirname: 总是返回被执行的 js 所在文件夹的绝对路径
- __filename: 总是返回被执行的 js 的绝对路径
- process.cwd(): 总是返回运行 node 命令时所在的文件夹的绝对路径

## node相关path API 有哪些？
> path 模块提供了一些实用工具，用于处理文件和目录的路径，常用api有：path.dirname、path.join、path.resolve 其他的看文档 [Path API](http://nodejs.cn/api/path.html)

- path.dirname()： 返回 path 的目录名
- path.join()：所有给定的 path 片段连接到一起，然后规范化生成的路径
- path.resolve()：方法会将路径或路径片段的序列解析为绝对路径，解析为相对于当前目录的绝对路径，相当于cd命令

path.join(__dirname, '../lib/common.js')和 path.resolve(__dirname, '../lib/common.js')返回的结果相同，难道可以相互替换？

1. join是把各个path片段连接在一起， resolve把/当成根目录
```js
path.join('/a', '/b') // '/a/b'
path.resolve('/a', '/b') //'/b'
```

2. join是直接拼接字段，resolve是解析路径并返回
```js
path.join("a","b")  // "a/b"
path.resolve("a", "b") // "/Users/tree/Documents/infrastructure/KSDK/src/a/b"
```

## node的文件读取怎么做的？
> 通过fs文件系统模块提供的API，也是node中重要的模块之一，fs模块主要用于文件的读写、移动、复制、删除、重命名等操作。

```js
fs.rename('a', 'b', (err)=>{
    if (err) {
        exec('rm -rf a', function(err, out) {

        })
    } else {}
})
```

> ⏰需要注意的是，使用require('fs')载入fs模块，fs模块中所有方法都有同步和异步两种形式,刚刚我们展示的rename是异步方法的调用，因为在繁忙的进程中，应使用异步方法， 同步的版本会阻塞整个进程（停止所有的连接），当然fs.rename对应的同步方法就是fs.renameSync

```js
// 同步的例子
let isExists = fs.existsSync('dirname')
if (isExists) {
    process.exit(1);
}
// 无论同步异步尽量对抛出的异常做相应的处理
```

## node的url模块是用来干嘛的？
> 用来对url的字符串解析、url组成等功能，主要包括以下几个API。url.parse()、url.format()

- url.parse：可以将一个url的字符串解析并返回一个url的对象
- url.format:将传入的url对象解析成一个url字符串并返回

```js
url.parse("https://baidu.com:8080/test/h?query=js#node")

Url {
  protocol: 'http:',
  slashes: true,
  auth: null,
  host: 'baidu.com:8080',
  port: '8080',
  hostname: 'baidu.com',
  hash: '#node',
  search: '?query=js',
  query: 'query=js',
  pathname: '/test/h',
  path: '/test/h?query=js',
  href: 'http://baidu.com:8080/test/h?query=js#node'
}
```

## node的http模块创建服务与Express或Koa框架有何不同?
> express是一个服务端框架，框架简单封装了node的http模块，express支持node原生的写法，express不仅封装好服务器，还封装了中间件、路由等特征，方便开发web服务器，换句话说express = http模块 + 中间件 + 路由

### http
```js
const http = require('http')
const server = http.createServer(function (req, res) {
    res.writeHead(200, {
       'content-type': 'text/plain'
    })
    res.write('hello world')
    res.end()
})
server.listen(3000)
```

### express
```js
const express = require('express')
const app = express()
app.user(middleware)

app.get('/', function(req, res){
    res.send('hello world')
})

app.listen(3000, function() {

})

function middleware(req, res, next) {
    next()
}
```

### koa
```js
const Koa = require('koa')
const app = new Koa()
app.user(middleware)

app.listen(3000)

async function middleware(ctx, next) {
    await next()
}
```

##  Express和Koa框架中间件有什么不同？
> 中间件： app.use方法就是往中间件队列中塞入新的中间件，express中间件处理方式是线性的，next过后继续寻找下一个中间件，当然如果没有调用next()的话，就不会调用下一个函数了，调用就会被终止。

- express 中间件：是通过 next 的机制，即上一个中间件会通过 next 触发下一个中间件
- koa2 中间件：是通过 async await 实现的，中间件执行顺序是“洋葱圈”模型（推荐）

1. 语法区别
experss 异步使用 回调
koa1 异步使用 generator + yield
koa2 异步使用 await/async

2. 中间件区别
koa采用洋葱模型，进行顺序执行，出去反向执行，支持context传递数据
express本身无洋葱模型，需要引入插件，不支持context
express的中间件中执行异步函数，执行顺序不会按照洋葱模型，异步的执行结果有可能被放到最后，response之前。

3. 集成度区别
express 内置了很多中间件，集成度高，使用省心，
koa 轻量简洁，容易定制

## koa2和egg的区别
- egg是在koa2上的封装
- egg有controller、service、router
- egg约定了文件目录结构

## 什么是模版引擎？
> 模板引擎是一个通过结合页面模板、要展示的数据生成HTML页面的工具，本质上是后端渲染（SSR）的需求，加上Node渲染页面本身是纯静态的，当我们需要页面多样化、更灵活，我们就需要使用模板引擎来强化页面，更好的凸显服务端渲染的优势。

常见主流模版引擎有：

- art-template [官方文档](http://aui.github.io/art-template/) ：号称效率最高的，模版引擎
- ejs  [官方文档](https://ejs.co/)：是一个JavaScript模板库，用来从JSON数据中生成HTML字符串。
- pug [官方文档](https://pugjs.org/api/getting-started.html)：是一款健壮、灵活、功能丰富的模板引擎，专门为 Node.js 平台开发

[Node.js入门教程](https://github.com/cosyer/node-learn)
