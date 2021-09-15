---
title: HTML中p标签中插入div标签会发生什么
tags:
  - 前端
copyright: true
comments: true
date: 2020-09-02 11:13:55
categories: 知识
photos:
---

面试遇到了问题:`<p>中能不能插入<div>? 插入<div>会如何?`

先直接实践下：

![div1](http://cdn.mydearest.cn/blog/images/div1.png)

> 我们可以看到,<div>把<p>分成了两段, 并且div外字段并不在<p>内。把div变成行内块级元素也不行。

![div2](http://cdn.mydearest.cn/blog/images/div2.png)

解答:
可以在HTML标准(https://www.w3.org/TR/html401/struct/text.html#h-9.3.1)中看到,
> <p>虽然是块级元素, 但是只能包含行内元素, 不能包含块级元素(包括<p>自己)

![div3](http://cdn.mydearest.cn/blog/images/div3.png)

over!
