---
title: babel的.babelrc配置
tags:
  - 整理
copyright: true
comments: true
date: 2018-10-29 17:09:30
categories: 知识
photos:
top: 113
---

> Babel 是一个工具链，主要用于将 ECMAScript 2015+ 版本的代码转换为向后兼容的 JavaScript 语法，以便能够运行在当前和旧版本的浏览器或其他环境中。Babel 内部所使用的语法解析器是 Babylon

一个基本的.babelrc 配置:

```javascript
{
  "presets": [
    "env",
    "stage-0"
  ],
  "plugins": ["transform-runtime"]
}
```

---

<!-- more -->

### presets env

presets 是 babel 的一个预设，使用的时候需要安装对应的插件，对应 babel-preset-xxx，例如下面的配置，需要 npm install babel-preset-env

> 每年每个 preset 只编译当年批准的内容。 而 babel-preset-env 相当于 es2015 ，es2016 ，es2017 及最新版本。

```javascript
{
  "presets": ["env"]
}
```

### presets stage

stage 代表着 ES 提案的各个阶段，一共有 5 个阶段，存在依赖关系。也就是说 stage-1 是包括 stage-0 的，以此类推：

- Stage 0 - 稻草人: 只是一个想法，可能是 babel 插件。
- Stage 1 - 提案: 初步尝试。
- Stage 2 - 初稿: 完成初步规范。
- Stage 3 - 候选: 完成规范和浏览器初步实现。
- Stage 4 - 完成: 将被添加到下一年度发布。

### plugins

presets，是 plugins 的预设，起到方便设置的作用。如果不采用 presets，可以使用 plugins

```javascript
{
  "plugins": ["transform-es2015-arrow-functions"] // 也可以预设babel-preset-es2015
}
```

### 自定义预设和插件

3 种方式设置都 ok

```javascript
"plugins": ["babel-plugin-myPlugin"]
"plugins": ["myPlugin"]
"plugins": ["./node_modules/asdf/plugin"]。
// presets同理。
```

### plugins/presets 排序

- plugins 会运行在 presets 之前。
- plugins 会从第一个开始顺序执行。
- presets 的顺序则刚好相反(从最后一个逆序执行)。

### babel-polyfill

`babel`本身只提供预发的转换，当我们使用一些箭头函数这样的新的语法，其实在 babel 看来，更像是一种语法糖。
但是 babel 不能转义一些 ES6、ES7...的新的全局属性，例如 Promise 、新的原生方法如 String.padStart (left-pad) 等。
这个时候我们就需要使用 babel-polyfill。
