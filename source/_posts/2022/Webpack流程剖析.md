---
title: Webpack流程剖析
tags:
  - 打包
copyright: true
comments: true
date: 2022-02-17 10:05:32
categories: 工具
top: 108
photos:
---

## 背景
时至 5.0 版本之后，Webpack 的功能已变得非常强大，包括：模块打包、代码分割、按需加载、HMR、Tree-shaking、文件监听、sourcemap、Module 
Federation、devServer、DLL、多进程等等。这些导致了源码的阅读、分析、学习成本非常高，社区衍生出了各种手脚架，比如 vue-cli、
create-react-app等来解决“用”的问题。

但这又导致一个新的问题，大部分人在工程化方面逐渐变成一个配置工程师，停留在"会用会配"但是不知道黑盒里面到底是怎么转的阶段，遇到具体问题就瞎了：

- 想给基础库做个升级，出现兼容性问题跑不动了，直接放弃
- 想优化一下编译性能，但是不清楚内部原理，无从下手

究其原因还是对 webpack 内部运行机制没有形成必要的整体认知，无法迅速定位问题，今天和大家分享下对其内部原理的分析和探索。

## 基本概念
- Entry（入口）：Webpack 执行构建的第一步将从 Entry 开始，可抽象成输入

- Output（出口）：指示 webpack 如何去输出、以及在哪里输出

- Compiler（编译管理器）：webpack 启动后会创建 compiler 对象，该对象一直存活直到结束退出

- Compilation（单次编辑过程的管理器）：比如 watch = true 时，运行过程中只有一个 compiler 但每次文件变更触发重新编译时，都会创建一个新的 
compilation 对象

- Dependence（依赖对象）：webpack 基于该类型记录模块间依赖关系
 
- Module（模块）：在 Webpack 里一切皆模块，一个模块对应一个文件。Webpack从配置的 Entry 开始，递归找出所有依赖的模块
 
- Chunk（代码块）：一个 Chunk 由多个模块组合而成，用于代码合并与分割
 
- Loader（模块转换器）：用于将模块的原内容按照需求转换成新内容
 
- Plugin（扩展插件）：在 Webpack 构建流程中的特定时机会广播对应的事件，插件可以监听这些事件的发生，在特定的时机做对应的事情

首先我们需要知道 webpack 的核心功能就是将各种类型的资源，包括图片、css、js等，转译、组合、拼接、最终生成 JS 格式的 bundle 文件。

这个过程核心完成了 `内容转换 + 资源合并` 两种功能，实现上包含三个阶段：

1. 初始化阶段：

初始化参数：从配置文件、 配置对象、Shell 参数中读取，与默认配置进行合并最终打包配置参数
创建编译器对象：用上一步得到的参数创建 Compiler 对象， Compiler 负责文件监听和启动编译。在 Compiler 实例中包含了完整的 Webpack 配置，全局只
一个 Compiler 实例
初始化编译环境：包括注入内置插件、注册各种模块工厂、初始化 RuleSet 集合、加载配置的插件等
开始编译：执行 compiler 对象的 run 方法
确定入口：根据配置中的 entry 找出所有的入口文件，调用 compilation.addEntry 将入口文件转换为 dependence 对象

主要逻辑集中在 WebpackOptionsApply 类，webpack 内置了数百个插件，这些插件并不需要我们手动配置，WebpackOptionsApply 会在初始化阶段根据配置内容动态注入对应的插件，包括：

注入 EntryOptionPlugin 插件，处理 entry 配置
根据 devtool 值判断后续用那个插件处理 sourcemap，可选值：EvalSourceMapDevToolPlugin、SourceMapDevToolPlugin、EvalDevToolModulePlugin
注入 RuntimePlugin ，用于根据代码内容动态注入 webpack 运行时

2. 构建阶段：

编译模块(make)：根据 entry 对应的 dependence 创建 module 对象，调用 loader 将模块转译为标准 JS 内容，调用 JS 解释器将内容转换为 AST 对
象，从中找出该模块依赖的模块，再递归本步骤直到所有入口依赖的文件都经过了本步骤的处理

完成模块编译：上一步递归处理所有能触达到的模块后，得到了每个模块被翻译后的内容以及它们之间的依赖关系图

解释一下，构建阶段从入口文件开始：

调用 handleModuleCreate ，根据文件类型构建 module 子类
调用 loader-runner 仓库的 runLoaders 转译 module 内容，通常是从各类资源类型转译为 JavaScript 文本
调用 acorn 将 JS 文本解析为AST
遍历 AST，触发各种钩子
在 HarmonyExportDependencyParserPlugin 插件监听 exportImportSpecifier 钩子，解读 JS 文本对应的资源依赖
调用 module 对象的 addDependency 将依赖对象加入到 module 依赖列表中

AST 遍历完毕后，调用 module.handleParseResult 处理模块依赖
对于 module 新增的依赖，调用 handleModuleCreate ，控制流回到第一步
所有依赖都解析完毕后，构建阶段结束
这个过程中数据流 module => ast => dependences => module ，先转 AST 再从 AST 找依赖。这就要求 loaders 处理完的最后结果必须是可以被 acorn 处理的标准 JavaScript 语法，比如说对于图片，需要从图像二进制转换成类似于 export default "data:image/png;base64,xxx" 这类 base64 格式或者 export default "http://xxx" 这类 url 格式。

3. 生成阶段：

输出资源(seal)：根据入口和模块之间的依赖关系，组装成一个个包含多个模块的 Chunk，再把每个 Chunk 转换成一个单独的文件加入到输出列表，这步是可以修
改输出内容的最后机会

写入文件系统(emitAssets)：在确定好输出内容后，根据配置确定输出的路径和文件名，把文件内容写入到文件系统

构建本次编译的 ChunkGraph 对象；
遍历 compilation.modules 集合，将 module 按 entry/动态引入 的规则分配给不同的 Chunk 对象；
compilation.modules 集合遍历完毕后，得到完整的 chunks 集合对象，调用 createXxxAssets 方法
createXxxAssets 遍历 module/chunk ，调用 compilation.emitAssets 方法将 assets 信息记录到 compilation.assets 对象中
触发 seal 回调，控制流回到 compiler 对象
这一步的关键逻辑是将 module 按规则组织成 chunks ，webpack 内置的 chunk 封装规则比较简单：

entry 及 entry 触达到的模块，组合成一个 chunk
使用动态引入语句引入的模块，各自组合成一个 chunk
chunk 是输出的基本单位，默认情况下这些 chunks 与最终输出的资源一一对应，那按上面的规则大致上可以推导出一个 entry 会对应打包出一个资源，而通过动态引入语句引入的模块，也对应会打包出相应的资源


- chunk 是输出的基本单位，默认情况下这些 chunks 与最终输出的资源一一对应，那按上面的规则大致上可以推导出一个 entry 会对应打包出一个资源，而通过
动态引入语句引入的模块，也对应会打包出相应的资源，我们来看个示例。

## SplitChunksPlugin 的作用
SplitChunksPlugin 是 webpack 架构高扩展的一个绝好的示例，我们上面说了 webpack 主流程里面是按 entry / 动态引入 两种情况组织 chunks 的，这
必然会引发一些不必要的重复打包，webpack 通过插件的形式解决这个问题。

回顾 compilation.seal 函数的代码，大致上可以梳理成这么4个步骤：

1. 遍历 compilation.modules ，记录下模块与 chunk 关系
2. 触发各种模块优化钩子，这一步优化的主要是模块依赖关系
3. 遍历 module 构建 chunk 集合
4. 触发各种优化钩子

```js
// compilation.seal
while(this.hooks.optimizeChunks.call(this.chunks, this.chunkGroups)) {

}
```

```js
module.exports = class SplitChunksPlugin {
  constructor(options = {}) {
    // ...
  }

  _getCacheGroup(cacheGroupSource) {
    // ...
  }

  apply(compiler) {
    // ...
    compiler.hooks.thisCompilation.tap("SplitChunksPlugin", (compilation) => {
      // ...
      compilation.hooks.optimizeChunks.tap(
        {
          name: "SplitChunksPlugin",
          stage: STAGE_ADVANCED,
        },
        (chunks) => {
          // ...
        }
      );
    });
  }
};
```
webpack 插件架构的高扩展性，使得整个编译的主流程是可以固化下来的，分支逻辑和细节需求暴露出去由第三方来实现。
- compiler.hooks.compilation ：
时机：启动编译创建出 compilation 对象后触发
参数：当前编译的 compilation 对象
示例：很多插件基于此事件获取 compilation 实例

- compiler.hooks.make：
时机：正式开始编译时触发
参数：同样是当前编译的 compilation 对象
示例：webpack 内置的 EntryPlugin 基于此钩子实现 entry 模块的初始化

- compilation.hooks.optimizeChunks ：
时机： seal 函数中，chunk 集合构建完毕后触发
参数：chunks 集合与 chunkGroups 集合
示例： SplitChunksPlugin 插件基于此钩子实现 chunk 拆分优化

- compiler.hooks.done：
时机：编译完成后触发
参数： stats 对象，包含编译过程中的各类统计信息
示例： webpack-bundle-analyzer 插件基于此钩子实现打包分析

## 写入文件系统
经过构建阶段后，compilation 会获知资源模块的内容与依赖关系，也就知道“输入”是什么；而经过 seal 阶段处理后，compilation 则获知资源输出的图谱，
也就是知道怎么“输出”：哪些模块跟那些模块“绑定”在一起输出到哪里。seal 后大致的数据结构：

```js
compilation = {
  // ...
  modules: [
    /* ... */
  ],
  chunks: [
    {
      id: "entry name",
      files: ["output file name"],
      hash: "xxx",
      runtime: "xxx",
      entryPoint: {xxx}
      // ...
    },
    // ...
  ],
};
```
seal 结束之后，紧接着调用 compiler.emitAssets 函数，函数内部调用 compiler.outputFileSystem.writeFile 方法将 assets 集合写入文件系统。
