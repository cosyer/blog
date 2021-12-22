---
title: classNames在react上的应用
tags:
  - react
copyright: true
comments: true
date: 2018-08-23 17:22:35
categories: JS
top: 107
photos:
---

### 前言

在 Vue 里有一个动态的 class 语法，很好的根据条件动态设置 class。例如：

```javascript
<div class="button" :class="{ active: show }"></div>
```

就是当 show 为 true 时，此标签被赋予 active 样式。

在 React 要实现这样功能，可能会这样做：

```javascript
<div className={`button ${show ? "active" : ""}`}></div>
```

注意到，这里只有一个属性判断，如果有多个时会显得非常麻烦，那么现在使用 [ClassNames](https://github.com/JedWatson/classnames) 这个库来解决这个问题。

---

<!-- more -->

### 基本使用

`ClassNames` 是一个高性能、简便的用户根据条件动态设置 `className` 的 `Javascript` 库。

它的使用非常简单，来看看下面的几种使用方式。（自己也可以开发一个类似的库，不过没必要再造轮子）

```javascript
import classNames from "classnames";

classNames("foo", "bar"); // => 'foo bar'
classNames("foo", { bar: true }); // => 'foo bar'
classNames({ "foo-bar": true }); // => 'foo-bar'
classNames({ "foo-bar": false }); // => ''
classNames({ foo: true }, { bar: true }); // => 'foo bar'
classNames({ foo: true, bar: true }); // => 'foo bar'

// 多级嵌套，多参数
classNames("foo", { bar: true, duck: false }, "baz", { quux: true });
// => 'foo bar baz quux'

// !! 为 false 的将被忽略
classNames(null, false, "bar", undefined, 0, 1, { baz: null }, "");
// => 'bar 1'
```

### 动态属性名

在 ES6 下，可以使用模板语法，来设置跟强大的动态 `className`。

```javascript
const buttonType = "primary";
classNames({ [`btn-${buttonType}`]: true });
```

### 去重功能 dedupe

使用 dedupe 版本的 classNames 可以正确地对类进行重复数据删除，并确保在后面的参数中指定的错误类从结果集中排除。dedupe 会慢（约 5 倍），因此它是作为选择提供的（在默认是不会去重的）。

```javascript
import classNames from "classnames/dedupe";

classNames("foo", "foo", "bar"); // => 'foo bar'
classNames("foo", { foo: false, bar: true }); // => 'bar'
```

### 映射 bind

如果您使用 css-modules 或类似的方法来抽象类“名称”以及 className 实际输出到 DOM 的真实值，那么要使用 bind 版本。

```javascript
import classNames from "classnames/bind";
// 映射关系
const styles = {
  foo: "abc",
  bar: "def",
  baz: "xyz",
};

const cx = classNames.bind(styles);
const className = cx("foo", ["bar"], { baz: true }); //（1） => "abc def xyz"
// const className = cx('abc', ['def'], { xyz: true }); （2）
```

这里什么意思呢？实际上就是把 foo 与 abc 产生映射，也就是说 （1） 和 （2） 两条语句是等效的，好处就像是定义一些常量一样。

### 在 React 上使用

如 antd 上的源码，prefix 定义 class

```javascript
const prefixCls = "alter";

const classs = classNames(
  prefixCls,
  {
    [`${prefixCls}-${type}`]: true,
    [`${prefixCls}-close`]: !this.state.closing,
    [`${prefixCls}-with-description`]: !!description,
    [`${prefixCls}-no-icon`]: !showIcon,
    [`${prefixCls}-banner`]: !!banner,
  },
  className
);
```

### 参考资料

- https://github.com/JedWatson/classnames
- https://www.npmjs.com/package/classcat
