---
title: 新一代性能指标 Web Vitals
tags:
  - 知识
copyright: true
comments: true
date: 2022-7-6 20:16:20
categories: 知识
top: 107
photos:
---

### 什么是 Web Vitals ？
Web Vitals，即 Google 给的定义是一个良好网站的基本指标（Essential metrics for a healthy site）

上面我们已经介绍了很多指标，为什么 Google 还要再去定义一个新的指标集

这是因为，在过去要去衡量一个高质量网站，需要的指标太多，且有些指标计算很复杂，所以，Google 推出 Web Vitals 就是为了简化这个过程，用户仅仅需要关注 Web Vitals 即可。

在 Web Vitals 中，Core Web Vitals 是最核心的，它包含以下三个指标：

![](https://camo.githubusercontent.com/b1fd6f78efad145ffb8ab57204cd2002dcdd4ca5b8c607996ff1a6f0952c6c43/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353037343530362e706e67)

* **LCP** （Largest Contentful Paint）：最大内容绘制时间，用来衡量加载体验，谷歌要求LCP最好在页面首次开始加载后的2.5秒内发生；
* **FID** （First Input Delay）：首次输入延迟时间，用于衡量页面交互性，谷歌要求页面的FID最好小于100毫秒；
* **CLS** （Cumulative Layout Shift）：累计布局位移，用于衡量视觉稳定性，谷歌要求页面的CLS最好保持小于0.1。

![](https://camo.githubusercontent.com/0a5813ba539823c9e4b5caa02f85fe498bb212360ffc967b57d73a8ca85bba4a/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353035353930362e6a7067)

下面我们详细介绍各大核心指标以及测量工具

## 三大核心指标
### LCP：衡量加载体验
Largest Contentful Paint，最大内容绘制，用于记录视窗内最大的元素绘制的时间，该时间会随着页面渲染变化而变化，因为页面中的最大元素在渲染过程中可能会发生改变，另外该指标会在用户第一次交互后停止记录。

指标变化如下图：

![](https://camo.githubusercontent.com/314c1be35977b0e9df4de603a466a543c68a1cfc27e638628bdd7adc8df7c184/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632343036323234362e706e67)

LCP 比 FP、FCP、FMP 更能体现一个页面的性能好坏程度，因为这个指标会持续更新。举个例子：当页面出现骨架屏或者 Loading 动画时 FCP 其实已经被记录下来了，但此时页面内容其实并未呈现

在 2.5 秒内表示体验优秀

![](https://camo.githubusercontent.com/eb6f482fe2832dda54818e5459d4b487fadc8035d882e17d6462f894d46b14d2/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632343036313934372e706e67)

`LCP` 目前并不会计算所有元素，因为这样会使这个指标变得非常复杂，它现在只关注下面的元素：

* `<img>` 元素
* `<image>`元素内的`<svg>`元素
* `<video>` 元素
* 通过 `url()` 函数加载背景图片的元素
* 包含文本节点或其他内联文本元素子级的块级元素。

### FID：衡量页面交互性
First Input Delay，首次输入延迟，用于记录用户首次与页面交互时响应的延迟，即从用户首次与页面进行交互（即当他们单击链接、按钮、输入框等）到浏览器实际上能够响应该交互之间的时间

FID 在 FCP 和 TTI 之间，这个阶段页面已经部分呈现，但还不具备完全可持续交互的状态，如果其中有长任务发生的话那么势必会造成响应时间变长

![](https://camo.githubusercontent.com/20e21ddc5743a17ffcfd40e5a8a700b0740e4236b91318540187dfb4a96c2199/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632343036353630392e737667)

Google 推荐响应用户交互在 100ms 以内：

![](https://camo.githubusercontent.com/e66cd66747d5b0c8f68d7f5d00776a71b7bc83fe55cdb2dcae2ebabcd6771411/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632343036353431342e706e67)

### CLS：衡量视觉稳定性
Cumulative Layout Shift，累积布局偏移，是一个重要的、以用户为中心的衡量视觉稳定性的指标，因为它有助于量化用户体验意外布局位移的频率，低 CLS 有助于确保页面令人愉快。

![](https://camo.githubusercontent.com/3c02a865f5fa40d2322340c05092707dc9af9696ece013bb3b47948298c2c69e/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036353230372e676966) [ ](https://camo.githubusercontent.com/3c02a865f5fa40d2322340c05092707dc9af9696ece013bb3b47948298c2c69e/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036353230372e676966) ![687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036353230372e676966](https://camo.githubusercontent.com/3c02a865f5fa40d2322340c05092707dc9af9696ece013bb3b47948298c2c69e/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036353230372e676966) [ ](https://camo.githubusercontent.com/3c02a865f5fa40d2322340c05092707dc9af9696ece013bb3b47948298c2c69e/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036353230372e676966)

在使用 app 时，我们经常会遇到这样的问题，当我们点击一个按钮或其他操作时，或将页面滑动到某一位置时，突然文本或按钮没有任何警告的移动，这对于用户来说体验是非常糟糕的

为什么会发生这种毫无预警的移动喃？主要是因为页面可能使用某些异步或 DOM 元素加载资源，或者动态将某些元素添加到页面上，或者具有未知维度的图像或视频，或者默认字体大小与后面真实呈现的字体不匹配、或者是动态调整大小的第三方广告或窗口小部件等等。

因此谷歌在 Core Web Vitals 中用 CLS 来衡量页面的累积布局偏移，偏移越大，得分越低。

![](https://camo.githubusercontent.com/de56a267f62e140aa8164ebe19a1c111db6a6358d08feaabc0afc1fdb35685c3/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353037323335352e706e67)

## 其他Web Vitals
除了核心之外，还有其他类型的 Web Vitals，当然这些一般都是核心的补充，为一些特定的场景提供服务。

例如，Time to First Byte (TTFB) 和 First Contentful Paint (FCP) 都是关于加载性能的，两者都有助于诊断 LCP (缓慢的服务端响应，或者渲染阻塞的资源)。

同上，Total Blocking Time (TBT) 和 Time to Interactive (TTI) 则是影响 FID 的实验性指标，他们不属于核心，因为不能测试现场数据，不能反映用户为核心的关键结果。

## 如何测量
### web-vitals（npm包）
`Google` 提供了一个小而美 `npm` 包：`web-vitals`，

![](https://camo.githubusercontent.com/36e413a0f95e9251a788f0352d336fae266ba0c752accde51a7f1b1c410de2f0/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036333333392e706e67)

### Chrome 插件
Google 总共在六种工具上新增了 Web Vitals 的衡量功能，如下图所示：

![](https://camo.githubusercontent.com/978198feafab525c72680b949956757737fd86ef37ae064a1474283ee8d38975/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353036353035372e706e67)

其中 TBT (Total Blocking Time) 总阻止时间其实和 FID 很相关。TBT 越短越好，TBT 越长，首次输入时恰好在阻止时间段的可能性越大， FID 可能更长

其中 `web-vitals-extension` 是 `Google` 提供一个新的插件，如果你是新手，建议使用它

![](https://camo.githubusercontent.com/d138bca9609616ef95a7281fd124ef37cd5922518198a54981296a2111796e6e/687474703a2f2f7265736f757263652e6d757969792e636e2f696d6167652f32303231303632353037313130322e706e67)

### create-react-app
在最近的 create-react-app 脚手架已经包含 web-vitals，主要代码是：

```js
const reportWebVitals = onPerfEntry ={
  if (onPerfEntry && onPerfEntry instanceof Function) {
    // 引入一个 web-vitals 的库
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) ={
      getCLS(onPerfEntry);
      getFID(onPerfEntry);
      getFCP(onPerfEntry);
      getLCP(onPerfEntry);
      getTTFB(onPerfEntry);
    });
  }
};
export default reportWebVitals;
```

如果你要测量任何受支持的指标，只需将函数传递到 `index.js` 中的 `reportWebvitals` 函数中：

```js
reportWebVitals(console.log);
```

当指标的最终值在页面上完成计算时，将触发此函数。我们就可以通过它将结果记录到控制台或发送到特定端点

## 总结
本文重点介绍了Core Web Vitals，Google 等平台对 Web Vitals 的重视以及作出的努力，让性能优化指标不再像之前那么难以理解与测量，极大的方便了研发人员

#### 参考链接
* https://web.dev/vitals/
* [SEJ](https://www.searchenginejournal.com/google-now-has-6-ways-to-measure-core-web-vitals)

