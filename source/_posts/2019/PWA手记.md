---
title: PWA手记
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-05-26 21:18:30
categories: JS
photos:
top: 220
---

PWA作为2018最火热的技术概念之一，对提升Web应用的安全、性能和体验有着很大的意义，非常值得我们去了解与学习。

PWA是Progressive Web App的英文缩写，也就是渐进式增强WEB应用。目的就是在移动端利用提供的标准化框架，在网页应用中实现和原生应用相近的用户体验。

一个 PWA 应用首先是一个网页, 可以通过 Web 技术编写出一个网页应用. 随后添加上 App Manifest 和 Service Worker 来实现 PWA 的

安装和离线等功能。

我们需要理解的是，PWA不是某一项技术，或者某一个新的产物；而是一系列Web技术与标准的集合与应用。通过应用这些新的技术与标准，可以从安

全、性能和体验三个方面，优化我们的Web App。所以，其实PWA本质上依然是一个Web App。
---
<!--more-->

## 核心技术

- Service Worker （可以理解为服务工厂）

- Manifest （应用清单）

- Push Notification（推送通知）

## service worker (web worker)
- 一个独立的 worker 线程，独立于当前网页进程，有自己独立的 worker context。
- 一旦被 install，就永远存在，除非被 uninstall
- 需要的时候可以直接唤醒，不需要的时候自动睡眠（有效利用资源）
- 可编程拦截代理请求和返回，缓存文件，缓存的文件可以被网页进程取到（包括网络离线状态）
- 不能直接操作DOM出于安全的考虑，必须在 HTTPS 环境下才能工作
- 异步实现，内部大都是通过 Promise 实现

web worker
web worker  是运行在后台的JavaScript，独立于其他脚本，不会影响页面的性能。

应用场景：处理密集型数学计算、大数据集排序、数据处理(压缩、音频分析、图像处理等)、高流量网络通信

浏览器一般有三类 web Worker

- Dedicated Worker ：专用的 worker，只能被创建它的 JS 访问，创建它的页面关闭，它的生命周期就结束了。

- Shared  Worker ：共享的 worker，可以被同一域名下的 JS 访问，关联的页面都关闭时，它的生命周期就结束了。

- Service Worker ：是事件驱动的 worker，生命周期与页面无关，关联页面未关闭时，它也可以退出，没有关联页面时，它也可以启动。SW 作用于浏览器与服务器之间，相当于一个代理服务器。

### Service Worker生命周期 
看成红绿灯
红 下载和解析
黄 正在执行 还没准备好
绿 随时可使用
且第一次加载页面 sw还没有激活 不会处理任何请求 只有安装和激活后才能使用。（刷新页面和跳转新页面才会生效）

- 步骤
1. 用户导航到url
2. 注册sw 过程中浏览器下载解析执行sw
3. 一旦执行激活安装时间
4. 安装成功就可以控制客户端功能事件

### 全局变量
- self: 表示 Service Worker 作用域, 也是全局变量
SW 的默认作用域为基于当前文件 URL 的 ./。意思就是如果你在//example.com/foo/bar.js里注册了一个 SW，那么它默认的作用域为 //example.com/foo/。

通过查看navigator.serviceWorker.controller是否为 null 来查看一个client是否被 SW 控制。
- caches: 表示缓存
- skipWaiting: 表示强制当前处在 waiting 状态的脚本进入 activate 状态（为了在页面更新的过程当中，新的 SW 脚本能够立刻激活和生效。无需刷新或者跳转新页面。）
- clients: 表示 Service Worker 接管的页面
- clients.claim() 在 activate 事件回调中执行该方法表示取得页面的控制权, 这样之后打开页面都会使用版本更新的缓存。旧的 Service Worker 脚本不再控制着页面，之后会被停止。

### Service Worker 注册
```js
// 检查当前浏览器是否支持sw
if ('serviceWorker' in navigator) {
    // 如果支持开始注册sw
    navigator.serviceWorker
        .register('./service-worker.js')
        .then(registration => { 
            console,log('注册成功', registration)
            // 消息推送 获取授权
            // Notification.requestPermission(function(result) {
            //         console.log('result', result)
            //         if (result === 'granted') {
            //             registration.showNotification('Vibration Sample', {
            //                 body: 'Buzz! Buzz!',
            //                 icon: './img/mario.png',
            //                 vibrate: [200, 100, 200, 100, 200, 100, 200],
            //                 tag: 'vibration-sample'
            //             });
            //         } else {
            //             alert(result);
            //         }     
            // });
            // 手动更新
            // registration.update();
        })
        .catch(err => console.log('注册失败',err));
}
// 查看是否注册成功可以在 PC 上chrome 浏览器, 输入 chrome://inspect/#service-workers
```

### Service Worker 安装（处理静态缓存）

1. 这个状态发生在 Service Worker 注册之后，是 sw 触发的第一个事件并且只触发一次。表示开始安装，触发 install 事件回调指定一些静态资源进行离线缓存。修改你的 SW 后，浏览器会认为这是一个新的 SW，从而会再触发这个新 SW 的install事件。

2. e.waitUntil() 传入一个 Promise 为参数，等到该 Promise 为 resolve 状态为止。如果 Promise 被拒绝，则安装失败，SW会进入 Redundant（ 废弃 ）状态。确保 Service Worker 不会在 waitUntil() 里面的代码执行完毕之前安装完成。

3. sw 在安装成功和激活之前不会触发任何的 fetch 或 push 等事件。

4. 默认情况下，页面的请求（fetch）不会通过 SW，除非它本身是通过 SW 获取的，也就是说，在安装 SW 之后，需要刷新页面才能有效果。

5. clients.claim()可以改变这种默认行为。

localStorage 的用法和 Service Worker cache 的用法很相似，但是由于 localStorage 是同步的用法，所以不允许在 Service Worker 中使用。 IndexedDB 也可以在 Service Worker 内做数据存储。

```js
// 首先定义需要缓存的路径, 以及需要缓存的静态文件的列表。
var cacheName = 'minimal-pwa-1'

var cacheList = [
  '/',
  "index.html",
  "main.css",
  "e.png"
]
self.addEventListener('install', e => {
    console.log("安装事件，注册后触发只触发一次");
    e.waitUntil(
        // 使用指定的缓存名来打开缓存
        caches.open(cacheName)
            .then(cache => {
                console.log("加入缓存", cacheList);
                return cache.addAll(cacheList);
            })
            // 可加
            .then(() => {
                console.log('跳过等待')
                return self.skipWaiting()
            })
    );
});
// self.oninstall = e => {}
```

###  Service Worker 激活（更新缓存）

在这个状态下没有被其他的 Service Worker 控制的客户端，允许当前的 worker 完成安装，并且清除了其他的 worker 以及关联缓存的旧缓存资源，等待新的 Service Worker 线程被激活。

```js
// 激活 缓存更新
self.addEventListener('activate', e => {
    console.log('[ServiceWorker] Activate');
    e.waitUntil(
        caches.keys()
            .then(keyList => Promise.all(keyList.map(key => {
                if (key !== cacheName) {
                    console.log('移除旧缓存', key);
                    return caches.delete(key);
                }
            })))
            // 可加
            .then(() => {
            return self.clients.matchAll()
                .then(clients => {
                if (clients && clients.length) {
                    clients.forEach((v,i) => {
                        // 发送字符串'sw.update'
                        v.postMessage('sw '+i+' update')
                    })
                }
                })
            })
            // return self.clients.claim();
    );
    // return self.clients.claim();
});
```

### 已激活 （activated）

在这个状态会处理 activate 事件回调 (提供了更新缓存策略的机会)。并可以处理功能性的事件 fetch (请求)、 sync (后台同步)、 push (推送)。

### 废弃 （redunant）

这个状态表示一个 Service Worker 的生命周期结束。

这里特别说明一下，进入废弃 (redundant) 状态的原因可能为这几种：

- 安装 (installing) 失败

- 激活 (activating) 失败

- 新版本的 Service Worker 替换了它并成为激活状态

### 处理动态缓存
监听捕获 fetch 事件，在 caches 中去 match 事件的 request ，如果 response 不为空的话就返回 response ，最后返回 fetch 请求，在 fetch 事件中我们也可以手动生成 response 返回给页面。
```js
// 捕获请求
self.addEventListener('fetch', e => {
    console.log('fetch事件', e.request.url);
    e.respondWith(
        caches.match(e.request)
            .then(response => response || fetch(e.request))
    );
    // e.respondWith(
    //     caches.match(e.request)
    //         .then(response => {
    //             if(response) {
    //                 return response; // || fetch(e.request)
    //             }
    //             // 新的内容添加到缓存中
    //             // 复制请求 请求是一个流 只能使用一次
    //             var requestToCache = e.request.clone();
    //             return fetch(requestToCache).then(function(response){
    //                 if(!response || response.status !==200) {
    //                     // 错误信息立即返回
    //                     return response;
    //                 }
    //                 var responseToCache = response.clone();
    //                 // 将响应添加到缓存中
    //                 caches.open(cacheName).then(function (cache){
    //                     cache.put(requestToCache, responseToCache);
    //                 })
    //             })
    //         }) 
    // );

    // 自定义响应
    // e.respondWith(new Response('<p>it is a response</p>', {
    //     headers:{
    //         'Content-Type': 'text/html'
    //     }
    // }))
});
```

通过存放到 Cache Storage 中，我们下次访问的时候如果是弱网或者断网的情况下，就可以不走网络请求，而直接就能将本地缓存的内容展示给用户，优化用户的弱网及断网体验。

两种方式的比较

- on install 的优点是第二次访问即可离线，缺点是需要将需要缓存的 URL 在编译时插入到脚本中，增加代码量和降低可维护性；

- on fetch 的优点是无需更改编译过程，也不会产生额外的流量，缺点是需要多一次访问才能离线可用。

### Service Worker 调试

- 借助 Chrome 浏览器 debug
使用 Chrome 浏览器，可以通过进入控制台 Application -> Service Workers 面板查看和调试。

- 查看缓存
Service Worker 使用 Cache API 缓存只读资源，可以在 Chrome DevTools 上查看缓存的资源列表。

http缓存：由服务器告知资源何时缓存和何时过期。sw缓存是对http缓存的增强

### Service Worker 网络跟踪
经过 Service Worker 的 fetch 请求 Chrome 都会在 Chrome DevTools Network 标签页里标注出来，其中：

- 来自 Service Worker 的内容会在 Size 字段中标注为 from ServiceWorker

- Service Worker 发出的请求会在 Name 字段中添加 ‘齿轮’ 图标。

### Service Worker 功能性事件

- fetch (请求)：当浏览器在当前指定的 scope 下发起请求时，会触发 fetch 事件，并得到传有 response 参数的回调函数，回调中就可以做各种代理缓存的事情了。

- push (推送)：push 事件是为推送准备的。不过首先需要了解一下 Notification API 和 PUSH API。通过 PUSH API，当订阅了推送服务后，可以使用推送方式唤醒 Service Worker 以响应来自系统消息传递服务的消息，即使用户已经关闭了页面。

- sync (后台同步)：sync 事件由 background sync (后台同步)发出。background sync 配合 Service Worker 推出的 API，用于为 Service Worker 提供一个可以实现注册和监听同步处理的方法。但它还不在 W3C Web API 标准中。在 Chrome 中这也只是一个实验性功能，需要访问 chrome://flags/#enable-experimental-web-platform-features ，开启该功能，然后重启生效。

## APP Manifest 与添加到主屏幕

允许将站点添加至主屏幕，是 PWA 提供的一项重要功能

1. 定义 manifest.json 配置添加到主屏幕功能

2. 创建 manifest.json 文件，并将它放到你的站点目录中

3. 在所有页面引入该文件

4. 可以在 Service Worker 中监听 beforeinstallprompt 事件做一些应用内的行为处理

```js
{ 
    "name" : "Minimal PWA" , 
    "short_name" : "PWA Demo" , 
    "display" : "standalone" , 
    "start_url" : "/" , 
    "theme_color" : "#313131" , 
    "background_color" : "#313131" , 
    "icons" : [ 
        { 
        "src" : "e.png" , 
        "sizes" : "256x256" , 
        "type" : "image/png" 
        } 
    ] 
}
```

- name ：定义此PWA的名称。

- icons ：定义一系列的图标以适应不同型号的设备。

- theme_color ：主题颜色（影响手机状态栏颜色）。

- background_color ：背景颜色。

- start_url ：启动地址。由于PWA实际上是一个web页面，所以需要定义PWA 在启动时应该访问哪个地址。

- display ："standalone"表示其以类似原生APP的全屏方式启动。

### IOS Safari 设置
```js
应用图标： 
<link rel="apple-touch-icon" href="apple-touch-icon.png" > 
启动画面： 
<link rel="apple-touch-startup-image" href="launch.png" > 
应用名称： 
<meta name="apple-mobile-web-app-title" content="Todo-PWA" > 
全屏效果： 
<meta name="apple-mobile-web-app-capable" content="yes" > 
设置状态栏颜色： 
<meta name="apple-mobile-web-app-status-bar-style" content="#fff" >
```

### window10 贴片图标
```js
<meta name="msapplication-TileImage" content="images/logo/144x144.png" > 
<meta name="msapplication-TileColor" content="#2F3BA2" >
```

### 在线生成 manifest.json 文件

- https://app-manifest.firebaseapp.com/

- https://tomitm.github.io/appmanifest/

- https://brucelawson.github.io/manifest/

### 参考资料

1. [Web App Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)

2. [manifest.json 简介](https://lavas.baidu.com/doc/engage-retain-users/add-to-home-screen/introduction)

## App Shell

App Shell，顾名思义，就是`壳`的意思，也可以理解为`骨架屏`，说白了就是在内容尚未加载完全的时候，优先展示页面的结构、占位图、主题和背景颜色等，它们都是一些被强缓存的html，css和javascript。

要用好App Shell，就必须保证这部分的资源被Service Worker缓存起来。我们在组织代码的时候，可以优先完成App Shell的部分，然后把这部分代码分别打包构建出来。

### 优势

- 始终快速的可靠性能

- 如同本机一样的交互

- 数据的经济使用

### 参考资料

1. [App Shell 模型](https://developers.google.cn/web/fundamentals/architecture/app-shell)

## 使用Offine-Plugin把网站升级成 PWA

### 参考资料

1. [offline-plugin](https://github.com/NekR/offline-plugin)

2. [offline-plugin DEMO](https://offline-plugin.now.sh)

3. [使用offline-plugin搭配webpack轻松实现PWA](https://segmentfault.com/a/1190000010669126)

## 与PWA相关的开源框架

### Lavas

基于 Vue 的 PWA 解决方案，帮助开发者快速搭建 PWA 应用，解决接入 PWA 的各种问题

1. [Lavas 官 网](https://lavas.baidu.com/)

2. [Lavas GitHub](https://github.com/lavas-project/lavas)

### 加载库
importScripts() // sw里的全局函数
```js
importScripts('workbox-sw.prod.v1.1.0.js');

const workboxSW = new self.WorkboxSW();

workbox.precaching([
  // 注册成功后要立即缓存的资源列表
]);

// html的缓存策略
workbox.routing.registerRoute(
  new RegExp(''.*\.html'),
  workbox.strategies.networkFirst()
);

workbox.routing.registerRoute(
  new RegExp('.*\.(?:js|css)'),
  workbox.strategies.cacheFirst()
);

workbox.routing.registerRoute(
  new RegExp('https://your\.cdn\.com/'),
  workbox.strategies.staleWhileRevalidate()
);

workbox.routing.registerRoute(
  new RegExp('https://your\.img\.cdn\.com/'),
  workbox.strategies.cacheFirst({
    cacheName: 'example:img'
  })
);
```
通过 workbox.precaching 中的是 install 以后要塞进 caches 中的内容，workbox.routing.registerRoute 中第一个参数是一个正则，匹配经过 fetch 事件的所有请求，如果匹配上了，就走相应的缓存策略。

## 注意事项
- 避免改变 SW 的 URL（对index.html做了缓存，这样永远拿不到新的sw）