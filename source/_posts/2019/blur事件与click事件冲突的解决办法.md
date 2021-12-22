---
title: blur事件与click事件冲突的解决办法
tags:
  - 解决方案
copyright: true
comments: true
date: 2019-07-13 00:59:46
categories: 知识
photos:
---

在处理表单登录的过程中，遇到了一个问题，当我们在输入框输入内容输入框获取到焦点时，输入框后面会出现一个图标删除已输入的内容，因此删除图标会绑定一个 click 事件，但是当我们点击图标的时候，也触发了 input 的 blur 事件，blur 事件会让 input 失去焦点时隐藏删除的图标，并且 blur 事件先于图标的 click 事件执行，因此这时候点击图标并不会删除输入框已输入的内容，而是图标消失了。还有弹窗输入框 blur 同时点击取消按钮关闭，也会出现需要点击 2 次的情况。

<p align="center"><img src="http://cdn.mydearest.cn/blog/images/blur.png" alt="blur img"></p>

---

<!--more-->

- blur 事件：当元素失去焦点时触发 blur 事件；blur 事件仅发生于表单元素上。在新浏览器中，该事件可用于任何元素，blur 和 focus 事件不会冒泡，其他表单事件都可以。

- click 事件：当点击元素时触发 click 事件；所有元素都有此事件，会产生冒泡。

### 原因分析

> blur 事件比 click 事件先触发，而 javascript 为单线程，同一时间只能执行处理一个事件，所以当 blur 执行时，导致其后续 click 事件并不会执行。

### 方案一 加定时器延时触发 blur 事件

缺点：设置多久的延时是一个难以两全的问题，时间太短不能保证 click 事件的 100%触发，时间太长则会造成卡顿的感觉，影响用户体验。

### 方案二 将 click 事件改为 mousedown 事件，mousedown 事件是优先于 blur 事件执行

缺点：鼠标按下便触发了事件，不收起、长按也会触发，可能造成用户体验不好。还需要判断是否是鼠标左键点击(event.button===0)。

### 方案三 给 click 所在元素再添加一个 mousedown 事件，在其中执行 event.preventDefault()阻止浏览器默认事件，这样点击按钮时输入框就不会失去焦点了

缺点：如果是弹窗下次打开时，焦点仍然存在。

### 方案四 动态绑定移除 blur 事件

**推荐方案三和四**
