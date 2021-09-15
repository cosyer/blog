---
title: 详解 Cookie、 LocalStorage 与 SessionStorage
date: 2018-06-23 13:43:32
tags:
  - 浏览器
categories: JS
---

## Cookie(属于文档对象模型DOM树根节点document)

Cookie 是小甜饼的意思。顾名思义，cookie 确实非常小，它的大小限制为4KB左右。它的主要用途有保存登录信息，比如你登录某个网站市场可以看到“记住密码”，这通常就是通过在 Cookie 中存入一段辨别用户身份的数据来实现的。

## localStorage(属于浏览器对象模型BOM的对象window)

localStorage 是 HTML5 标准中新加入的技术，它并不是什么划时代的新东西。早在 IE 6 时代，就有一个叫 userData 的东西用于本地存储，而当时考虑到浏览器兼容性，更通用的方案是使用 Flash。而如今，localStorage 被大多数浏览器所支持，如果你的网站需要支持 IE6+，那以 userData 作为你的 polyfill 的方案是种不错的选择。

缺点：
1. 存储容量限制，大部分浏览器应该最多5M。
2. 仅支持字符串，如果是存对象还需要将使用JSON.stringify和JSON.parse方法互相转换，有些啰嗦。
3. 读取都是同步的。大多数情况下，还挺好使的。但如果存储数据比较大，例如一张重要图片base64格式存储了，读取可能会有可感知的延迟时间。

## sessionStorage

sessionStorage 与 localStorage 的接口类似，但保存数据的生命周期与 localStorage 不同。做过后端开发的同学应该知道 Session 这个词的意思，直译过来是“会话”。而 sessionStorage 是一个前端的概念，它只是可以将一部分数据在当前会话中保存下来，刷新页面数据依旧存在。但当页面关闭后，sessionStorage 中的数据就会被清空。

--- 
<!-- more -->

## 三者的异同

|特性|Cookie|localstorage|sessionstorage|
|:---:|:---:|:---:|
|生命周期|一般由服务器生成，可设置失效时间。如果在浏览器端生成Cookie，默认是关闭浏览器后失效|除非被清除，否则永久保存|仅在当前会话下有效，关闭页面或浏览器后被清除|
|数据大小|4K|5M|5M|
|与服务器端通信|每次都会携带在HTTP头中，如果使用cookie保存过多数据会带来性能问题|仅在客户端（即浏览器）中保存，不参与和服务器的通信|同上|
|易用性|需要自己封装，原生的Cookie接口不友好|可以封装来对Object和Array有更好的支持|同上|

还有两种存储技术用于大规模数据存储，webSQL（已被废除）和 indexDB。
IE 支持 userData 存储数据，但是基本很少使用到，除非有很强的浏览器兼容需求。

## 安全性的考虑

需要注意的是，不是什么数据都适合放在 Cookie、localStorage 和 sessionStorage 中的。使用它们的时候，需要时刻注意是否有代码存在 XSS 注入的风险。因为只要打开控制台，你就随意修改它们的值，也就是说如果你的网站中有 XSS 的风险，它们就能对你的 localStorage 肆意妄为。所以千万不要用它们存储你系统中的敏感数据。

## cookie用法
JavaScript 可以使用 document.cookie 属性来创建 、读取、及删除 cookie。
document.cookie="username=John Doe";

您还可以为 cookie 添加一个过期时间（以 UTC 或 GMT 时间）。默认情况下，cookie 在浏览器关闭时删除：
document.cookie="username=John Doe; expires=Thu, 18 Dec 2013 12:00:00 GMT";

您可以使用 path 参数告诉浏览器 cookie 的路径。默认情况下，cookie 属于当前页面。
document.cookie="username=John Doe; expires=Thu, 18 Dec 2013 12:00:00 GMT; path=/";

```javascript
// 设置cookie
function setCookie(cname,cvalue,exdays)
{
  var d = new Date();
  d.setTime(d.getTime()+(exdays*24*60*60*1000));
  var expires = "expires="+d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(name) {
  var arr = document.cookie.replace(/\s/g, "").split(";");
  for (var i = 0; i < arr.length; i++) {
    var tempArr = arr[i].split("=");
    if (tempArr[0] === name) {
      return decodeURIComponent(tempArr[1]);
    }
  }
  return "";
}

// 获取指定cookie
function getCookie2(cname)
{
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) 
  {
    var c = ca[i].trim();
    if (c.indexOf(name)==0) return c.substring(name.length,c.length);
  }
  return "";
}

function getCookie3(name) {
  let v = window.document.cookie.match("(^|;) ?" + name + "=([^;]*)(;|$)");
  return v ? v[2] : null;
}

const cookie = (n, v) => {
  if (typeof v !== 'undefined') {
    window.document.cookie = [n, '=', encodeURIComponent(v)].join('')
  } else {
    v = window.document.cookie.match(new RegExp(`(?:\\s|^)${n}\\=([^;]*)`))
    return v ? decodeURIComponent(v[1]) : null
  }
}

// 检测cookie函数
function checkCookie()
{
  var username=getCookie("username");
  if (username!="")
  {
    alert("Welcome again " + username);
  }
  else 
  {
    username = prompt("Please enter your name:","");
    if (username!="" && username!=null)
    {
      setCookie("username",username,365);
    }
  }
}
```
## localStorage和sessionStorage用法(存储数组、数字、对象等可以被序列化为字符串的内容)
localStorage和sessionStorage类似(也可以像普通对象一样用点(.)操作符，及[]的方式进行数据存储)

window.localStorage.key(1) // 读取索引为1的值
```javascript
    static setStorage(name, data) {
        if (typeof data === 'object') {
            window.localStorage.setItem(name, JSON.stringify(data))
        } else if (typeof data === 'number' || typeof data === 'string' || typeof data === 'boolean') {
            window.localStorage.setItem(name, data)
        } else {
            alert('该类型不能用于本地存储~')
        }
    }

    /**
     * 获取localstorage
     */
    static getStorage(name) {
        let data = window.localStorage.getItem(name)
        if (data) {
            return JSON.parse(data)
        } else {
            return ''
        }
    }

    /**
     * 删除localstorage
     */
    static removeStorage(name) {
        window.localStorage.removeItem(name)
    }

    /**
     * 清空localstorage
     */
    static clearStorage() {
        window.localStorage.clear()
    }
```

## cookie 与 session 的区别
- Session 是在服务端保存的一个数据结构，用来跟踪用户的状态，这个数据可以保存在集群、数据库、文件中； 

- Cookie 是客户端保存用户信息的一种机制，用来记录用户的一些信息，也是实现 Session 的一种方式。


### session鉴权流程

- 用户登录的时候，服务端生成一个会话和一个id标识
- 会话id在客户端和服务端之间通过cookie进行传输
- 服务端通过会话id可以获取到会话相关的信息，然后对客户端的请求进行响应；如果找不到有效的会话，那么认为用户是未登陆状态
- 会话会有过期时间，也可以通过一些操作（比如登出）来主动删除

### token的典型流程

- 用户登录的时候，服务端生成一个token返回给客户端
- 客户端后续的请求都带上这个token
- 服务端解析token获取用户信息，并响应用户的请求
- token会有过期时间，客户端登出的时候也会废弃token，但是服务端不需要任何操作

## 规避localStorage缺点---localforage

localforage的逻辑是这样的：优先使用IndexedDB存储数据，如果浏览器不支持，使用WebSQL，浏览器再不支持，使用localStorage。

localforage的API名称和localStorage一样，但是，在同步还是异步上却不同，localforage是异步执行的，用法示意如下。
```javascript
localforage.getItem('key', function (err, value) {
    // 如果err不是null，则出错。否则value就是我们想要的值
});
```
