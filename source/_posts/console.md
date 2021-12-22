---
title: console控制台优化
tags:
  - 优化
copyright: true
comments: true
date: 2018-06-18 20:07:08
categories: JS
top: 107
photos:
---

谷歌开发者中心上面关于谷歌浏览器控制台 console.log()的文档：

| 格式说明符 |                                              描述 |
| :--------- | ------------------------------------------------: |
| %s         |                              将值格式化为字符串。 |
| %d?or?%i   |                                将值格式化为整数。 |
| %f         |                              将值格式化为浮点值。 |
| %o         | 将值格式化为可扩展的 DOM 元素（如在元素面板中）。 |
| %O         |            将值格式化为可扩展的 JavaScript 对象。 |
| %c         |           根据您提供的 CSS 样式格式化输出字符串。 |

\n 是换行，可以将一个字符串设置成多行
%c 标记之后的内容使用对应样式，格式如 console.log(‘%c 第一个样式%c 第二个样式’,’css1′,’css2′); 如此对应
样式和普通的 css 效果基本一致，可以设置文字颜色，背景颜色，字体大小，间距，边距等等。还支持部分 css3 高级效果。

---

<!-- more -->

## 3D 字体效果 Text

```javascript
<script>
  console.log("%c3D Text"," text-shadow: 0 1px 0 #ccc,0 2px 0 #c9c9c9,0 3px 0
  #bbb,0 4px 0 #b9b9b9,0 5px 0 #aaa,0 6px 1px rgba(0,0,0,.1),0 0 5px
  rgba(0,0,0,.1),0 1px 3px rgba(0,0,0,.3),0 3px 5px rgba(0,0,0,.2),0 5px 10px
  rgba(0,0,0,.25),0 10px 10px rgba(0,0,0,.2),0 20px 20px
  rgba(0,0,0,.15);font-size:5em")
</script>
```

## Colorful 彩色背景 CSS

```javascript
<script>
  console.log("%cColorful CSS","background: rgba(252,234,187,1);background:
  -moz-linear-gradient(left, rgba(252,234,187,1) 0%, rgba(175,250,77,1) 12%,
  rgba(0,247,49,1) 28%, rgba(0,210,247,1) 39%,rgba(0,189,247,1) 51%,
  rgba(133,108,217,1) 64%, rgba(177,0,247,1) 78%, rgba(247,0,189,1) 87%,
  rgba(245,22,52,1) 100%);background: -webkit-gradient(left top, right top,
  color-stop(0%, rgba(252,234,187,1)), color-stop(12%, rgba(175,250,77,1)),
  color-stop(28%, rgba(0,247,49,1)), color-stop(39%, rgba(0,210,247,1)),
  color-stop(51%, rgba(0,189,247,1)), color-stop(64%, rgba(133,108,217,1)),
  color-stop(78%, rgba(177,0,247,1)), color-stop(87%, rgba(247,0,189,1)),
  color-stop(100%, rgba(245,22,52,1)));background: -webkit-linear-gradient(left,
  rgba(252,234,187,1) 0%, rgba(175,250,77,1) 12%, rgba(0,247,49,1) 28%,
  rgba(0,210,247,1) 39%, rgba(0,189,247,1) 51%, rgba(133,108,217,1) 64%,
  rgba(177,0,247,1) 78%, rgba(247,0,189,1) 87%, rgba(245,22,52,1)
  100%);background: -o-linear-gradient(left, rgba(252,234,187,1) 0%,
  rgba(175,250,77,1) 12%, rgba(0,247,49,1) 28%, rgba(0,210,247,1) 39%,
  rgba(0,189,247,1) 51%, rgba(133,108,217,1) 64%, rgba(177,0,247,1) 78%,
  rgba(247,0,189,1) 87%, rgba(245,22,52,1) 100%);background:
  -ms-linear-gradient(left, rgba(252,234,187,1) 0%, rgba(175,250,77,1) 12%,
  rgba(0,247,49,1) 28%, rgba(0,210,247,1) 39%, rgba(0,189,247,1) 51%,
  rgba(133,108,217,1) 64%, rgba(177,0,247,1) 78%, rgba(247,0,189,1) 87%,
  rgba(245,22,52,1) 100%);background: linear-gradient(to right,
  rgba(252,234,187,1) 0%, rgba(175,250,77,1) 12%, rgba(0,247,49,1) 28%,
  rgba(0,210,247,1) 39%, rgba(0,189,247,1) 51%, rgba(133,108,217,1) 64%,
  rgba(177,0,247,1) 78%, rgba(247,0,189,1) 87%, rgba(245,22,52,1) 100%);filter:
  progid:DXImageTransform.Microsoft.gradient( startColorstr='#fceabb',
  endColorstr='#f51634', GradientType=1 );font-size:5em")
</script>
```

## Rainbow 彩虹字 Text

```javascript
<script>
  console.log('%cRainbow Text ', 'background-image:-webkit-gradient( linear,
  left top, right top, color-stop(0, #f22), color-stop(0.15, #f2f),
  color-stop(0.3, #22f), color-stop(0.45, #2ff), color-stop(0.6,
  #2f2),color-stop(0.75, #2f2), color-stop(0.9, #ff2), color-stop(1, #f22)
  );color:transparent;-webkit-background-clip: text;font-size:5em;');
</script>
```

## 在 Chrome 控制台输出图片

```javascript
<script>
  console.log("%c", "padding:50px
  700px;line-height:120px;background:url('http://wx1.sinaimg.cn/large/ba098b64ly1fjz4j8pju5j20p002sgm4.jpg')
  no-repeat;");
</script>
```

## 示例

```javascript
<script>
  console.log("%c%c源码作者%ccosyer chenyu@mydearest.cn", "line-height:26px;",
  "line-height:16px;padding:2px 6px;border-radius: 5px 0px 0px
  5px;background:#35495e;color:#fff;font-size:12px;", "padding:2px
  8px;background:#0093ff;color:#fff;line-height:16px;font-size:12px;border-radius:
  0px 5px 5px 0px;"); console.log("%c%c网站地址%chttps://mydearest.cn",
  "line-height:26px;", "line-height:16px;padding:2px 6px;border-radius: 5px 0px
  0px 5px;background:#35495e;color:#fff;font-size:12px;", "padding:2px
  8px;background:#0093ff;color:#fff;line-height:16px;font-size:12px;border-radius:
  0px 5px 5px 0px;"); console.log("%c%cgithub%https://github.com/cosyer",
  "line-height:26px;", "line-height:16px;padding:2px 6px;border-radius: 5px 0px
  0px 5px;background:#35495e;color:#fff;font-size:12px;", "padding:2px
  8px;background:#0093ff;color:#fff;line-height:16px;font-size:12px;border-radius:
  0px 5px 5px 0px;");
</script>
```

- 未曾遗忘的青春

```js
function setConsole() {
  var text =
    arguments.length > 0 && arguments[0] !== undefined
      ? arguments[0]
      : "this is console!";
  var isOneLine =
    arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 1;
  var author =
    arguments.length > 2 && arguments[2] !== undefined
      ? arguments[2]
      : "未曾遗忘的青春";

  if (isOneLine) {
    console.log("");
    console.log(
      "%c" + text + "  ---  " + author,
      "background-image: url('data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4gPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJncmFkIiBncmFkaWVudFVuaXRzPSJvYmplY3RCb3VuZGluZ0JveCIgeDE9IjAuMCIgeTE9IjAuNSIgeDI9IjEuMCIgeTI9IjAuNSI+PHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzY2Y2NjYyIvPjxzdG9wIG9mZnNldD0iMjAlIiBzdG9wLWNvbG9yPSIjMzM5OTk5Ii8+PHN0b3Agb2Zmc2V0PSI0MCUiIHN0b3AtY29sb3I9IiNjY2NjOTkiLz48c3RvcCBvZmZzZXQ9IjYwJSIgc3RvcC1jb2xvcj0iIzk5Y2NmZiIvPjxzdG9wIG9mZnNldD0iODAlIiBzdG9wLWNvbG9yPSIjY2NjY2ZmIi8+PHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjZmY5OWNjIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNncmFkKSIgLz48L3N2Zz4g');background-size: 100%;background-image: -webkit-gradient(linear, 0% 50%, 100% 50%, color-stop(0%, #66cccc), color-stop(20%, #339999), color-stop(40%, #cccc99), color-stop(60%, #99ccff), color-stop(80%, #ccccff), color-stop(100%, #ff99cc));background-image: -moz-linear-gradient(left, #66cccc 0%, #339999 20%, #cccc99 40%, #99ccff 60%, #ccccff 80%, #ff99cc 100%);background-image: -webkit-linear-gradient(left, #66cccc 0%, #339999 20%, #cccc99 40%, #99ccff 60%, #ccccff 80%, #ff99cc 100%);background-image: linear-gradient(to right, #66cccc 0%, #339999 20%, #cccc99 40%, #99ccff 60%, #ccccff 80%, #ff99cc 100%);padding:20px 40px;color:#fff;font-size:12px;"
    );
    console.log("");
  } else {
    console.log(
      "%c" + text + "  ---  " + author,
      "background-image: url('data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4gPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJncmFkIiBncmFkaWVudFVuaXRzPSJvYmplY3RCb3VuZGluZ0JveCIgeDE9IjAuMCIgeTE9IjAuNSIgeDI9IjEuMCIgeTI9IjAuNSI+PHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzY2Y2NjYyIvPjxzdG9wIG9mZnNldD0iMjAlIiBzdG9wLWNvbG9yPSIjMzM5OTk5Ii8+PHN0b3Agb2Zmc2V0PSI0MCUiIHN0b3AtY29sb3I9IiNjY2NjOTkiLz48c3RvcCBvZmZzZXQ9IjYwJSIgc3RvcC1jb2xvcj0iIzk5Y2NmZiIvPjxzdG9wIG9mZnNldD0iODAlIiBzdG9wLWNvbG9yPSIjY2NjY2ZmIi8+PHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjZmY5OWNjIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNncmFkKSIgLz48L3N2Zz4g');background-size: 100%;background-image: -webkit-gradient(linear, 0% 50%, 100% 50%, color-stop(0%, #66cccc), color-stop(20%, #339999), color-stop(40%, #cccc99), color-stop(60%, #99ccff), color-stop(80%, #ccccff), color-stop(100%, #ff99cc));background-image: -moz-linear-gradient(left, #66cccc 0%, #339999 20%, #cccc99 40%, #99ccff 60%, #ccccff 80%, #ff99cc 100%);background-image: -webkit-linear-gradient(left, #66cccc 0%, #339999 20%, #cccc99 40%, #99ccff 60%, #ccccff 80%, #ff99cc 100%);background-image: linear-gradient(to right, #66cccc 0%, #339999 20%, #cccc99 40%, #99ccff 60%, #ccccff 80%, #ff99cc 100%);padding:0;color:#fff;font-size:12px;"
    );
  }
}
```

- FBI WARNING (暂只支持 Chrome)

```js
console.log(
  `%c                                                                            
                                                                            
                                                                            
                               %c FBI WARNING %c                                
                                                                            
                                                                            
%c        Federal Law provides severe civil and criminal penalties for        
        the unauthorized reproduction,distribution, or exhibition of        
         copyrighted motion pictures (Title 17, United States Code,         
        Sections 501 and 508). The Federal Bureau of Investigation          
         investigates allegations of criminal copyright infringement        
                 (Title 17, United States Code, Section 506).               
                                                                            
                                                                            
                                                                            
`,
  "background: #000; font-size: 18px; font-family: monospace",
  "background: #f33; font-size: 18px; font-family: monospace; color: #eee; text-shadow:0 0 1px #fff",
  "background: #000; font-size: 18px; font-family: monospace",
  "background: #000; font-size: 18px; font-family: monospace; color: #ddd; text-shadow:0 0 2px #fff"
);
```

[FBI](http://cdn.mydearest.cn/blog/images/FBI.png)

### 设计相关

- https://icomoon.io/

- https://zh-cn.cooltext.com/

- https://www.logaster.cn/logo/#logos

- http://www.logoko.com.cn/design

- http://www.beipy.com/335.html
