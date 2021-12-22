---
title: redux状态传播
date: 2018-06-21 19:37:18
tags:
  - redux
  - react
copyright: true
comments: true
categories: JS
top: 106
photos:
---

## Redux 三大概念

> Redux 是 JavaScript 状态容器，提供可预测化的状态管理

> action 普通的 JS 对象描述发生什么

> reducer 只是一个接收 state 和 action，并返回新的 state 的函数

Store — 数据存储中心，同时连接着 Actions 和 Views（React Components）。

1. Store 需要负责接收 Views 传来的 Action
2. 然后，根据 Action.type 和 Action.payload 对 Store 里的数据进行修改
3. 最后，Store 还需要通知 Views，数据有改变，Views 便去获取最新的 Store 数据，通过 setState 进行重新渲染组件（re-render）。

### 三大原则

1. 单一数据源

整个应用的 state 被储存在一棵 object tree 中，并且这个 object tree 只存在于唯一一个 store 中。和根级的 reducer,拆成多个 reducer 而不是多个 store。

2. State 是只读的

唯一改变 state 的方法就是触发 action，action 是一个用于描述已发生事件的普通对象。

3. 使用纯函数来执行修改

为了描述 action 如何改变 state tree ，你需要编写 reducers。传递数据 payload 规范。

当 state 变化时需要返回全新的对象，而不是修改传入的参数。

---

<!-- more -->

### api

```javascript
// API 是 { subscribe, dispatch, getState }。
let store = createStore(counter);

// 可以手动订阅更新，也可以事件绑定到视图层。
store.subscribe(() => console.log(store.getState()));

// 改变内部 state 唯一方法是 dispatch 一个 action。
// action 可以被序列化，用日记记录和储存下来，后期还可以以回放的方式执行
store.dispatch({ type: "INCREMENT" });
// 1
store.dispatch({ type: "INCREMENT" });
// 2
store.dispatch({ type: "DECREMENT" });
// 1
```

不要再 reducer 里做以下操作保持纯净

> 修改传入参数；

> 执行有副作用的操作，如 API 请求和路由跳转；

> 调用非纯函数，如 Date.now() 或 Math.random()。

通过 reducer 修改数据带来的好处

1. 数据拆解 => 通过定义多个 reducerr 对数据进行拆解访问或者修改，最终再通过 combineReducers 函数将零散的数据拼装回去。

```javascript
import { combineReducers } from "redux";

// 叶子reducer
function aReducer(state = 1, action) {
  /*...*/
}
function cReducer(state = true, action) {
  /*...*/
}
function eReducer(state = [2, 3], action) {
  /*...*/
}

const dReducer = combineReducers({
  e: eReducer,
});

const bReducer = combineReducers({
  c: cReducer,
  d: dReducer,
});

// 根reducer
const rootReducer = combineReducers({
  a: aReducer,
  b: bReducer,
});
```

2. 数据不可变
   组件的生命周期函数 shouldComponentUpdate 进行判断是否有必要进行对该组件进行更新（即，是否执行该组件 render 方法以及进行 diff 计算）

#### 维持应用的 state

> 提供 getState() 方法获取 state；

> 提供 dispatch(action) 方法更新 state；发送通知；

> 通过 subscribe(listener) 注册监听器;

> 通过 unsubscribe() 返回的函数注销监听器。

纯函数是这样一种函数，即相同的输入，永远会得到相同的输出。
store.dispatch 方法会触发 Reducer 的自动执行。为此，Store 需要知道 Reducer 函数，做法就是在生成 Store 的时候，将 Reducer 传入 createStore 方法。

中间件提供的是位于 action 被发起之后，到达 reducer 之前的扩展点。

```javascript
import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import createLogger from "redux-logger";
import rootReducer from "../reducers";

// store扩展
const enhancer = applyMiddleware(thunk, createLogger());

const store = createStore(rootReducer, initialState, enhancer);
```

## react-redux

Redux 本身和 React 没有关系，只是数据处理中心，是 React-Redux 让它们联系在一起。

React-Redux 提供两个方法：connect 和 Provider。

### connect

connect 连接 React 组件和 Redux store。connect 实际上是一个高阶函数，返回一个新的已与 Redux store 连接的组件类。

```javascript
const VisibleTodoList = connect(mapStateToProps, mapDispatchToProps)(TodoList);
```

TodoList 是 UI 组件，VisibleTodoList 就是由 react-redux 通过 connect 方法自动生成的容器组件。

mapStateToProps：从 Redux 状态树中提取需要的部分作为 props 传递给当前的组件。
mapDispatchToProps：将需要绑定的响应事件（action）作为 props 传递到组件上。

### Provide(将 store 通过 context 传入组件中)

Provider 实现 store 的全局访问，将 store 传给每个组件。
原理：使用 React 的 context，context 可以实现跨组件之间的传递。

### reducer 的拆分和重构

随着项目越大，如果将所有状态的 reducer 全部写在一个函数中，将会 难以维护；可以将 reducer 进行拆分，也就是 函数分解，最终再使用`combineReducers()`进行重构合并；

### 异步 Action

由于 Reducer 是一个严格的纯函数，因此无法在 Reducer 中进行数据的请求，需要先获取数据，再 dispatch(Action)即可，下面是三种不同的异步实现:

- [redex-thunk](https://github.com/reduxjs/redux-thunk)
- [redux-saga](https://github.com/redux-saga/redux-saga)
- [redux-observable](https://github.com/redux-observable/redux-observable)

## 使用 复杂性 数据交互 结构复杂繁琐 大型

- "如果你不知道是否需要 Redux，那就是不需要它。"
- "只有遇到 React 实在解决不了的问题，你才需要 Redux。"
