---
title: react组件实现按需加载
tags:
  - react
copyright: true
comments: true
date: 2018-8-15 10:45:27
categories: JS
top: 107
photos:
---

随着前端应用体积的扩大，资源加载的优化是我们必须要面对的问题，动态代码加载就是其中的一个方案，webpack 提供了符合  ECMAScript 提案   的  `import()`  语法 ，让我们来实现动态地加载模块（注：require.ensure 与 import() 均为 webpack 提供的代码动态加载方案，在 webpack 2.x 中，require.ensure 已被 import 取代）。

## React.lazy 是什么

在 React 16.6 版本中，新增了 React.lazy 函数，它能让你像渲染常规组件一样处理动态引入的组件，配合 webpack 的 Code Splitting ，只有当组件被加载，对应的资源才会导入 ，从而达到懒加载的效果。

## 使用 React.lazy

```js
// 不使用 React.lazy
import OtherComponent from "./OtherComponent";
// 使用 React.lazy
const OtherComponent = React.lazy(() => import("./OtherComponent"));
```

React.lazy 接受一个函数作为参数，这个函数需要调用 import() 。它需要返回一个 Promise，该 Promise 需要 resolve 一个 defalut export 的 React 组件。

在控制台打印可以看到，React.lazy 方法返回的是一个 lazy 组件的对象，类型是 react.lazy，并且 lazy 组件具有 \_status 属性，与 Promise 类似它具有 Pending、Resolved、Rejected 三个状态，分别代表组件的加载中、已加载、和加载失败三种状态。

> 需要注意的一点是，React.lazy 需要配合 Suspense 组件一起使用，在 Suspense 组件中渲染 React.lazy 异步加载的组件。如果单独使用 React.lazy，React 会给出错误提示。其中在 Suspense 组件中，
> fallback 是一个必需的占位属性，如果没有这个属性的话也是会报错的。

```js
// 延迟加载回调 不需要加载效果设置为null maxDuration可以设置最大持续时间 最新版本中已移除了这个属性
const SuspenseComponent = (Component) => (props) => {
  return (
    <Suspense fallback={Math.random() >= 0.5 ? <Loading /> : <SkeletonView />}>
      <Component {...props}></Component>
    </Suspense>
  );
};
...
...
component: SuspenseComponent(OtherComponent),
```

---

<!--more-->

## Webpack 动态加载

上面使用了 `import()` 语法，webpack 检测到这种语法会自动代码分割。使用这种动态导入语法代替以前的静态引入，可以让组件在渲染的时候，再去加载组件对应的资源。这个异步加载流程的实现机制是怎么样
呢？

```js
__webpack_require__.e = function requireEnsure(chunkId) {
  // installedChunks 是在外层代码中定义的对象，可以用来缓存了已加载 chunk
  var installedChunkData = installedChunks[chunkId];
  // 判断 installedChunkData 是否为 0：表示已加载
  if (installedChunkData === 0) {
    return new Promise(function (resolve) {
      resolve();
    });
  }
  if (installedChunkData) {
    return installedChunkData[2];
  }
  // 如果 chunk 还未加载，则构造对应的 Promsie 并缓存在 installedChunks 对象中
  var promise = new Promise(function (resolve, reject) {
    installedChunkData = installedChunks[chunkId] = [resolve, reject];
  });
  installedChunkData[2] = promise;
  // 构造 script 标签
  var head = document.getElementsByTagName("head")[0];
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.charset = "utf-8";
  script.async = true;
  script.timeout = 120000;
  if (__webpack_require__.nc) {
    script.setAttribute("nonce", __webpack_require__.nc);
  }
  script.src =
    __webpack_require__.p +
    "static/js/" +
    ({ 0: "alert" }[chunkId] || chunkId) +
    "." +
    { 0: "620d2495" }[chunkId] +
    ".chunk.js";
  var timeout = setTimeout(onScriptComplete, 120000);
  script.onerror = script.onload = onScriptComplete;
  function onScriptComplete() {
    script.onerror = script.onload = null;
    clearTimeout(timeout);
    var chunk = installedChunks[chunkId];
    // 如果 chunk !== 0 表示加载失败
    if (chunk !== 0) {
      // 返回错误信息
      if (chunk) {
        chunk[1](new Error("Loading chunk " + chunkId + " failed."));
      }
      // 将此 chunk 的加载状态重置为未加载状态
      installedChunks[chunkId] = undefined;
    }
  }
  head.appendChild(script);
  // 返回 fulfilled 的 Promise
  return promise;
};
```

结合上面的代码来看，webpack 通过创建 script 标签来实现动态加载的，找出依赖对应的 chunk 信息，然后生成 script 标签来动态加载 chunk，每个 chunk 都有对应的状态：未加载 、 加载中、已加载 。

## Suspense

Suspense 内部主要通过捕获组件的状态去判断如何加载，上面我们提到 React.lazy 创建的动态加载组件具有  Pending、Resolved、Rejected  三种状态，当这个组件的状态为 Pending 时显示的是 Suspense
中 fallback 的内容，只有状态变为 resolve 后才显示组件。

## Error Boundaries 统一处理资源加载失败场景

如果遇到网络问题或是组件内部错误，页面的动态资源可能会加载失败，为了优雅降级，可以使用 [Error Boundaries](https://react.docschina.org/docs/error-boundaries.html) 来解决这个问题。
Error Boundaries 是一种组件，如果你在组件中定义了 static getDerivedStateFromError() 或  componentDidCatch() 生命周期函数，它就会成为一个 Error Boundaries 的组件。

```js
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
​
  static getDerivedStateFromError(error) {
      // 更新 state 使下一次渲染能够显示降级后的 UI
      return { hasError: true };  
  }
  componentDidCatch(error, errorInfo) {
      // 你同样可以将错误日志上报给服务器
      logErrorToMyService(error, errorInfo);
  }
  render() {
    if (this.state.hasError) {
        // 你可以自定义降级后的 UI 并渲染      
        return <h1>对不起，发生异常，请刷新页面重试</h1>;    
    }
    return this.props.children;
  }
}
```

你可以在 componentDidCatch 或者 getDerivedStateFromError 中打印错误日志并定义显示错误信息的条件，当捕获到 error 时便可以渲染备用的组件元素，不至于导致页面资源加载失败而出现空白。

```js
<ErrorBoundary>
   <App />
</ErrorBoundary>
```

> 需要注意的是：错误边界仅可以捕获其子组件的错误，它无法捕获其自身的错误。

## 总结

React.lazy()  和 React.Suspense 的提出为现代 React 应用的性能优化和工程化提供了便捷之路。 React.lazy 可以让我们像渲染常规组件一样处理动态引入的组件，结合 Suspense 可以更优雅地展现组件懒
加载的过渡动画以及处理加载异常的场景。

> 注意：React.lazy 和 Suspense 尚不可用于服务器端，如果需要服务端渲染，可遵从官方建议使用 [Loadable Components](https://github.com/gregberge/loadable-components)。loadable 支持服务端
> 懒加载，而且支持库的懒加载。

[react koa2 ssr 教程](https://github.com/cosyer/react-koa2-ssr)
