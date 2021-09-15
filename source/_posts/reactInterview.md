---
title: react面试题记录
tags:
  - react
  - 面试
copyright: true
comments: true
date: 2018-06-07 14:47:09
categories: React
photos:
---

{% fi http://cdn.mydearest.cn/blog/images/reactInterview.jpeg , reactInterview, React%}
---
<!-- more -->

## React面试问题
下面是一个常用的关于 React 的面试问题列表：

### React 的响应式原理
React 会创建一个虚拟 DOM(virtual DOM)。当一个组件中的状态改变时，React 首先会通过 "diff" 算法来标记虚拟 DOM 中的改变，第二步是调节(reconciliation)，会用`diff`的结果来更新真实DOM。虚拟
DOM作为一种缓存机制优化了UI渲染减少昂贵的DOM变化的数量。

1. 开发者只需关注状态转移（数据），当状态发生变化，React框架会自动根据新的状态重新构建UI。
2. React框架在接收到用户状态改变通知后，会根据当前渲染树，结合最新的状态改变，通过Diff算法，计算出树中变化的部分，然后只更新变化的部分（DOM操作），从而避免整棵树重构，提高性能。状态变化后
React框架并不会立即去计算并渲染DOM树的变化部分，相反，React会在DOM的基础上建立一个抽象层，即虚拟DOM树，对数据和状态所做的任何改动，都会被自动且高效的同步到虚拟DOM，最后再批量同步到真实DOM
中，而不是每次改变都去操作一下DOM。

为什么不能每次改变都直接去操作DOM树？
这是因为在浏览器中每一次DOM操作都有可能引起浏览器的重绘或回流：
* 如果DOM只是外观风格发生变化，如颜色变化，会导致浏览器重绘界面。
* 如果DOM树的结构发生变化，如尺寸、布局、节点隐藏等导致，浏览器就需要回流（及重新排版布局）。
而浏览器的重绘和回流都是比较昂贵的操作，如果每一次改变都直接对DOM进行操作，这会带来性能问题，而批量操作只会触发一次DOM更新。

### 使用 React 有何优点
* 只需查看 `render` 函数就会很容易知道一个组件是如何被渲染的
* JSX 的引入，使得组件的代码更加可读，也更容易看懂组件的布局，或者组件之间是如何互相引用的
* 支持服务端渲染，这可以改进 SEO 和性能
* 易于测试
* React 只关注 View 层，所以可以和其它任何框架(如Backbone.js, Angular.js)一起使用

### 展示组件(Presentational component)和容器组件(Container component)之间有何不同
展示组件关心组件看起来是什么。展示专门通过 props 接受数据和回调，并且几乎不会有自身的状态，但当展示组件拥有自身的状态时，通常也只关心 UI 状态而不是数据的状态。

容器组件则更关心组件是如何运作的。容器组件会为展示组件或者其它容器组件提供数据和行为(behavior)，它们会调用 `Flux actions`，并将其作为回调提供给展示组件。容器组件经常是有状态的，因为它们是(其它组件的)数据源。

### 类组件(Class component)和函数式组件(Functional component)之间有何不同
* 类组件不仅允许你使用更多额外的功能，如组件自身的状态和生命周期钩子，也能使组件直接访问 `store` 并维持状态
* 当组件仅是接收 `props`，并将组件自身渲染到页面时，该组件就是一个 '无状态组件(stateless component)'，可以使用一个纯函数来创建这样的组件。这种组件也被称为哑组件(dumb components)或展示组件

### (组件的)状态(state)和属性(props)之间有何不同
`State` 是一种数据结构，用于组件挂载时所需数据的默认值。`State` 可能会随着时间的推移而发生突变，但多数时候是作为用户事件行为的结果。

`Props`(properties 的简写)则是组件的配置。`props` 由父组件传递给子组件，并且就子组件而言，`props` 是不可变的(immutable)。组件不能改变自身的 props，但是可以把其子组件的 props 放在一起(统一管理)。Props 也不仅仅是数据--回调函数也可以通过 props 传递。

### 指出(组件)生命周期方法的不同
* `componentWillMount` -- 多用于根组件中的应用程序配置
* `componentDidMount` -- 在这可以完成所有没有 DOM 就不能做的所有配置，并开始获取所有你需要的数据；如果需要设置事件监听，也可以在这完成
* `componentWillReceiveProps` -- 这个周期函数作用于特定的 prop 改变导致的 state 转换
* `shouldComponentUpdate` -- 如果你担心组件过度渲染，`shouldComponentUpdate` 是一个改善性能的地方，因为如果组件接收了新的 `prop`， 它可以阻止(组件)重新渲染。shouldComponentUpdate 应该返回一个布尔值来决定组件是否要重新渲染
* `componentWillUpdate` -- 很少使用。它可以用于代替组件的 `componentWillReceiveProps` 和 `shouldComponentUpdate`(但不能访问之前的 props)
* `componentDidUpdate` -- 常用于更新 DOM，响应 prop 或 state 的改变
* `componentWillUnmount` -- 在这你可以取消网络请求，或者移除所有与组件相关的事件监听器

### 应该在 React 组件的何处发起 Ajax 请求
在 React 组件中，应该在 `componentDidMount` 中发起网络请求。这个方法会在组件第一次“挂载”(被添加到 DOM)时执行，在组件的生命周期中仅会执行一次。更重要的是，你不能保证在组件挂载之前 Ajax 请求已经完成，如果是这样，也就意味着你将尝试在一个未挂载的组件上调用 setState，这将不起作用。在 `componentDidMount` 中发起网络请求将保证这有一个组件可以更新了。

### 何为受控组件(controlled component)
在 HTML 中，类似 `<input>`, `<textarea>` 和 `<select>` 这样的表单元素会维护自身的状态，并基于用户的输入来更新。当用户提交表单时，前面提到的元素的值将随表单一起被发送。但在 React 中会有些不同，包含表单元素的组件将会在 state 中追踪输入的值，并且每次调用回调函数时，如 `onChange` 会更新 state，重新渲染组件。一个输入表单元素，它的值通过 React 的这种方式来控制，这样的元素就被称为"受控元素"。

### 在 React 中，refs 的作用是什么
Refs 可以用于获取一个 DOM 节点或者 React 组件(组件实例)的引用。何时使用 refs 的好的示例有管理焦点/文本选择，触发命令动画，或者和第三方 DOM 库集成。你应该避免使用 String 类型的 Refs 和内联的 ref 回调。Refs 回调是 React 所推荐的。

### 三种ref方式
1. string类型绑定
类似于vue中的ref绑定方式，可以通过this.refs.绑定的ref的名字获取到节点dom，注意的是这种方式已经不被最新版的react推荐使用，有可能会在未来版本中遗弃。
```js
focus = () => {
  this.refs.inputRef.focus()
}
<input ref="inputRef"/>

// 获取子组件的div
// 父组件
<Child myRef={this.state.myDiv}/>
// 子组件
 <div ref={this.props.myRef}>我是子组件</div>
```

2. react.CreateRef()
通过在class中使用React.createRef()方法创建一些变量，可以将这些变量绑定到标签的ref中，该变量的current则指向绑定的标签dom。
```js
inputRef = React.createRef()
focus = () => {
  this.inputRef.current.focus()
}
<input ref={this.inputRef}/>
```

3. 函数形式
在class中声明函数，在函数中绑定ref使用这种方法可以将子组件暴露给父组件以使得父组件能够调用子组件的方法
```js
inputRef = null
focus = () => {
  this.inputRef.focus()
}
<input ref={(el)=>this.inputRef=el}/>
```

4. useRef(实例属性)
```js
function UseRefDemo() {
  const inputRef = useRef(null as any)

  const handleFocusInput = () => {
    inputRef.current.focus()
  }

  return (
    <div>
      <input ref={inputRef} />
      <button onClick={handleFocusInput}>click focus</button>
    </div>
  )
}
```

5. forwardRef(获取组件内的引用)
```js
// 子组件
const Child = forwardRef((props, ref)=>{
  return (
  	<div ref={ref}>{props.txt}</div>
  )
})

// 父组件
<Child ref={this.state.myDiv} txt="parent props txt"/>
```

注意: react并不推荐过度使用ref，如果能通过state做到的事情，就不应该使用 refs 在你的 app 中“让事情发生”。过度使用ref并不符合数据驱动的思想。

### 何为高阶组件(higher order component)
高阶组件是一个以组件为参数并返回一个新组件的函数。HOC 运行你重用代码、逻辑和引导抽象。最常见的可能是 Redux 的 `connect` 函数。除了简单分享工具库和简单的组合，HOC最好的方式是共享 React 组件之间的行为。如果你发现你在不同的地方写了大量代码来做同一件事时，就应该考虑将代码重构为可重用的 HOC。
装饰器@decoration
优点:
- 逻辑复用
- 不影响被包裹组件的逻辑

缺点:
- 传递的props和包裹组件的props发生重名会覆盖
- 组件嵌套导致层级过深

### 渲染属性(render props)
Render prop 是一个告知组件需要渲染什么内容的函数 prop
优点:
- 逻辑复用
- 数据共享

缺点:
- 嵌套
- 无法在return语句外访问数据

### 使用箭头函数(arrow functions)的优点是什么
* 作用域安全：在箭头函数之前，每一个新创建的函数都有定义自身的 `this` 值(在构造函数中是新对象；在严格模式下，函数调用中的 `this` 是未定义的；如果函数被称为“对象方法”，则为基础对象等)，但箭头函数不会，它会使用封闭执行上下文的 `this` 值。
* 简单：箭头函数易于阅读和书写
* 清晰：当一切都是一个箭头函数，任何常规函数都可以立即用于定义作用域。开发者总是可以查找 next-higher 函数语句，以查看 `this` 的值

### 为什么建议传递给 setState 的参数是一个 callback 而不是一个对象
因为 `this.props` 和 `this.state` 的更新可能是异步的，不能依赖它们的值去计算下一个 state。setState在生命周期里是异步的，第二个参数是组件重新渲染完成后的回调。

### 除了在构造函数中绑定 `this`，还有其它方式吗
在 constructor 里使用 bind。在回调中你可以使用箭头函数，但问题是每次组件渲染时都会创建一个新的回调。

### 怎么阻止组件的渲染
在组件的 `render` 方法中返回 `null` 并不会影响触发组件的生命周期方法

### react 与 vue 数组中 key 的作用是什么
diff算法需要比对虚拟dom的修改，然后异步的渲染到页面中，当出现大量相同的标签时，vnode会首先判断key和标签名是否一致，如果一致再去判断子节点一致，使用key可以帮助diff算法提升判断的速度，在页面
重新渲染时更快消耗更少。

### (在构造函数中)调用 super(props) 的目的是什么
在 `super()` 被调用之前，子类是不能使用 `this` 的，在 ES2015 中，子类必须在 `constructor` 中调用 `super()`。传递 `props` 给 `super()` 的原因则是便于(在子类中)能在 `constructor` 访问 `this.props`。

### 何为 JSX
JSX 是 JavaScript 语法的一种语法扩展，并拥有 JavaScript 的全部功能。JSX 生产 React "元素"，你可以将任何的 JavaScript 表达式封装在花括号里，然后将其嵌入到 JSX 中。在编译完成之后，JSX 表达式就变成了常规的 JavaScript 对象，这意味着你可以在 `if` 语句和 `for` 循环内部使用 JSX，将它赋值给变量，接受它作为参数，并从函数中返回它。

缺点：b&& 强转成boolean类型 否则如果b=0渲染出0

### 怎么用 React.createElement 重写下面的代码

Question：

```js
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
);
```

Answer：

```js
const element = React.createElement(
  'h1',
  {className: 'greeting'},
  'Hello, world!'
);
```

### 何为 `Children`
在JSX表达式中，一个开始标签(比如`<a>`)和一个关闭标签(比如`</a>`)之间的内容会作为一个特殊的属性`props.children`被自动传递给包含着它的组件。

这个属性有许多可用的方法，包括 `React.Children.map`，`React.Children.forEach`， `React.Children.count`， `React.Children.only`，`React.Children.toArray`。

### 在 React 中，何为 state
State 和 props 类似，但它是私有的，并且完全由组件自身控制。State 本质上是一个持有数据，并决定组件如何渲染的对象。

### 你为何排斥 create-react-app
在你排斥之前，你并不能去配置 webpack 或 babel presets。

### 何为 redux
Redux 的基本思想是整个应用的 state 保持在一个单一的 store 中。store 就是一个简单的 javascript 对象，而改变应用 state 的唯一方式是在应用中触发 actions，然后为这些 actions 编写 reducers 来修改 state。整个 state 转化是在 reducers 中完成，并且不应该由任何副作用。

### 在 Redux 中，何为 store
Store 是一个 javascript 对象，它保存了整个应用的 state。与此同时，Store 也承担以下职责：

* 允许通过 `getState()` 访问 state
* 运行通过 `dispatch(action)` 改变 state
* 通过 `subscribe(listener)` 注册 listeners
* 通过 `subscribe(listener)` 返回的函数处理 listeners 的注销

### 何为 action
Actions 是一个纯 javascript 对象，它们必须有一个 type 属性表明正在执行的 action 的类型。实质上，action 是将数据从应用程序发送到 store 的有效载荷。

### 何为 reducer
一个 reducer 是一个纯函数，该函数以先前的 state 和一个 action 作为参数，并返回下一个 state。

### Redux Thunk 的作用是什么
Redux thunk 是一个允许你编写返回一个函数而不是一个 action 的 actions creators 的中间件。如果满足某个条件，thunk 则可以用来延迟 action 的派发(dispatch)，这可以处理异步 action 的派发(dispatch)。

### 何为纯函数(pure function)
一个纯函数是一个不依赖于且不改变其作用域之外的变量状态的函数，这也意味着一个纯函数对于同样的参数总是返回同样的结果。
- 同输入同输出
- 无副作用(函数内部的操作不会对外部产生影响(如修改全局变量的值、修改 dom 节点等))

### redux有哪些中间件，作用？
中间件提供第三方插件的模式，自定义拦截 action -> reducer 的过程。变为 action -> middlewares -> reducer 。这种机制可以让我们改变数据流，实现如异步 action ，action 过滤，日志输出，异常报告等功能。

redux-logger：提供日志输出

redux-thunk：处理异步操作

redux-promise：处理异步操作，actionCreator的返回值是promise

### 示例项目
* [React Spotify](https://github.com/Pau1fitz/react-spotify)
* [React Soundcloud](https://github.com/andrewngu/sound-redux)

### 虚拟dom(虚拟节点)是用JS对象来模拟真实DOM中的节点
虚拟dom相当于在js和真实dom中间加了一个缓存，利用dom diff算法避免了没有必要的dom操作，从而提高性能。具体实现步骤如下：用 JavaScript 对象结构表示 DOM 树的结构；然后用这个树构建一个真正的 DOM 树，插到文档当中当状态变更的时候，重新构造一棵新的对象树。然后用新的树和旧的树进行比较，记录两棵树差异把2所记录的差异应用到步骤1所构建的真正的DOM树上，视图就更新了。插入新组件有了key可以帮助react找到映射。

- 真实的元素节点
```html
<div id="wrap">
    <p class="title">Hello world!</p>
</div>
```

- vnode
```js
{
    tag:'div',
    attrs:{
        id:'wrap'
    },
    children:[
        {
            tag:'p',
            text:'Hello world!',
            attrs:{
                class:'title',
            }
        }
    ]
}
```

### 为什么使用虚拟dom
起初我们在使用JS/JQuery时，不可避免的会大量操作DOM，而DOM的变化又会引发回流或重绘，从而降低页面渲染性能。那么怎样来减少对DOM的操作呢？此时虚拟DOM
应用而生，所以虚拟DOM出现的主要目的就是`为了减少频繁操作DOM而引起回流重绘所引发的性能问题的`

### 虚拟dom的作用
兼容性好。因为Vnode本质是JS对象，所以不管Node还是浏览器环境，都可以操作；
减少了对Dom的操作。页面中的数据和状态变化，都通过Vnode对比，只需要在比对完之后更新DOM，不需要频繁操作，提高了页面性能。

每个setState重新渲染整个子树标记为dirty。 如果要压缩性能，请尽可能调用 setState，并使用shouldComponentUpdate 来防止重新渲染大型子树。把树形结构按照层级分解，只比较同级元素。给列表结构的每个单元添加唯一的key属性，方便比较。pureComponent(浅比较)+immutable 替换成preact

### diff算法 
> 一开始会根据真实DOM生成虚拟DOM，当虚拟DOM某个节点的数据改变后会生成一个新的Vnode，然后VNode和oldVnode对比，把不同的地方修改在真实DOM上，最后再使得oldVnode的值为Vnode。

`diff过程就是调用patch函数，比较新老节点，一边比较一边给真实DOM打补丁(patch)；`

![patch](http://cdn.mydearest.cn/blog/images/patch.png)

把树形结构按照层级分解，只比较同级元素。

给列表结构的每个单元添加唯一的key属性，方便比较。

React 只会匹配相同 class 的 component（这里面的class指的是组件的名字）

合并操作，调用 component 的 setState 方法的时候, React 将其标记为 dirty.到每一个事件循环结束, React 检查所有标记 dirty 的 component 重新绘制.

选择性子树渲染。开发人员可以重写shouldComponentUpdate提高diff的性能。

diff的只是html tag，并没有diff数据。

### setState的理解
- setState 只在`合成事件`和`钩子函数(除了componentDidUpdate)`中是“异步”的，在原生事件和 setTimeout 中都是同步的。
- setState 的“异步”并不是说内部由异步代码实现，其实本身执行的过程和代码都是同步的，只是合成事件和钩子函数的调用顺序在更新之前，导致在合成事件和钩子函数中没法立马拿到更新后的值，形成了所谓的“异步”，当然可以通过第二个参数 setState(partialState, callback) 中的callback拿到更新后的结果。
- setState 的批量更新优化也是建立在“异步”（合成事件、钩子函数）之上的，在原生事件和setTimeout 中不会批量更新，在“异步”中如果对同一个值进行多次setState，setState的批量更新策略会对其进行覆盖，取最后一次的执行，如果是同时setState多个不同的值，在更新时会对其进行合并批量更新。

- 异步与同步: setState并不是单纯的异步或同步，这其实与调用时的环境相关:
  - 在 合成事件 和 生命周期钩子(除 componentDidUpdate) 中，setState是"异步"的；
    - 原因: 因为在setState的实现中，有一个判断: 当更新策略正在事务流的执行中时，该组件更新会被推入dirtyComponents队列中等待执行；否则，开始执行batchedUpdates队列更新；

  - 在生命周期钩子调用中，更新策略都处于更新之前，组件仍处于事务流中，而componentDidUpdate是在更新之后，此时组件已经不在事务流中了，因此则会同步执行；
  在合成事件中，React 是基于 事务流完成的事件委托机制 实现，也是处于事务流中；
    - 问题: 无法在setState后马上从this.state上获取更新后的值。
    - 解决: 如果需要马上同步去获取新值，setState其实是可以传入第二个参数的。setState(updater, callback)，在回调中即可获取最新值；

  - 在 原生事件 和 setTimeout 中，setState是同步的，可以马上获取更新后的值；
    - 原因: 原生事件是浏览器本身的实现，与事务流无关，自然是同步；而setTimeout是放置于定时器线程中延后执行，此时事务流已结束，因此也是同步；

- 批量更新
  - 在 合成事件 和 生命周期钩子 中，setState更新队列时，存储的是`合并状态(Object.assign)`。因此前面设置的 key 值会被后面所覆盖，最终只会执行一次更新；

- 函数式
  - 由于 Fiber 及 合并 的问题，官方推荐可以传入 函数 的形式。setState(fn)，在fn中返回新的state对象即可，例如this.setState((state, props) => newState)；
  - 使用函数式，可以用于避免setState的批量更新的逻辑，传入的函数将会被顺序调用；

- 注意点
  - 当组件已被销毁，如果再次调用setState，React 会报错警告，通常有两种解决办法:
    - 将数据挂载到外部，通过 props 传入，如放到 Redux 或 父级中；
    - 在组件内部维护一个状态量 (isUnmounted)，componentWillUnmount中标记为 true，在setState前进行判断；

### 替换的属性

- class/className for/htmlFor

### 插入html文本
```javascript
dangerouslySetInnerHTML={{__html: content}}
```

### 15版本的生命周期如下：
1. 初始化阶段
- constructor
- getDefaultProps
- getInitialState

2. 挂载阶段
- componentWillMount
- render
- componentDidMount

3. 更新阶段
props：
- componentWillReceiveProps
- shouldComponentUpdate
- componentWillUpdate
- render
- componentDidUpdate
state：
- shouldComponentUpdate
- componentWillUpdate
- render
- componentDidUpdate

4. 卸载阶段
- componentWillUnmount

### 16版本生命周期如下：
1. 初始化阶段
- constructor
- getDefaultProps
- getInitialState

2. 挂载阶段
```js
组件实例化。
组件的props发生变化。
父组件重新渲染。
this.setState()不会触发getDerivedStateFromProps()，但是this.forceUpdate()会。
```
- getDerivedStateFromProps:传入nextProps和prevState，根据需要将props映射到state，否则返回null
- render
- componentDidMount

3. 更新阶段
- getDerivedStateFromProps
- shouldComponentUpdate
- render
- getSnapshotBeforeUpdate：render之后dom渲染之前会发生，返回一个值作为componentDidUpdate的第三个参数使用
- componentDidUpdate

4. 卸载阶段
- componentWillUnmount

5. 错误处理
- componentDidCatch

### 事件机制
react事件并没有绑定到真实的dom节点上，而是通过事件代理，在最外层的document上对事件进行统一分发。

### 为什么react事件要自己绑定this
在react中事件处理函数是直接调用的，并没有指定调用的组件，所以不进行手动绑定的情况下直接获取到的this是不准确的，所以我们需要手动将当前组件绑定到this上。

### react和原生事件的执行顺序是什么，可以混用吗
react的所有事件都通过document进行统一分发，当真实dom触发事件后冒泡到document后才会对react事件进行处理

所以原生事件会先执行，然后执行react合成事件，最后执行真正在document上挂载的事件两者最好不要混用，原生事件中如果执行了stopPropagation方法，则会导致其他react事件失效。

### 虚拟dom比普通dom更快吗
首次渲染时vdom不具有任何优势甚至要进行更多的计算，消耗更多的内存。

vdom的优势在于react的diff算法和批处理策略，react在页面更新之前，提前计算好了如何进行更新和渲染dom。vdom主要是能在重复渲染时帮助我们计算如何实现更高效的更新，而不是说它比dom操作快。

### 虚拟dom中的$$typeof属性的作用是什么
它被赋值为REACT_ELEMENT_TYPE，是一个symbol类型的变量，这个变量可以防止XSS。react渲染时会把没有$$typeof标识以及规则校验不通过的组件全都过滤掉。当你的环境不支持Symbol时，$$typeof被赋值为0xeac7，为什么采用0xeac7？
> 0xeac7看起来有点像React。

### HOC在业务场景中有哪些实际的应用

- 组合渲染(属性代理)
```js
// 更改 props
function proxyHoc(Comp) {
	return class extends React.Component {
		render() {
			const newProps = {
				name: 'tayde',
				age: 1,
			}
			return <Comp {...this.props} {...newProps} />
		}
	}
}
```
很方便将`Input`组件转化为受控组件
- 条件渲染
```js
// 反向继承传递过来的组件
function withLoading(Comp) {
    return class extends Comp {
        render() {
            if(this.props.isLoading) {
                return <Loading />
            } else {
                return super.render()
            }
        }
    };
}
```
- 操作props
- 获取refs
- 操作state
可以直接通过 this.state 获取到被包裹组件的状态，并进行操作。但这样的操作容易使 state 变得难以追踪，不易维护，谨慎使用。
- 渲染劫持

实际应用场景：
- 日志打点
```js
// 性能监控埋点
function withTiming(Comp) {
    return class extends Comp {
        constructor(props) {
            super(props);
            this.start = Date.now();
            this.end = 0;
        }
        componentDidMount() {
            super.componentDidMount && super.componentDidMount();
            this.end = Date.now();
            console.log(`${WrappedComponent.name} 组件渲染时间为 ${this.end - this.start} ms`);
        }
        render() {
            return super.render();
        }
    };
}
```
- 权限控制
```js
function withAdminAuth(WrappedComponent) {
    return class extends React.Component {
		constructor(props){
			super(props)
			this.state = {
		    	isAdmin: false,
			}
		} 
		async componentWillMount() {
		    const currentRole = await getCurrentUserRole();
		    this.setState({
		        isAdmin: currentRole === 'Admin',
		    });
		}
		render() {
		    if (this.state.isAdmin) {
		        return <Comp {...this.props} />;
		    } else {
		        return (<div>您没有权限查看该页面，请联系管理员！</div>);
		    }
		}
    };
}
```
- 双向绑定
- 表单校验
- 代码复用

### HOC和mixin的异同点是什么
- mixin可能会互相依赖，互相耦合，不利于代码维护

- 不同的mixin中的方法可能会相互冲突

- mixin非常多的时候组件是可以感知到的，甚至还要为其做相关处理，这样会给代码造成滚雪球式的复杂性

- 而HOC的出现则可以解决这些问题

 - hoc是一个没有副作用的纯函数，各个高阶组件不会互相依赖耦合
 - 高阶组件也有可能造成冲突，但我们可以在遵守约定的情况下避免这些情况
 - 高阶组件并不关心数据使用的方式和原因，而被包裹的组件也不关心数据来自何处。高阶组件的增加不会为原组件增加负担

#### hooks有哪些优势(react提供的api,hoc和render props开发模式)
- 组件逻辑越来越复杂(componentDidMount, componentDidUpdate)
尤其是生命周期函数中常常包含一些不相关的逻辑，完全不相关的代码却在同一个方法中组合在一起。如此很容易产生 bug，并且导致逻辑不一致。

- 组件之间复用状态逻辑很难，避免地狱嵌套
hook和mixin在用法上有一定的相似之处，但是mixin引入的逻辑状态是可以互相覆盖的，而多个hooks之间互不影响，hoc也可能带来一定冲突，比如props覆盖等等，使用hooks则可以避免这些问题。大量使用hoc让我们的代码变得嵌套层级非常深，使用hooks我们可以实现扁平式的状态逻辑复用，而避免了大量的组件嵌套。

- 让组件变得更加容易理解 class组件this钩子函数
相比函数，编写一个class可能需要更多的知识，hooks让你可以在class之外使用更多的react的新特性

后续中展示组件需要改造成类组件需要有自己的状态管理和生命周期方法将复用逻辑提升到代码顶部。

### Fiber
> Fiber核心是实现了一个基于优先级和requestIdleCallback的循环任务调度算法

- reconciliation阶段可以把任务拆分成多个小任务
- reconciliation阶段可随时中止或恢复任务
- 可以根据优先级不同来选择优先执行任务

> 在任务队列中选出高优先级的fiber node执行，调用requestIdleCallback获取所剩时间，若执行时间超过了deathLine，或者突然插入更高优先级的任务，则执行中断，保存当前结果，修改tag标记一下，设置为pending状态，迅速收尾并再调用一个requestIdleCallback，等主线程释放出来再继续
恢复任务执行时，检查tag是被中断的任务，会接着继续做任务或者重做

在 v16 之前，reconciliation 简单说就是一个自顶向下递归算法，产出需要对当前DOM进行更新或替换的操作列表，一旦开始，会持续占用主线程，中断操作却不容易实现。当JS长时间执行（如大量计算等），会阻塞
样式计算、绘制等工作，出现页面脱帧现象。所以，v16 进行了一次重写，迎来了代号为Fiber的异步渲染架构。

React 的核心流程可以分为两个部分:
- reconciliation (调度算法，也可称为 render diff阶段):
  - 更新 state 与 props；
  - 调用生命周期钩子；
  - 生成 virtual dom；
    - 这里应该称为 Fiber Tree 更为符合；
  - 通过新旧 vdom 进行 diff 算法，获取 vdom change；
  - 确定是否需要重新渲染

- commit(操作dom阶段):
  - 如需要，则操作 dom 节点更新；

- 问题: 随着应用变得越来越庞大，整个更新渲染的过程开始变得吃力，大量的组件渲染会导致主进程长时间被占用，导致一些动画或高频操作出现卡顿和掉帧的情况。而关键点，便是 同步阻塞。在之前的调度算法中，React 需要实例化每个类组件，生成一颗组件树，使用 同步递归 的方式进行遍历渲染，而这个过程最大的问题就是无法 暂停和恢复。


- 解决方案: 解决同步阻塞的方法，通常有两种: 异步与任务分割。而 React Fiber 便是为了实现任务分割而诞生的。

  - 在 React V16 将调度算法进行了重构， 将之前的 stack reconciler 重构成新版的 fiber reconciler，变成了具有链表和指针的`单链表树遍历算法`。通过指针映射，每个单元都记录着遍历当下的上一步与下一步，从而使遍历变得可以被暂停和重启。
  - 这里我理解为是一种`任务分割调度算法`，主要是将原先同步更新渲染的任务分割成一个个独立的`小任务单位`，根据不同的优先级，将小任务分散到浏览器的空闲时间执行，充分利用主进程的事件循环机制。

```js
class Fiber {
	constructor(instance) {
		this.instance = instance
		// 指向第一个 child 节点
		this.child = child
		// 指向父节点
		this.return = parent
		// 指向第一个兄弟节点
		this.sibling = previous
	}	
}
```

> 核心思想是 任务拆分和协同，主动把执行权交给主线程，使主线程有时间空挡处理其他高优先级任务。
> 当遇到进程阻塞的问题时，任务分割、异步调用 和 缓存策略 是三个显著的解决思路。

- 任务优先级(7种)
```js
{  
  NoWork: 0, // No work is pending.
  SynchronousPriority: 1, // 文本输入框
  TaskPriority: 2, // 当前调度正执行的任务
  AnimationPriority: 3, // 动画过渡
  HighPriority: 4, // 用户交互反馈
  LowPriority: 5, // 数据的更新
  OffscreenPriority: 6, // 预估未来需要显示的任务
}
```

### 为什么生命周期有了变动
在 Fiber 中，reconciliation 阶段进行了任务分割，涉及到 暂停 和 重启，因此可能会导致 reconciliation 中的生命周期函数在一次更新渲染循环中被`多次调用`的情况，产生一些意外错误。

```js
class Component extends React.Component {
  // 替换 `componentWillReceiveProps` ，
  // 初始化和 update 时被调用
  // 静态函数，无法使用 this
  static getDerivedStateFromProps(nextProps, prevState) {}
  
  // 判断是否需要更新组件
  // 可以用于组件性能优化
  shouldComponentUpdate(nextProps, nextState) {}
  
  // 组件被挂载后触发
  componentDidMount() {}
  
  // 替换 componentWillUpdate
  // 可以在更新之前获取最新 dom 数据
  getSnapshotBeforeUpdate() {}
  
  // 组件更新后调用
  componentDidUpdate() {}
  
  // 组件即将销毁
  componentWillUnmount() {}
  
  // 组件已销毁
  componentDidUnMount() {}

  // 错误边界捕获全局异常
  componentDidCatch() {}
}
```

- 在constructor初始化 state；
- 在componentDidMount中进行事件监听，并在componentWillUnmount中解绑事件；
- 在componentDidMount中进行数据的请求，而不是在componentWillMount；
- 需要根据 props 更新 state 时，使用getDerivedStateFromProps(nextProps, prevState)；
  - 旧 props 需要自己存储，以便比较；
```js
public static getDerivedStateFromProps(nextProps, prevState) {
	// 当新 props 中的 data 发生变化时，同步更新到 state 上
	if (nextProps.data !== prevState.data) {
		return {
			data: nextProps.data
		}
	} else {
		return null
	}
}
```

- 可以在componentDidUpdate监听 props 或者 state 的变化，例如:
```js
componentDidUpdate(prevProps) {
	// 当 id 发生变化时，重新获取数据
	if (this.props.id !== prevProps.id) {
		this.fetchData(this.props.id);
	}
}
```

- 在componentDidUpdate使用setState时，必须加条件，否则将进入死循环；
- getSnapshotBeforeUpdate(prevProps, prevState)可以在更新之前获取最新的渲染数据，它的调用是在 render 之后， update 之前；
- shouldComponentUpdate: 默认每次调用setState，一定会最终走到 diff 阶段，但可以通过shouldComponentUpdate的生命钩子返回false来直接阻止后面的逻辑执行，通常是用于做条件渲染，优化渲染的性能。

废弃的原因主要是因为 react 在 16 版本重构了调度算法，新的调度可能会导致一些生命周期被反复调用，所以在 16 中就不建议使用了，而改在其他时机中暴露出其
他生命周期钩子用来替代。

### SSR
SSR，俗称 服务端渲染 (Server Side Render)，讲人话就是: 直接在服务端层获取数据，渲染出完成的 HTML 文件，直接返回给用户浏览器访问。
前后端分离: 前端与服务端隔离，前端动态获取数据，渲染页面。
- 痛点:
  - 首屏渲染性能瓶颈:
  - 空白延迟: HTML下载时间 + JS下载/执行时间 + 请求时间 + 渲染时间。在这段时间内，页面处于空白的状态。
  - SEO 问题: 由于页面初始状态为空，因此爬虫无法获取页面中任何有效数据，因此对搜索引擎不友好。
    - 虽然一直有在提动态渲染爬虫的技术，不过据我了解，大部分国内搜索引擎仍然是没有实现。

#### 原理
- Node 服务: 让前后端运行同一套代码成为可能。
- Virtual Dom: 让前端代码脱离浏览器运行。

![ssr](http://cdn.mydearest.cn/blog/images/ssr.png)


### 为什么react没有双向绑定
React的设计思想是单向数据流，我觉得可以这样理解为什么没有双向数据绑定：

首先，React是纯粹的View层；然后，对于React来说双向数据绑定是什么需求? -- 明显是业务需求。因为单向数据流已经满足了 View 层渲染的要求并且更易测试与控制（来自 Props 或 State），更加的清晰可控，所以在纯粹的 React 中怎么会需要双向数据绑定这种功能呢。

如果需要解决双向数据绑定问题，可以借助第三方库如 Ant Design 的 rc-form 之类，你也可以存在 State 里甚至是 Redux 里，根据需求来吧。所以 React 没有双向数据绑定不是功能的缺失或冲突问题，而是 React 只关注解决纯粹的问题： View 层。

### 单向数据流

单向数据流是指数据的流向只能由父组件通过props将数据传递给子组件，不能由子组件向父组件传递数据，要想实现数据的双向绑定，只能由子组件接收父组件props传过来的方法去改变父组件的数据，而不是直接将
子组件的数据传递给父组件。

### react和vue的对比
react 函数式思想 纯组件传入状态和逻辑，所以单项数据流结合immutable setState 触发重新render 单项数据流设计成不可变数据 purecomponent对shouldconponentupdate是否触发重新渲染。不可变数据返回新的state，计算虚拟dom的差异。数据流props/callback，context

vue 响应式的思想 监听数据的变化 初始化时对数据的每一个属性添加watcher基于数据可变 数据变化时触发watcher回调 更新虚拟dom。可变数据直接修改，setter能精确监听数据变化。数据流props/event，inject/provide

react的性能优化需要手动去判断 vue是自动的应为要给每个属性添加 watcher所以大型项目state不比较多的时候watcher也会比较多容易造成卡顿的情况。redux不能直接调用reducer进行修改。而vuex有dispatch和commit

### React 中，cloneElement 与 createElement 各是什么，有什么区别
```js
React.cloneElement(
  element,
  [props],
  [...children]
)

React.createElement(
  type,
  [props],
  [...children]
)
```

### React Portal 有哪些使用场景
在以前， react 中所有的组件都会位于 #app 下，而使用 Portals 提供了一种脱离 #app 的组件。
因此 Portals 适合脱离文档流(out of flow) 的组件，特别是 position: absolute 与 position: fixed 的组件。比如模态框，通知，警告，goTop 等。

```js
const modalRoot = document.getElementById('modal');

class Modal extends React.Component {
  constructor(props) {
    super(props);
    this.el = document.createElement('div');
  }

  componentDidMount() {
    modalRoot.appendChild(this.el);
  }

  componentWillUnmount() {
    modalRoot.removeChild(this.el);
  }

  render() {
    return ReactDOM.createPortal(
      this.props.children,
      this.el,
    );
  }
}
```

### 路由传参
1. params传参(刷新页面后参数不消失，参数会在地址栏显示)
```
路由页面：<Route path='/demo/:id' component={Demo}></Route>  //注意要配置 /:id
路由跳转并传递参数：
    链接方式：<Link to={'/demo/'+'6'}>XX</Link>
        或：<Link to={{pathname:'/demo/'+'6'}}>XX</Link>

    js方式：this.props.history.push('/demo/'+'6')  
        或：this.props.history.push({pathname:'/demo/'+'6'})
获取参数：this.props.match.params.id    //注意这里是match而非history
```

2. query传参(刷新页面后参数消失)
```
路由页面：<Route path='/demo' component={Demo}></Route>  //无需配置
路由跳转并传递参数：
    链接方式：<Link to={{pathname:'/demo',query:{id:22,name:'dahuang'}}}>XX</Link>
    js方式：this.props.history.push({pathname:'/demo',query:{id:22,name:'dahuang'}})
获取参数： this.props.location.query.name
```

3. state传参(刷新页面后参数不消失，state传的参数是加密的，比query传参好用)
```
路由页面：<Route path='/demo' component={Demo}></Route>  //无需配置
路由跳转并传递参数：
    链接方式： <Link to={{pathname:'/demo',state:{id:12,name:'dahuang'}}}>XX</Link> 
    js方式：this.props.history.push({pathname:'/demo',state:{id:12,name:'dahuang'}})
获取参数： this.props.location.state.name
```

### create-react-app配置文件修改

- 通过package.json或引用第三方的库增加配置
- react构建时通过webpack，关于webpack配置查看node_modules/react-scripts/config/webpack*
- npm run eject暴露所有配置文件、(安装react-app-rewired包)建立新的配置文件覆盖部分默认的配置
- HashRouter支持配置package-json homepage: '.'修改根目录路径，BrowerRouter修改无效还得修改服务端配置

### react diff和vue diff的区别
- vnode作为数据和视图的一种映射关系
- 相同点：都是同层比较、不同点：vue使用双指针比较，react是key集合级比较

### react StrictMode严格模式
StrictMode是一种辅助组件，可以帮助编写更好的组件。
1. 验证是否遵循推荐写法
2. 验证是否使用了已经废弃的写法
3. 通过识别一些潜在的风险预防副作用

### react事件的合成机制
1. div 或其他元素触发事件，该事件会冒泡到 document，然后被 React 的事件处理程序捕获
2. 事件处理程序随后将事件传递给 SyntheticEvent 的实例，这是一个跨浏览器原生事件包装器。
3. SyntheticEvent 触发 dispatchEvent，将 event 对象交由对应的处理器执行。

- 为什么要合成事件机制
  - 更好的兼容性和跨平台
  - react事件机制采用了事件池，大大节省内存
  - 方便事件的统一管理

- react处理阻止冒泡
```js
// 阻止事件冒泡，（阻止这个合成事件，往document上冒泡，因此不会触发click方法）
e.stopPropagation();
// 阻止合成事件间的冒泡，不会往最外层冒了
e.nativeEvent.stopImmediatePropagation();
```

### redux存在的问题 => 重
- 一份store树，离开页面再次进入，数据不会初始化
- reducer拆分造成汇总困难
- action的type管理混乱，重复问题
- 繁杂的使用规则，index页面action和store引入，纯函数reducer大量case仅仅为了改变一个值

### 常用UI库

- 移动端
[ant design mobile](https://mobile.ant.design/index-cn)

- pc端
[ant design](https://ant.design/)

[reactstrap](https://reactstrap.github.io/)

[patternfly-react](https://patternfly-react.surge.sh/)

[semantic-ui](https://react.semantic-ui.com/)

[material-ui](https://material-ui.com/)

[elemental-ui](http://elemental-ui.com/home)

### 常用组件
- 无限滚动加载
[react-infinite-scroller](https://github.com/danbovey/react-infinite-scroller)

[react-list](https://github.com/caseywebdev/react-list)

[react-infinite-scroll-component](https://github.com/ankeetmaini/react-infinite-scroll-component)

- 国际化
[react-i18next](https://github.com/i18next/react-i18next)

[react-intl](https://github.com/formatjs/formatjs)

- date库
[moment](https://github.com/moment/moment)
[miment](https://github.com/noahlam/Miment)
[dayjs](https://github.com/iamkun/dayjs)
