---
title: react源码解析系列一(React相关API)
tags:
  - react
copyright: true
comments: true
date: 2020-11-03 19:21:48
categories: React
photos:
---

今天开始学习 react 源码相关的内容，源码基于版本`v16.6.0`。React16 相较于之前的版本是核心上的一次重写，虽然主要的 API 都没有变化，但是增加了很多能力。并且首次引入了`Fiber`的概念，之后新的功能都是围绕`Fiber`进行实现，比如`AsyncMode`，`Profiler`等。

## React 与 ReactDom 的区别

问题：**_react 仅仅 1000 多行代码，而 react-dom 却将近 2w 行_**

答： React 主要定义基础的概念，比如节点定义和描述相关，真正的实现代码都是在 ReactDom 里面的，也就是“平台无关”概念，针对不同的平台有不同的实现，但
基本的概念都定义在 React 里。

## React16.6.0 使用 FlowType 做类型检查

Flow 是 facebook 出品的 JavaScript 静态类型检查⼯具。所谓类型检查，就是在编译期尽早发现（由类型错误引起的）bug，⼜不影响代码运⾏（不需要运⾏时动态检查类型），使编写 JavaScript 具有和编写 Java 等强类型语⾔相近的体验。

[官方网站](https://github.com/facebook/flow)

简单示例 🌰

```bash
npm install -g flow-bin
flow init
touch index.js
```

```js
// index.js 进行类型注释
/*@flow*/
function add(x: number, y: number): number {
  return x + y;
}
add("Hello", 11);

// 报错
```

---

<!-- more -->

## React 暴露的 Api

```js
const React = {
  Children: {
    map,
    forEach,
    count,
    toArray,
    only,
  },

  createRef,
  Component,
  PureComponent,

  createContext,
  forwardRef,

  Fragment: REACT_FRAGMENT_TYPE,
  StrictMode: REACT_STRICT_MODE_TYPE,
  unstable_AsyncMode: REACT_ASYNC_MODE_TYPE,
  unstable_Profiler: REACT_PROFILER_TYPE,

  createElement: __DEV__ ? createElementWithValidation : createElement,
  cloneElement: __DEV__ ? cloneElementWithValidation : cloneElement,
  createFactory: __DEV__ ? createFactoryWithValidation : createFactory,
  isValidElement: isValidElement,

  version: ReactVersion,

  __SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED: ReactSharedInternals,
};
```

## JSX 转换成什么

- 核心`React.createElement`
  `ReactElement`通过`createElement`创建，调用该方法需要传入三个参数
  - type
  - config
  - children

### type 指代这个 ReactElement 的类型

- 字符串比如`div`原生 DOM，称为`HostComponent`**首字母小写**
- 自定义组件变量(`functional Component`/`ClassComponent`)**首字母大写**不大写会识别为原生 DOM 解析
- 原生提供的组件

```js
Fragment: REACT_FRAGMENT_TYPE,
StrictMode: REACT_STRICT_MODE_TYPE,
unstable_AsyncMode: REACT_ASYNC_MODE_TYPE,
unstable_Profiler: REACT_PROFILER_TYPE,
```

这四个都是`React`提供的组件，但它们其实都只是占位符，都是一个`Symbol`，在`React`实际检测到他们的时候会做一些特殊的处理，比如`StrictMode`和
`AsyncMode`会让他们的子节点对应的`Fiber`的`mode`都变成和它们一样的`mode`。

### config

react 会把关键参数解析出来，例如`key`、`ref`，在`createElement`中识别分离，这些参数不会和其他参数一起处理而是单独作为变量出现在
`ReactElement`上。

### children

第三个参数就是 children，而且可以有任意多的参数，表示兄弟节点。可以通过`this.props.children`访问到。

### 相关源码以及注解 ⬇️

```js
export function createElement(type, config, children) {
  if (config != null) {
    if (hasValidRef(config)) {
      // 从第二个参数筛选出ref和key
      ref = config.ref;
    }
    if (hasValidKey(config)) {
      key = "" + config.key;
    }

    // Remaining properties are added to a new props object
    for (propName in config) {
      if (
        hasOwnProperty.call(config, propName) &&
        !RESERVED_PROPS.hasOwnProperty(propName) // 内置的ref、id就是这解析出来的
      ) {
        props[propName] = config[propName];
      }
    }
  }

  //
  const childrenLength = arguments.length - 2; // 3以后的参数都是children
  if (childrenLength === 1) {
    props.children = children;
  } else if (childrenLength > 1) {
    const childArray = Array(childrenLength); // 大于1 放到数组
    for (let i = 0; i < childrenLength; i++) {
      childArray[i] = arguments[i + 2];
    }

    props.children = childArray; // 放到chidren props.children拿的就是这个
  }

  // Resolve default props
  if (type && type.defaultProps) {
    // 设置props的默认值
    const defaultProps = type.defaultProps;
    for (propName in defaultProps) {
      if (props[propName] === undefined) {
        // 如果props是undefined才会使用默认值
        props[propName] = defaultProps[propName];
      }
    }
  }

  return ReactElement(
    type,
    key,
    ref,
    self,
    source,
    ReactCurrentOwner.current,
    props
  );
}

const ReactElement = function (type, key, ref, self, source, owner, props) {
  const element = {
    // This tag allows us to uniquely identify this as a React Element
    $$typeof: REACT_ELEMENT_TYPE,

    // Built-in properties that belong on the element
    type: type,
    key: key,
    ref: ref,
    props: props,

    // Record the component responsible for creating this element.
    _owner: owner,
  };

  return element;
};
```

### ReactElement

`ReactElement`只是一个用来承载信息的容器，它会告诉后续的操作这个节点的以下信息：

- type 类型，用于判断如何创建节点
- key 和 ref 这些特殊信息
- props 新的属性内容
- $$typeof 用于确定是否属于`ReactElement`

> React 通过提供这种类型的数据，来脱离平台的限制。

### $$typeof

在最后创建`ReactElement`我们 👀 看到了这么一个变量`$$typeof`。这是啥呢？React 元素，会有一个`$$typeof`来表示该元素是什么类型。当本地有
`Symbol`，则使用`Symbol`生成，没有时使用 16 进制。但有一个特例：`ReactDOM.createPortal`的时候是`REACT_PORTAL_TYPE`，不过它不是通过
`createElement`创建的，所以它也不属于`ReactElement`

```js
export let REACT_ELEMENT_TYPE = 0xeac7;
export let REACT_PORTAL_TYPE = 0xeaca;
export let REACT_FRAGMENT_TYPE = 0xeacb;
....
if (typeof Symbol === 'function' && Symbol.for) {
  const symbolFor = Symbol.for;
  REACT_ELEMENT_TYPE = symbolFor('react.element');
  REACT_PORTAL_TYPE = symbolFor('react.portal');
  REACT_FRAGMENT_TYPE = symbolFor('react.fragment');
  ....
}
```

## cloneElement

```js
// 第一个参数传入ReactElement，第二、三个参数和createElement一致
export function cloneElement(element, config, children) {
  invariant(
    !(element === null || element === undefined),
    "React.cloneElement(...): The argument must be a React element, but you passed %s.",
    element
  );

  let propName;

  // 复制传入的element props
  const props = Object.assign({}, element.props);

  // 提取内嵌的key和ref 不进行覆盖是原有的
  let key = element.key;
  let ref = element.ref;

  const self = element._self;
  // Source is preserved since cloneElement is unlikely to be targeted by a
  // transpiler, and the original source is probably a better indicator of the
  // true owner.
  const source = element._source;

  // Owner will be preserved, unless ref is overridden
  let owner = element._owner;

  // config和children的解析是一样的
  if (config != null) {
    if (hasValidRef(config)) {
      // Silently steal the ref from the parent.
      ref = config.ref;
      owner = ReactCurrentOwner.current;
    }
    if (hasValidKey(config)) {
      key = "" + config.key;
    }

    // Remaining properties override existing props
    let defaultProps;
    if (element.type && element.type.defaultProps) {
      defaultProps = element.type.defaultProps;
    }
    for (propName in config) {
      if (
        hasOwnProperty.call(config, propName) &&
        !RESERVED_PROPS.hasOwnProperty(propName)
      ) {
        if (config[propName] === undefined && defaultProps !== undefined) {
          // Resolve default props
          props[propName] = defaultProps[propName];
        } else {
          props[propName] = config[propName];
        }
      }
    }
  }

  // Children can be more than one argument, and those are transferred onto
  // the newly allocated props object.
  const childrenLength = arguments.length - 2;
  if (childrenLength === 1) {
    props.children = children;
  } else if (childrenLength > 1) {
    const childArray = Array(childrenLength);
    for (let i = 0; i < childrenLength; i++) {
      childArray[i] = arguments[i + 2];
    }
    props.children = childArray;
  }

  return ReactElement(element.type, key, ref, self, source, owner, props);
}
```

> React.cloneElement()几乎等同于

```js
<element.type {...element.props} {...props}>
  {children}
</element.type>
```

### 劫持组件

```js
function AddStyle({ children }) {
  return React.cloneElement(
    children,
    {
      style: {
        background: "#dfdfdf",
      },
    },
    "hello world"
  );
}
<AddStyle>
  <div></div>
</AddStyle>;
```

## Component 和 PureComponent 两个基类(ReactBaseClasses.js)

> 以 element 为样板克隆返回新的 React 元素，返回的 props 为新和旧的 props 进行浅层合并后的结果。新的子元素会替代旧的子元素，但是 key 和 ref 会保留。

源码解析 ↓

```js
function Component(props, context, updater) {
  this.props = props;
  this.context = context;
  // 使用string ref
  this.refs = emptyObject;
  this.updater = updater || ReactNoopUpdateQueue;
}

Component.prototype.isReactComponent = {};

Component.prototype.setState = function (partialState, callback) {
  // 校验第一个参数
  // partialState: 要更新的对象
  // 新的react版本推荐setState使用方法 => this.setState((preState) => ({count:preState.count+1}))
  invariant(
    typeof partialState === "object" ||
      typeof partialState === "function" ||
      partialState == null,
    "setState(...): takes an object of state variables to update or a " +
      "function which returns an object of state variables."
  );
  // 更新队列 实现在react-dom里 整个Component的初始化入口
  this.updater.enqueueSetState(this, partialState, callback, "setState");
};

// 强制更新
Component.prototype.forceUpdate = function (callback) {
  // 同样也在react-dom里实现
  this.updater.enqueueForceUpdate(this, callback, "forceUpdate");
};

function ComponentDummy() {}
ComponentDummy.prototype = Component.prototype;

/**
 * 和Component一致
 */
function PureComponent(props, context, updater) {
  this.props = props;
  this.context = context;
  this.refs = emptyObject;
  this.updater = updater || ReactNoopUpdateQueue;
}

// 继承
const pureComponentPrototype = (PureComponent.prototype = new ComponentDummy());
pureComponentPrototype.constructor = PureComponent;
// 复制拷贝 唯一的区别是标记上的区别 isPureReactComponent
Object.assign(pureComponentPrototype, Component.prototype);
pureComponentPrototype.isPureReactComponent = true;
```

有标识则会进行浅比较 state 和 props。
**React 中对比一个 ClassComponent 是否需要更新，只有两个地方。一是看有没有 shouldComponentUpdate 方法，二就是这里的 PureComponent 判断**

```js
if (ctor.prototype && ctor.prototype.isPureReactComponent) {
  return !shallowEqual(oldProps, newProps) || !shallowEqual(oldState, newState);
}
```

## 设计思想

- 平台思想(React 和 ReactDOM 分包)
  抽象出概念，彻底剥离实现层，react 只是处理了类型和参数的转换，不具体的实现任何业务。各个平台的实现放到 ReactDom 里处理。

未完待续...

## createRef & ref

> 核心：Refs 提供了一种方式，允许我们访问 DOM 节点或在 render 方法中创建的 React 元素。

_三种使用方式_

- string ref 即将抛弃不推荐
- obj
- function

```js
class App extends React.Component {
  componentDidMount() {
    setTimeout(() => {
      this.refs.myDiv.textContent = "string ref";
      this.objRef.current.textContent = "object ref";
      this.funRef.textContent = "function ref";
    }, 2000);
  }
  render() {
    <>
      <p ref="myDiv"></p>
      <p ref={this.objRef}></p>
      <p ref={(node) => (this.funRef = node)}></p>
    </>;
  }
}
```

### createRef

Refs 是使用 React.createRef() 创建的，并通过 ref 属性附加到 React 元素。在构造组件时，通常将 Refs 分配给实例属性，以便可以在整个组
件中引用它们。

如果想使用 ref,只需要拿 current 对象即可，

### 源码

```js
export function createRef(): RefObject {
  const refObject = {
    current: null,
  };
  return refObject;
}
```

### 访问 Refs

当 ref 被传递给 render 中的元素时，对该节点的引用可以在 ref 的 current 属性中被访问。

```js
const node = this.myRef.current;
```

- 当 ref 属性用于 HTML 元素时，current 属性为底层 DOM 元素。
- 当 ref 属性用于自定义 class 组件时，current 属性为接收组件的挂载实例。
- 不能在函数组件上使用 ref 属性，因为它们没有实例。可以通过`useRef`可以在函数组件内部使用 ref 属性，只要它指向一个 DOM 元素或 class 组件

## forwardRef

> forwardRef 是用来解决 HOC 组件传递 ref 的问题的。

```js
const TargetComponent = React.forwardRef((props, ref) => (
  <TargetComponent ref={ref} />
));
```

> 这也是为什么要提供 createRef 作为新的 ref 使用方法的原因，如果用 string ref 就没法当作参数传递了。

### 源码

```js
export function forwardRef<Props, ElementType: React$ElementType>(
  render: (props: Props, ref: React$Ref<ElementType>) => React$Node,
) {
  ...
  const elementType = {
    $$typeof: REACT_FORWARD_REF_TYPE,
    render,
  };
  return elementType;
}
// 返回对象 reactElement的type还是REACT_ELEMENT_TYPE
```

## Context

> Context 提供了一个无需为每层组件手动添加 props，就能在组件间进行数据传递的方法。

### 老 api -> childContextType 17 大版本移除 老 api 性能差会多次渲染

```js
// Parent
getChildContext () {
  return { value: this.state.text }
}

Parent.childContextTypes = {
  // 都需要声明
  value: PropTypes.string
}

// Child 使用
{this.state.context.value}

Child.childContextTypes = {
  // 都需要声明 因为可能有多个父级
  value: PropTypes.string
}
```

### 新 api -> createContext

#### 使用

```js
// createContext的Provider和Consumer是一一对应的
const { Provider, Consumer } = React.createContext('defaultValue')

const ProviderComp = (props) => (
  <Provider value={'realValue'}>
    {props.children}
  </Provider>
)

const ConsumerComp = () => (
  <Consumer>
    {(value) => <p>{value}</p>}
  </Consumber>
)
```

当 Provider 的 value 值发生变化时，它内部的所有消费组件都会重新渲染。Provider 及其内部 consumer 组件都不受制于
shouldComponentUpdate 函数，因此当 consumer 组件在其祖先组件退出更新的情况下也能更新。

#### 源码

```js
//calculateChangedBits方法,使用Object.is()计算新老context变化
//defaultValue 当Provider组件属性value不存在时 会使用默认值defaultValue
function createContext(defaultValue, calculateChangedBits) {
  if (calculateChangedBits === undefined) {
    calculateChangedBits = null;
  } else {
    {
      !(
        calculateChangedBits === null ||
        typeof calculateChangedBits === "function"
      )
        ? warningWithoutStack$1(
            false,
            "createContext: Expected the optional second argument to be a " +
              "function. Instead received: %s",
            calculateChangedBits
          )
        : void 0;
    }
  }

  var context = {
    $$typeof: REACT_CONTEXT_TYPE, //context的$$typeof在createElement中的type中的type对象中存储
    _calculateChangedBits: calculateChangedBits, //计算新老context变化
    //_currentValue和_currentValue2作用一样,只是作用平台不同
    _currentValue: defaultValue, //Provider的value属性
    _currentValue2: defaultValue,
    _threadCount: 0, //用来追踪context的并发渲染器数量
    Provider: null, //提供组件
    Consumer: null, //应用组件
  };
  //返回一个context对象
  return context;
}
```

## ConcurrentMode

> ConcurrentMode 有一个特性，在一个子树当中渲染了 ConcurrentMode 之后，它下面的所有节点产生的更新都是一个低优先级的更新。方便 react 区分一
> 些优先级高低的任务，在进行更新的过程中，优先执行一些较高的任务。

### 使用

```js
<ConcurrentMode>
  <List />
</ConcurrentMode>
```

### 源码

```js
// React.js
import {
  REACT_CONCURRENT_MODE_TYPE,
  REACT_FRAGMENT_TYPE,
  REACT_PROFILER_TYPE,
  REACT_STRICT_MODE_TYPE,
  REACT_SUSPENSE_TYPE,
} from 'shared/ReactSymbols';
...

if (enableStableConcurrentModeAPIs) {
  React.ConcurrentMode = REACT_CONCURRENT_MODE_TYPE;
  React.Profiler = REACT_PROFILER_TYPE;
} else {
  React.unstable_ConcurrentMode = REACT_CONCURRENT_MODE_TYPE;
  React.unstable_Profiler = REACT_PROFILER_TYPE;
}

...

// ReactSymbols.js
const hasSymbol = typeof Symbol === 'function' && Symbol.for;

...

export const REACT_CONCURRENT_MODE_TYPE = hasSymbol
  ? Symbol.for('react.concurrent_mode')
  : 0xeacf;

// 可以看出ConcurrentMode组件就是一个简单的Symbol，它也没有任何的属性
// 思考它是如何承载children的?
```

## suspense & lazy

### 使用

```js
import React, { lazy, Suspense } from "react";

const LazyComp = lazy(() => import("../views/LazyComp"));
// 延迟加载回调
const SuspenseComponent = (Component) => (props) => {
  return (
    <Suspense fallback="loading data">
      <Component {...props}></Component>
      <LazyComp />
    </Suspense>
  );
};
```

在 Suspense 内部有多个组件，它要等所有组件都 resolve 之后，它才会把 fallback 去掉，然后显示出这里面的内容，有任何一个还处于
pending 状态的，那么它还是会显示 fallback 的内容.

### 源码

```js
Suspense: REACT_SUSPENSE_TYPE, // Suspense也是Symbol 也是一个标识
```

```js
import type { LazyComponent, Thenable } from "shared/ReactLazyComponent";

import { REACT_LAZY_TYPE } from "shared/ReactSymbols";

// lazy 是一个方法，接收一个方法并且返回一个 Thenable(就是Promise对象)
export function lazy<T, R>(ctor: () => Thenable<T, R>): LazyComponent<T> {
  return {
    $$typeof: REACT_LAZY_TYPE,
    _ctor: ctor, // 记载了传入的生产thenable对象的方法
    // React uses these fields to store the result.
    _status: -1, // 用来记录 Thenable 的一个状态
    _result: null, // 用来记录这个对象 resolve 之后返回的那个属性 lazy()最终返回出来的组件会放到_result 里面，
  };
}
```

㊗️ 💐 恭喜初中毕业了 😃❀❀❀

## Children 详解

children 由`map`, `forEach`, `count`, `toArray`, `only`组成。看起来和数组的方法很类似，用于处理`this.props.children`这种不透
明数据结构的应用程序。由于 children 几个方法的核心都是`mapIntoArray`，因此这里只对 map 做分析，其他的可以自己去查看。

React.Children 提供了用于处理 props.children 不透明数据结构的实用方法。

- React.Children.map
- React.Children.forEach
- React.Children.count
- React.Children.only: 验证 children 是否只有一个子节点（一个 React 元素），如果有则返回它，否则此方法会抛出错误。
- React.Children.toArray: 将 children 这个复杂的数据结构以数组的方式扁平展开并返回，并为每个子节点分配一个 key。

### react.children.map

map 的使用实例，虽然处理函数给的是多维数组，但是通过 map 处理后，返回的结果其实被处理成为了一维数组。

- 如果是 fragment，将会被视为一个子组件，不会被遍历。

```js
class Child extends React.Component {
  render() {
    console.log(React.Children.map(this.props.children, c => [[c],[c],[c]]));
    return (
      <div>{
        React.Children.map(this.props.children, c => [[c],[c],[c]])
      }</div>
    )
  }
}
class App extends React.Component {
  render() {
    return(
      <div>
        <Child><p>hello1</p><p>hello2</p></Child>
      </div>
    )
  }
}
// 渲染结果：
<p>hello1</p>
<p>hello1</p>
<p>hello1</p>
<p>hello2</p>
<p>hello2</p>
<p>hello2</p>
```

![map流程两个递归](http://cdn.mydearest.cn/blog/images/react-children-map.png)

打印 dom 结构，发现每个节点都各自生成了一个 key，下面会解析生成该 key 的步骤。
![源码1](http://cdn.mydearest.cn/blog/images/react-origin.png)

## memo

与 React.PureComponent 非常相似，适用于函数组件，但不适用于 class 组件。

since React 16.6

**memo 用法**

```jsx
function MyComponent(props) {
  /* 使用 props 渲染 */
}
function areEqual(prevProps, nextProps) {
  /*
  如果把 nextProps 传入 render 方法的返回结果与
  将 prevProps 传入 render 方法的返回结果一致则返回 true，
  否则返回 false
  */
}
export default React.memo(MyComponent, areEqual);
```

**memo 源码**

```jsx
// * react/packages/react/src/memo.js
export default function memo<Props>(
  type: React$ElementType,
  compare?: (oldProps: Props, newProps: Props) => boolean,
) {
  if (__DEV__) {
    ...
  }
  return {
    $$typeof: REACT_MEMO_TYPE,
    type,
    compare: compare === undefined ? null : compare,
  };
}
```

## Fragment

> 不额外创建 DOM 元素的情况下，让 render() 方法中返回多个元素。

```jsx
// * react/packages/react/src/React.js
const React = {
  ...,
  Fragment: REACT_FRAGMENT_TYPE,
  ...
}

// * react/packages/shared/ReactSymbols.js
export const REACT_FRAGMENT_TYPE = hasSymbol
  ? Symbol.for('react.fragment')
  : 0xeacb;
```

## StrictMode

用于检查子节点有没有潜在的问题。严格模式检查仅在开发模式下运行；它们不会影响生产构建。

```jsx
// * 不会对 Header 和 Footer 组件运行严格模式检查。但是，ComponentOne 和 ComponentTwo 以及它们的所有后代元素都将进行检查。
function ExampleApplication() {
  return (
    <div>
      <Header />
      <React.StrictMode>
        <div>
          <ComponentOne />
          <ComponentTwo />
        </div>
      </React.StrictMode>
      <Footer />
    </div>
  );
}
```

```jsx
// * react/packages/react/src/React.js
const React = {
  ...,
  StrictMode: REACT_STRICT_MODE_TYPE,
  ...
}

// * react/packages/shared/ReactSymbols.js
export const REACT_STRICT_MODE_TYPE = hasSymbol
  ? Symbol.for('react.strict_mode')
  : 0xeacc;
```

## 参考文档

https://juejin.im/post/6855129007852109837

https://react.jokcy.me/book/api/react.html

http://muyunyun.cn/blog/#/README
