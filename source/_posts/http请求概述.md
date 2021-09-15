---
title: Http请求概述
tags:
  - http
copyright: true
comments: true
date: 2018-08-14 14:56:52
categories: 知识
top: 107
photos:
---

超文本传输协议（HTTP, HyperText Transfer Protocol）是一种无状态的协议，它位于OSI七层模型的传输层。HTTP客户端会根据需要构建合适的HTTP请求方法，而HTTP服务器会根据不同的HTTP请求方法做出不同的响应。

--- 
<!-- more -->


## HTTP 报文组成部分
- 请求报文: 请求行 请求头 空行 请求体
- 响应报文: 响应行 响应头 空行 响应体
> 请求行里包括请求方法, url, http 版本; 响应行里包括状态码, http 版本, 状态说明;

![http-request](http://cdn.mydearest.cn/blog/images/http-request.png)

![http-response](http://cdn.mydearest.cn/blog/images/http-response,png)

## HTTP版本
在HTTP的发展过程中，出现了很多HTTP版本，其中的大部分协议都是向下兼容的。在进行HTTP请求时，客户端在请求时会告诉服务器它采用的协议版本号，而服务器则会在使用相同或者更早的协议版本进行响应。
- HTTP/0.9
这是HTTP最早大规模使用的版本，现已过时。在这个版本中 只有GET一种请求方法，在HTTP通讯也没有指定版本号，也不支持请求头信息。该版本不支持POST等方法，因此客户端向服务器传递信息的能力非常有限。HTTP/0.9的请求只有如下一行：
GET www.baidu.com

- HTTP/1.0
这个版本是第一个在HTTP通讯中指定版本号的协议版本，HTTP/1.0至今仍被广泛采用，特别是在代理服务器中。该版本支持：GET、POST、HEAD三种HTTP请求方法。
- HTTP/1.1

HTTP/1.1是当前正在使用的版本。该版本默认采用持久连接，并能很好地配合代理服务器工作。还支持以管道方式同时发送多个请求，以便降低线路负载，提高传输速度。HTTP/1.1新增了：OPTIONS、PUT、DELETE、TRACE、CONNECT五种HTTP请求方法。

- HTTP/2
这个版本是最新发布的版本，于2015年5月做HTTP标准正式发布。HTTP/2通过支持请求与相应的多路重用来减少延迟，通过压缩HTTP头字段将协议开销降到最低，同时增加了对请求优先级和服务器端推送的支持。

 - 二进制流：http2.0会将所有的传输信息分割为更小的信息或者帧，并对他们进行二进制编码
 - 数据压缩：使用HPACK算法对header的数据进行压缩
 - 多路复用：多路复用允许同时通过单一的HTTP/2连接发送多重请求-响应信息。改善了：在http1.1中浏览器客户端在同一时间，针对同一域名下的请求有一定数量的限制，超过限制会发生阻塞。
 - 资源推送优先级(服务器端推送)-当我们对支持HTTP2.0的web server请求数据的时候，服务器会顺便把一些客户端需要的资源一起推送到客户端，免得客户端再次创建连接发送请求到服务器端获取。这种方式非常
 合适加载静态资源。

![服务端推送](http://cdn.mydearest.cn/blog/images/http2-push.png)
### nginx实现
```
server {
    listen 443 ssl http2;
    ···//省略
    location / {
        ···//省略
        http2_push /style.css;
        http2_push /example.png;
    }
}
```

### 多路复用和持久连接的区别
> 相当于你们家跟你叔叔家打电话：一个是你把跟你叔叔聊完后，不挂电话，你妈和你婶婶聊，你跟你堂兄弟姐妹聊。一个是你们家3口人和你叔叔家三口人同时一对一聊天。
- 所谓持久连接，就是重用下之前的连接，明显连接一次只能一个请求/应答消息。
- 多路复用（multiple access），就是多个http请求/应答使用一个连接。

## HTTP请求方法

### HTTP/1.1
协议中共定义了8种HTTP请求方法，HTTP请求方法也被叫做“请求动作”，不同的方法规定了不同的操作指定的资源方式。服务端也会根据不同的请求方法做不同的响应。

#### GET
GET请求会显示请求指定的资源。一般来说GET方法应该只用于数据的读取，而不应当用于会产生副作用的非幂等的操作中。GET会方法请求指定的页面信息，并返回响应主体，GET被认为是不安全的方法，因为GET方法会被网络蜘蛛等任意的访问。

#### HEAD
HEAD方法与GET方法一样，都是向服务器发出指定资源的请求。但是，服务器在响应HEAD请求时不会回传资源的内容部分，即：响应主体。这样，我们可以不传输全部内容的情况下，就可以获取服务器的响应头信息。HEAD方法常被用于客户端查看服务器的性能。

#### POST
POST请求会 向指定资源提交数据，请求服务器进行处理，如：表单数据提交、文件上传等，请求数据会被 包含在请求体中。POST方法是非幂等的方法，因为这个请求可能会创建新的资源或/和修改现有资源。

#### PUT
PUT请求会身向指定资源位置上传其最新内容，PUT方法是幂等的方法。通过该方法客户端可以将指定资源的最新数据传送给服务器取代指定的资源的内容。

#### DELETE
DELETE请求用于请求服务器删除所请求URI（统一资源标识符，Uniform Resource Identifier）所标识的资源。DELETE请求后指定资源会被删除，DELETE方法也是幂等的。

#### CONNECT
CONNECT方法是HTTP/1.1协议预留的，能够将连接改为管道方式的代理服务器。通常用于SSL加密服务器的链接与非加密的HTTP代理服务器的通信。

#### OPTIONS
OPTIONS请求与HEAD类似，一般也是用于客户端查看服务器的性能。 这个方法会请求服务器返回该资源所支持的所有HTTP请求方法，该方法会用 * 来代替资源名称，向服务器发送OPTIONS请求，可以测试服务器功能是否正常。JavaScript的XMLHttpRequest对象进行CORS跨域资源共享时，就是使用OPTIONS方法发送嗅探请求，以判断是否有对指定资源的访问权限。

#### TRACE
TRACE请求服务器回显其收到的请求信息，该方法主要用于HTTP请求的测试或诊断。

### HTTP/1.1之后增加的方法
在HTTP/1.1标准制定之后，又陆续扩展了一些方法。其中使用中较多的是PATCH 方法:

#### PATCH
PATCH方法出现的较晚，它在2010年的RFC 5789标准中被定义。PATCH请求与PUT请求类似，同样用于资源的更新。二者有以下两点不同：
1.PATCH一般用于资源的部分更新，而PUT一般用于资源的整体更新。
2.当资源不存在时，PATCH会创建一个新的资源，而PUT只会对已在资源进行更新。

### 请求头和响应头
> header 有哪些字段
1)请求(客户端->服务端[request]) 
    GET(请求的方式) /newcoder/hello.html(请求的目标资源) HTTP/1.1(请求采用的协议和版本号) 
    Accept: */*(客户端能接收的资源类型) 
    Accept-Language: en-us(客户端接收的语言类型) 
    Connection: Keep-Alive(维护客户端和服务端的连接关系) 
    Host: localhost:8080(连接的目标主机和端口号) 
    Referer: http://localhost/links.asp(告诉服务器我来自于哪里) 
    User-Agent: Mozilla/4.0(客户端版本号的名字) 
    Accept-Encoding: gzip, deflate(客户端能接收的压缩数据的类型) 
    If-Modified-Since: Tue, 11 Jul 2000 18:23:51 GMT(缓存时间)  
    Cookie(客户端暂存服务端的信息) 
    Date: Tue, 11 Jul 2000 18:23:51 GMT(客户端请求服务端的时间)
    content-type：请求/响应体文件里 MIME 类型。
    content-length：请求/响应体长
    origin：跨域请求时存在，请求来源
    cache-control：强缓存控制，字段见 MDN
    expires：强缓存控制，值为时间戳，标记缓存过期时间

2)响应(服务端->客户端[response])
    HTTP/1.1(响应采用的协议和版本号) 200(状态码) OK(描述信息)
    Location: http://www.baidu.com(服务端需要客户端访问的页面路径) 
    Server:apache tomcat(服务端的Web服务端名)
    Content-Encoding: gzip(服务端能够发送压缩编码类型) 
    Content-Length: 80(服务端发送的压缩数据的长度) 
    Content-Language: zh-cn(服务端发送的语言类型) 
    Content-Type: text/html; charset=GB2312(服务端发送的类型及采用的编码方式)
    Last-Modified: Tue, 11 Jul 2000 18:23:51 GMT(服务端对该资源最后修改的时间)
    Refresh: 1;url=http://www.it315.org(服务端要求客户端1秒钟后，刷新，然后访问指定的页面路径)
    Content-Disposition: attachment; filename=aaa.zip(服务端要求客户端以下载文件的方式打开该文件)
    Transfer-Encoding: chunked(分块传递数据到客户端）  
    Set-Cookie:SS=Q0=5Lb_nQ; path=/search(服务端发送到客户端的暂存数据)
    Expires: -1//3种(服务端禁止客户端缓存页面数据)
    Cache-Control: no-cache(服务端禁止客户端缓存页面数据)  
    Pragma: no-cache(服务端禁止客户端缓存页面数据)   
    Connection: close(1.0)/(1.1)Keep-Alive(维护客户端和服务端的连接关系)  
    Date: Tue, 11 Jul 2000 18:23:51 GMT(服务端响应客户端的时间)
在服务器响应客户端的时候，带上Access-Control-Allow-Origin头信息，解决跨域的一种方法。

## 状态码

|   | 类别                          | 原因短语
:---|:----------                   |:---------
1XX | Informational（信息性状态码）   | 接收的请求正在处理
2XX | Success（成功状态码）           | 请求正常处理完毕
3XX | Redirection（重定向状态码）     | 需要进行附加操作以完成请求
4XX | Client Error（客户端错误状态码） | 服务器无法处理请求
5XX | Server Error（服务器错误状态码） | 服务器处理请求出错

- 101: 需要切换协议(使用 Websocket 开始阶段是 http 协议, 中间切换到 WebSocket 协议, 此时返回的状态码是 101 表示后续协议还需切换)
- 2XX
  * 200 OK 
    <details>
      <summary>成功处理</summary>
      表示从客户端发来的请求在服务器端被正常处理了
    </details>
  * 204 No Content
    <details>
      <summary>成功处理，但无报文实体的主体返回</summary>
      该状态码代表服务器接收的请求已成功处理，但在返回的响应报文中不含实体的主体部分。另外，也不允许返回任何实体的主体。比如，当从浏览器发出请求处理后，返回 204 响应，那么浏览器显示的页面不发生更新。
    </details>
  * 206 Partial Content
    <details>
      <summary>范围请求</summary>
      该状态码表示客户端进行了范围请求，而服务器成功执行了这部分的GET 请求。响应报文中包含由 Content-Range 指定范围的实体内容。
    </details>
- 3XX
  * 301 Moved Permanently
    <details>
      <summary>永久性重定向</summary>
      该状态码表示请求的资源已被分配了新的 URI，以后应使用资源现在所指的 URI。也就是说，如果已经把资源对应的 URI保存为书签了，这时应该按 Location 首部字段提示的 URI 重新保存。
    </details>
  * 302 Found
    <details>
      <summary>临时性重定向(可使用原有URI)</summary>
      该状态码表示请求的资源已被分配了新的 URI，希望用户（本次）能使用新的 URI 访问。和 301 Moved Permanently 状态码相似，但 302 状态码代表的资源不是被永久移动，只是临时性质的。换句话说，已移动的资源对应的URI 将来还有可能发生改变。比如，用户把 URI 保存成书签，但不会像 301 状态码出现时那样去更新书签，而是仍旧保留返回 302 状态码的页面对应的 URI。
    </details>
  * 303 See Other
    <details>
      <summary>同302，但此处因采用GET方法</summary>
      该状态码表示由于请求对应的资源存在着另一个 URI，应使用 GET方法定向获取请求的资源。303 状态码和 302 Found 状态码有着相同的功能，但 303 状态码明确表示客户端应当采用 GET 方法获取资源，这点与 302 状态码有区别。
    </details>
  * 304 Not Modified
    <details>
      <summary>协商缓存(资源未修改可使用缓存)</summary>
      该状态码表示客户端发送附带条件的请求时，服务器端允许请求访问资源，但未满足条件的情况。304 状态码返回时，不包含任何响应的主体部分。304 虽然被划分在 3XX 类别中，但是和重定向没有关系。(附带条件的请求是指采用 GET方法的请求报文中包含 If-Match，If-ModifiedSince，If-None-Match，If-Range，If-Unmodified-Since 中任一首部。)
    </details>
  * 307 Temporary Redirect
    <details>
      <summary>临时重定向</summary>
      该状态码与 302 Found 有着相同的含义。尽管 302 标准禁止 POST 变换成 GET，但实际使用时大家并不遵守。307 会遵照浏览器标准，不会从 POST 变成 GET。但是，对于处理响应时的行为，每种浏览器有可能出现不同的情况。
    </details>
- 4XX 客户端错误
  * 400 Bad Request
    <details>
      <summary>报文中存在语法错误</summary>
      该状态码表示请求报文中存在语法错误。当错误发生时，需修改请求的内容后再次发送请求。另外，浏览器会像 200 OK 一样对待该状态码。
    </details>
  * 401 Unauthorized
    <details>
      <summary>要求身份认证</summary>
      该状态码表示发送的请求需要有通过 HTTP 认证（BASIC 认证、DIGEST 认证）的认证信息。另外若之前已进行过 1 次请求，则表示用 户认证失败。返回含有 401 的响应必须包含一个适用于被请求资源的 WWWAuthenticate 首部用以质询（challenge）用户信息。当浏览器初次接收到 401 响应，会弹出认证用的对话窗口。
    </details>
  * 403 Forbidden
    <details>
      <summary>拒绝请求</summary>
      该状态码表明对请求资源的访问被服务器拒绝了。服务器端没有必要给出拒绝的详细理由，但如果想作说明的话，可以在实体的主体部分对原因进行描述，这样就能让用户看到了。未获得文件系统的访问授权，访问权限出现某些问题（从未授权的发送源 IP 地址试图访问）等列举的情况都可能是发生 403 的原因。
    </details>
  * 404 Not Found
    <details>
      <summary>未找到请求的资源</summary>
      该状态码表明服务器上无法找到请求的资源。除此之外，也可以在服务器端拒绝请求且不想说明理由时使用。
    </details>
  * 409 Conflict 与被请求资源的状态存在冲突
  * 415 Unsupported media type：不支持的媒体类型
* 5XX
  * 500 Internal Server Error
    <details>
      <summary>服务器端在执行请求时发生了错误</summary>
      该状态码表明服务器端在执行请求时发生了错误。也有可能是 Web应用存在的 bug 或某些临时的故障。
    </details>
  * 503 Service Unavailable
    <details>
      <summary>服务器暂时无响应</summary>
      该状态码表明服务器暂时处于超负载或正在进行停机维护，现在无法处理请求。如果事先得知解除以上状况需要的时间，最好写入RetryAfter 首部字段再返回给客户端。
    </details>

## HTTP 事物时延
DNS 解析、连接、传输、处理。

## HTTP 连接
管道化连接: 依赖于 Http/1.1 是持久连接的。

## TCP三次握手
客户端和服务端都需要知道各自可收发，因此需要三次握手(syn建立联机,ack确认联机)

- 客户端发送 syn=1(同步序列编号)，ack=0标志的数据包给服务端，进入 syn_send 状态，等待确认
- 服务端接收并确认 syn 包后发送 syn+ack(1,1) 包，进入 syn_recv 状态
- 客户端接收 syn+ack 包后，发送syn=0，ack=1 包，双方进入 established 状态

```js
                  C                   S
                          SYN=1
                     ---------------> 确认自己可以接收
                        SYN=1,ACK
   确定s可收，自己可收 <--------------
                            ACK
                     ---------------> 确认C可收

```

## TCP四次挥手
- 客户端 -- FIN --> 服务端， FIN—WAIT
- 服务端 -- ACK --> 客户端， CLOSE-WAIT
- 服务端 -- ACK,FIN --> 客户端， LAST-ACK
- 客户端 -- ACK --> 服务端，CLOSED

```
1. 第一次挥手(FIN=1，seq=x)

假设客户端想要关闭连接，客户端发送一个 FIN 标志位置为1的包，表示自己已经没有数据可以发送了，但是仍然可以接受数据。

发送完毕后，客户端进入 FIN_WAIT_1 状态。

2. 第二次挥手(ACK=1，ACKnum=x+1)

服务器端确认客户端的 FIN 包，发送一个确认包，表明自己接受到了客户端关闭连接的请求，但还没有准备好关闭连接。

发送完毕后，服务器端进入 CLOSE_WAIT 状态，客户端接收到这个确认包之后，进入 FIN_WAIT_2 状态，等待服务器端关闭连接。

3. 第三次挥手(FIN=1，seq=y)

服务器端准备好关闭连接时，向客户端发送结束连接请求，FIN 置为1。

发送完毕后，服务器端进入 LAST_ACK 状态，等待来自客户端的最后一个ACK。

4. 第四次挥手(ACK=1，ACKnum=y+1)

客户端接收到来自服务器端的关闭请求，发送一个确认包，并进入 TIME_WAIT状态，等待可能出现的要求重传的 ACK 包。

服务器端接收到这个确认包之后，关闭连接，进入 CLOSED 状态。

客户端等待了某个固定时间（两个最大段生命周期，2MSL，2 Maximum Segment Lifetime）之后，没有收到服务器端的 ACK ，认为服务器端已经正常关闭连接，于是自己也关闭连接，进入 CLOSED 状态。
```

## TCP和UDP的区别

1. TCP是面向连接的，UDP是无连接的，即发送之前不需要先建立连接 

2. TCP提供可靠的服务。也就是说，通过TCP连接传输数据，无差错，不丢失，不重复，且按序到达；UDP尽最大努力交付，即不保证可靠交付。正因如此，TCP适合大数据量的交换 (为什么是可靠的：因为有ACK)

3. TCP是面向字节流，UDP是面向报文，并且网络出现拥塞不会使发送速率降低（因此会出现丢包，实时的应用如ip电话和视频会议等）

4. TCP是一对一，UDP支持一对一，一对多 

5. TCP的首部较大为20字节，而UDP只有8字节 

6. TCP是面向连接的可靠性传输，而UDP是不可靠的
