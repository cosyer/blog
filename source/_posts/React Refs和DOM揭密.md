---
title: React Refs揭密
tags:
  - react
copyright: true
comments: true
date: 2019-02-17 23:25:48
categories: JS
photos:
top: 140
---

## 什么是 Ref

React 的官方介绍是这样的：

In the typical React dataflow, props are the only way that parent components interact with their children. To modify a child, you re-render it with new props. However, there are a few cases where you need to imperatively modify a child outside of the typical dataflow. The child to be modified could be an instance of a React component, or it could be a DOM element. For both of these cases, React provides an escape hatch.

其中提到了这几个概念：

在典型的 React 数据流理念中，父组件跟子组件的交互都是通过传递属性(properties)实现的。如果父组件需要修改子组件，只需要将新的属性传递给子组件，由子组件来实现具体的绘制逻辑。

在特殊的情况下，如果你需要命令式(imperatively)的修改子组件，React 也提供了应急的处理办法--Ref。

Ref 既支持修改 DOM 元素，也支持修改自定义的组件。

---

<!-- more -->

## 什么是声明式编程(Declarative Programming)

值得一提的是当中声明式编程(Declarative Programming)和命令式编程(Imperative Programming)的区别。声明式编程的特点是只描述要实现的结果，而不关心如何一步一步实现的，而命令式编程则相反，必须每个步骤都写清楚。我们可以根据语义直观的理解代码的功能是：针对数组的每一个元素，将它的值打印出来。不必关心实现其的细节。而命令式编程必须将每行代码读懂，然后再整合起来理解总体实现的功能。

React 有 2 个基石设计理念：一个是声明式编程，一个是函数式编程。函数式编程以后有机会再展开讲。声明式编程的特点体现在 2 方面：

组件定义的时候，所有的实现逻辑都封装在组件的内部，通过 state 管理，对外只暴露属性。

组件使用的时候，组件调用者通过传入不同属性的值来达到展现不同内容的效果。一切效果都是事先定义好的，至于效果是怎么实现的，组件调用者不需要关心。

因此，在使用 React 的时候，一般很少需要用到 Ref。那么，Ref 的使用场景又是什么？

## Ref 使用场景

React 官方文档是这么说的：

There are a few good use cases for refs: Managing focus, text selection, or media playback.Triggering imperative animations.Integrating with third-party DOM libraries. Avoid using refs for anything that can be done declaratively.

简单理解就是，控制一些 DOM 原生的效果，如输入框的聚焦效果和选中效果等；触发一些命令式的动画；集成第三方的 DOM 库。最后还补了一句：如果要实现的功能可以通过声明式的方式实现，就不要借助 Ref。

通常我们会利用 render 方法得到一个 App 组件的实例，然后就可以对它做一些操作。但在组件内，JSX 是不会返回一个组件的实例的，它只是一个 ReactElement，只是告诉你，React 被挂载的组件应该什么样：

```js
const myApp = <App />;
```

refs 就是由此而生，它是 React 组件中非常特殊的 props， 可以附加到任何一个组件上，从字面意思上看，refs 即 reference，组件被调用时会创建一个该组件的实例，而 refd 就会指向这个实例。

## Ref 用法

如果作用在原生的 DOM 元素上，通过 Ref 获取的是 DOM 元素，可以直接操作 DOM 的 API：

```js
class CustomTextInput extends React.Component {
  constructor(props) {
    super(props);
    this.focusTextInput = this.focusTextInput.bind(this);
  }
  focusTextInput() {
    if (this.myTextInput !== null) {
      this.textInput.current.focus();
    }
  }
  render() {
    return (
      <div>
        <input type="text" ref={(ref) => (this.myTextInput = ref)} />
        <input
          type="button"
          value="Focus the text input"
          onClick={this.focusTextInput}
        />
      </div>
    );
  }
}
```

如果作用在自定义组件，Ref 获取的是组件的实例，可以直接操作组件内的任意方法：

```js
class AutoFocusTextInput extends React.Component {
  constructor(props) {
    super(props);
    this.textInput = React.createRef();
  }
  componentDidMount() {
    this.textInput.current.focusTextInput();
  }
  render() {
    return <CustomTextInput ref={this.textInput} />;
  }
}
```

## Ref 总结

为了防止内存泄漏，当卸载一个组件时，组件里所有的 refs 就会变成 null。

值得注意的是，`findDOMNode` 和 `refs` 都无法用于无状态组件中。因为，无状态组件挂载时只是方法调用，并没有创建实例。

对于 React 组件来讲，refs 会指向一个组件类实例，所以可以调用该类定义的任何方法。如果需要访问该组件的真实 DOM ，可以用 ReactDOM 。 findDOMNode 来找到 DOM 节点，但并不推荐这样做，因为这大部分情况下都打破了封装性，而且通常都能用更清晰的方法在 React 中构建代码。
