---
title: react SSR教程
tags:
  - 解决方案
copyright: true
comments: true
date: 2020-06-10 22:55:08
categories: React
photos:
---

# 前言

本文是基于react ssr的入门教程，在实际项目中使用还需要做更多的配置和优化，比较适合第一次尝试react ssr的小伙伴们。技术涉及到 koa2 + react，案例使用create-react-app创建。

## 客户端渲染与服务端渲染

### 客户端渲染
+ 客户端渲染，实际上就是客户端向服务端请求页面，服务端返回的是一个非常简单的 HTML 页面，在这个页面里，只有很少的一些 HTML 标签
+ 客户端渲染时，页面中有两个比较重要的点，第一个是 script 标签，可能会有好几个 script 标签，这个标签是打包后的 js 代码，用来生成 DOM 元素，发送请求，事件绑定等。但是，生成的 DOM 元素需要有一个在页面上展示的容器，所以另外一个点就是容器，一般是一个 id 名为 root 或 app 的 div 标签，类似于这样 `<div id="root"></div>` 或`<div id="app"></div>`
+ 客户端渲染的特点
  + 客户端加载所有的 js 资源，渲染 DOM 元素
  + 在浏览器页面上的所有资源，都由客户端主动去获取，服务端只负责静态资源的提供和 API 接口，不再负责页面的渲染，如果采用 CDN 的话，服务端仅仅需要提供 API 接口
  + 优点: 前后端分离，责任区分，前端专注页面的开发，后端专注接口的开发
  + 缺点: 首屏加载资源多，首屏加载时响应慢。页面上没有 DOM 元素，不利于 SEO 优化

### 服务端渲染
+ 服务端渲染，就是客户端页面上的 HTML 元素，都要由服务端负责渲染。服务端利用模板引擎，把数据填充到模板中，生成 HTML 字符串，最终把 HTML 字符串返回到浏览器，浏览器接收到 HTML 字符串，通过 HTML 引擎解析，最终生成 DOM 元素，显示在页面上
+ 比如 Node.js 可以渲染的模板引擎有 ejs，nunjucks，pug 等。Java 最常见的是 JSP 模板引擎。Python 最常见的是 Jinja2 模板引擎。
+ 服务端渲染的特点
  + 优点: 页面资源大多由服务端负责处理，所以页面加载速度快，缩短首屏加载时间。有利于 SEO 优化。无需占用客户端资源
  + 缺点: 不利于前后端分离，开发效率低。占用服务器资源

### 区分与选择
+ 客户端渲染和服务端渲染本质的区别就是，是谁负责 HTML 页面的拼接，那么就是谁渲染的页面
+ 如果对首屏加载时间有非常高的需求，或者是需要 SEO 优化，那么就选择服务端渲染
+ 如果对首屏加载时间没有要求，也不需要做 SEO 优化，类似于做后台管理系列的业务，那么就可以选择客户端渲染
+ 具体选择客户端渲染还是服务端渲染，没有强制的要求，具体要根据项目的需求来区分选择

---
<!--more-->

## SSR 介绍
Server Slide Rendering，缩写为 **ssr** 即服务器端渲染，这个要从SEO说起，目前react单页应用HTML代码是下面这样的
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="shortcut icon" href="favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta name="theme-color" content="#000000" />
    <title>React App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
    <script src="/js/main.js"></script>
  </body>
</html>
```
1. 如果main.js 加载比较慢，会出现白屏一闪的现象。
2. 传统的搜索引擎爬虫因为不能抓取JS生成后的内容，遇到单页web项目，抓取到的内容啥也没有。在SEO上会吃很多亏，很难排搜索引擎到前面去。
React SSR（react服务器渲染）正好解决了这2个问题。

## React SSR介绍

这里通过一个例子来带大家入坑！先使用create-react-app创建一个react项目。因为要修改webpack，这里我们使用react-app-rewired启动项目。根目录创建一个server目录存放服务端代码，服务端代码我们这里使用koa2。

这里先来看看react ssr是怎么工作的。

![图片描述][1]

这个业务流程图比较清晰了，服务端只生成HTML代码，实际上前端会生成一份main.js提供给服务端的HTML使用。这就是react ssr的工作流程。有了这个图会更好的理解，如果这个业务没理解清楚，后面的估计很难理解。

> react提供的SSR方法有两个renderToString 和 renderToStaticMarkup，区别如下：

- renderToString 方法渲染的时候带有 data-reactid 属性. 在浏览器访问页面的时候，main.js能识别到HTML的内容，不会执行React.createElement二次创建DOM。
- renderToStaticMarkup 则没有 data-reactid 属性，页面看上去干净点。在浏览器访问页面的时候，main.js不能识别到HTML内容，会执行main.js里面的React.createElement方法重新创建DOM。适用于纯静态页面。

## 实现流程

```javascript
import "./App.css";

import React, { Component } from "react";

import logo from "./logo.svg";

class App extends Component {
  componentDidMount() {
    console.log('哈哈哈~ 服务器渲染成功了！');
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.js</code> and save to reload.
          </p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
        </header>
      </div>
    );
  }
}

export default App;
```

在项目中新建server目录，用于存放服务端代码。项目中我们用的ES6，所以还要配置下.babelrc

> .babelrc 配置，因为要使用到ES6
```json
{
    "presets": [
        "env",
        "react"
    ],
    "plugins": [
        "transform-decorators-legacy",
        "transform-runtime",
        "react-hot-loader/babel",
        "add-module-exports",
        "transform-object-rest-spread",
        "transform-class-properties",
        [
            "import",
            {
                "libraryName": "antd",
                "style": true
            }
        ]
    ]
}
```

> index.js 项目入口做一些预处理，使用asset-require-hook过滤掉一些类似 ```import logo from "./logo.svg";``` 这样的资源代码。因为我们服务端只需要纯的HTML代码，不过滤掉会报错。这里的name，我们是去掉了hash值的。

```javascript
require("asset-require-hook")({
  extensions: ["svg", "css", "less", "jpg", "png", "gif"],
  name: '/static/media/[name].[ext]'
});
require("babel-core/register")();
require("babel-polyfill");
require("./app");
```

> public/index.html html模版代码要做个调整，```{{root}}``` 这个可以是任何可以替换的字符串，等下服务端会替换这段字符串。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="shortcut icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta name="theme-color" content="#000000" />
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <title>React App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">{{root}}</div>
  </body>
</html>

```

> app.js 服务端渲染的主要代码，加载App.js，使用renderToString 生成html代码，去替换掉 index.html 中的 ```{{root}}``` 部分

```javascript
import App from '../src/App';
import Koa from 'koa';
import React from 'react';
import Router from 'koa-router';
import fs from 'fs';
import koaStatic from 'koa-static';
import path from 'path';
import { renderToString } from 'react-dom/server';

// 配置文件
const config = {
  port: 3030
};

// 实例化 koa
const app = new Koa();

// 静态资源
app.use(
  koaStatic(path.join(__dirname, '../build'), {
    maxage: 365 * 24 * 60 * 1000,
    index: 'root' 
    // 这里配置不要写成'index'就可以了，因为在访问localhost:3030时，不能让服务默认去加载index.html文件，这里很容易掉进坑。
  })
);

// 设置路由
app.use(
  new Router()
    .get('*', async (ctx, next) => {
      ctx.response.type = 'html'; //指定content type
      let shtml = '';
      await new Promise((resolve, reject) => {
        fs.readFile(path.join(__dirname, '../build/index.html'), 'utfa8', function(err, data) {
          if (err) {
            reject();
            return console.log(err);
          }
          shtml = data;
          resolve();
        });
      });
      // 替换掉 {{root}} 为我们生成后的HTML
      ctx.response.body = shtml.replace('{{root}}', renderToString(<App />));
    })
    .routes()
);

app.listen(config.port, function() {
  console.log('服务器启动，监听 port： ' + config.port + '  running~');
});

```

> config-overrides.js 因为我们用的是create-react-app，这里使用react-app-rewired去改下webpack的配置。因为执行**npm run build**的时候会自动给资源加了hash值，而这个hash值，我们在asset-require-hook的时候去掉了hash值，配置里面需要改下，不然会出现图片不显示的问题，这里也是一个坑，要注意下。

```javascript
module.exports = {
  webpack: function(config, env) {
    // ...add your webpack config
    // console.log(JSON.stringify(config));
    // 去掉hash值，解决asset-require-hook资源问题
    config.module.rules.forEach(d => {
      d.oneOf &&
        d.oneOf.forEach(e => {
          if (e && e.options && e.options.name) {
            e.options.name = e.options.name.replace('[hash:8].', '');
          }
        });
    });
    return config;
  }
};

```

好了，所有的代码就这些了，是不是很简单了？我们koa2读取的静态资源是 build目录下面的。先执行**npm run build**打包项目，再执行**node ./server** 启动服务端项目。看下
http://localhost:3030 页面的HTML代码检查下：

![图片描述][2]

没有```{{root}}```了，服务器渲染成功！

> 注: 这个项目只是用来学习 react 的服务端渲染，而非安利大家一定要使用服务端渲染，因为 react 和 vue 的服务端渲染和普通的服务端渲染有很多的不一样，所以可以学习一下，提高一下自己的水平。

## 代码仓库地址
[react-koa2-ssr](https://github.com/cosyer/react-koa2-ssr)

[1]: http://cdn.mydearest.cn/blog/images/react-ssr.png
[2]: http://cdn.mydearest.cn/blog/images/react-ssr-demo.png
