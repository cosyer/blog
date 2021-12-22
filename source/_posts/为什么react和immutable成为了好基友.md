---
title: 为什么react和immutable成为了好基友
tags:
  - react
copyright: true
comments: true
date: 2018-11-21 11:17:20
categories: JS
photos:
top: 120
---

工作中，React 社区推崇搭配一起使用 Immutable，就像咖啡牛奶伴侣一样。众所周知 React 的性能优化我们可以优化组件的嵌套层级，

避免不必要的重绘，以及 shouldComponentUpdate 来判别组件是否会因为当前属性(props)和状态(state)变化而导致组件输出变化。

一提到 React，大家第一时间就想到的虚拟 DOM(Virtual DOM)和伴随其带来的高性能（在虚拟 dom 上进行节点的更改最后在反映到真实 dom 上）。

但是 React 提供的是声明式的 API(declarative API),好的一方面是让我们编写程序更加方便，但另一方面，却使得我们不太了解内部细节。

---

<!-- more -->

### 一致化处理(Reconciliation)

React 采用的是虚拟 DOM，每次属性(props)和状态(state)发生变化的时候，render 函数返回不同的元素树，

React 会检测当前返回的元素树和上次渲染的元素树之前的差异，然后找出何如高效的更新 UI。即 render 就执行 diff 差异再进行重绘。

### shouldComponentUpdate

默认的 shouldComponentUpdate 会在 props 和 state 发生变化时返回 true,表示组件会重新渲染，从而调用 render 函数。

当然了在首次渲染的时候和使用 forceUpdate 的时候，是不会经过 shouldComponentUpdate 判断。

合理地编写 shouldComponentUpdate 函数，从而能避免不必要的一致化处理，使得性能可以极大提高。。我们可以通过

继承 React.PureComponent 或者通过引入 PureRenderMixin 模块来达到目的。但是这也存在一个问题:

```javascript
// 子组件继承PureComponent只会进行浅比较
class ListOfWords extends React.PureComponent {
  render() {
    return <div>{this.props.words.join(",")}</div>;
  }
}

class WordAdder extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      words: ["marklar"], // 复杂类型
    };
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    // 当触发点击页面并没有进行重新渲染
    const words = this.state.words;
    words.push("marklar");
    this.setState({ words: words });
  }

  render() {
    return (
      <div>
        <button onClick={this.handleClick} />
        <ListOfWords words={this.state.words} />
      </div>
    );
  }
}
```

> 共享的可变状态是万恶之源

JavaScript 中的对象一般是可变的（Mutable），因为使用了引用赋值，新的对象简单的引用了原始对象，改变新的对象将影响到原始对象。

如 foo={a: 1}; bar=foo; bar.a=2 你会发现此时 foo.a 也被改成了 2。

虽然这样做可以节约内存，但当应用复杂后，这就造成了非常大的隐患，Mutable 带来的优点变得得不偿失。

为了解决这个问题，一般的做法是使用 shallowCopy（浅拷贝）或 deepCopy（深拷贝）来避免被修改，但这样做造成了 CPU 和内存的浪费。

Immutable 可以很好地解决这些问题。

### Immutable Data

Immutable Data 就是一旦创建，就不能再被更改的数据。对 Immutable 对象的任何修改或添加删除操作都会返回一个新的 Immutable 对象。

Immutable 实现的原理是 Persistent Data Structure（持久化数据结构），

也就是使用旧数据创建新数据时，要保证旧数据同时可用且不变。同时为了避免 deepCopy 把所有节点都复制一遍带来的性能损耗，

Immutable 使用了 Structural Sharing（结构共享），即如果对象树中一个节点发生变化，只修改这个节点和受它影响的父节点，其它节点则进行共享。

> Map：键值对集合，对应于 Object，ES6 也有专门的 Map 对象

> List：有序可重复的列表，对应于 Array

> Set：无序且不可重复的列表

比较两个 Immutable 对象是否相同，只需要使用===就可以轻松判别。因此如果 React 传入的数据是 Immutable Data,那么 React 就能高效地比较前后属性的变化，从而决定 shouldComponentUpdate 的返回值。

```javascript
// 原来的写法
let foo = { a: { b: 1 } };
let bar = foo;
bar.a.b = 2;
console.log(foo.a.b); // 打印 2
console.log(foo === bar); //  打印 true

// 使用 immutable.js 后
import Immutable from "immutable";
foo = Immutable.fromJS({ a: { b: 1 } });
bar = foo.setIn(["a", "b"], 2); // 使用 setIn 赋值
console.log(foo.getIn(["a", "b"])); // 使用 getIn 取值，打印 1
console.log(foo === bar); //  打印 false

// 使用  seamless-immutable.js 后
import SImmutable from "seamless-immutable";
foo = SImmutable({ a: { b: 1 } });
bar = foo.merge({ a: { b: 2 } }); // 使用 merge 赋值
console.log(foo.a.b); // 像原生 Object 一样取值，打印 1
console.log(foo === bar); //  打印 false
```

#### Immutable-advantage

1. Immutable 降低了 Mutable 带来的复杂度

```javascript
function touchAndLog(touchFn) {
  let data = { key: "value" };
  touchFn(data);
  console.log(data.key);
}
```

在不了解 touchFn 函数的代码的情况下，不知道是否对 data 进行了修改。而如果 data 为 Immutable 对象一切都简单了，会打印 value。

2. 节省内存
   Immutable.js 使用了 Structure Sharing （结构共享）会尽量复用内存，甚至以前使用的对象也可以再次被复用。没有被引用的对象会被垃圾回收。

```javascript
import { Map } from "immutable";
let a = Map({
  select: "users",
  filter: Map({ name: "Cam" }),
});
let b = a.set("select", "people");

a === b; // false
a.get("filter") === b.get("filter"); // true
// 上面 a 和 b 共享了没有变化的 filter 节点。
```

3. Undo/Redo，Copy/Paste，时间旅行等功能

4. 并发安全

5. 函数式编程

#### Immutable-disadvantage

1. 需要熟悉新的 api

2. 引入新的库有大小

3. 思维的变化
   Immutable 中的 Map 和 List 虽对应原生 Object 和 Array，但操作非常不同，比如你要用 map.get('key')而不是 map.key，array.get(0) 而不是 array[0]。

下面给出一些办法来避免类似问题发生：

> 使用 Flow 或 TypeScript 这类有静态类型检查的工具
> 约定变量命名规则：如所有 Immutable 类型对象以 $$ 开头。
> 使用 Immutable.fromJS 而不是 Immutable.Map 或 Immutable.List 来创建对象，这样可以避免 Immutable 和原生对象间的混用。

另外 Immutable 每次修改都会返回新对象，也很容易忘记赋值。

#### 两个 Immutable 对象的比较

1. === 全等比较内存地址性能最好

2. Immutable.is() 进行值比较

Immutable.is 比较的是两个对象的 hashCode 或 valueOf（对于 JavaScript 对象）。

由于 immutable 内部使用了 Trie 数据结构来存储，只要两个对象的 hashCode 相等，值就是一样的。这样的算法避免了深度遍历比较，性能非常好。

```javascript
let a = Immutable.Map({a：1})
let b = Immutable.Map({a：1})
a === b // false
Immutable.is(a,b) // true
// Object.defineProperty() // IE9
```

#### 与 Object.freeze、const 区别

Object.freeze 和 ES6 中新加入的 const 都可以达到防止对象被篡改的功能，但它们是 shallowCopy 的。对象层级一深就要特殊处理了。怪不得常量 const 复杂类型就不行了，直接回答浅拷贝。

#### react 中使用

```javascript
import { is } from "immutable";

shouldComponentUpdate: (nextProps = {}, nextState = {}) => {
  const thisProps = this.props || {},
    thisState = this.state || {};
  // 不清楚层级 直接比较两个对象
  if (
    Object.keys(thisProps).length !== Object.keys(nextProps).length ||
    Object.keys(thisState).length !== Object.keys(nextState).length
  ) {
    return true;
  }

  for (const key in nextProps) {
    if (!is(thisProps[key], nextProps[key])) {
      return true;
    }
  }

  for (const key in nextState) {
    if (
      thisState[key] !== nextState[key] ||
      !is(thisState[key], nextState[key])
    ) {
      return true;
    }
  }
  return false;
};
```

```javascript
function diff(obj1, obj2) {
  var o1 = obj1 instanceof Object;
  var o2 = obj2 instanceof Object;
  if (!o1 || !o2) {
    /*  判断不是对象  */
    return obj1 === obj2;
  }

  if (Object.keys(obj1).length !== Object.keys(obj2).length) {
    return false;
    //Object.keys() 返回一个由对象的自身可枚举属性(key值)组成的数组,例如：数组返回下表：let arr = ["a", "b", "c"];console.log(Object.keys(arr))->0,1,2;
    //即Object.keys只适用于可枚举的属性，而Object.getOwnPropertyNames返回对象自动的全部属性名称。
  }

  for (var attr in obj1) {
    var t1 = obj1[attr] instanceof Object;
    var t2 = obj2[attr] instanceof Object;
    if (t1 && t2) {
      return diff(obj1[attr], obj2[attr]);
    } else if (obj1[attr] !== obj2[attr]) {
      return false;
    }
  }
  return true;
}
```

```javascript
import '_' from 'lodash';

const Component = React.createClass({
  getInitialState() {
    return {
      data: { times: 0 }
    }
  },
  handleAdd() {
    let data = _.cloneDeep(this.state.data);
    data.times = data.times + 1;
    this.setState({ data: data });
    // 如果上面不做 cloneDeep，下面打印的结果会是已经加 1 后的值。let data = this.state.data 指向同一内存地址
    console.log(this.state.data.times);
  }
}

使用 Immutable 后：

  getInitialState() {
    return {
      data: Map({ times: 0 })
    }
  },
  handleAdd() {
    this.setState({ data: this.state.data.update('times', v => v + 1) });
    // 这时的 times 并不会改变
    console.log(this.state.data.get('times'));
  }
上面的 handleAdd 可以简写成：

  handleAdd() {
    this.setState(({data}) => ({
      data: data.update('times', v => v + 1) })
    });
  }
```

#### 常用 api

```javascript
// 声明
Immutable.Map({ a: 1 });
Immutable.Map([1, 2]);

// 原生js转换为immutable data
Immutable.fromJS({ a: 1 }); // immutable的 map

Immutable.fromJS([1, 2]); // immutable的 list

// 从immutableData 回到 JavaScript 对象
immutableData.toJS();

// 判断两个immutable数据是否一致
Immutable.is(immutableA, immutableB);

// 判断是不是map或List
Immutable.Map.isMap(x);

Immutable.List.isList(x);

// 对象合并(注意是同个类型)
immutableMaB = immutableMapA.merge(immutableMaC);

// Map的增删改查
immutableData.get("a"); // {a:1} 得到1。

immutableData.getIn(["a", "b"]); // {a:{b:2}} 得到2。访问深层次的key

// 增和改(注意不会改变原来的值，返回新的值原有的基础上扩展出分支)
immutableData.set("a", 2); // {a:1} 得到1。

immutableData.setIn(["a", "b"], 3);

immutableData.update("a", function (x) {
  return x + 1;
});

immutableData.updateIn(["a", "b"], function (x) {
  return x + 1;
});

// 删
immutableData.delete("a");

immutableData.deleteIn(["a", "b"]);

// List的增删查改如同Map，不过参数变为数字索引。比如immutableList.set(1, 2)
```

当然还有现在火热的 immer.js，unstated 了解一下@\_@

[参考文章](https://www.cnblogs.com/3body/p/6224010.html)
