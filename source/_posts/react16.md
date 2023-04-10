---
title: 快速了解React 16新特性
tags:
  - react
copyright: true
comments: true
date: 2018-06-11 20:09:00
categories: React
top: 107
photos:
---

## Error Boundary

Error Boundary 可以看作是一种特殊的 React 组件，新增了 componentDidCatch 这个生命周期函数，它可以捕获自身及子树上的错误并对错误做优雅处理，包括上报错误日志、展示出错提示，而不是卸载整个组件树。（注：它并不能捕获 runtime 所有的错误，比如组件回调事件里的错误，可以把它想象成传统的 try-catch 语句）

---

<!-- more -->

```javascript
//最佳实践：将ErrorBoundary抽象为一个公用的组件类

import React, { Component } from "react";

export default class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  componentDidCatch(err, info) {
    this.setState({ hasError: true });
    //sendErrorReport(err,info)
  }
  render() {
    if (this.state.hasError) {
      return <div>Something went wrong!</div>;
    }
    return this.props.children;
  }
}
```

```javascript
// 使用方式 包裹容易出错的组件
render(){
  return (
    <div>
      <ErrorBoundary>
        <Profile user={this.state.user} />
      </ErrorBoundary>
      <button onClick={this.onClick}>Update</button>
    </div>
  )
}
```

## render 方法新增返回类型

在 React 16 中，render 方法支持直接返回 string，number，boolean，null，portal，以及 fragments(带有 key 属性的数组)，这可以在一定程度上减少页面的 DOM 层级。

```javascript
//string
render(){
  return 'hello,world'
}

//number
render(){
  return 12345
}

//boolean
render(){
  return isTrue?true:false
}

//null
render(){
  return null
}

//fragments，未加key标识符，控制台会出现warning
render(){
  return [
    <div>hello</div>,
    <span>world</span>,
    <p>oh</p>
  ]
}
```

以上各种类型现在均可以直接在 render 中返回，不需要再在外层包裹一层容器元素，不过在返回的数组类型中，需要在每个元素上加一个唯一且不变的 key 值，否则控制台会报一个 warning。

## 16.2 增加 Fragment 组件，其作用是将一些子元素添加到 DOM tree 上且不需要为这些元素提供额外的父节点，相当于 render 返回数组元素

## 增加 React.memo() API，它只能作用在简单的函数组件上，本质是一个高阶函数，可以自动帮助组件执行

## 增加 React.lazy() API，它提供了动态 import 组件的能力，实现代码分割

## 使用 createPortal 将组件渲染到当前组件树之外

## 支持自定义 DOM 属性

在之前的版本中，React 会忽略无法识别的 HTML 和 SVG 属性，自定义属性只能通过 data-\*形式添加，现在它会把这些属性直接传递给 DOM（这个改动让 React 可以去掉属性白名单，从而减少了文件大小）。

## setState 传入 null 时不会再触发更新

## 更好的服务器端渲染

React 16 的 SSR 被完全重写，新的实现非常快，接近 3 倍性能于 React 15，现在提供一种流模式 streaming，可以更快地把渲染的字节发送到客户端。

## 新的打包策略

新的打包策略中去掉了 process.env 检查。
React 16 的体积比上个版本减小了 32%（30% post-gzip），文件尺寸的减小一部分要归功于打包方法的改变。

## React 16 采用了新的核心架构 React Fiber。官方解释是“React Fiber 是对核心算法的一次重新实现”

- 时间切片(Concurrent Mode 开启后就会启用时间切片)

```js
// 通过使用ReactDOM.unstable_createRoot开启Concurrent Mode
// ReactDOM.render(<App/>, rootEl);
ReactDOM.unstable_createRoot(rootEl).render(<App />);
```

`解决cpu瓶颈`

- 任务调度

## 制约快速响应的两个因素

- cpu 的瓶颈 (1 帧中 16.6ms 预留出 5ms 给 js 线程，其余时间处理样式布局和绘制)
- io 的瓶颈

## useState 伪代码
```js
// 全局变量 数组 队列 render
let state = [] // 存储声明的多个状态
let setters = [] // 存储声明的多个状态的修改方法
let index = 0 // 存储对应的索引
function useState(initValue) {
  state[index] = state[index] || initValue
  setters.push(createSetter(index))
  return [state[index, setters[index]]]
}
function createSetter() {
  return function (newState) {
    state[index] = newState
  }
}
```

## react动画过渡库(react-transition-group)

## react拖拽
- [拖拽排序react-dnd](https://github.com/react-dnd/react-dnd)
- [react-draggable](https://github.com/react-grid-layout/react-draggable)
- [容器大小react-resizable](https://github.com/react-grid-layout/react-resizable)

## 走马灯
- [react-slick](https://react-slick.neostack.com/docs/api)

## 多页签
- [react-router-cache-route](https://github.com/CJY0208/react-router-cache-route)
- [react-activation](https://github.com/CJY0208/react-activation)
