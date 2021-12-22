---
title: React 16新特性context api
tags:
  - react
copyright: true
comments: true
date: 2018-06-11 17:19:45
categories: JS
top: 107
photos:
---

React 16.3 带来了正式版的 context API。让我们来看看有哪些改变，在那些地方可以取代 redux 吧！

---

<!-- more -->

我当前依赖的版本

```javascript
"dependencies": {
    "react": "^16.4.0",
    "react-dom": "^16.4.0"
}
```

## 创建 context 实例

```javascript
// 创建context实例
const ThemeContext = React.createContext({
  background: "red",
  color: "white",
});

const { Provider, Consumer } = ThemeContext;
```

## Provider 组件

**Provider 组件用于将 context 数据传给该组件树下的所有组件 value 属性是 context 的内容。**

```javascript
class App extends React.Component {
  render() {
    return (
      <Provider value={{ text: "hello react!" }}>
        <Comp1 />
        <Comp2 />
      </Provider>
    );
  }
}
```

## Consumer 组件

**Consumer 消费 Provider 传递的数据**

```javascript
// 函数式
const Comp1 = () => <Consumer>{(context) => <p>{context.text}</p>}</Consumer>;
// 类
class Comp2 extends React.Component {
  render() {
    return <Consumer>{(context) => <p>{context.text}</p>}</Consumer>;
  }
}
```

如果你没有将 Consumer 作为 Provider 的子组件，那么 Consumer 将使用创建 context 时的参数作为 context。
