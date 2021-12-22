---
title: 获取浏览器url参数方法总结
tags:
  - 知识
copyright: true
comments: true
date: 2018-8-8 23:21:52
categories: 知识
top: 107
photos:
---

1. 正则(xxx?typeId=2)

```javascript
function getQueryString(name) {
  var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  var r = window.location.search.substr(1).match(reg);
  if (r != null) {
    // return unescape(r[2]); // 中文会乱码
    return decodeURI(r[2]);
  }
  return null;
}
getQueryString("typeId"); // "2"
```

---

<!-- more -->

2. split 拆分

```javascript
function getQueryString() {
  var url = location.search; //获取url中"?"符后的字串
  var theRequest = new Object();
  if (url.indexOf("?") != -1) {
    var str = url.substr(1);
    strs = str.split("&");
    for (var i = 0; i < strs.length; i++) {
      theRequest[strs[i].split("=")[0]] = decodeURI(strs[i].split("=")[1]);
    }
  }
  return theRequest;
}
getQueryString("typeId"); // {typeId:"2}
```

3. 正则获值 和 1 一样

```javascript
function getQueryString(name) {
  var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  var r = window.location.search.substr(1).match(reg); //获取url中"?"符后的字符串并正则匹配
  var context = "";
  if (r != null) context = r[2];
  reg = null;
  r = null;
  return context == null || context == "" || context == "undefined"
    ? ""
    : context;
}
```

4. 单参数获取(?1)获取？后面的数据

```javascript
var url = window.location.href;
url.substring(url.indexOf("?") + 1);
// url.substr(url.indexOf('?') + 1)

var url = window.location.search;
url.substring(1);
// url.substr(1)
```

5. 获取所有参数的对象

```js
function getQueryStringObject() {
  var reg = /([^?&=]+)=([^&]+)/g;
  var q = {};
  location.search.replace(reg, (m, k, v) => (q[k] = v));
  return q;
}
```

6. URL 对象-URLSearchParams
   URLSearchParams 构造函数不会解析完整 URL，但是如果字符串起始位置有 ? 的话会被去除。

```js
var paramsString1 = "http://example.com/search?query=123";
var searchParams1 = new URLSearchParams(paramsString1);

searchParams1.has("query"); // false
searchParams1.has("http://example.com/search?query"); // true

searchParams1.get("query"); // null
searchParams1.get("http://example.com/search?query"); // "123" (equivalent to decodeURIComponent('%40'))

var paramsString2 = "?query=value";
var searchParams2 = new URLSearchParams(paramsString2);
searchParams2.has("query"); // true

var url = new URL("http://example.com/search?query=%40");
var searchParams3 = new URLSearchParams(url.search);
searchParams3.has("query"); // true

let param = new URLSearchParams();
param.append("username", "admin");
param.append("pwd", "admin");
```
