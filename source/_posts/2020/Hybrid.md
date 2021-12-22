---
title: Hybrid混合方案
tags:
  - 解决方案
copyright: true
comments: true
date: 2020-06-01 15:37:15
categories: 工具
photos:
---

随着 Web 技术 和 移动设备 的快速发展，在各家大厂中，Hybrid 技术已经成为一种最主流最不可取代的架构方案之一。一套好的 Hybrid 架构方案能让 App 既能拥有极致的体验和性能，同时也能拥有 Web 技术灵活的开发模式、跨平台能力以及热更新机制。因此，相关的 Hybrid 领域人才也是十分的吃香，精通 Hybrid 技术和相关的实战经验，也是面试中一项大大的加分项。

## 混合方案简析

Hybrid App，俗称 混合应用，即混合了 Native 技术 与 Web 技术 进行开发的移动应用。现在比较流行的混合方案主要有三种，主要是在 UI 渲染机制上的不同:

### Webview UI

#### 通过 JSBridge 完成 H5 与 Native 的双向通讯，并 基于 Webview 进行页面的渲染；

##### 优势: 简单易用，架构门槛/成本较低，适用性与灵活性极强；

##### Webview 性能局限，在复杂页面中，表现远不如原生页面；

### Native UI

#### 通过 JSBridge 赋予 H5 原生能力，并进一步将 JS 生成的虚拟节点树(Virtual DOM)传递至 Native 层，并使用 原生系统渲染。

##### 优势: 用户体验基本接近原生，且能发挥 Web 技术 开发灵活与易更新的特性；

##### 上手/改造门槛较高，最好需要掌握一定程度的客户端技术。相比于常规 Web 开发，需要更高的开发调试、问题排查成本；

### 小程序

#### 通过更加定制化的 JSBridge，赋予了 Web 更大的权限，并使用双 WebView 双线程的模式隔离了 JS 逻辑 与 UI 渲染，形成了特殊的开发模式，加强了 H5 与 Native 混合程度，属于第一种方案的优化版本；

##### 优势: 用户体验好于常规 Webview 方案，且通常依托的平台也能提供更为友好的开发调试体验以及功能；

##### 劣势: 需要依托于特定的平台的规范限定

---

<!--more-->

## Webview

Webview 是 Native App 中内置的一款基于 Webkit 内核的浏览器，主要由两部分组成:

- WebCore 排版引擎
- JSCore 解析引擎

在原生开发 SDK 中 Webview 被封装成了一个组件，用于作为 Web 页面 的容器。因此作为宿主的客户端中拥有更高的权限，可以对 Webview 中的 Web 页面进行配置和开发。
Hybrid 技术中双端的交互原理，便是基于 Webview 的一些 API 和特性。

## 交互原理

Hybrid 技术中最核心的点就是 Native 端与 H5 端之间的双向通讯层，其实这里也可以理解为我们需要一套跨语言通讯方案，便是我们常听到的 JSBridge。

### JavaScript 通知 Native

1. API 注入，Native 直接在 JS 上下文中挂载数据或者方法

延迟较低，在安卓 4.1 以下具有安全性问题，风险较高

2. WebView URL Scheme 跳转拦截

兼容性好，但延迟较高，且有长度限制

3. WebView 中的 prompt/console/alert 拦截(通常使用 prompt)

### Native 通知 Javascript

1. IOS: stringByEvaluatingJavaScriptFromString

```js
// Swift
webview.stringByEvaluatingJavaScriptFromString("alert('NativeCall')");
```

2. Android: loadUrl (4.4-)

```js
// 调用js中的JSBridge.trigger方法
// 该方法的弊端是无法获取函数返回值；
webView.loadUrl("javascript:JSBridge.trigger('NativeCall')");
```

3. Android: evaluateJavascript (4.4+)

```js
// 4.4+后使用该方法便可调用并获取函数返回值；
mWebView.evaluateJavascript（"javascript:JSBridge.trigger('NativeCall')", new ValueCallback<String>() {
    @Override
    public void onReceiveValue(String value) {
        //此处为 js 返回的结果
    }
});
```

## 接入方案

整套方案需要 Web 与 Native 两部分共同来完成:

- Native: 负责实现 URL 拦截与解析、环境信息的注入、拓展功能的映射、版本更新等功能；
- JavaScirpt: 负责实现功能协议的拼装、协议的发送、参数的传递、回调等一系列基础功能。

接入方式:

- 在线 H5: 直接将项目部署于线上服务器，并由客户端在 HTML 头部注入对应的 Bridge。

  - 优势: 接入/开发成本低，对 App 的侵入小；
  - 劣势: 重度依赖网络，无法离线使用，首屏加载慢；

- 内置离线包: 将代码直接内置于 App 中，即本地存储中，可由 H5 或者 客户端引用 Bridge。
  - 优势: 首屏加载快，可离线化使用；
  - 劣势: 开发、调试成本变高，需要多端合作，且会增加 App 包体积

## 5. 优化方案简述

- Webview 预加载: Webview 的初始化其实挺耗时的。我们测试过，大概在 100~200ms 之间，因此如果能前置做好初始化于内存中，会大大加快渲染速度。
- 更新机制: 使用离线包的时候，便会涉及到本地离线代码的更新问题，因此需要建立一套云端下发包的机制，由客户端下载云端最新代码包 (zip 包)，并解压替换本地代码。
  - 增量更新: 由于下发包是一个下载的过程，因此包的体积越小，下载速度越快，流量损耗越低。只打包改变的文件，客户端下载后覆盖式替换，能大大减小每次更新包的体积。
  - 条件分发: 云平台下发更新包时，可以配合客户端设置一系列的条件与规则，从而实现代码的条件更新:
    - 单 地区 更新: 例如一个只有中国地区才能更新的版本；
    - 按 语言 更新: 例如只有中文版本会更新；
    - 按 App 版本 更新: 例如只有最新版本的 App 才会更新；
    - 灰度 更新: 只有小比例用户会更新；
    - AB 测试: 只有命中的用户会更新；
- 降级机制: 当用户下载或解压代码包失败时，需要有套降级方案，通常有两种做法:

  - 本地内置: 随着 App 打包时内置一份线上最新完整代码包，保证本地代码文件的存在，资源加载均使用本地化路径；
  - 域名拦截: 资源加载使用线上域名，通过拦截域名映射到本地路径。当本地不存在时，则请求线上文件，当存在时，直接加载；

- 跨平台部署: Bridge 层 可以做一套浏览器适配，在一些无法适配的功能，做好降级处理，从而保证代码在任何环境的可用性，一套代码可同时运行于 App 内 与 普通浏览器； -环境系统: 与客户端进行统一配合，搭建出 正式 / 预上线 / 测试 / 开发环境，能大大提高项目稳定性与问题排查；
- 开发模式:
  - 能连接 PC Chrome/safari 进行代码调试；
  - 具有开发调试入口，可以使用同样的 Webview 加载开发时的本地代码；
  - 具备日志系统，可以查看 Log 信息；
