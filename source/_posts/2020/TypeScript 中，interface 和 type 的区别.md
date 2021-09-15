---
title: TypeScript 中，interface 和 type 的区别
tags:
  - 性能优化
copyright: true
comments: true
date: 2020-05-18 10:10:54
categories: JS
photos:
---

> interface是接口，type是类型，本身就是两个概念。只是碰巧表现上比较相似。希望定义一个变量类型，就用type，如果希望是能够继承并约束的，就
用interface。如果你不知道该用哪个，说明你只是想定义一个类型而非接口，所以应该用type。

在 `TypeScript` 中，`interface` 和 `type` 主要用于类型的声明，它们的相同点以及区别如下：

---
<!--more-->

## 相同点

### 都可以描述一个对象或者函数
```js
/* interface */
interface User {
  name: string
  age: number
}

interface SetUser {
  (name: string, age: number): string
}
```

```js
/* type */
type User = {
  name: string
  age: number
}

type SetUser = {
  (name: string, age: number): string
}
```

### 都可以进行拓展
```js
/* interface */
interface User {
  name: string
  age: number
}

interface ProUser extends User {
  email: string
}

type VipUserType = {
  readonly vip: boolean
}

/* interface 和 type 拓展*/
interface VipUserInterfce extends VipUserType {
  member: boolean
}
```

```js
/* type */
type User = {
  name: string
  age: number
}

type ProUser = User & {
  email: string
}

interface VipUserInterface {
  readonly vip: boolean
}

/* type 与 interface 拓展 */
type VipUserType = VipUserInterface & {
  member: boolean
}
```

## 区别

### type 可以声明基本类型别名，联合类型，元组类型，而 interface 不可以
```js
/* 基本类型 */
type Name = string

/* 联合类型 */
interface Dog {}
interface Cat {}

type Pet = Dog | Cat

/* 元组类型 */
type PetList = [Dog, Cat]
```

### interface 可以进行类型合并，而 type 不可以
```js
interface Cloner {
  clone(animal: Animal): Animal
}

interface Cloner {
  clone(animal: Sheep): Sheep
}

interface Cloner {
  clone(animal: Dog): Dog
  clone(animal: Cat): Cat
}

// 以上三个 interface 会被合并成一个声明
interface Cloner {
  clone(animal: Dog): Dog
  clone(animal: Cat): Cat
  clone(animal: Sheep): Sheep
  clone(animal: Animal): Animal
}
```

[关于 declaration-merging](https://www.typescriptlang.org/docs/handbook/declaration-merging.html)
