---
title: 实现网页顶部加载条loading
tags:
  - 知识
copyright: true
comments: true
date: 2018-09-10 19:54:52
categories: JS
top: 104
photos:
---

### 为什么要加loading的效果

一款好的产品，都需要有一个漂亮的loading界面。lodaing界面不仅能给用户带来良好的体验，而且有效的消除了程序加载等待过程中的枯躁感。loading进度条更是对当前加载进度的一个良好反馈。从0%-100%的加载进度可以有效的告知用户还有多久即可打开页面。带有进度条的loading界面在程序中并不罕见，但是在web中呢？到目前为止浏览器并没有提供有效的浏览器对象来反馈页面的加载进度，所以无法直接、便捷的获得页面加载进度的反馈。

---
<!-- more -->

### jquery实现
```html
<div id="progress"> 
   <span></span> 
</div> 
```

```css
body{ 
      margin:0; 
  } 
  #progress { 
      position:fixed; 
      height: 2px; 
      background:#6bc30d; 
      transition:opacity 500ms linear 
  } 
  #progress.done { 
      opacity:0 
  } 
  #progress span { 
      position:absolute; 
      height:2px; 
      -webkit-box-shadow:#6bc30d 1px 0 6px 1px; 
      -webkit-border-radius:100%; 
      opacity:1; 
      width:150px; 
      right:-10px; 
      -webkit-animation:pulse 2s ease-out 0s infinite; 
  } 
 
  @-webkit-keyframes pulse { 
      30% { 
          opacity:.6 
      } 
      60% { 
          opacity:0; 
      } 
      100% { 
          opacity:.6 
      } 
} 
```

```javascript
$({property: 0}).animate({property: 100}, { 
    duration: 2000, 
    step: function() { 
        var percentage = Math.round(this.property); 
 
        $('#progress').css('width',  percentage+"%"); 
 
         if(percentage == 100) { 
                $("#progress").addClass("done");//完成，隐藏进度条 
            } 
    } 
}); 
```

### tip
- 这种方法简单明了，但兼容性不是太好。主流的浏览器肯定没有问题，但如果考虑IE兼容性的，就不要用此方法了。
- duration是设置时间的。默认是2秒。换算代码：2000=2秒
- 请引入jquery库文件。否则程序不会运行

