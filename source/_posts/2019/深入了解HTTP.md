---
title: 深入了解HTTP
tags:
  - http
copyright: true
comments: true
date: 2019-04-30 00:48:20
categories: 知识
photos:
top: 200
---

## HTTP 特性
- 基于TCP-IP协议 应用层协议 默认端口号80
- 无连接无状态

### 什么是无状态
- 状态】的含义就是：客户端和服务器在某次会话中产生的数据
- 那么对应的【无状态】就意味着：这些数据不会被保留
- 通过增加cookie和session机制，现在的网络请求其实是有状态的
- 在没有状态的http协议下，服务器也一定会保留你每次网络请求对数据的修改，但这跟保留每次访问的数据是不一样的，保留的只是会话产生的结果，而没有保留会话

## HTTP 报文    
### 请求报文
HTTP 协议是以 ASCII （a s ki）码传输，建立在 TCP/IP 协议之上的应用层规范。规范把 HTTP 请求分为三个部分：状态行、请求头、消息主体。

- GET 可提交的数据量受到URL长度的限制，HTTP 协议规范没有对 URL 长度进行限制。这个限制是特定的浏览器及服务器对它的限制
- 理论上讲，POST 是没有大小限制的，HTTP 协议规范也没有进行大小限制，出于安全考虑，服务器软件在实现时会做一定限制
- 参考上面的报文示例，可以发现 GET 和 POST 数据内容是一模一样的，只是位置不同，一个在 URL 里，一个在 HTTP 包的包体里

---
<!--more-->

### POST提交的方式
HTTP 协议中规定 POST 提交的数据必须在 body 部分中，但是协议中没有规定数据使用哪种编码方式或者数据格式。实际上，开发者完全可以自己决定消息主体的格式，只要最后发送的 HTTP 请求满足上面的格式就可以。

但是，数据发送出去，还要服务端解析成功才有意义。一般服务端语言如 PHP、Python 等，以及它们的 framework，都内置了自动解析常见数据格式的功能。服务端通常是根据请求头（headers）中的 Content-Type 字段来获知请求中的消息主体是用何种方式编码，再对主体进行解析。所以说到 POST 提交数据方案，包含了 Content-Type 和消息主体编码方式两部分。

1. application/x-www-form-urlencoded
这是最常见的 POST 数据提交方式。浏览器的原生 <form> 表单，如果不设置 enctype 属性，那么最终就会以 application/x-www-form-urlencoded 方式提交数据。

2. multipart/form-data
使用表单上传文件时，必须让 <form> 表单的 enctype 等于 multipart/form-data。

上面提到的这两种 POST 数据的方式，都是浏览器原生支持的，而且现阶段标准中原生 <form> 表单也只支持这两种方式（通过 <form> 元素的 enctype 属性指定，默认为 application/x-www-form-urlencoded。其实 enctype 还支持 text/plain，不过用得非常少）。

随着越来越多的 Web 站点，尤其是 WebApp，全部使用 Ajax 进行数据交互之后，我们完全可以定义新的数据提交方式，例如 application/json，application/form-data，text/xml，乃至 application/x-protobuf 这种二进制格式，只要服务器可以根据 Content-Type 和 Content-Encoding 正确地解析出请求，都是没有问题的。

### 响应报文
- 状态行
- 响应头(Response Header)
- 响应正文

GET 请求 304获取缓存
第一次请求时，服务器端返回请求数据，之后的请求，服务器根据请求中的 If-Modified-Since 字段判断响应文件没有更新，如果没有更新，服务器返回一个 304 Not Modified响应，告诉浏览器请求的资源在浏览器上没有更新，可以使用已缓存的上次获取的文件。

### 持久连接

在 HTTP 1.0 版本中，并没有官方的标准来规定 Keep-Alive 如何工作，因此实际上它是被附加到 HTTP 1.0协议上，如果客户端浏览器支持 Keep-Alive ，那么就在HTTP请求头中添加一个字段 Connection: Keep-Alive，当服务器收到附带有 Connection: Keep-Alive 的请求时，它也会在响应头中添加一个同样的字段来使用 Keep-Alive 。这样一来，客户端和服务器之间的HTTP连接就会被保持，不会断开（超过 Keep-Alive 规定的时间，意外断电等情况除外），当客户端发送另外一个请求时，就使用这条已经建立的连接。

在 HTTP 1.1 版本中，默认情况下所有连接都被保持，如果加入 "Connection: close" 才关闭。目前大部分浏览器都使用 HTTP 1.1 协议，也就是说默认都会发起 Keep-Alive 的连接请求了。

- HTTP Keep-Alive 简单说就是保持当前的TCP连接，避免了重新建立连接。也就是默认都是持续连接的。在事务处理结束之后仍然保持在打开状态的TCP连接称之为持久连接。

- HTTP 长连接不可能一直保持，例如 Keep-Alive: timeout=5, max=100，表示这个TCP通道可以保持5秒，max=100，表示这个长连接最多接收100次请求就断开。

#### 当 HTTP 采用 keepalive 模式，当客户端向服务器发生请求之后，客户端如何判断服务器的数据已经发生完成？
1. 使用消息首部字段 Conent-Length：Conent-Length表示实体内容长度，客户端可以根据这个值来判断数据是否接收完成。

2. 使用消息首部字段 Transfer-Encoding：chunk在最后有一个空 chunked 块，表明本次传输数据结束。 

### HTTP Pipelining（HTTP 管线化）
默认情况下 HTTP 协议中每个传输层连接只能承载一个 HTTP 请求和响应，浏览器会在收到上一个请求的响应之后，再发送下一个请求。在使用持久连接的情况下，某个连接上消息的传递类似于请求1 -> 响应1 -> 请求2 -> 响应2 -> 请求3 -> 响应3。

HTTP Pipelining（管线化）是将多个 HTTP 请求整批提交的技术，在传送过程中不需等待服务端的回应。使用 HTTP Pipelining 技术之后，某个连接上的消息变成了类似这样请求1 -> 请求2 -> 请求3 -> 响应1 -> 响应2 -> 响应3

### 会话跟踪
1. 什么是会话？

客户端打开与服务器的连接发出请求到服务器响应客户端请求的全过程称之为会话。

2. 什么是会话跟踪？

会话跟踪指的是对同一个用户对服务器的连续的请求和接受响应的监视。

3. 为什么需要会话跟踪？

浏览器与服务器之间的通信是通过HTTP协议进行通信的，而HTTP协议是”无状态”的协议，它不能保存客户的信息，即一次响应完成之后连接就断开了，下一次的请求需要重新连接，这样就需要判断是否是同一个用户，所以才有会话跟踪技术来实现这种要求。

Cookie

Cookie 是Web 服务器发送给客户端的一小段信息，客户端请求时可以读取该信息发送到服务器端，进而进行用户的识别。对于客户端的每次请求，服务器都会将 Cookie 发送到客户端,在客户端可以进行保存,以便下次使用。

客户端可以采用两种方式来保存这个 Cookie 对象，一种方式是保存在客户端内存中，称为临时 Cookie，浏览器关闭后这个 Cookie 对象将消失。另外一种方式是保存在客户机的磁盘上，称为永久 Cookie。以后客户端只要访问该网站，就会将这个 Cookie 再次发送到服务器上，前提是这个 Cookie 在有效期内，这样就实现了对客户的跟踪。

Cookie 是可以被客户端禁用的。

Session:

每一个用户都有一个不同的 session，各个用户之间是不能共享的，是每个用户所独享的，在 session 中可以存放信息。

在服务器端会创建一个 session 对象，产生一个 sessionID 来标识这个 session 对象，然后将这个 sessionID 放入到 Cookie 中发送到客户端，下一次访问时，sessionID 会发送到服务器，在服务器端进行识别不同的用户。

Session 的实现依赖于 Cookie，如果 Cookie 被禁用，那么 session 也将失效。

### 跨站攻击

#### CSRF（Cross-site request forgery，跨站请求伪造）

- 如何防范 CSRF 攻击？

1. 关键操作只接受 POST 请求，get 不修改数据
2. 验证码 强制用户必须与应用进行交互。
3. 检测referer 通过Referer识别 根据HTTP协议，在HTTP头中有一个字段叫Referer，它记录了该HTTP请求的来源地址。在通常情况下，访问一个安全受限的页面的请求都来自于同一个网站。
4. 请求校验

#### XSS（Cross Site Scripting，跨站脚本攻击）

XSS 全称“跨站脚本”，是注入攻击的一种。其特点是不对服务器端造成任何伤害，而是通过一些正常的站内交互途径，例如发布评论，提交含有 JavaScript 的内容文本。这时服务器端如果没有过滤或转义掉这些脚本，作为内容发布到了页面上，其他用户访问这个页面的时候就会运行这些脚本。

XSS 是实现 CSRF 的诸多途径中的一条，但绝对不是唯一的一条。一般习惯上把通过 XSS 来实现的 CSRF 称为 XSRF。

XSS（跨站脚本攻击）是指攻击者在返回的HTML中嵌入js脚本，为了减轻这些攻击，需要在HTTP头部配上set-cookie：http-only这个属性可以防止xss，它会禁止js脚本访问cookie。secure这个属性告诉浏览器仅在请求为https时发送cookie。

分为非持久型(反射型XSS)，一次攻击；存储型XSS存储到服务器上，多次攻击。

- 如何防范 XSS
1. cookie设置http-only，不允许js修改访问cookie
2. 输入检查、输出检查，对变量输入到HTML页面的代码进行编码或转义

### http缓存
`缓存是指浏览器（客户端）在本地磁盘中对访问过的资源保存的副本文件。`
浏览器缓存主要有以下几个优点：

1. 减少重复数据请求，避免通过网络再次加载资源，节省流量。
2. 降低服务器的压力，提升网站性能。
3. 加快客户端加载网页的速度， 提升用户体验。

浏览器缓存分为强缓存和协商缓存，两者有两个比较明显的区别：

- 如果浏览器命中强缓存，则不需要给服务器发请求；而协商缓存最终由服务器来决定是否使用缓存，即客户端与服务器之间存在一次通信。
- 在 chrome 中强缓存（虽然没有发出真实的 http 请求）的请求状态码返回是 200 (from cache)；而协商缓存如果命中走缓存的话，请求的状态码是 304 (not modified)。 不同浏览器的策略不同，在 Fire Fox 中，from cache 状态码是 304.

>  from cache 会分为 from disk cache 和 from memory cache. 从内存中获取最快，但是是 session 级别的缓存，关闭浏览器之后就没有了。

- 强缓存（from cache）强制浏览器使用本地缓存
    - Cache-control(响应头)
    - Expires(响应头)
    - Pragma
- 协商缓存（304还是要和服务器通信一次）
    - last-modified(响应头)
    - Etag(响应头)
    - If-None-Match(请求头)
    - If-Modified-Since(请求头)

优先级
>  Cache-Control  > Expires > Etag > Last-Modified

HTTP 缓存机制流程图:
![缓存机制流程图](http://cdn.mydearest.cn/blog/images/http-cache.jpeg)

![流程图](http://cdn.mydearest.cn/blog/images/http-cache2.png)

### 如何设置强缓存和协商缓存
1. 后端服务器，写入代码逻辑中：
```js
res.setHeader('max-age': '3600 public')
res.setHeader(etag: '5c20abbd-e2e8')
res.setHeader('last-modified': Mon, 24 Dec 2018 09:49:49 GMT)
```

2. Nginx 配置
```js
add_header Cache-Control "max-age=3600"
```

## HTTPS基本过程
HTTPS即 HTTP over TLS，是一种在加密信道进行HTTP内容传输的协议

> TLS 的早期版本叫做 SSL。SSL 的 1.0, 2.0, 3.0 版本均已经被废弃，出于安全问题考虑广大浏览器也不再对老旧的 SSL 版本进行支持了，因此这里我们就统一使用 TLS 名称了。