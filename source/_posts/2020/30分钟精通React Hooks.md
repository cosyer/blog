---
title: 30分钟精通React Hooks
tags:
  - react
copyright: true
comments: true
date: 2020-05-12 11:40:08
categories: JS
photos:
---

它来了，它来了，16.8 版本`hooks`成功加入(_^▽^_)

你还在为该使用无状态组件（Function）还是有状态组件（Class）而烦恼吗？
—— 拥有了 hooks，你再也不需要写 Class 了，你的所有组件都将是 Function。

你还在为搞不清使用哪个生命周期钩子函数而日夜难眠吗？
—— 拥有了 Hooks，生命周期钩子函数可以先丢一边了。

你在还在为组件中的 this 指向而晕头转向吗？
—— 既然 Class 都丢掉了，哪里还有 this？你的人生第一次不再需要面对 this。

---

<!--more-->

## React 为什么要搞一个 Hooks？

**_想要复用一个有状态的组件太麻烦了！_**
我们都知道 react 的核心思想是，将一个页面拆成一堆独立的，可复用的组件，并且用自上而下的单向数据流的形式将这些组件串联起来。但假如你在大型的工作项目中用 react，你会发现你的项目中实际上很多 react 组件冗长且难以复用。尤其是那些写成 class 的组件，它们本身包含了状态（state），所以复用这类组件就变得很麻烦。

那之前，官方推荐怎么解决这个问题呢？答案是：[渲染属性（Render Props）](https://reactjs.org/docs/render-props.html)和[高阶组件（Higher-Order Components）](https://reactjs.org/docs/higher-order-components.html)。

### 渲染属性

渲染属性指的是使用一个值为函数的 prop 来传递需要动态渲染的 nodes 或组件。如下面的代码可以看到 DataProvider 组件包含了所有跟状态相关的代码，而 Cat 组件则可以是一个单纯的展示型组件，这样一来 DataProvider 就可以单独复用了。

```js
import Cat from "components/cat";
class DataProvider extends React.Component {
  constructor(props) {
    super(props);
    this.state = { target: "Zac" };
  }

  render() {
    return <div>{this.props.render(this.state)}</div>;
  }
}

<DataProvider render={(data) => <Cat target={data.target} />} />;
```

虽然这个模式叫 Render Props，但不是说非用一个叫 render 的 props 不可，习惯上大家更常写成下面这种：

```js
<DataProvider>{(data) => <Cat target={data.target} />}</DataProvider>
```

#### 其他 🌰

```js
class GithubProfile extends React.PureComponent<IProps, IStates> {
  state: IStates = {
    profile: {},
  };

  componentDidMount() {
    fetch("https://api.github.com/users/cosyer")
      .then((response) => {
        return response.json();
      })
      .then((res) => {
        this.setState({
          profile: res,
        });
      });
  }

  render() {
    const { profile } = this.state;
    return (
      <div className="profile">
        <img src={profile.avatar_url} alt="avatar" width="200px" />
        <div>name: {profile.name}</div>
        <div>company: {profile.company}</div>
        <div>bio: {profile.bio}</div>
      </div>
    );
  }
}
```

如果其它页面也有相同的需求，或者数据一样，仅仅 UI 不一样，那么我们该怎么处理？其实这个问题目的很简单，那就是：如何实现代码复用。

```js
// Render Props
class Profile extends React.Component<IProps, IStates> {
  constructor(props: IProps) {
    super(props);
    this.state = {
      profile: {},
    };
  }

  componentDidMount() {
    fetch("https://api.github.com/users/cosyer")
      .then((response) => {
        return response.json();
      })
      .then((res) => {
        this.setState({
          profile: res,
        });
      });
  }

  render() {
    const { profile } = this.state;
    return <React.Fragment>{this.props.children(profile)}</React.Fragment>;
  }
}
```

定义 props 渲染函数：

```js
class ProfileRenderProps extends React.PureComponent {
  render() {
    return (
      <Profile>
        {(profile: any) => (
          <div className="profile">
            <img src={profile.avatar_url} alt="avatar" width="200px" />
            <div>name: {profile.name}</div>
            <div>company: {profile.company}</div>
            <div>bio: {profile.bio}</div>
          </div>
        )}
      </Profile>
    );
  }
}
```

#### 缺点

- 回调地狱

### 高阶组件

说白了就是一个函数接受一个组件作为参数，经过一系列加工后，最后返回一个新的组件。

看个栗子

```js
const withUser = (WrappedComponent) => {
  const user = sessionStorage.getItem("user");
  return (props) => <WrappedComponent user={user} {...props} />;
};

const UserPage = (props) => (
  <div class="user-container">
    <p>My name is {props.user}!</p>
  </div>
);

export default withUser(UserPage);
```

`withUser`函数就是一个高阶组件，它返回了一个新的组件，这个组件具有了它提供的获取用户信息的功能。
但是这两种模式会增加代码的层级关系，而 hooks 简洁多了，没有多余的层级嵌套，把各种想要的功能写成一个一个可复用的自定义 hook，当你的组件想用什么功能时，直接在组件里调用这个 hook 即可。

```js
// withGithubProfile
const withGithubProfile = (WrappedComponent: any) => {
  return class extends React.Component<IProps, IStates> {
    constructor(props: IProps) {
      super(props);
      this.state = {
        profile: {},
      };
    }

    componentDidMount() {
      fetch("https://api.github.com/users/cosyer")
        .then((response) => {
          return response.json();
        })
        .then((res) => {
          this.setState({
            profile: res,
          });
        });
    }

    render() {
      const { profile } = this.state;
      return <WrappedComponent profile={profile} {...this.props} />;
    }
  };
};
```

引入高阶组件，使用其 profile

```js
class GithubProfileHoc extends React.Component<IProps, IStates> {
  render() {
    const { profile } = this.props;
    return (
      <div className="profile">
        <img src={profile.avatar_url} alt="avatar" width="200px" />
        <div>name: {profile.name}</div>
        <div>followers: {profile.followers}</div>
        <div>following: {profile.following}</div>
      </div>
    );
  }
}

export default WithGithubProfile(GithubProfileHoc);
```

#### 缺点

- 使用多个高阶组件时，无法确定 props 来源
- 相同的 props 会存在覆盖的情况
- 增加调试难度

**_生命周期钩子函数里的逻辑太乱了吧！_**
我们通常希望一个函数只做一件事情，但我们的生命周期钩子函数里通常同时做了很多事情。比如我们需要在 componentDidMount 中发起 ajax 请求获取数据，绑定一些事件监听等等。同时，有时候我们还需要在 componentDidUpdate 做一遍同样的事情。当项目变复杂后，这一块的代码也变得不那么直观。

**_class 真的太让人困惑了！_**
我们用 class 来创建 react 组件时，还有一件很麻烦的事情，就是 this 的指向问题。为了保证 this 的指向正确，我们要经常写这样的代码：`this.handleClick = this.handleClick.bind(this)`，或者是这样的代码：`<button onClick={() => this.handleClick(e)}>`。一旦我们不小心忘了绑定 this，各种 bug 就随之而来，很麻烦。

还有就是无状态组件因为需求的变动需要有自己的 state，又得很麻烦的改成 class 组件。

在 React 16.8 之前 function 有两个问题：

- function 组件不得不返回一些 UI 信息，即 JSX 代码
- function 组件内部不能拥有 state

- Hooks 让函数式组件拥有类组件一样的功能，state ，lifecycle 以及 context。
- Hooks 不是 React 的新功能，可以将它理解为一个“钩子”，可以让你在不写类组件的情况下“勾住”React 的所有功能。

## State Hooks

### 状态组件

```js
class Example extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0,
    };
  }

  render() {
    return (
      <div>
        <p>You clicked {this.state.count} times</p>
        <button onClick={() => this.setState({ count: this.state.count + 1 })}>
          Click me
        </button>
      </div>
    );
  }
}
```

### hooks 改造

```js
import { useState } from "react";

function Example() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

是不是简单多了！可以看到，Example 变成了一个函数，但这个函数却有自己的状态（count），同时它还可以更新自己的状态（setCount）。

除了`useState`这个 hook 外，还有很多别的 hook，比如`useEffect`提供了类似于`componentDidMount`等生命周期钩子的功能，`useContext`提供了上下文（context）的功能等等。

`useState`是 react 自带的一个 hook 函数，它的作用就是用来声明状态变量。useState 这个函数接收的参数是我们的状态初始值（initial state），它返回了一个数组，这个数组的第[0]项是当前的状态值，第[1]
项是可以改变状态值的方法函数。

当用户点击按钮时，我们调用 setCount 函数，这个函数接收的参数是修改过的新状态值。接下来的事情就交给 react 了，react 将会重新渲染我们的 Example 组件，并且使用的是更新后的新的状态，即 count=1。
Example 本质上也是一个普通的函数，为什么它可以记住之前的状态？Example 函数每次执行的时候，都是拿的上一次执行完的状态值作为初始值？

### 组件有多个状态值

```js
function ExampleWithManyStates() {
  const [age, setAge] = useState(42);
  const [fruit, setFruit] = useState("banana");
  const [todos, setTodos] = useState([{ text: "Learn Hooks" }]);
}
```

`useState`接收的初始值没有规定一定要是`string/number/boolean`这种简单数据类型，它完全可以接收对象或者数组作为参数。唯一需要注意的点是，之前我们的`this.setState`做的是合并状态后返回一个新
状态，而`useState`是直接替换老状态后返回新状态。最后，react 也给我们提供了一个`useReducer`的 hook，如果你更喜欢 redux 式的状态管理方案的话。

从`ExampleWithManyStates`函数我们可以看到，`useState`无论调用多少次，相互之间是独立的。其实我们看 hook 的“形态”，有点类似之前被官方否定掉的`Mixins`这种方案，都是提供一种“插拔式的功能注入”
的能力。而`Mixins`之所以被否定，是因为`Mixins`机制是让多个 Mixins 共享一个对象的数据空间，这样就很难确保不同`Mixins`依赖的状态不发生冲突。不同组件调用同一个 hook 也能保证各自状态的独立性，这
就是两者的本质区别。

### react 是怎么保证多个 useState 的相互独立的？

看上面给出的`ExampleWithManyStates`例子，我们调用了三次`useState`，每次我们传的参数只是一个值（如 42，‘banana’），我们根本没有告诉 react 这些值对应的 key 是哪个，那 react 是怎么保证这三个 useState 找到它对应的 state 呢？

```js
//第一次渲染
useState(42); //将age初始化为42
useState("banana"); //将fruit初始化为banana
useState([{ text: "Learn Hooks" }]); //...

//第二次渲染
useState(42); //读取状态变量age的值（这时候传的参数42直接被忽略）
useState("banana"); //读取状态变量fruit的值（这时候传的参数banana直接被忽略）
useState([{ text: "Learn Hooks" }]); //...
```

答案是，react 是根据`useState`出现的顺序来定的。我们具体来看一下：

```js
let showFruit = true;
function ExampleWithManyStates() {
  const [age, setAge] = useState(42);

  if (showFruit) {
    const [fruit, setFruit] = useState("banana");
    showFruit = false;
  }

  const [todos, setTodos] = useState([{ text: "Learn Hooks" }]);
}
```

```js
//第一次渲染
useState(42); //将age初始化为42
useState("banana"); //将fruit初始化为banana
useState([{ text: "Learn Hooks" }]); //...

//第二次渲染
useState(42); //读取状态变量age的值（这时候传的参数42直接被忽略）
// useState('banana');
useState([{ text: "Learn Hooks" }]); //读取到的却是状态变量fruit的值，导致报错
```

所以 react 规定我们必须把 hooks 写在函数的最外层，不能写在 ifelse 等条件语句当中，来确保 hooks 的执行顺序一致。

## Effect Hooks

同样是上个栗子，俺们增加一个新功能：

```js
import { useState, useEffect } from "react";

function Example() {
  const [count, setCount] = useState(0);

  // 类似于componentDidMount 和 componentDidUpdate:
  useEffect(() => {
    // 更新文档的标题
    document.title = `You clicked ${count} times`;
  });

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

我们写的有状态组件，通常会产生很多的副作用（side effect），比如发起 ajax 请求获取数据，添加一些监听的注册和取消注册，手动修改 dom 等等。我们之前都把这些副作用的函数写在生命周期函数钩子里，比如
`componentDidMount`，`componentDidUpdate`和`componentWillUnmount`。而现在的 useEffect 就相当与这些声明周期函数钩子的集合体。它以一抵三，厉害了！

同时，由于前文所说 hooks 可以反复多次使用，相互独立。所以我们合理的做法是，给每一个副作用一个单独的 useEffect 钩子。这样一来，这些副作用不再一股脑堆在生命周期钩子里，代码变得更加清晰。

### useEffect 做了什么？

首先，我们声明了一个状态变量 count，将它的初始值设为 0。然后我们告诉 react，我们的这个组件有一个副作用。我们给`useEffect hook`传了一个匿名函数，这个匿名函数就是我们的副作用。在这个例子里，我
们的副作用是调用`browser API`来修改文档标题。当 react 要渲染我们的组件时，它会先记住我们用到的副作用。等 react 更新了 DOM 之后，它再依次执行我们定义的副作用函数。

这里要注意：

1. react 首次渲染和之后的每次渲染都会调用一遍传给 useEffect 的函数。而之前我们要用两个声明周期函数来分别表示首次渲染`componentDidMount`，和之后的更新导致的重新渲染`componentDidUpdate`。

2. `useEffect`中定义的副作用函数的执行不会阻碍浏览器更新视图，也就是说这些函数是异步执行的，而之前的`componentDidMount`或`componentDidUpdate`中的代码则是同步执行的。这种安排对大多数副作
   用说都是合理的，但有的情况除外，比如我们有时候需要先根据 DOM 计算出某个元素的尺寸再重新渲染，这时候我们希望这次重新渲染是同步发生的，也就是说它会在浏览器真的去绘制这个页面前发生。

### useEffect 怎么解绑一些副作用？

这种场景很常见，当我们在`componentDidMount`里添加了一个注册，我们得在`componentWillUnmount`中，也就是组件被注销之前清除掉我们添加的注册，否则内存泄漏的问题就出现了。

怎么清除呢？让我们传给`useEffect`的副作用函数返回一个新的函数即可。这个新的函数将会在组件下一次重新渲染之后执行。这种模式在一些 pubsub 模式的实现中很常见。

```js
import { useState, useEffect } from "react";

function FriendStatus(props) {
  const [isOnline, setIsOnline] = useState(null);

  function handleStatusChange(status) {
    setIsOnline(status.isOnline);
  }

  useEffect(() => {
    ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
    // 一定注意下这个顺序：告诉react在下次重新渲染组件之后，同时是下次调用ChatAPI.subscribeToFriendStatus之前执行cleanup
    return function cleanup() {
      ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
    };
  });

  if (isOnline === null) {
    return "Loading...";
  }
  return isOnline ? "Online" : "Offline";
}
```

这里有一个点需要重视！这种解绑的模式跟`componentWillUnmount`不一样。`componentWillUnmount`只会在组件被销毁前执行一次而已，而 useEffect 里的
函数，每次组件渲染后都会执行一遍，包括副作用函数返回的这个清理函数也会重新执行一遍。每次视图更新之后，并不是只有组件卸载的时候执行。所以我们一起来看一下面这个问题：

### 为什么要让副作用函数每次组件更新都执行一遍？

我们先看以前的模式：

```js
componentDidMount() {
  ChatAPI.subscribeToFriendStatus(
    this.props.friend.id,
    this.handleStatusChange
  );
}

componentWillUnmount() {
  ChatAPI.unsubscribeFromFriendStatus(
    this.props.friend.id,
    this.handleStatusChange
  );
}
```

我们在`componentDidMount`注册，再在`componentWillUnmount`清除注册。但假如这时候 props.friend.id 变了怎么办？我们不得不再添加一个 componentDidUpdate 来处理这种情况：

```js
componentDidUpdate(prevProps) {
  // 先把上一个friend.id解绑
  ChatAPI.unsubscribeFromFriendStatus(
    prevProps.friend.id,
    this.handleStatusChange
  );
  // 再重新注册新但friend.id
  ChatAPI.subscribeToFriendStatus(
    this.props.friend.id,
    this.handleStatusChange
  );
}
```

很繁琐，而我们但`useEffect`则没这个问题，因为它在每次组件更新后都会重新执行一遍。所以代码的执行顺序是这样的：

```
1.页面首次渲染
2.替friend.id=1的朋友注册

3.突然friend.id变成了2
4.页面重新渲染
5.清除friend.id=1的绑定
6.替friend.id=2的朋友注册
```

### 怎么跳过一些不必要的副作用函数？

按照上一节的思路，每次重新渲染都要执行一遍这些副作用函数，显然是不经济的。怎么跳过一些不必要的计算呢？我们只需要给 useEffect 传第二个参数即可。用第二个参数来告诉 react 只有当这个参数的值发生改
变时，才执行我们传的副作用函数（第一个参数）。

```js
useEffect(() => {
  document.title = `You clicked ${count} times`;
}, [count]); // 只有当count的值发生变化时，才会重新执行`document.title`这一句
```

当我们第二个参数传一个空数组[]时，其实就相当于只在首次渲染的时候执行。也就是`componentDidMount`加`componentWillUnmount`的模式。不过这种用法可能带来 bug，少用。

## 怎么写自定义的 Effect Hooks?

为什么要自己去写一个 Effect Hooks? 这样我们才能把可以复用的逻辑抽离出来，变成一个个可以随意插拔的“插销”，哪个组件要用来，我就插进哪个组件里，so easy！看一个完整的例子，你就明白了。

比如我们可以把上面写的 FriendStatus 组件中判断朋友是否在线的功能抽出来，新建一个 useFriendStatus 的 hook 专门用来判断某个 id 是否在线。

```js
import { useState, useEffect } from "react";

function useFriendStatus(friendID) {
  const [isOnline, setIsOnline] = useState(null);

  function handleStatusChange(status) {
    setIsOnline(status.isOnline);
  }

  useEffect(() => {
    ChatAPI.subscribeToFriendStatus(friendID, handleStatusChange);
    return () => {
      ChatAPI.unsubscribeFromFriendStatus(friendID, handleStatusChange);
    };
  });

  return isOnline;
}
```

这时候 FriendStatus 组件就可以简写为：

```js
function FriendStatus(props) {
  const isOnline = useFriendStatus(props.friend.id);

  if (isOnline === null) {
    return "Loading...";
  }
  return isOnline ? "Online" : "Offline";
}
```

假如这个时候我们又有一个朋友列表也需要显示是否在线的信息也可以复用：

```js
function FriendListItem(props) {
  const isOnline = useFriendStatus(props.friend.id);

  return (
    <li style={{ color: isOnline ? "green" : "black" }}>{props.friend.name}</li>
  );
}
```

funky!!!

比如还有

### useProfile 使用 Hooks 实现 API 请求

```js
// useProfile
const useProfile = () => {
  const [profile, setProfile] = useState({} as TProfile)
  const [loading, setLoading] = useState(false)
  const [isError, setIsError] = useState(false)

  useEffect(() => {
    setLoading(true)
    fetch('https://api.github.com/users/gaearon')
      .then(response => {
        return response.json()
      })
      .then(res => {
        setProfile(res as TProfile)
        setIsError(false)
        setLoading(false)
      }).catch(()=> {
        setIsError(true)
        setLoading(false)
      })
  }, [])

  return { profile, loading, isError }
}
```

使用 `useProfile` Hooks：

```js
const UseProfilePage = () => {
  const { profile, loading, isError } = useProfile();
  return (
    <React.Fragment>
      {isError ? (
        <div>Network Error...</div>
      ) : (
        <div className="profile">
          {loading ? (
            <div>loading profile...</div>
          ) : (
            <React.Fragment>
              <img src={profile.avatar_url} alt="avatar" width="200px" />
              <div>name: {profile.name}</div>
              <div>company: {profile.company}</div>
              <div>bio: {profile.bio}</div>
            </React.Fragment>
          )}
        </div>
      )}
    </React.Fragment>
  );
};
```

### useInput 使用 Hooks 实现 input 输入逻辑

```js
const useInput = (initialValue: string) => {
  const [value, setValue] = useState(initialValue);

  const handleChange = (e: any) => {
    setValue(e.target.value);
  };

  return {
    value,
    onChange: handleChange,
  };
};
```

```js
const useInputDemo = () => {
  const value = useInput("cosyer");

  return (
    <div className="use-input">
      <p>current name: {value.value}</p>
      <input {...value} />
    </div>
  );
};
```

## useContext

`useContext` 是为了在 function 组件中使用类组件的 [context](https://reactjs.org/docs/context.html) API，使用方法很简单，首先创建一个 context：

```js
const local = "🇨🇳";
const ThemeContext = React.createContext(local);
```

然后在 `useContext hook` 使用 context：

```js
function UseContextDemo() {
  const local = useContext(ThemeContext);
  return (
    <div>
      <p>local: {local}</p>
    </div>
  );
}
// render: 🇨🇳
```

在 class 组件中，如果想要修改 context 的值，我们会使用 Provider 提供 value 值，同样，在 function 组件中也可以：

```js
const ThemeContext = React.createContext("🇨🇳");

function Context() {
  const local = useContext(ThemeContext);
  return <p>local: {local}</p>;
}

function App() {
  return (
    <ThemeContext.Provider value={"🇺🇸"}>
      <Context />
    </ThemeContext.Provider>
  );
}
// render: 🇺🇸
```

## useReducer

`useReducer` 是 `useState` 的一种代替方案，用于 state 之间有依赖关系或者比较复杂的场景。`useReducer` 接收三个参数：

- reducer：(state, action) => newState
- initialArg： 初始化参数
- Init： 惰性初始化,返回初始化数据

返回当前 state 以及配套的 dispatch 方法。首先看下 `useReducer` 处理简单的 state：

```js
function UseReducerDemo() {
  const [count, dispatch] = useReducer((state) => {
    return state + 1;
  }, 0);

  return (
    <div>
      <p>count: {count}</p>
      <button
        onClick={() => {
          dispatch();
        }}
      >
        add
      </button>
    </div>
  );
}
```

这个例子和使用 `useState` 一样，都达到了计数的效果。 该例子中，`useReducer` 初始化了 count 值为 0，传入的 reducer 很简单，当接收到一个 dispatch 时，将 count 的值增加 1。

### 处理 state 有相互依赖的场景

```js
const CountApp = () => {
  const [count, setCount] = useState(0);
  const [frozen, setFrozen] = useState(false);

  const increase = () => {
    setCount((prevCount) => {
      if (frozen) {
        return prevCount;
      }
      return prevCount + 1;
    });
  };

  useEffect(() => {
    increase();
    setFrozen(true);
    increase();
  }, []);

  return <p>count {count}</p>;
};
// render 2
```

原因在于 function 组件的更新机制，当引入 hooks 以后，function 组件也拥有了 state 的功能，当我们 setState 时，UI 会重新渲染，但在这个过程中**function 组件中，state 以及 props 都是静态值，不存在引用，或者也可以理解为 state 和 props 是一个 capture value，每次渲染的 state 和 props 都是独立的。**

在这个例子中，由于 useEffect 传入的依赖为 []，即该副作用只会在 UI 第一次渲染结束后执行一次。而在这次 render 中，count 的值为 0， frozen 值为 false，所以第二次执行 increase 时，frozen 值依然为 false， setCount 返回的 prevCount 为 1 ，然后增加 1，这也就是为什么最后 render 的结果为 2，而不是 1。

对于 state 有相互依赖的情况，我们可以用 `useReducer` 来处理：

```js
const INCREASE = "INCREASE";
const SET_FROZEN = "SET_FROZEN";

const initialState = {
  count: 0,
  frozen: false,
};

const CountApp = () => {
  const reducer = (state: any, action: any) => {
    switch (action.type) {
      case INCREASE:
        if (state.frozen) {
          return state;
        }
        return {
          ...state,
          count: state.count + 1,
        };

      case SET_FROZEN:
        return {
          ...state,
          frozen: action.frozen,
        };
      default:
        return state;
    }
  };
  const [state, dispath] = useReducer(reducer, initialState);

  useEffect(() => {
    dispath({ type: INCREASE });
    dispath({ type: SET_FROZEN, frozen: true });
    dispath({ type: INCREASE });
  }, []);

  return <p>current count: {state.count}</p>;
};
```

### 如何用 useState 实现 useReducer

```js
const CountApp = () => {
  const [state, setState] = useState({
    count: 0,
    frozen: false,
  });

  const increase = () => {
    setState((prevState) => {
      if (prevState.frozen) {
        return prevState;
      }
      return {
        ...prevState,
        count: state.count + 1,
      };
    });
  };

  const setFrozen = () => {
    setState((prevState) => {
      return {
        ...prevState,
        frozen: true,
      };
    });
  };

  useEffect(() => {
    increase();
    setFrozen();
    increase();
  }, []);

  return <p>current count: {state.count}</p>;
  // render：1
};
```

`useReducer` 和 `useState` 相比，优势在于可以将使用 reducer 将一些逻辑进行抽离，进行集中化管理。

## useCallback(useMemo 返回函数)

`useCallback` 可以理解为将函数进行了缓存，它接收一个回调函数和一个依赖数组，只有当依赖数组中的值发生改变时，该回调函数才会更新。

```js
function UseCallbackDemo() {
  const [count, setCount] = useState(0);

  const handleResize = useCallback(() => {
    console.log(`the current count is: ${count}`);
  }, [count]);

  useEffect(() => {
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, [handleResize]);

  return (
    <div>
      <button
        onClick={() => {
          setCount(count + 1);
        }}
      >
        click
      </button>
      <p>current count: {count}</p>
    </div>
  );
}
```

该例子中，当改变 count 后，然后改变浏览器窗口大小，可以获取到最新的 count 。如果传入的依赖为 []，handleResize 不会更新，则改变浏览器窗口时， count 的值始终为 0 。

## useMemo

`useMemo` 对值进行了缓存，与 `useCallback` 类似，接收一个创建值的函数和一个依赖数组，它仅会在某个依赖项改变时才重新计算 memoized 值，这种优化有助于避免在每次渲染时都进行高开销的计算。

```js
function UseMemoDemo() {
  const [count, setCount] = useState(0);
  const [value, setValue] = useState("");

  const useMemoChild = useMemo(() => <Child count={count} />, [count]);
  return (
    <div>
      <p>{count}</p>
      <button
        onClick={() => {
          setCount(count + 1);
        }}
      >
        click
      </button>
      <br />
      <input value={value} onChange={(e) => setValue(e.target.value)} />
      {useMemoChild}
    </div>
  );
}

function Child({ count }: { count: number }) {
  console.log("child render");
  return (
    <Fragment>
      <p>useMemo hooks</p>
      <p>child count: {count}</p>
    </Fragment>
  );
}
```

该例子中，UseMemoDemo 组件引用了 Child 组件，在 UseMemoDemo 组件中，定义了 count 和 value 两个 state，如果不使用 `useMemo`，那么每当 UseMemoDemo 中 input 发生改变时，Child 组件就会重
新渲染。但 Child 组件 UI 只和 count 有关，那么这样就会造成 Child 组件无效更新，因此就引入了 `useMemo`，将 count 作为依赖传入，这样只有当 count 值发生改变时， Child 组件才会重新渲染。

## useRef

`useRef` 返回一个可变的 ref 对象，其 .current 属性被初始化为传入的参数 （initialValue）。返回的 ref 对象在组件的整个生命周期内保持不变。在 function 组件中， 使用 `useRef` 主要可以完成以
下两件事：

1. 获取 dom 结构
2. 保存变量

先看一个获取 dom 节点, 点击 button 时，input 聚焦。

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

官方 demo

```js
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    setTimeout(() => {
      console.log(`You clicked ${count} times`);
    }, 3000);
  });

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>Click me</button>
    </div>
  );
}
```

如果我们 3s 点多次点击 button，那么控制台输出的结果会是 0,1,2,3…， 这是由于每次渲染时 count 的值都是固定的。但类似的逻辑在 class 组件中表现不一样：

```js
componentDidUpdate() {
  setTimeout(() => {
    console.log(`You clicked ${this.state.count} times`);
  }, 3000);
}
```

在 class 组件中，我们在 3s 内多次点击 button，最后在控制台输出的结果是最后一次 count 更新的值。
解释说明下：

> state 是 Immutable 的，setState 后一定会生成一个全新的 state 引用。但 Class Component 通过 this.state 方式读取 state，这导致了每次代码执行都会拿到最新的 state 引用，所以快速点击 4 次的结果是 4 4 4 4。

而在 function 组件中，我们使用 `useRef` 实现这个效果

```js
function useRefDemo() {
  const [count, setCount] = useState(0);
  const countRef = useRef(count);

  useEffect(() => {
    countRef.current = count;
    setTimeout(() => {
      console.log(`You clicked ${countRef.current} times`);
    }, 2000);
  }, [count]);

  return (
    <div>
      <p>count: {count}</p>
      <button
        onClick={() => {
          setCount(count + 1);
        }}
      >
        click
      </button>
    </div>
  );
}
```

useRef 返回的对象在组件的整个生命周期内保持不变，每次渲染时返回的是同一个 ref 对象，因此 countRef.current 始终是最新的 count 值。

> 闭包带来的坑:
> 因为每次 render 都有一份新的状态，因此上述代码中的 setTimeout 使用产生了一个闭包，捕获了每次 render 后的 count，也就导致了输出了 0、1、2。如果你希望输出的内容是最新的 state 的话，可以通过 useRef 来保存 state。前文讲过 ref 在组件中只存在一份，无论何时使用它的引用都不会产生变化，因此可以来解决闭包引发的问题。

**但由于对 state 的读取没有通过 this. 的方式，使得每次 setTimeout 都读取了当时渲染闭包环境的数据，虽然最新的值跟着最新的渲染变了，但旧的渲染里，状态依然是旧值。**

## useImperativeHandle

`useImperativeHandle` 可以让你在使用 ref 时，自定义暴露给父组件的实例值，在大多数情况下，应当避免使用 ref 这样的命令式代码。`useImperativeHandle` 应当与 `forwardRef` 一起使用：

```js
function FancyInput(props, ref) {
  const inputRef = useRef(null as any)
  useImperativeHandle(ref, () => ({
    focus: () => {
      inputRef.current.focus()
    }
  }))
  return <input ref={inputRef} />
}

const FancyInputRef = forwardRef(FancyInput)

const useImperativeHandleDemo = () => {
  const inputRef = useRef(null as any)

  useEffect(() => {
    inputRef.current.focus()
  })

  return <FancyInputRef ref={inputRef} />
}
```

## useLayoutEffect

其函数签名 与 `useEffect` 相同，但它会在所有的 DOM 变更之后同步调用 effect。可以使用它来读取 DOM 布局并同步触发渲染。在浏览器执行绘制之前完成。

```js
const BlinkyRender = () => {
  const [value, setValue] = useState(0);

  useEffect(() => {
    if (value === 0) {
      setValue(10 + Math.random() * 200);
    }
  }, [value]);

  return <div onClick={() => setValue(0)}>value: {value}</div>;
};
```

当我们快速点击时，value 会发生随机变化，但 `useEffect` 是 UI 已经渲染到屏幕上以后才会执行，value 会先渲染为 0，然后在渲染成随机数，因此屏幕会出现闪烁。

```js
useLayoutEffect(() => {
  if (value === 0) {
    setValue(10 + Math.random() * 200);
  }
}, [value]);
```

相比使用 `useEffect`，当点击 div，value 更新为 0，此时页面并不会渲染，而是等待 useLayoutEffect 内部状态修改后，才会去更新页面，所以页面不会闪烁。

## useDebugValue

`useDebugValue` 可用于在 React 开发者工具中显示自定义 hook 的标签。

```js
function useFriendStatus() {
  const [isOnline] = useState(null);
  useDebugValue(isOnline ? "Online" : "Offline");

  return isOnline;
}

const App = () => {
  const isOnline = useFriendStatus();

  return <div>{isOnline}</div>;
};
```

在某些情况下，格式化值的显示可能是一项开销很大的操作，因此，`useDebugValue` 接受一个格式化函数作为可选的第二个参数。该函数只有在 Hook 被检查（打开 React 开发者工具）时才会被调用。它接受 debug 值作为参数，并且会返回一个格式化的显示值。
例如， 一个返回 Date 值的自定义 Hook 可以通过格式化函数来避免不必要的 toDateString 函数调用:

```js
useDebugValue(date, (date) => date.toDateString());
```

## hooks 中的坑

1. 不要在循环，条件或嵌套函数中调用 Hook，必须始终在 React 函数的顶层使用 Hook。这是因为 React 需要利用调用顺序来正确更新相应的状态，以及调用相应的钩子
   函数。一旦在循环或条件分支语句中调用 Hook，就容易导致调用顺序的不一致性，从而产生难以预料到的后果。

2. 使用 useState 时候，使用 push，pop，splice 等直接更改数组对象的坑，使用 push 直接更改数组无法获取到新值，应该采用析构方式，但是在 class 里面
   不会有这个问题。

```js
let [num, setNums] = useState([0, 1, 2, 3]);
const test = () => {
  // 这里坑是直接采用push去更新num，setNums(num)是无法更新num的，必须使用num = [...num ,1]
  num.push(1);
  // setNums([...num ,1])
  setNums(num);
};

// class采用同样的方式是没有问题的
this.state.nums.push(1);
this.setState({
  nums: this.state.nums,
});
```

比对`eagerState`和`currentState`，引用类型当然是同一个引用所以当然不会重新渲染，和`pureComponent`只进行浅比较的逻辑差不多。(setNum,依赖数组)
因为本身我们就是修改的 state 的 obj.name，因此在这次闭包中，认为传过来的新的 state 其实和之前对比是相同的（之前的 state 是我们人工修改的值），这种情况下，
就不会出发渲染。

3. useState 设置状态的时候，只有第一次生效，后期需要更新状态，必须通过 useEffect。useEffect 使用 set 一定要加条件判断否则会出现死循环。

4. useEffect 是 render 结束后，callback 函数执行，但是不会阻断浏览器的渲染，算是某种异步的方式吧。但是 class 的 componentDidMount 和 componentDidUpdate 是同步的,在 render 结束后就运行,useEffect 在大部分场景下都比 class 的方式性能更好.

useLayoutEffect 里面的 callback 函数会在 DOM 更新完成后立即执行，但是会在浏览器进行任何绘制之前运行完成，阻塞了浏览器的绘制.

## useEffect 依赖数组深入

```js
// <React.Fragment></React.Fragment>
// 简洁语法<></>
```

空数组副作用回调函数只运行一次，并不代表 useEffect 只运行一次。在每次更新中，useEffect 依然会每次都执行，只不过因为传递给它的数组依赖项是空的，导致 React
每次检查的时候，都没有发现依赖的变化，所以不会重新执行回调。

> 检查依赖，只是简单的比较了一下值或者引用是否相等。

1. 什么都不传，组件每次 render 之后 useEffect 都会调用，相当于 componentDidMount 和 componentDidUpdate。
2. 传入一个空数组 [], 只会调用一次，相当于 componentDidMount 和 componentWillUnmount。
3. 传入一个数组，其中包括变量，只有这些变量变动时，useEffect 才会执行。

React 中判断是否需要执行 useEffect 内代码是通过 Object.is 进行判断的，而这个判断方法对于对象和数组之间的判断永远返回 false。

## hooks 实现计时器

注意第一个计时器错误的写法，在 useEffect 里面重复定义 setInterval，正确写法是 setInterval 只定义一次，它的回调函数保存状态的更新，重点是把 count 更新和
setInterval 定义分开。

```js
import React from "react";
import { useState, useRef, useEffect } from "react";

// 错误的写法
// const CountTimer = () => {
//     let [count, setCount] = useState(0)
//     let CountTimer
//     useEffect(() => {
//         setInterval(() => {
//             setCount(count+1)
//         })
//         return () => window.clearInterval(CountTimer)
//     }, [count])
//     return (
//         <React.Fragment>
//             <div> {count} </div>
//         </React.Fragment>
//     )
// }

//正确的写法
const CountTimer = () => {
  let [count, setCount] = useState(0);
  let intervalCb = useRef(null);
  let CountTimer;
  useEffect(() => {
    intervalCb.current = () => {
      setCount(count + 1);
    };
  }, [count]);

  useEffect(() => {
    function itvFn() {
      intervalCb.current();
    }
    CountTimer = window.setInterval(itvFn, 1000);
    return () => window.clearInterval(CountTimer);
  }, []);

  const handleStop = () => {
    window.clearInterval(CountTimer);
  };
  return (
    <React.Fragment>
      <div>{count}</div>
      <div
        onClick={() => {
          handleStop();
        }}
      >
        停止计时
      </div>
    </React.Fragment>
  );
};

export default CountTimer;
```

## useMemo、useCallback、useEffect 的区别

useMemo 和 useEffect 的执行时机是不一致的：useEffect 执行的是副作用，所以一定是在渲染之后执行的，useMemo 是需要有返回值的，而返回值可以直接参与渲染的，所以
useMemo 是在渲染期间完成的，有这样一个一前一后的区别。

useMemo 返回的是计算的结果值，用于缓存计算后的状态
useCallback 返回的是函数，主要用来缓存函数，因为函数式组件中的 state 的变化都会导致整个组件被重新刷新（即使一些函数没有必要被刷新），此时用 useCallback 就会将
函数进行缓存，减少渲染时的性能损耗 ​；

React Hooks 只能用于函数组件，而每一次函数组件被渲染，都是一个全新的开始；
每一个全新的开始，所有的局部变量全都重来，全体失忆；
每一次全新的开始，只有 Hooks 函数（比如 useEffect）具有上一次渲染的“记忆”；

## 仓库代码

[react-hooks-demo](https://github.com/cosyer/react-hooks-demo)

## 源码解析

```js
// React.js
import {
  useCallback,
  useContext,
  useEffect,
  useImperativeMethods,
  useLayoutEffect,
  useMemo,
  useReducer,
  useRef,
  useState,
} from "./ReactHooks";
```

```js
function resolveDispatcher() {
  // 只管定义 不管实现 这个currentDispatcher是啥呢 我们会在renderRoot渲染的时候设置这个值
  // 离开的时候renderRoot设置为null
  const dispatcher = ReactCurrentOwner.currentDispatcher;
  return dispatcher;
}

export function useState<S>(initialState: (() => S) | S) {
  const dispatcher = resolveDispatcher();
  return dispatcher.useState(initialState);
}

export function useEffect(
  create: () => mixed,
  inputs: Array<mixed> | void | null
) {
  const dispatcher = resolveDispatcher();
  return dispatcher.useEffect(create, inputs);
}

export function useContext<T>(
  Context: ReactContext<T>,
  observedBits: number | boolean | void
) {
  const dispatcher = resolveDispatcher();
  // dev code
  return dispatcher.useContext(Context, observedBits);
}
```

- dispatcher 释义

```js
// ReactFiberDispatcher.js
import { readContext } from "./ReactFiberNewContext";
import {
  useCallback,
  useContext,
  useEffect,
  useImperativeMethods,
  useLayoutEffect,
  useMemo,
  useReducer,
  useRef,
  useState,
} from "./ReactFiberHooks";

export const Dispatcher = {
  readContext,
  useCallback,
  useContext,
  useEffect,
  useImperativeMethods,
  useLayoutEffect,
  useMemo,
  useReducer,
  useRef,
  useState,
};
```

## 总结

这篇文章将 React Hooks 语法进行了简单介绍，Hooks 功能十分强大，如果看完文章还不是很理解的话，建议把这些 demo 自己再手动实现一遍，这样收获会更多。
如果文章内容有哪些描述错误或者不清的地方，欢迎各位纠正并一起交流。👏👏👏
