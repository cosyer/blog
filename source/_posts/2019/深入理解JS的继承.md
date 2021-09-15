---
title: 深入理解JS的继承
tags:
  - 深入理解
copyright: true
comments: true
date: 2019-03-07 23:56:48
categories: JS
photos:
top: 160
---

{% fi https://user-images.githubusercontent.com/25027560/38763933-ac0fdb2a-3fd8-11e8-8510-5e8a2444f49a.png, Summary, Summary %}

---
<!--more-->

## 总览
![c5925056-aa27-4b97-9f5d-2ec786ea5125](https://user-images.githubusercontent.com/25027560/38763933-ac0fdb2a-3fd8-11e8-8510-5e8a2444f49a.png)

## 一、借助构造函数
```js
function Parent1() {
  this.name = 'parent1'
}
function Child1() {
  // 将父类的执行上下文指向子类，父类执行时的实例属性都会指向子类
  Parent1.call(this);// apply
  this.type = 'child1'
}
```

#### 缺点
子类没有继承父类的原型方法
只继承了父类构造函数中的属性和方法

```js
Parent1.prototype.method = (arg) =console.log(arg);
console.log(new Child1().method); // undefined
```

## 二、借助原型链
```js
function Parent2() {
  this.name = 'parent2';
  this.arr = [1, 2, 3];
  this.method = (arg) =console.log(arg)
}
function Child2() {
  this.type = 'child2'
}
Child2.prototype = new Parent2();
```

原型图如下
![f9311957-d401-4bc0-961b-65f3f49d65ea](https://user-images.githubusercontent.com/25027560/38763935-b449916e-3fd8-11e8-8b76-e12f58c20d27.png)

#### 缺点
引用类型的属性被所有实例共享，实例之间会互相影响

```js
let c21 = new Child2();
let c22 = new Child2();

c21.arr.push(4);
console.log(c21.arr, c22.arr);
// 注意，下面是直接给实例添加method属性
// 只是修改了method指针，没有修改原型链上的method方法
// 只有修改引用对象才是真正的修改
c21.method = 'c21';
console.log(Parent2);
console.log(c21, c22);
```

![c79f3ffe-030d-4753-9f32-361a2dffb9d2](https://user-images.githubusercontent.com/25027560/38763937-bad54c58-3fd8-11e8-9248-1f6b2954daf9.png)

## 三、组合（构造+原型链）
```js
function Parent3() {
  this.name = 'parent3';
  this.arr = [1, 2, 3]
}
function Child3() {
  Parent3.call(this);
  this.type = 'child3'
}
Child3.prototype = new Parent3();
```

#### 优点
每个实例不会再互相影响

#### 缺点
实例化时，父类被构造了两次，这没有必要
call一次，new一次

## 四、组合优化一
```js
function Parent4() {
  this.name = 'parent4';
  this.arr = [1, 2, 3]
}
function Child4() {
  Parent4.call(this);
  this.type = 'child4'
}
Child4.prototype = Parent4.prototype;
```

![3dcc9c3e-5e1d-45bc-bcb5-72aaea635cc2](https://user-images.githubusercontent.com/25027560/38763939-c318a5fe-3fd8-11e8-9581-9e04e57976a4.png)

#### 缺点
无法判断实例的构造函数是父类还是子类

```js
let c41 = new Child4();
let c42 = new Child4();
console.log(c41 instanceof Child4, c41 instanceof Parent4);
// true true
```

但其实，构造函数就是父类本身

```js
console.log(c41.constructor); // Parent4
```

很难得才通过`Parent4.call(this)`改变了构造函数的指向，现在又改回去了？天……不想看下去了行不行，兄dei，坚持一会就是胜利，别打瞌睡

`Child4.prototype = Parent4.prototype`只是把`Child4`的`prototype`属性指针指向了`Parent4.prototype`这个引用对象而已，实际上`Parent4.prototype.constructor = Parent4`
![af779508-30f5-43ea-8af8-ff25a308ccf9](https://user-images.githubusercontent.com/25027560/38763942-cdc97b40-3fd8-11e8-8f45-c7bdb95f8f5f.png)

## 五、组合优化二
```js
function Parent5() {
  this.name = 'parent5';
  this.arr = [1, 2, 3]
}
function Child5() {
  Parent5.call(this);
  this.type = 'child5'
}
// 组成原型链
Child5.prototype = Object.create(Parent5.prototype);
```

但是，这时候，实例对象的`constructor`依然是`Parent5`

![f611911f-9fc1-4ff8-8da6-eb7874eeb335](https://user-images.githubusercontent.com/25027560/38763943-d3d9703a-3fd8-11e8-92d4-d161a335c80c.png)

所以需要重新指定实例对象的构造器

```js
Child5.prototype.constructor = Child5;
```

```js
let c51 = new Child5();
let c52 = new Parent5();
console.log(c51 instanceof Child5, c51 instanceof Parent5);
console.log(c52 instanceof Child5, c52 instanceof Parent5);
console.log(c51.constructor, c52.constructor);
// true true
// false true
// Child5 Parent5
```

## 相关链接
[js创建对象实现继承](https://mydearest.cn/js%E5%88%9B%E5%BB%BA%E5%AF%B9%E8%B1%A1%E5%AE%9E%E7%8E%B0%E7%BB%A7%E6%89%BF.html)