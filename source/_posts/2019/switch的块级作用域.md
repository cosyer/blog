---
title: switch的块级作用域
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-03-10 00:21:30
categories: JS
photos:
top: 160
---

ES6 或 TS 引入了块级作用域,通过 let 和 const、class 等可以定义块级作用域里的变量，块级作用域内的变量不存在变量提升，且存在`暂时性死区`(在代码块内，使用 let 或 const 声明变量前该变量都是不可改变的)。常见的 if 语句，for 循环的循环体内都可以定义块级变量。那么 switch 语句中的块级作用域是什么呢？ 先给出结论：

`switch语句中的块级作用域，在整个switch语句中，而不是对于每一个case生成一个独立的块级作用域。`

---

<!--more-->

举个栗子 🌰

```javascript
let number = 1;
switch (number) {
  case 1:
    let name = "cosyer";
  default:
    console.log(name);
}
// cosyer
```

```javascript
let number = 1;
switch (number) {
  case 1:
    let name = "cosyer";
    break;
  case 2:
    let name = "yu";
    break;
  default:
    console.log(name);
}
// Uncaught SyntaxError: Identifier 'name' has already been declared
```

## 可能存在的问题

```javascript
let number = 1;
switch (number) {
  case 1:
    name = "cosyer";
    break;
}
// name虽然没有声明，但是给name赋值相当于给全局的window对象复制，也就是window.name = 'cosyer'。
```

```javascript
let number = 2;
switch (number) {
  case 1:
    let name = "cosyer";
    break;
  case 2:
    name = "yu";
    break;
}
// Uncaught ReferenceError: name is not defined
```

这里虽然 case 里面定义的块级虽然不会存在变量提升，但是会存在暂时性锁区,也就是说如果 let name = 'cosyer' 没有执行，也就是 name 定义的过程没有执行，那么 name 在整个块级作用域内都是不可用的，都是 undefined。

所以尽量不要在 case 里定义块级变量。
