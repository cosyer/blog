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

Error Boundary可以看作是一种特殊的React组件，新增了componentDidCatch这个生命周期函数，它可以捕获自身及子树上的错误并对错误做优雅处理，包括上报错误日志、展示出错提示，而不是卸载整个组件树。（注：它并不能捕获runtime所有的错误，比如组件回调事件里的错误，可以把它想象成传统的try-catch语句）

---
<!-- more -->

```javascript
//最佳实践：将ErrorBoundary抽象为一个公用的组件类
 
import React, { Component } from 'react'
 
export default class ErrorBoundary extends Component {
  constructor(props) {
    super(props)
    this.state = { hasError: false }
  }
  componentDidCatch(err, info) {
    this.setState({ hasError: true })
    //sendErrorReport(err,info)
  }
  render(){
    if(this.state.hasError){
      return <div>Something went wrong!</div>
    }
    return this.props.children
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
## render方法新增返回类型
在React 16中，render方法支持直接返回string，number，boolean，null，portal，以及fragments(带有key属性的数组)，这可以在一定程度上减少页面的DOM层级。

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
以上各种类型现在均可以直接在render中返回，不需要再在外层包裹一层容器元素，不过在返回的数组类型中，需要在每个元素上加一个唯一且不变的key值，否则控制台会报一个warning。

## 16.2 增加 Fragment 组件，其作用是将一些子元素添加到 DOM tree 上且不需要为这些元素提供额外的父节点，相当于 render 返回数组元素

## 增加 React.memo() API，它只能作用在简单的函数组件上，本质是一个高阶函数，可以自动帮助组件执行

## 增加 React.lazy() API，它提供了动态 import 组件的能力，实现代码分割

## 使用createPortal将组件渲染到当前组件树之外

## 支持自定义DOM属性
在之前的版本中，React会忽略无法识别的HTML和SVG属性，自定义属性只能通过data-*形式添加，现在它会把这些属性直接传递给DOM（这个改动让React可以去掉属性白名单，从而减少了文件大小）。

## setState传入null时不会再触发更新

## 更好的服务器端渲染
React 16的SSR被完全重写，新的实现非常快，接近3倍性能于React 15，现在提供一种流模式streaming，可以更快地把渲染的字节发送到客户端。

## 新的打包策略
新的打包策略中去掉了process.env检查。
React 16的体积比上个版本减小了32%（30% post-gzip），文件尺寸的减小一部分要归功于打包方法的改变。

## React 16采用了新的核心架构React Fiber。官方解释是“React Fiber是对核心算法的一次重新实现”

- 时间切片(Concurrent Mode开启后就会启用时间切片)
```js
// 通过使用ReactDOM.unstable_createRoot开启Concurrent Mode
// ReactDOM.render(<App/>, rootEl);  
ReactDOM.unstable_createRoot(rootEl).render(<App/>);
```
`解决cpu瓶颈`

- 任务调度

## 制约快速响应的两个因素
- cpu的瓶颈 (1帧中16.6ms预留出5ms给js线程，其余时间处理样式布局和绘制)
- io的瓶颈
