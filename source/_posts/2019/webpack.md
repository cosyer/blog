---
title: webpack
tags:
  - 打包
copyright: true
comments: true
date: 2019-08-18 14:37:40
categories: 工具
photos:
top: 260
---

## 谈谈你对 webpack 的看法

webpack 是一个模块打包工具，可以使用它管理项目中的模块依赖，并编译输出模块所需的静态文件。它可以很好地管理、打包开发中所用到的 HTML,CSS,JavaScript 和静态文件（图片，字体）等，让开发更高效。对于不同类型的依赖，webpack 有对应的模块加载器，而且会分析模块间的依赖关系，最后合并生成优化的静态资源。

> webpack 最出色的功能之一就是，除了 JavaScript，还可以通过 loader 引入任何其他类型的文件。

## webpack 的基本功能和工作原理？

- 代码转换：TypeScript 编译成 JavaScript、SCSS 编译成 CSS 等等
- 文件优化：压缩 JavaScript、CSS、HTML 代码，压缩合并图片等
- 代码分割：提取多个页面的公共代码、提取首屏不需要执行部分的代码让其异步加载
- 模块合并：在采用模块化的项目有很多模块和文件，需要构建功能把模块分类合并成一个文件
- 自动刷新：监听本地源代码的变化，自动构建，刷新浏览器
- 代码校验：在代码被提交到仓库前需要检测代码是否符合规范，以及单元测试是否通过
- 自动发布：更新完代码后，自动构建出线上发布代码并传输给发布系统。

- Entry（入口）：Webpack 执行构建的第一步将从 Entry 开始，可抽象成输入。
- Output（出口）：指示 webpack 如何去输出、以及在哪里输出
- Module（模块）：在 Webpack 里一切皆模块，一个模块对应着一个文件。Webpack 会从配置的 Entry 开始递归找出所有依赖的模块。
- Chunk（代码块）：一个 Chunk 由多个模块组合而成，用于代码合并与分割。
- Loader（模块转换器）：用于把模块原内容按照需求转换成新内容。
- Plugin（扩展插件）：在 Webpack 构建流程中的特定时机会广播出对应的事件，插件可以监听这些事件，并改变输出结果

## webpack 构建过程

- 从 entry 里配置的 module 开始递归解析 entry 依赖的所有 module
- 每找到一个 module，就会根据配置的 loader 去找对应的转换规则
- 对 module 进行转换后，再解析出当前 module 依赖的 module
- 这些模块会以 entry 为单位分组，一个 entry 和其所有依赖的 module 被分到一个组 Chunk
- 最后 webpack 会把所有 Chunk 转换成文件输出
- 在整个流程中 webpack 会在恰当的时机执行 plugin 里定义的逻辑

1. 初始化：解析 webpack 配置参数，生成 Compiler 实例
2. 注册插件：调用插件的 apply 方法，给插件传入 compiler 实例的引用，插件通过 compiler 调用 Webpack 提供的 API，让插件可以监听后续的所有事件节点。
3. 入口：读取入口文件
4. 解析文件：使用 loader 将文件解析成抽象语法树 AST
5. 生成依赖图谱：找出每个文件的依赖项（遍历）
6. 输出：根据转换好的代码，生成 chunk
7. 生成最后打包的文件

## webpack 打包原理

## 将所有依赖打包成一个 bundle.js，通过代码分割成单元片段按需加载

<!--more-->

## 什么是 webpack，与 gulp,grunt 有什么区别

- webpack 是一个模块打包工具，可以递归地打包项目中的所有模块，最终生成几个打包后的文件。
- 区别：webpack 支持代码分割，模块化（AMD,CommonJ,ES2015），全局分析。gulp 是任务执行器(task runner)：就是用来自动化处理常见的开发任务，例如项目的检查(lint)、构建(build)、测试(test)

## 什么是 entry,output?

- entry 入口，告诉 webpack 要使用哪个模块作为构建项目的起点，默认为./src/index.js
- output 出口，告诉 webpack 在哪里输出它打包好的代码以及如何命名，默认为./dist

## 什么是 loader，plugins?

- loader 是用来告诉 webpack 如何转换某一类型的文件，并且引入到打包出的文件中
- plugins(插件)作用更大，可以打包优化，资源管理和注入环境变量(plugin 是一个含有 apply 方法的类)

apply 方法中接收一个 compiler 参数，也就是 webpack 实例。由于该参数的存在 plugin 可以很好的运用 webpack 的生命周期钩子，在不同的时间节点做一些操作。

### 手写一个 loader

loader 就是一个 node 模块(导出为函数的 JS 模块)，它输出了一个函数。当某种资源需要用这个 loader 转换时，这个函数会被调用。并且，这个函数可以通过提供给它的 this 上下文访问 Loader API。传入上一个 loader 的结果或者资源文件。

```js
// 定义 reverse-txt-loader.js
module.exports = function(src) {
  //src是原文件内容（abcde），下面对内容进行处理，这里是反转
  var result = src.split('').reverse().join('');
  //返回JavaScript源码，必须是String或者Buffer
  return `module.exports = '${result}'`;
}
// 使用
{
	test: /\.txt$/,
	use: [
		{
			'./path/reverse-txt-loader'
		}
	]
    // use: {
    //     loader: './path/reverse-txt-loader',
    //     include: path.resolve(__dirname, 'src'),// 指定需要转译的文件夹
    //     exclude: path.resolve(__dirname, 'node_modules'),// 指定转译时忽略的文件夹
    // }
},
```

注意点：

- 编写 Loader 时要遵循单一职责，每个 Loader 只做一种"转义"工作。每个 Loader 的拿到的是源文件内容（source），可以通过返回值的方式将处理后的内容输出，也可以调用 this.callback()方法，将内容返回给 webpack。 还可以通过 this.async()生成一个 callback 函数，再用这个 callback 将处理后的内容输出出去。
- Loader 运行在 Node.js 中，我们可以调用任意 Node.js 自带的 API 或者安装第三方模块进行调用
- Webpack 传给 Loader 的源内容默认都是 UTF-8 格式编码的字符串，当某些场景下 Loader 处理二进制文件时，需要通过 exports.raw = true 告诉 Webpack 该 Loader 是否需要二进制数据
- 尽可能的异步化 Loader，如果计算量很小，同步也可以
- Loader 是无状态的，我们不应该在 Loader 中保留状态
- 使用 loader-utils 和 schema-utils 为我们提供的实用工具

### 手写一个 plugin

```js
class DemoWebpackPlugin {
  constructor() {
    console.log("初始化 插件");
  }
  apply(compiler) {
    compiler.hooks.run.tap("pluginName", (compilation) => {
      console.log("webpack 构建过程开始！");
    });
  }
}

module.exports = DemoWebpackPlugin;
```

## 什么是 bundle,chunk,module?

bundle 是 webpack 打包出来的文件，chunk 是 webpack 在进行模块的依赖分析的时候，代码分割出来的代码块，module 是开发中的单个模块。

## 如何自动生成 webpack 配置？

可以用一些官方脚手架

- webpack-cli
- vue-cli

```js
// 首先安装
npm install -g @vue/cli
// 新建项目hello
vue create hello
```

nuxt-cli

```js
// 确保安装了npx,npx在npm5.2.0默认安装了
// 新建项目hello
npx create-nuxt-app hello
```

## webpack 如何配置单页面和多页面的应用程序？

```js
// 单个页面
module.exports = {
  entry: "./path/to/my/entry/file.js",
};

// 多页面应用程序
module.entrys = {
  entry: {
    pageOne: "./src/pageOne/index.js",
    pageTwo: ["./src/pageTwo/index.js", "./src/pageTwo/main.js"],
  },
};
```

多入口可以通过 HtmlWebpackPlugin 分开注入

```js
plugins: [
  new HtmlWebpackPlugin({
    chunks: ["pageOne"],
    filename: "test.html",
    template: "src/assets/test.html",
  }),
];
```

## 几个常见的 loader

- file-loader：把文件输出到一个文件夹中，在代码中通过相对 URL 去引用输出的文件
- url-loader：和 file-loader 类似，但是能在文件很小的情况下以 base64 的方式把文件内容注入到代码中去
- source-map-loader：加载额外的 Source Map 文件，以方便断点调试
- image-loader：加载并且压缩图片文件
- babel-loader：把 ES6 转换成 ES5
- css-loader：加载 CSS，支持模块化、压缩、文件导入等特性
- style-loader：把 CSS 代码注入到 JavaScript 中，通过 DOM 操作去加载 CSS。
- eslint-loader：通过 ESLint 检查 JavaScript 代码

## 几个常见的 plugin

- define-plugin：定义环境变量
- terser-webpack-plugin：通过 TerserPlugin 压缩 ES6 代码
- html-webpack-plugin 为 html 文件中引入的外部资源，可以生成创建 html 入口文件
- mini-css-extract-plugin：分离 css 文件
- clean-webpack-plugin：删除打包文件
- happypack：实现多线程加速编译

```js
var UglifyJSPlugin = require("uglifyjs-webpack-plugin");
var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var providePlugin = new webpack.ProvidePlugin({
  $: "jquery",
  jQuery: "jquery",
  "window.jQuery": "jquery",
});
module.exports = {
  entry: {
    index: "./src/js/index.js",
    goodsInfo: "./src/js/goodsInfo.js",
  },
  output: {
    filename: "[name].js",
    path: __dirname + "/out",
    publicPath: "http://localhost:8080/out",
  },
  module: {
    rules: [
      { test: /.js$/, use: ["babel-loader"] },
      // // {test: /.css$/, use: ['style-loader','css-loader']},
      // {
      //     test: /.css$/,
      //     use: ExtractTextPlugin.extract({
      //       fallback: "style-loader",
      //       use: "css-loader"
      //     })
      // },
      {
        test: /.jpg|png|gif|svg$/,
        use: ["url-loader?limit=8192&name=./[name].[ext]"],
      },
      { test: /.less$/, use: ["style-loader", "css-loader", "less-loader"] },
    ],
  },
  plugins: [
    new UglifyJSPlugin(),
    new webpack.optimize.CommonsChunkPlugin({
      name: "commons",
      filename: "commons.js",
      minChunks: 2,
    }),
    new ExtractTextPlugin("[name].css"),
    providePlugin,
  ],
  externals: {
    // 从输出的 bundle 中排除 echarts 依赖
    echarts: "echarts",
  },
};
```

## webpack-dev-server

1. 用 express 启一个服务
2. sockjs 与页面互动。

底层一方面使用 webpack 在服务器端进行构建打包，一方面在客户端注入 runtime 以便和服务器端建立联系。还提供了代理功能，代理有很多应用场景，举几个简单的例子：本地数据接口模拟、远端接口调试、分拆接
口到不同的远端服务器等。

### 自动刷新

- iframe 模式 http://[host]:[port]/webpack-dev-server/[path]
  ✦ 无需额外的配置
  ✦ 顶部条可以显示编译信息
  ✦ 浏览器的地址不会跟着页面 URL 变动

- inline 模式 http://[host]:[port]/[path]
  ✦ 需要额外的配置
  ✦ 编译信息只能在命令行和浏览器 console 中查看
  ✦ 浏览器的地址和页面 URL 同步

### 热替换 HMR 只支持 inline 模式

> webpack-dev-server --inline --hot

### 哈希值计算方式

webpack 给我们提供了三种哈希值计算方式，分别是 hash 、chunkhash 和 contenthash。

- hash：跟整个项目的构建相关，构建生成的文件 hash 值都是一样的，只要项目里有文件更改，整个项目构建的 hash 值都会更改。
- chunkhash：根据不同的入口文件(Entry)进行依赖文件解析、构建对应的 chunk，生成对应的 hash 值。
- contenthash：由文件内容产生的 hash 值，内容不同产生的 contenthash 值也不一样。

### devServer 配置

- devServer.compress， 启用 gzip 压缩。
- devServer.contentBase，告诉服务器从哪里提供内容。 只有在你想要提供静态文件时才需要。
- devServer.host， 指定 host。 使用 0 .0 .0 .0 可以让局域网内可访问。
- devServer.hot， 启用 webpack 的模块热替换特性（ Hot Module Replacement）。
- devServer.inline， 模式切换。 默认为内联模式， 使用 false 切换到 iframe 模式。
- devServer.open， 启动 webpack - dev - server 后是否使用浏览器打开首页。
- devServer.port， 监听端口号。 默认 8080。
- devServer.proxy， 代理， 对于另外有单独的后端开发服务器 API 来说比较适合。
- devServer.publicPath， 设置内存中的打包文件的输出目录。 区别于 output.publicPath。
- devServer.historyApiFallback，回退:支持历史 API。
- devServer.progress，让编译的输出内容带有进度和颜色。

![webpack-hmr](http://cdn.mydearest.cn/blog/images/webpack-hmr.png)

注释：绿色是 webpack 控制区域，蓝色是 webpack-dev-server 控制区域，红色是文件系统，青色是项目本身。

第一步：webpack 监听文件变化并打包（1，2）
webpack-dev-middleware 调用 webpack 的 api 对文件系统 watch，当文件发生改变后，webpack 重新对文件进行编译打包，然后保存到内存中。 打包到了内存中，不生成文件的原因就在于访问内存中的代码比访问文件系统中的文件更快，而且也减少了代码写入文件的开销

第二步： webpack-dev-middleware 对静态文件的监听（3）
webpack-dev-server 对文件变化的一个监控，这一步不同于第一步，并不是监控代码变化重新打包。当我们在配置文件中配置了 devServer.watchContentBase 为 true 的时候，Server 会监听这些配置文件夹中静态文件的变化，变化后会通知浏览器端对应用进行 live reload。注意，这儿是浏览器刷新，和 HMR 是两个概念

第三步：devServer 通知浏览器端文件发生改变（4）
sockjs 在服务端和浏览器端建立了一个 webSocket 长连接，以便将 webpack 编译和打包的各个阶段状态告知浏览器，最关键的步骤还是 webpack-dev-server 调用 webpack api 监听 compile 的 done 事件，当 compile 完成后，webpack-dev-server 通过 \_sendStatus 方法将编译打包后的新模块 hash 值发送到浏览器端。

第四步：webpack 接收到最新 hash 值验证并请求模块代码（5，6）
webpack-dev-server/client 端并不能够请求更新的代码，也不会执行热更模块操作，而把这些工作又交回给了 webpack，webpack/hot/dev-server 的工作就是根据 webpack-dev-server/client 传给它的信息以及 dev-server 的配置决定是刷新浏览器呢还是进行模块热更新。当然如果仅仅是刷新浏览器（执行步骤 11），也就没有后面那些步骤了。

第五步：HotModuleReplacement.runtime 对模块进行热更新（7,8,9）
是客户端 HMR 的中枢，它接收到上一步传递给他的新模块的 hash 值，它通过 JsonpMainTemplate.runtime 向 server 端发送 Ajax 请求，服务端返回一个 json，该 json 包含了所有要更新的模块的 hash 值，获取到更新列表后，该模块再次通过 jsonp 请求，获取到最新的模块代码。

第六步：HotModulePlugin 将会对新旧模块进行对比（10）
HotModulePlugin 将会对新旧模块进行对比，决定是否更新模块，在决定更新模块后，检查模块之间的依赖关系，更新模块的同时更新模块间的依赖引用 ，第一个阶段是找出 outdatedModules 和 outdatedDependencies。第二个阶段从缓存中删除过期的模块和依赖。第三个阶段是将新的模块添加到 modules 中，当下次调用 **webpack_require** (webpack 重写的 require 方法)方法的时候，就是获取到了新的模块代码了。

### 使用场景

工具的使用是分场景的，Rollup 的使用场景是，你的代码基于 ES6 模块编写，并且你做的东西是准备给他人使用的。

有一句经验之谈：在开发应用时使用 Webpack，开发库时使用 Rollup。

## html 模板配置 cdn

```html
<% for (var i in htmlWebpackPlugin.options.cdn &&
htmlWebpackPlugin.options.cdn.css) { %>
<link
  href="<%= htmlWebpackPlugin.options.cdn.css[i] %>"
  rel="preload"
  as="style"
/>
<link href="<%= htmlWebpackPlugin.options.cdn.css[i] %>" rel="stylesheet" />
<% } %> <% for (var i in htmlWebpackPlugin.options.cdn &&
htmlWebpackPlugin.options.cdn.js) { %>
<script src="<%= htmlWebpackPlugin.options.cdn.js[i] %>"></script>
<% } %>
```

```js
// cdn预加载使用
const externals = {
  vue: "Vue",
  "vue-router": "VueRouter",
};
const cdn = {
  // 开发环境
  dev: {
    css: ["https://unpkg.com/element-ui/lib/theme-chalk/index.css"],
    js: [],
  },
  // 生产环境
  build: {
    css: ["https://unpkg.com/element-ui/lib/theme-chalk/index.css"],
    js: [
      "https://cdn.jsdelivr.net/npm/vue@2.5.17/dist/vue.min.js",
      "https://cdn.jsdelivr.net/npm/vue-router@3.0.1/dist/vue-router.min.js",
    ],
  },
};
chainWebpack: (config) => {
  config.plugin("html").tap((args) => {
    if (process.env.NODE_ENV === "production") {
      args[0].cdn = cdn.build;
    }
    if (process.env.NODE_ENV === "development") {
      args[0].cdn = cdn.dev;
    }
    return args;
  });
};
```

## 开启 Gzip，包含 js/css

```js
new CompressionWebpackPlugin({
  algorithm: "gzip", // 算法
  test: /\.(js|css)$/, // 匹配文件名
  threshold: 10000, // 对超过10k的数据进行压缩
  deleteOriginalAssets: false, // 是否删除源文件
  minRatio: 0.8, //压缩比
});
```

## 去除注释、去掉 console.log

安装 `uglifyjs-webpack-plugin`

```js
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
new UglifyJsPlugin({
  uglifyOptions: {
    output: {
      comments: false, // 去掉注释
    },
    warnings: false,
    compress: {
      drop_console: true,
      drop_debugger: false,
      pure_funcs: ["console.log"], // 移除console
    },
  },
});
```

## 压缩图片

```js
chainWebpack: (config) => {
  // 压缩图片
  config.module
    .rule("images")
    .test(/\.(png|jpe?g|gif|svg)(\?.*)?$/)
    .use("image-webpack-loader")
    .loader("image-webpack-loader")
    .options({ bypassOnDebug: true });
};
```

## 本地代理

```js
devServer: {
	open: false, // 自动启动浏览器
	host: '0.0.0.0', // localhost
	port: 6060, // 端口号
	https: false,
	hotOnly: false, // 热更新
	proxy: {
		'^/sso': {
			target: process.env.VUE_APP_SSO, // 重写路径
			ws: true, //开启WebSocket
			secure: false, // 如果是https接口，需要配置这个参数
			changeOrigin: true
		}
	}
}
```

## 设置 vscode 识别别名

在 vscode 中插件安装栏搜索 `Path Intellisense` 插件，打开 settings.json 文件添加 以下代码 "@": "${workspaceRoot}/src"，按以下添加

```js
{
	"workbench.iconTheme": "material-icon-theme",
	"editor.fontSize": 16,
	"editor.detectIndentation": false,
	"guides.enabled": false,
	"workbench.colorTheme": "Monokai",
	"path-intellisense.mappings": {
			"@": "${workspaceRoot}/src"
	}
}
```

在项目 package.json 所在同级目录下创建文件 jsconfig.json

```js
{
	"compilerOptions": {
			"target": "ES6",
			"module": "commonjs",
			"allowSyntheticDefaultImports": true,
			"baseUrl": "./",
			"paths": {
				"@/*": ["src/*"]
			}
	},
	"exclude": [
			"node_modules"
	]
}
```

## 只打包改变的文件

```js
const { HashedModuleIdsPlugin } = require("webpack");
configureWebpack: (config) => {
  const plugins = [];
  plugins.push(new HashedModuleIdsPlugin());
};
```

## 分析打包日志

```js
// webpack-bundle-analyzer
chainWebpack: (config) => {
  config
    .plugin("webpack-bundle-analyzer")
    .use(require("webpack-bundle-analyzer").BundleAnalyzerPlugin);
};
```
