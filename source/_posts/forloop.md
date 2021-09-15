---
title: 从 for 循环入手优化性能
date: 2018-06-08 20:32:57
tags:
  - 前端
  - 性能优化
categories: JS
---

今天要说的是最简单的 for 循环，一个简单的 for 循环看似没有任何优化的意义，但实质上优化前后差距挺大的，那么该如何优化呢？

---
<!-- more -->

从最简单的遍历数组说起。

```javascript
// 定义一个数组arr（假设是从后台返回的数据）
let i = 0;
let arr = [];
while (i < 50) {
    arr.push(i);
    i++;
}
```

如果我们想从数组 arr 中取出数据，就必须要进行遍历，普遍的做法是：

```javascript
for (let i = 0; i < arr.length; i++) {
    // arr[i]
}
```

但其实这样的写法遍历是最慢的，他要经过两次迭代，第一次是 i 的迭代，每次都要判断 i 是否小于 arr.length，第二次是 arr 的迭代，每次循环 arr 都会调用底层的迭代器，对长度进行计算，这样循环的效率非常低，时间空间复杂度为 O[n^2]。

下面进行优化，看看两者到底有什么区别：

```javascript
for (let i = 0, len = arr.length; i < len; i++) {
    // arr[i]
}
```

区别就是，整个循环当中，我们预存了 len 来保存数组的长度，这样不需要每次循环都调用底层迭代器，调用一次即可，这样的时间空间复杂度为 O[n+1]。

但是这并不是最完美的，因为会多了一次迭代操作，那么该如何进行优化呢？

```javascript
for (let i = 0, item; item = arr[i++];) {
    // item
}
```
这次迭代的时间空间复杂度为 O[n] ，完美做到了每次一迭代没有通过长度进行判断，而是直接通过下标进行取值的方式映射到了循环体内部。

最后用5万条数据进行测试各种方式的循环时间：

```javascript
// 定义一个数组arr（假设是从后台返回的数据）
let index = 0;
let arr = [];
while (index < 50000) {
    arr.push(index);
    index++;
}

console.time('one');
for (let i = 0; i < arr.length; i++) {

}
console.timeEnd('one');

console.time('two');
for (let i = 0, len = arr.length; i < len; i++) {

}
console.timeEnd('two');

console.time('three');
for (let i = 0, item; item = arr[i++];) {

}
console.timeEnd('three');

// es6的数组遍历
console.time('four');
for (let i of arr) {

}
console.timeEnd('four');
// 会访问可枚举属性和原型的遍历，数组不推荐使用
console.time('five');
for (let i in arr) {

}
console.timeEnd('five');
// one: 0.711ms
// two: 4.508ms
// three: 0.006ms
// four: 3.255ms
// five: 11.144ms
```
在数据量大的情况下，第三种循环方式效果显而易见。

## 为什么普通 for 循环的性能远远高于 forEach 的性能

- 区别：

一个按顺序遍历，一个使用iterator迭代器遍历；

- 从数据结构来说：

for循环是随机访问元素，foreach是顺序链表访问元素；

- 性能上：

对于arraylist，是顺序表，使用for循环可以顺序访问，速度较快；使用foreach会比for循环稍慢一些。
对于linkedlist，是单链表，使用for循环每次都要从第一个元素读取next域来读取，速度非常慢；使用foreach可以直接读取当前结点，数据较快；
