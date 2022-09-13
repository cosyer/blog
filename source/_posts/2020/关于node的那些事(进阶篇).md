---
title: 关于node的那些事(进阶篇)
tags:
  - NodeJS
copyright: true
comments: true
date: 2020-07-02 00:31:02
categories: Node
photos:
---

## 👨 提问：注册路由时 app.get、app.use、app.all 的区别是什么？

### app.use(path,callback)

> app.use 是 express 用来调用中间件的方法。中间件通常不处理请求和响应，一般只处理输入数据，并将其交给队列中的下一个处理程序，比如下面这个例子 app.use
> ('/user')，那么只要路径以 /user 开始即可匹配，如 /user/tree 就可以匹配。

### app.all()

> app.all 是路由中指代所有的请求方式，用作路由处理，匹配完整路径，在 app.use 之后可以理解为包含了 app.get、app.post 等的定义，比如 app.all('/
> user/tree'),能同时覆盖：get('/user/tree') 、 post('/user/tree')、 put('/user/tree') ,不过相对于 app.use()的前缀匹配，它则是匹配具体的路
> 由。

`all完整匹配，use只匹配前缀`

---

<!--more-->

## express response 有哪些常用方法?

express response 对象是对 Node.js 原生对象 ServerResponse 的扩展，express response 常见的有：res.end()、res.send()、res.render()、res.
redirect()，而这几个有什么不同呢？更多请看文档[express Response](https://www.expressjs.com.cn/4x/api.html#res)

### res.end()

结束 response - 如果服务端没有数据回传给客户端则可以直接用 res.end 返回，以此来结束响应过程。

### res.send(body)

如果服务端有数据可以使用 res.send,可以忽略 res.end，body 参数可以是一个 Buffer 对象，一个 String 对象或一个 Array。

### res.render

res.render 用来渲染模板文件，也可以结合模版引擎来使用，下面看个简单的 demo (express+ejs 模版引擎)

[node-ejs](http://cdn.mydearest.cn/blog/images/node-ejs.png)

- 配置

```js
app.set("views", path.join(__dirname, "views")); // views：模版文件存放的位置，默认是在项目根目录下
app.set("view engine", "ejs"); // view engine：使用什么模版引擎
```

其次是根据使用的模版引擎语法编写模版，最后通过 res.render(view,locals, callback)导出，具体使用参数

```
view：模板的路径
locals：渲染模板时传进去的本地变量
callback：如果定义了回调函数，则当渲染工作完成时才被调用，返回渲染好的字符串（正确）或者错误信息 ❌
```

### res.redirect

重定义到 path 所指定的 URL，同时也可以重定向时定义好 HTTP 状态码（默认为 302）

```js
res.redirect("http://baidu.com");
res.redirect(301, "http://baidu.com");
```

## node 如何利用多核 CPU 以及创建集群?

众所周知，nodejs 是基于 chrome 浏览器的 V8 引擎构建的，一个 nodejs 进程只能使用一个 CPU(一个 CPU 运行一个 node 实例)，举个例子：我们现在有一台 8 核的服务器，
那么如果不利用多核 CPU，是很一种浪费资源的行为，这个时候可以通过启动多个进程来利用多核 CPU。

Node.js 给我们提供了 cluster 模块，用于 nodejs 多核处理，同时可以通过它来搭建一个用于负载均衡的 node 服务集群。创建多进程。

> 本质还是通过 child_process.fork() 专门用于衍生新的 Node.js 进程,衍生的 Node.js 子进程独立于父进程，但两者之间建立的 IPC 通信通道除外， 每
> 个进程都有自己的内存，带有自己的 V8 实例

```js
const cluster = require("cluster");
const os = require("os");
const express = require("express");
const path = require("path");
const ejs = require("ejs");
const app = express();

const numCPUs = os.cpus().length;

if (cluster.isMaster) {
  for (let i = 0; i < numCPUs.length; ++i) {
    cluster.fork();
  }
  cluster.on("exit", (worker, code, signal) => {
    console.log(`worker ${worker.process.pid} died`);
  });
} else {
  app.listen(3000, function () {
    console.log(`worker ${worker.process.pid} started`);
  });
}
// 一个端口被多个进程监听
```

```bash
lsof -i -P -n | grep 3000
ps -ef | grep pid
```

## 开启多个子线程

```js
const {
  Worker,
  isMainThread,
  parentPort,
  workerData,
} = require("worker_threads");
const worker = new Worker(__filename, {
  workerData: script,
});
```

- 线程间如何传输数据: parentPort postMessage on 发送监听消息
- 共享内存： SharedArrayBuffer 通过这个共享内存

- 在服务中若需要执行 shell 命令，那么就需要开启一个进程

```js
var exec = require("child_process").exec;
exec("ls", function (error, stdout, stderr) {
  if (error) {
    console.error("error: " + error);
    return;
  }
  console.log("stdout: " + stdout);
});
```

## node 是怎样支持 https?

https 实现，离不开证书，通过 openssl 生成公钥私钥（不做详细介绍），然后基于 express 的 https 模块 实现，设置 options 配置, options 有两个选项，一个是
证书本体，一个是密码。

## node 和客户端怎么解决跨域的问题？

app.all('\*',(req,res,next)=>{}) 效果相当于 app.use((req,res,next)=>{}), 这也是 app.all 的一个比较常见的应用，就是用来处理跨域请求。

```js
app.all("*", function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  res.header("Access-Control-Allow-Methods", "PUT, POST, GET, DELETE, OPTIONS");
  res.header("Content-Type", "application/json;charset=utf-8");
  if (req.method == "OPTIONS") {
    res.send(200);
  } else {
    next();
  }
});
```

- cors 模块

## 两个 node 程序之间怎样交互?

通过 fork，原理是子程序用 process.on 来监听父程序的消息，用 process.send 给父程序发消息，父程序里用 child.on,child.send 进行交互，来实现父进程和子
进程互相发送消息。

> child-process 和 process 的 stdin,stdout,stderror 是一样的吗?概念都是一样的，输入，输出，错误，都是流．区别是在父程序眼里，子程序的 stdout 是输入流，stdin 是输出流

## 执行中间件（洋葱模型）

我们通过 use 注册中间件，中间件函数有两个参数第一个是上下文，第二个是 next，在中间件函数执行过程中，若遇到 next() ，那么就会进入到下一个中间件中执
行，下一个中间执行完成后，在返回上一个中间件执行 next() 后面的方法，这便是中间件的执行逻辑。

## 介绍下 stream

流在 nodejs 用的很广泛，但对于大部分开发者来说，更多的是使用流，比如说 HTTP 中的 request respond ，标准输入输出，文件读取
（createReadStream）， gulp 构建工具等等。
流，可以理解成是一个管道，比如读取一个文件，常用的方法是从硬盘读取到内存中，在从内存中读取，这种方式对于小文件没问题，但若是大文件，效率就非常低，还有
可能内存不足，采用流的方式，就好像给大文件插上一根吸管，持续的一点点读取文件的内容，管道的另一端收到数据，就可以进行处理，了解 Linux 的朋友应该非常熟
悉这个概念。

- Node.js 中有四种基本的流类型：

1. Writable - 可写入数据的流（例如 fs.createWriteStream()）。
2. Readable - 可读取数据的流（例如 fs.createReadStream()）。
3. Duplex - 可读又可写的流（例如 net.Socket）。
4. Transform - 在读写过程中可以修改或转换数据的 Duplex 流（例如 zlib.createDeflate()）。接触比较多的还是第一二种 pipe 来消费可读流

```js
const fs = require("fs");
// 直接读取文件
fs.open("./xxx.js", "r", (err, data) => {
  if (err) {
    console.log(err);
  }
  console.log(data);
});
// 流的方式读取、写入
let readStream = fs.createReadStream("./a.js");
let writeStream = fs.createWriteStream("./b.js");
readStream
  .pipe(writeStream)
  .on("data", (chunk) => {
    // 可读流被可写流消费
    console.log(chunk);
    writeStream.write(chunk);
  })
  .on("finish", () => console.log("finish"));
```

## ORM库防止SQL注入的漏洞
- TypeORM
- Sequelize
- Mongoose
