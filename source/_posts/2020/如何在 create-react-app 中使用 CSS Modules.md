---
title: 如何在 create-react-app 中使用 CSS Modules
tags:
  - 性能优化
copyright: true
comments: true
date: 2020-05-18 11:17:50
categories: JS
photos:
---

先简单了解下什么是 [CSS Modules](https://github.com/css-modules/css-modules)

> A CSS Module is a CSS file in which all class names and animation names are scoped locally by default

简单点说 CSS Module 是具有局部作用域的 css 文件。既然提到了局部作用域，那么肯定有全局作用域，在 create-react-app 中，我们引入 css 文件通常为以下形式：

```css
/* index.css */
.color {
  color: red;
}
```

```js
/* index.tsx */
import React, { Component } from "react";
import "./index.css";

export default class Index extends Component {
  // ...
}
```

---

<!--more-->

## 全局污染和错误覆盖

这种引入方法就会出现全局污染的问题，CSS 使用全局选择器机制来设置样式，优点是方便重写样式，缺点是所有的样式都是全局生效，样式可能被错误覆盖。假定一个页面有以下两个组件：

- <Header />，内容如下：

```js
import React, { Component } from "react";
import "./header.css";

export default class Index extends Component {
  // ...
  render() {
    return <div className="color">Header color</div>;
  }
}
```

- header.css

```css
.color {
  color: red;
}
```

- <Content />, 内容如下：

```js
import React, { Component } from "react";
import "./content.css";

export default class Index extends Component {
  // ...
  render() {
    return <div className="color">Content color</div>;
  }
}
```

- content.css

```css
.color {
  color: green;
}
```

我们期待在页面上 Header color 的字的颜色为 red，Content color 为 green，但实际上是两个都为 green，这就是因为我们直接引入 header.css 和 content.css 后，样式拥有全局作用域，而相同的样式又可能出现错误地覆盖，因此就出现了上面的情况。

避免这种情况在 create-react-app 的方法就是使用 CSS Modules，使用方法就是将对应的 css 文件名称命名为 [name].module.css 的形式（使用 less 或者 sass 类似），以 Header 组件为例，修改如下：

```css
/* header.module.css */
.color {
  color: red;
}
```

```js
import React, { Component } from "react";
import headerStyle from "./header.module.css";

export default class Index extends Component {
  // ...
  render() {
    return <div className={headerStyle.color}>Header color</div>;
  }
}
```

这样 Header color 的颜色就会为 red。

它的实现过程就是利用 Webpack 的 css-loader 生成（基本）唯一的 class 名称，在 create-react-app 中会以 [filename]\_[classname]\_\_[hash] 的命名规则来生成 class 名称，例如 Header 组件生成后的 html 如下：

```html
<div class="header_color__2Oqjl">Header color</div>
```

使用了 CSS Modules 后，就相当于给每个 class 名外加加了一个 :local，以此来实现样式的局部化，如果你想切换到全局模式，使用对应的 :global。:local 与 :global 的区别是 CSS Modules 只会对 :local 块的 class 样式做规则处理，:global 的样式编译后不变。

```css
.color {
  color: red;
}

/* 以上与下面等价 */
:local(.color) {
  color: red;
}

/* 定义全局样式 */
:global(.global-bg) {
  background-color: red;
}
```

## composes 处理复用

在开发中会遇到样式的复用问题，CSS Modules 只提供了唯一的方式来处理：`composes` 组合:

```css
/* 基础样式 */
.base {
  font-size: 20px;
  color: #82d7f7;
}

.active {
  composes: base;
  /* 组合外部文件 */
  composes: bold from "./content.module.css";
  /* active 其他样式 */
  text-decoration: underline;
}
```

在 active 中 composes base，编译后会 active 会变成三个 class

```html
<div
  class="composes-demo_active__27azZ composes-demo_base__MLJCB content_bold__vgYTg"
>
  active
</div>
```

## 总结

在 create-react-app 中使用 CSS Modules 会频繁的输入 styles.**，可以使用 [react-css-modules](https://github.com/gajus/react-css-modules)来避免这点，它通过高阶函数的形式来避免重复输入 styles.**。

栗子 ↓

```js
import React from "react";
import CSSModules from "react-css-modules";
import styles from "./table.css";

class Table extends React.Component {
  render() {
    return (
      <div styleName="table">
        <div styleName="row">
          <div styleName="cell">A0</div>
          <div styleName="cell">B0</div>
        </div>
      </div>
    );
  }
}
export default CSSModules(Table, styles);
```

有兴趣的同学可以参考模拟下`react-css-modules`的实现。

总的来说在 create-react-app 中使用 CSS Modules 还是比较容易，如果还没有在项目中尝试的话非常值得去使用 CSS Modules👏👏👏。
