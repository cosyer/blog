---
title: console控制台优化
tags:
  - 优化
copyright: true
comments: true
date: 2018-08-30 17:13:08
categories: 知识
top: 101
photos:
---

熟悉前端的不会对 console 和 alert 陌生，两者在调试的时候可谓是法宝级别的工具，但是关于 console，其实远远不止于 console.log 这一个简单的命令，它能做的事情有很多，那么让我们来一起了解一下，它有哪些冷门功能吧。

---

<!--more-->

### 显示信息的命令

```javascript
console.log("hello world");
console.info("信息");
console.debug("调试");
console.error("错误");
console.warn("警告");
```

### 占位符

​ console 上述的集中度支持 printf 的占位符格式，支持的占位符有：字符（%s）、整数（%d 或%i）、浮点数（%f）和对象（%o）

```javascript
console.log("%d年%d月%d日", 2016, 11, 11);
```

### 信息分组

```javascript
console.group("第一组信息");
console.log("第一组第一条:何问起(http://hovertree.com)");
console.log("第一组第二条:柯乐义(http://keleyi.com)");
console.groupEnd();
console.group("第二组信息");
console.log("第二组第一条:HoverClock 一个jQuery时钟插件");
console.log("第二组第二条:欢迎使用");
console.groupEnd();
```

### 对象信息

```javascript
var obj = {
  id: 1,
  name: 123,
};
console.dir(obj);
```

### 显示网页节点

```javascript
console.dirxml()用来显示网页的某个节点（node）所包含的html/xml代码
var info = document.getElementById('info');
console.dirxml(info);
```

### 判断变量是否为真

​console.assert()用来判断一个表达式或变量是否为真。如果结果为否，则在控制台输出一条相应信息，并且抛出一个异常。

```javascript
console.assert(1 == 1);
console.assert(1 == 2); // Assertion failed: console.assert
```

### 追踪函数的调用踪迹

```javascript
function add(a, b) {
  console.trace();
  return a + b;
}
var x = add3(1, 1);
function add3(a, b) {
  return add2(a, b);
}
function add2(a, b) {
  return add1(a, b);
}
function add1(a, b) {
  return add(a, b);
}
// add add1 add2 add3
```

### 计时功能

console.time()和 console.timeEnd()，用来显示代码的运行时间。

```javascript
console.time("控制台计时器一");
for (var i = 0; i < 10000; i++) {
  for (var j = 0; j < 1000; j++) {}
}
console.timeEnd("控制台计时器一");
```
