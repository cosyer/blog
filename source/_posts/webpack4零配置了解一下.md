---
title: webapck4零配置了解一下
tags:
  - 整理
copyright: true
comments: true
date: 2018-11-26 09:55:40
categories: 知识
photos:
top: 123
---

webpack4 最主要的卖点便是零配置，要想成为一位webpack配置工程师怎么能不开始了解呢？话不多说，让我们开始体验 webpack 4 的一些特性。

### entry 和 output
1. 创建空目录，初始化配置
```bash
mkdir webpack4-quickstart
cd  webpack4-quickstart
npm init -xyz
```

2. 安装相关依赖
```bash
npm i webpack --save-dev
npm i webpack-cli --save-dev
```

- webpack： 即 webpack 核心库。它提供了很多 API, 通过 Node.js 脚本中 require('webpack') 的方式来使用 webpack。
- webpack-cli：是 webpack 的命令行工具。webpack 4 之前命令行工具是集成在 webpack 包中的，4.0 开始 webpack 包本身不再集成 cli。

3. package.json添加构建命令
```javascript
"scripts":{
    "build":"webpack"
}
```
---
<!-- more -->

- 如果直接开始运行`npm run build`会因为缺少指定的默认目录的文件导致抛出错误
- 添加入口文件 
```javascript
// ./src/index.js
console.log("hello world")
```
- 再执行`npm run build`，则默认生成了'./dist/main.js'文件

### development和production模式
在webpack 4 以前，拥有2份配置文件是webpack项目常见的情况，一个常规的项目配置可能是这样的：

> 一份开发环境的配置，用来配置 dev server 和其他的一些东西
> 一份生产环境的配置，配置一些 UglifyJSPlugin、sourcemaps 等等
但是在webpack 4中，我们可以通过设置命令行参数production和development来区分环境：

```json
"scripts": {
  "dev": "webpack --mode development",
  "build": "webpack --mode production"
}
```

分别执行`npm run dev`和`npm run build`会发现第二种执行的代码被压缩了。

> Development mode 则是在速度上进行了优化，只不过不会提供压缩功能。
> Production mode 可以实现各种优化，包括 代码压缩、tree-shaking...

### 脚本中覆盖默认的入口和出口
```json
"scripts": {
  "dev": "webpack --mode development ./entry/index.js --output ./output/main.js",
  "build": "webpack --mode production ./entry/index.js --output ./output/main.js"
}
```

### babel插件配置es6->es5

1. 插件依赖
> babel-core
> babel-loader
> babel-preset-env 编译 ES6 -> ES5 
```javascript
npm i babel-core babel-loader babel-preset-env --save-dev
```

2. 通过`./babelrc`来配置相关插件
```json
{
    "presets":[
        "env"
    ]
}
```

3. 2种方式来配置`babel-loader`
> webpack.config.js配置
```javascript
module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  }
};
```
> 脚本命令配置 --module-bind
```json
"scripts": {
    "dev": "webpack --mode development --module-bind js=babel-loader",
    "build": "webpack --mode production --module-bind js=babel-loader"
  }
```

### 最小化js文件
> config.optimization.minimize(true)

### 图片资源压缩
```js
config.module
  .rule('images')
  .use('image-webpack-loader')
  .loader('image-webpack-loader')
  .options({
    bypassOnDebug: true
  })
  .end()
```

这里只是简单的介绍，想要详细的了解webpack4的新特性请访问[github地址](https://github.com/cosyer/webpack4)。
