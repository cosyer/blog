---
title: Rollup使用教程
tags:
  - 知识
copyright: true
comments: true
date: 2022-7-25 19:50:40
categories: 知识
top: 105
photos:
---

> Rollup 是一个 JavaScript 模块打包器，可以将小块代码编译成大块复杂的代码，例如 library 或应用程序。Rollup 对代码模块使用新的标准化格式，这些标准都包含在 JavaScript 的 ES6 版本中，而不是以前的特殊解决方案，如 CommonJS 和 AMD。ES6 模块可以使你自由、无缝地使用你最喜爱的 library 中那些最有用独立函数，而你的项目不必携带其他未使用的代码。ES6 模块最终还是要由浏览器原生实现，但当前 Rollup 可以使你提前体验。

`总而言之，rollup非常适合构建类库/工具包`

## 安装
```bash
# 编译的核心模块
npm i -D rollup
# rollup的ES6编译插件 简化版的babel
npm i -D @rollup/plugin-buble

# 官方babel ES6编译插件
npm i -D @rollup/plugin-babel
npm i -D @babel/core
npm i -D @babel/preset-env

# 编译本地开发服务插件
npm i -D rollup-plugin-serve

# 代码混淆插件
npm i -D rollup-plugin-uglify
```

## 开发模式
1. 本地开发的HTTP服务
2. 生成开发调试的sourceMap文件
3. 不能混淆，保证编译后代码的可读性

## 生产模式
1. 保证代码混淆，编译结果不可读
2. 体积压缩
3. 信息脱敏

## 模块化规范
一般项目中的js文件都有IIFE, AMD, CommonJS，UMD，四种模块化格式，具体的解释如下

- IIFE Imdiately Invoked Function Expression 立即执行函数
- AMD Asynchronous Module Definition 异步模块规范
- CommonJS CommonJS规范，是Node.js的官方模块化规范
- UMD， Universal Module Definition 通用模块规范

### AMD
`AMD`  规范就是模块定义注册到缓存中，通过沙箱化和模块化去使用和执行

```js
// 定义模块
define('module-01', function () {
  return {
    init() {
      console.log('hello')
    }
  }
})

// 自执行模块
define(['module-01'], function(mod1) {
  mod1.init()
})
```