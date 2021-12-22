---
title: Docker
tags:
  - react
copyright: true
comments: true
date: 2020-07-28 11:38:27
categories: React
photos:
---

## 前言

react-native 开发使用的是 JS,但是并不是纯正的 JS,而是一种 JSX 语言，就是在 JS 中嵌入 XML 语言，因此，只要有一些 JS 的语法基础的原生开发者，就可以肯容易理解 JSX 的语法了，在 RN 中，推荐使用 ES6 的语法。

## 性能

使用 react-native 开发的最大的有点在于开发效率，加入 APP 并不复杂的话，那么完全可以使用纯 JS 开发，也就是 Android 和 iOS 公用一套界面和逻辑。极大的提高了开发效率。在性能上，RN 的表现比原生弱一些，但
是远好于 H5。所以总体来看，其实 RN 的未来还是可以期待的。

## 运行机制

RN 是运行 JS 的，Android 是运行 Java 字节码的，所以，实际上 JS 代码的最终运行是通过一层封装，把 JS 的代码映射成原生代码，而界面上的元素最终使用的也是原生的组件，而不是自己渲染（所以在性能上，RN 比 H5 要
好很多）。

## Component 简介

在 Android 中，主要交互容器是 activity 或 Fragment,而在 RN 中，界面的交互容器是 Component：组件。我觉得 Component 和原生的 Fragment 其实很像，都存在于 activity 中，都受制于 activity 的生命周期，都可卸
载和装载。

---

<!--more-->

## 原有架构和问题

1. 用户编写的 React 代码
2. React 代码转换之后的 js
3. The Bridge
4. Native side

- 组件和 API 太过依赖 JSBridge 的初始化，而且通讯能力也局限于这一条通道。
- JS 和 Native 之间并不真正直接通信，它们的通信依赖于跨 Bridge 传输的异步 JSON 消息。

> UI 的渲染过程分为三层：JS 业务层、shadow tree、原生 UI 层。

其中 JS 和 shadow tree 是通过 JSBridge 来同步数据的，JS 层会将所有 UI node 生成一串 JSON 数据，传递到原生 shadow 层，原生 shadow 层通过传入 node 数据，新增新 UI 或者删除一些不需要的
UI 组件。

从渲染的层次来看，React Native 是多线程运行的，最常见的是 JS 线程和原生端的线程，一旦线程间异常，JSBridge 整体将会阻塞，我们经常也能看到 JS 运行异常了，实际 JS 线程已经无响应了，但原生端
还能响应滚动事件。

## 新的架构

> RN 在 0.59 版本使用 JSI 取代了先前的 JSBridge。
> 分为两部分：

- Fabric，新架构的 UI manager
- TurboModules，这个与 native 端交互的新一代实现

现在不需要序列化成 JSON 并双向传递等一系列操作，实现了 Native 和 JS 间的直接同步通讯。
