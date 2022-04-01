---
title: 面试题整理归纳
tags:
  - 面试
copyright: true
comments: true
date: 2018-06-23 10:58:48
categories: 知识
photos:
---

## 字符串扩展的方法

- includes()：返回布尔值，表示是否找到了参数字符串。数组也可以 a[1]=1 且能判断 undefined

```js
var a = [1, 2, 3];
a[4] = 5; // [1, 2, 3, undefined × 1, 5] empty
// a[3]=undefined [1, 2, 3, undefined, 5]

a.indexOf(undefined); // -1
a.includes(undefined); // true
```

- startsWith()：返回布尔值，表示参数字符串是否在原字符串的头部。

```js
// polyfill
if (String.prototype.startsWith) {
  String.prototype.startsWith = function (search, index) {
    return (
      this.substr(!index || index < 0 ? 0 : index, search.length) === search
    );
  };
}
```

- endsWith()：返回布尔值，表示参数字符串是否在原字符串的尾部。
  str | index
- repeat()：返回一个新字符串，表示将原字符串重复 n 次。参数如果是小数，会被取整(不四舍五入)。参数是负数或者 Infinity，会报错。0/NaN 返回空字符串,参数是字符串，则会先转换成数字，不传则为空字符串。
- padStart()：头部补全。
- padEnd()：尾部补全

```
'x'.padStart(5, 'ab') // 'ababx'
'x'.padStart(4, 'ab') // 'abax'

'x'.padEnd(5, 'ab') // 'xabab'
'x'.padEnd(4, 'ab') // 'xaba'
```

如果原字符串的长度，等于或大于指定的最小长度，则返回原字符串。默认使用空格

---

<!-- more -->

- 模板字符串（template string）是增强版的字符串，用反引号\`标识。它可以当作普通字符串使用，也可以用来定义多行字符串，或者在字符串中嵌入变量。\`${表达式、变量}\`
- commonjs 服务器端 amd 浏览器端
- const 必须赋值定义 let 在同一作用于无法重复命名 无法变量提升
- split(字符串或者正则,设置长度) 字符串=>数组
- substr(开始的索引//splice 可以为负数-1 则为字符串最后一个字符,length 字符数)方法不同的是,substring(开始索引，结束索引+1)负的参数有区别
  只有单参数时到字符串结尾
  String exd=filePath.substring(filePath.lastIndexOf(".")+1,filePath.length)

## 声明函数作用提升?声明变量和声明函数的提升有什么区别?

(1) 变量声明提升：变量申明在进入执行上下文就完成了。
只要变量在代码中进行了声明，无论它在哪个位置上进行声明， js 引擎都会将它的声明放在范围作用域的顶部；

(2) 函数声明提升：执行代码之前会先读取函数声明，意味着可以把函数申明放在调用它的语句后面。
只要函数在代码中进行了声明，无论它在哪个位置上进行声明， js 引擎都会将它的声明放在范围作用域的顶部；

(3) 变量 or 函数声明：函数声明会覆盖变量声明，但不会覆盖变量赋值。
同一个名称标识 a，即有变量声明 var a，又有函数声明 function a() {}，不管二者声明的顺序，函数声明会覆盖变量声明，也就是说，此时 a 的值是声明的函数 function a() {}。注意：如果在变量声明的同时初始化 a，或是之后对 a 进行赋值，此时 a 的值变量的值。

```javascript
eg: var a;
var c = 1;
a = 1;
function a() {
  return true;
}
console.log(a);
```

## 如何判断数据类型？

typeof 返回的类型都是字符串形式，可以判断 function 的类型；在判断除 Object 类型的对象时比较方便。
判断已知对象类型的方法： instanceof，后面一定要是对象类型，并且大小写不能错，该方法适合一些条件选择或分支。

```javascript
typeof null; // object null instanceof Object // false

var str = "abc";
console.log(typeof str++); //number NaN
console.log(typeof ("abc" + 1)); //string 'abc1'

console.log(typeof new Date()); //object
console.log(typeof Date()); //string
console.log(typeof Date); //function
```

### typeof 原理

- js 在底层存储变量的时候，会在变量的机器码的低位 1-3 位存储类型信息
- 对象 000 开头
- null 都为 0
- 浮点数 010
- 字符串 100
- 布尔 110
- 整数 1
- undefined -2^30

## 异步编程？

- 方法 1：回调函数，优点是简单、容易理解和部署，缺点是不利于代码的阅读和维护，各个部分之间高度耦合（Coupling），流程会很混乱，而且每个任务只能指定一个回调函数。

- 方法 2：事件监听，可以绑定多个事件，每个事件可以指定多个回调函数，而且可以“去耦合”（Decoupling），有利于实现模块化。缺点是整个程序都要变成事件驱动型，运行流程会变得很不清晰。

- 方法 3：事件发布/订阅，性质与“事件监听”类似，但是明显优于后者。

- 方法 4：Promises 对象，是 CommonJS 工作组提出的一种规范，目的是为异步编程提供统一接口。简单说，它的思想是，每一个异步任务返回一个 Promise 对象，该对象有一个 then 方法，允许指定回调函数。

- generator
- async/await

## 事件流？事件捕获？事件冒泡？

事件流：从页面中接收事件的顺序。也就是说当一个事件产生时，这个事件的传播过程，就是事件流。

事件的传播分为 3 个阶段：

1. 捕获阶段：事件从 window 对象自上而下向目标节点传播的阶段；
2. 目标阶段：真正的目标节点正在处理事件的阶段；
3. 冒泡阶段：事件从目标节点自下而上向 window 对象传播的阶段；

事件捕获是不太具体的元素应该更早接受到事件，而最具体的节点应该最后接收到事件。他们的用意是在事件到达目标之前就捕获它。
事件冒泡：事件开始时由最具体的元素接收，然后逐级向上传播到较为不具体的节点（文档）。

> 并不是所有的事件都能冒泡

- onblur
- onfocus
- onmouseenter
- onmouseleave

![boardcast](http://cdn.mydearest.cn/blog/images/boardcast.png)

```html
<nav id="root_b">
  <ul id="first_b">
    <li id="second_b"><a id="target_b" href="#">冒泡</a></li>
  </ul>
</nav>
<nav id="root_c">
  <ul id="first_c">
    <li id="second_c"><a id="target_c" href="#">捕获</a></li>
  </ul>
</nav>
```

```js
/**
 * listen
 * @param {string[]} ids
 * @param {boolean} isCatch
 */
const listen = (ids, isCatch) =>
  ids.forEach((id) =>
    document
      .getElementById(id)
      .addEventListener("click", () => alert(id), isCatch)
  );

// BubbleEvent
listen(["root_b", "first_b", "second_b", "target_b"], false);

// CatchEvent
listen(["root_c", "first_c", "second_c", "target_c"], true);
```

## 如何添加一个 dom 对象到 body 中?innerHTML、document.write 和 innerText 区别?

body.appendChild(dom 元素)；  
innerHTML:从对象的起始位置到终止位置的全部内容,包括 Html 标签。
innerText:从起始位置到终止位置的内容, 但它去除 Html 标签
document.write 只能重绘整个页面

## 简述 ajax 流程

1)客户端产生触发 js 的事件  
2)创建 XMLHttpRequest 对象

```js
var client = null;
if (window.XMLHttpRequest) {
  client = new XMLHttpRequest();
} else {
  client = new ActiveXObject("Microsoft.XMLHTTP");
}
```

3)对 XMLHttpRequest 进行配置

```js
client.open("GET", url);
client.onreadystatechange = function (e) {
  if (client.readyState !== 4) {
    // client状态
    return;
  }
  if (client.status === 200) {
    // HTTP状态码
    console.log("success", client.responseText);
  } else {
    console.warn("error");
  }
}; // 指定回调函数
client.responseType = "json";
client.setRequestHeader("Accept", "application/json;");
client.setRequestHeader("Content-Type", "application/json;charset=utf-8");
```

4)通过 AJAX 引擎发送异步请求

```javascript
client.send();
```

`promise 封装`

```js
/**
 * @param {string} url
 * @param {string} method
 * @param {object} params
 * @returns
 */
function request(url, method = "GET", params = null) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open(method, url);
    xhr.addEventListener("readystatechange", () => {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          resolve(xhr.responseText);
        } else {
          reject({
            code: xhr.status,
            response: xhr.response,
          });
        }
      }
    });
    setTimeout(() => reject("timeout:1000"), 1000);
    xhr.send(JSON.stringify(params));
  });
}
```

5)服务器端接收请求并且处理请求，返回 html 或者 xml 内容  
6)XML 调用一个 callback()处理响应回来的内容  
7)使用 JS 和 DOM 实现局部刷新

## 自执行函数？用于什么场景？好处？

1、声明一个匿名函数  
2、马上调用这个匿名函数。  
作用：创建一个独立的作用域。

好处：防止变量弥散到全局，以免各种 js 库冲突。隔离作用域避免污染，或者截断作用域链，避免闭包造成引用变量无法释放。利用立即执行特性，返回需要的业务函数或对象，避免每次通过条件判断来处理。

场景：一般用于框架、插件等场景，设计私有变量和方法，封闭私有作用域。

## 立即执行函数表达式(IIFE)

### 使用匿名函数表达式

```js
var a = 2;
(function IIFE() {
  var a = 3;
  console.log(a); //3
})();
console.log(a); //2
```

### 当作函数调用并传递参数进去

```js
var a = 2;
(function IIFE(global) {
  var a = 3;
  console.log(a); //3
  console.log(global.a); //2
})(window);
console.log(a); //2
```

### 解决 undefined 标识符默认值被错误覆盖

```js
undefined = true;
(function IIFE() {
  var a;
  if (a === undefined) {
    console.log("Undefined is safe here!");
  }
})();
```

### 倒置代码运行顺序

```js
var a = 2;
(function IIFE(def) {
  def(window);
})(function def(global) {
  var a = 3;
  console.log(a); //3
  console.log(global.a); //2
});
```

```js
var i = 1;
var IFun = (function(){
	var i = 1;
	console.log(i);
	return function(){
		i++;
		console.log(i);
}
})();
IFun();
IFun();
最终输出的结果为1，2，3，很多人会下意识的觉得结果会有4个值，但是运用了return 返回值以及自执行函数将函数返回给IFun变量，使得在第一次操作过程后，将返回函数直接赋给IFun。
```

### 作用

1. 创建作用域，内部保存一些大量临时变量的代码防止命名冲突。
2. 一些库的外层用这种形式包起来防止作用域污染。
3. 运行一些只执行一次的代码

## 回调函数？（传递地址，由非实现方调用）

回调函数就是一个通过函数指针调用的函数。如果你把函数的指针（地址）作为参数传递给另一个函数，当这个指针被用来调用其所指向的函数时，我们就说这是回调函
数。回调函数不是由该函数的实现方直接调用，而是在特定的事件或条件发生时由另外的一方调用的，用于对该事件或条件进行响应。

## 什么是闭包?堆栈溢出有什么区别？ 内存泄漏? 那些操作会造成内存泄漏？怎么样防止内存泄漏？impression

闭包：就是能够读取其他函数内部变量的函数。一般是指内层函数。(子函数在外调用，子函数所在的父函数的作用域不会被释放。)

堆栈溢出：就是不顾堆栈中分配的局部数据块大小，向该数据块写入了过多的数据，导致数据越界，结果覆盖了别的数据。经常会在递归中发生。

内存泄漏是指：用动态存储分配函数内存空间，在使用完毕后未释放，导致一直占据该内存单元。直到程序结束。指任何对象在您不再拥有或需要它之后仍然存在。

造成内存泄漏：
setTimeout 的第一个参数使用字符串而非函数的话，会引发内存泄漏。
闭包、控制台日志、循环（在两个对象彼此引用且彼此保留时，就会产生一个循环）

防止内存泄漏：  
1、不要动态绑定事件；  
2、不要在动态添加，或者会被动态移除的 dom 上绑事件，用事件冒泡在父容器监听事件；  
3、如果要违反上面的原则，必须提供 destroy 方法，保证移除 dom 后事件也被移除，这点可以参考 Backbone 的源代码，做的比较好；  
4、单例化，少创建 dom，少绑事件。

原因：
全局变量没有手动销毁，因为全局变量不会被回收
闭包：闭包中的变量被全局对象引用，则闭包中的局部变量不能释放
监听事件添加后，没有移除，会导致内存泄漏

- 意外的全局变量无法被回收
- 闭包
- 定时器未删除被正确关闭
- dom 事件未清除
- dom 元素删除内存存在引用

## html 和 xhtml 有什么区别?

HTML 是一种基本的 WEB 网页设计语言，XHTML 是一个基于 XML 的标记语言。

1.XHTML 元素必须被正确地嵌套。

2.XHTML 元素必须被关闭。

3.标签名必须用小写字母。

4.空标签也必须被关闭。

5.XHTML 文档必须拥有根元素。

## 什么是构造函数？与普通函数有什么区别?

构造函数：是一种特殊的方法(函数、对象)、主要用来创建对象时初始化对象，总与 new 运算符一起使用，创建对象的语句中构造函数的函数名必须与类名完全相同。

与普通函数相比只能由 new 关键字调用，构造函数是类的标识。

## 通过 new 创建一个对象的时候，函数内部有哪些改变？

```javascript
function Person() {}
Person.prototype.friend = [];
Person.prototype.age = 18;
var a = new Person();
a.friend[0] = "方涛"; // a.friend=['123'] 指向新对象 b.friend // []
a.age = 18;
var b = new Person();
b.friend; // ['方涛']
b.age; // 18
```

> 1、创建一个空对象，并且 this 变量引用该对象，同时还继承了该函数的原型。  
> 2、属性和方法被加入到 this 引用的对象中。  
> 3、新创建的对象由 this 所引用，并且最后隐式的返回 this 。

`new 操作符新建了一个空对象，这个对象原型指向构造函数的prototype，执行构造函数后返回这个对象。`

- 创建一个空对象：var obj = {}

- 将空对象的**proto**指向构造函数的 prototype：obj.**proto** = Person().prototype

- 使用空对象作为上下文调用构造函数： Person.call(obj)

```js
function myNew(fn, ...args) {
  let instance = Object.create(fn.prototype);
  let result = fn.call(instance, ...args);
  return typeof result === "object" ? result : instance;
}
```

## 事件委托的好处都有啥？说对了都给它=3=

- 利用冒泡的原理，把事件加到父级上，触发执行效果

- 好处：新添加的元素还会有之前的事件；提高性能。

## 节点类型?判断当前节点类型?

- 元素节点
- 属性节点
- 文本节点
- 注释节点
- 文档节点

通过 nodeObject.nodeType 判断节点类型：其中，nodeObject 为 DOM 节点（节点对象）。该属性返回以数字表示的节点类型，例如，元素节点返回 1，属性节点返回 2 。

## 数组合并的方法？

```js
// 四种方法。
var arr1 = [1, 2, 3];
var arr2 = [4, 5, 6];
arr1 = arr1.concat(arr2);
console.log(arr1);

var arr1 = [1, 2, 3];
var arr2 = [4, 5, 6];
Array.prototype.push.apply(arr1, arr2);
console.log(arr1);

var arr1 = [1, 2, 3];
var arr2 = [4, 5, 6];
for (var i = 0; i < arr2.length; i++) {
  arr1.push(arr2[i]);
}
console.log(arr1);

var arr1 = [1, 2, 3];
var arr2 = [4, 5, 6];

arr1.push(...arr2);
```

## jquery 和 zepto 有什么区别?

- 针对移动端程序，Zepto 有一些基本的触摸事件可以用来做触摸屏交互（tap 事件、swipe 事件），Zepto 是不支持 IE 浏览器的，这不是 Zepto 的开发者 Thomas Fucks 在跨浏览器问题上犯了迷糊，而是经过了认真考虑后为了降低文件尺寸而做出的决定，就像 jQuery 的团队在 2.0 版中不再支持旧版的 IE（6 7 8）一样。因为 Zepto 使用 jQuery 句法，所以它在文档中建议把 jQuery 作为 IE 上的后备库。那样程序仍能在 IE 中，而其他浏览器则能享受到 Zepto 在文件大小上的优势，然而它们两个的 API 不是完全兼容的，所以使用这种方法时一定要小心，并要做充分的测试。

- Dom 操作的区别：添加 id 时 jQuery 不会生效而 Zepto 会生效。

- zepto 主要用在移动设备上，只支持较新的浏览器，好处是代码量比较小，性能也较好。
  jquery 主要是兼容性好，可以跑在各种 pc，移动上，好处是兼容各种浏览器，缺点是代码量大，同时考虑兼容，性能也不够好。

## $(function(){})和 window.onload 和 $(document).ready(function(){})

- window.onload:用于当页面的所有元素，包括外部引用文件，图片等都加载完毕时运行函数内的函数。load 方法只能执行一次，如果在 js 文件里写了多个，只能执行最后一个。

- $(document).ready(function(){})和$(function(){})都是用于当页面的标准 DOM 元素被解析成 DOM 树后就执行内部函数。这个函数是可以在 js 文件里多次编写的，对于多人共同编写的 js 就有很大的优势，因为所有行为函数都会执行到。而且$(document).ready()函数在 HMTL 结构加载完后就可以执行，不需要等大型文件加载或者不存在的连接等耗时工作完成才执行，效率高。

## 简述下 this 和定义属性和方法的时候有什么区别?Prototype？

- this 表示当前对象，如果在全局作用范围内使用 this，则指代当前页面对象 window； 如果在函数中使用 this，则 this 指代什么是根据运行时此函数在什么对象上被调用。 我们还可以使用 apply 和 call 两个全局方法来改变函数中 this 的具体指向。

- prototype 本质上还是一个 JavaScript 对象。 并且每个函数都有一个默认的 prototype 属性。

- 在 prototype 上定义的属性方法为所有实例共享，所有实例皆引用到同一个对象，单一实例对原型上的属性进行修改，也会影响到所有其他实例。

## ajax 和 jsonp 的区别？

- 相同点：都是请求一个 url
- 不同点：ajax 的核心是通过 XMLHttpRequest 获取内容，jsonp 只能 get 请求
- jsonp 的核心则是动态添加`<script>`标签来调用服务器提供的 js 脚本。

## 常见的 http 协议状态码？

```js
1xx (临时响应)
100: 继续(正在加载)
101：切换协议
200：请求成功
201：请求成功并且服务器创建了新的资源
302：服务器目前从不同位置的网页响应请求，但请求者应继续使用原有位置来响应以后的请求。
304：自从上次请求后，请求的网页未修改过。服务器返回此响应时，不会返回网页内容。
400：服务器不理解请求的语法。
403：该状态表示服务器理解了本次请求但是拒绝执行该任务
404：请求的资源（网页等）不存在
405：方法不被允许
500：内部服务器错误
502：网关错误
504：网关超时
```

## sessionStorage 和 localstroage 与 cookie 之间有什么关联, cookie 最大存放多少字节？

三者共同点：都是保存在浏览器端，且同源的。

区别:
1、cookie 在浏览器和服务器间来回传递。而 sessionStorage 和 localStorage 不会自动把数据发给服务器，仅在本地保存

### cookie 的作用

- 保存用户登录状态(存储 sessionId 来标识唯一用户)
- 跟踪用户行为
- 定制页面

2、存储大小限制也不同，cookie 数据不能超过 4k，sessionStorage 和 localStorage 但比 cookie 大得多，可以达到 5M

3、数据有效期不同，sessionStorage：仅在当前浏览器窗口关闭前有效，自然也就不可能持久保持；localStorage：始终有效，窗口或浏览器关闭也一直保存，因此用作持久数据；cookie 只在设置的 cookie 过期时间之前一直有效，即使窗口或浏览器关闭

4、作用域不同，sessionStorage 只在同源的同窗口（或标签页）中共享数据，也就是只在当前会话中共享；localStorage 在所有同源窗口中都是共享的；cookie 也是在所有同源窗口中都是共享的( 即数据共享 )。

## ajax 的 get 与 post 区别？

- get 和 post 都是数据提交的方式。
- get 的数据是通过网址问号后边拼接的字符串进行传递的。post 是通过一个 HTTP 包(request body)进行传递数据的。
- get 的传输量是有限制的，post 是没有限制的。(实际上 HTTP 协议从未规定 GET/POST 的请求长度限制是多少。对 get 请求参数的限制是来源与浏览器或 web 服务器，浏览器或 web 服务器限制了 url 的长度)
- get 的安全性可能没有 post 高，所以我们一般用 get 来获取数据，post 一般用来修改数据。
- get 请求, 倒退按钮是无害的, post 会重新发起请求
- get 会主动缓存, post 不会
- get 请求只能进行 url 编码，而 post 请求支持多种编码
- **_get 产生一个 TCP 数据包，POST 产生两个 TCP 数据包_**
- get 比较快且有历史记录

get 就是将货品放在车顶，post 放在车内。

![get-post-diff](http://cdn.mydearest.cn/blog/images/get-post-diff.png)

## GC 机制？为什么闭包不会被回收变量和函数？

- GC 垃圾回收机制：将内存中不再使用的数据进行清理，释放出内存空间。

引用类型是在没有引用之后, 通过 v8 的 GC 自动回收, 值类型如果是处于闭包的情况下, 要等闭包没有引用才会被 GC 回收, 非闭包的情况下等待 v8 的新生代
(new space) 切换的时候回收。

v8 的垃圾回收机制基于分代回收机制，这个机制又基于世代假说，这个假说有两个特点，一是新生的对象容易早死，另一个是不死的对象会活得更久。基于这个假说，v
8 引擎将内存分为了新生代和老生代。

新创建的对象或者只经历过一次的垃圾回收的对象被称为新生代。经历过多次垃圾回收的对象被称为老生代。

V8 将内存分成 新生代空间 和 老生代空间。

回收方法有两种：标记清除、计数引用

老生代采用了标记清除法和标记压缩法。标记清除简单讲就是变量存储在内存中，当变量进入执行环境的时候，垃圾回收器会给它加上标记，这个变量离开执行环境，将其标记为“清除”，不可
追踪，不被其他对象引用，或者是两个对象互相引用，不被第三个对象引用，然后由垃圾回收器收回，释放内存空间。。

由于在进行垃圾回收的时候会暂停应用的逻辑，对于新生代方法由于内存小，每次停顿的时间不会太长，但对于老生代来说每次垃圾回收的时间长，停顿会造成很大的影
响。 为了解决这个问题 V8 引入了增量标记的方法，将一次停顿进行的过程分为了多步，每次执行完一小步就让运行逻辑执行一会，就这样交替运行。

## 面向对象？

万物皆对象，把一个对象抽象成类，具体上就是把一个对象的静态特征和动态特征抽象成属性（属性名、属性值）和方法，也就是把一类事物的算法和数据结构封装在一
个类之中，程序就是多个对象和互相之间的通信组成的。

面向对象具有封装性，继承性，多态性。
封装：隐蔽了对象内部不需要暴露的细节，使得内部细节的变动跟外界脱离，只依靠接口进行通信。封装性降低了编程的复杂性。通过继承，使得新建一个类变得容易，一个类从派生类那里获得其非私有的方法和公用属性的繁琐工作交给了编译器。而继承和实现接口和运行时的类型绑定机制所产生的多态，使得不同的类所产生的对象能够对相同的消息作出不同的反应，极大地提高了代码的通用性。

总之，面向对象的特性提高了大型程序的重用性和可维护性。

## jsonp 的原理和缺点？

- 原理：使用 script 标签实现跨域访问，可在 url 中指定回调函数，获取 JSON 数据并在指定的回调函数中执行 jquery 实现 jsop。
- 缺点：只支持 GET 方式的 jsonp 实现，是一种脚本注入行为存在一定的安全隐患。如果返回的数据格式有问题或者返回失败了，并不会报错。

## call 和 apply 两者的区别和好处？

- call 和 apply 都是改变 this 指向的方法，区别在于 call 可以写多个参数，而 apply 只能写两个参数，第二个参数是一个数组，用于存放要传的参数。
- 用 call 和 apply 实现更好的继承和扩展，更安全。

## 压缩合并目的？http 请求的优化方式？

- Web 性能优化最佳实践中最重要的一条是减少 HTTP 请求。而减少 HTTP 请求的最主要的方式就是，合并并压缩 JavaScript 和 CSS 文件。

- CSS Sprites（雪碧图、CSS 精灵）：把全站的图标都放在一个图像文件中，然后用 CSS 的 background-image 和 background-position 属性定位来显示其中的一小部分。

优点：

1. 减少 HTTP 请求数，极大地提高页面加载速度
2. 增加图片信息重复度，提高压缩比，减少图片大小
3. 更换风格方便，只需在一张或几张图片上修改颜色或样式即可实现

缺点：

1. 图片合并麻烦
2. 维护麻烦，修改一个图片可能需要重新布局整个图片，样式

- 合并脚本和样式表; 图片地图：利用 image map 标签定义一个客户端图像映射，（图像映射指带有可点击区域的一幅图像）具体看：http://club.topsage.com/thread-2527479-1-1.html

- 图片 js/css 等静态资源放在静态服务器或 CDN 服务器时，尽量采用不用的域名，这样能防止 cookie 不会互相污染，减少每次请求的往返数据。

- css 替代图片, 缓存一些数据

- 少用 location.reload()：使用 location.reload() 会刷新页面，刷新页面时页面所有资源 (css，js，img 等) 会重新请求服务器。建议使用 location.href="当前页 url" 代替 location.reload() ，使用 location.href 浏览器会读取本地缓存资源。

- 图片懒加载

## commonjs?requirejs?AMD|CMD|UMD?

- CommonJS 就是为 JS 的表现来制定规范，NodeJS 是这种规范的实现，webpack 也是以 CommonJS 的形式来书写。因为 js 没有模块的功能，所以 CommonJS 应运而生。但它不能在浏览器中运行。 CommonJS 定义的模块分为:{模块引用(require)} {模块定义(exports)} {模块标识(module)}

- RequireJS 是一个 JavaScript 模块加载器。 RequireJS 有两个主要方法(method): define()和 require()。这两个方法基本上拥有相同的定义(declaration) 并且它们都知道如何加载的依赖关系，然后执行一个回调函数(callback function)。与 require()不同的是， define()用来存储代码作为一个已命名的模块。 因此 define()的回调函数需要有一个返回值作为这个模块定义。这些类似被定义的模块叫作 AMD (Asynchronous Module Definition，异步模块定义)。

- AMD 是 RequireJS 在推广过程中对模块定义的规范化产出 AMD 异步加载模块。它的模块支持对象 函数 构造器 字符串 JSON 等各种类型的模块。 适用 AMD 规范适用 define 方法定义模块。

- CMD 是 SeaJS 在推广过程中对模块定义的规范化产出
  AMD 与 CMD 的区别：
  （1）对于于依赖的模块，AMD 是提前执行(requirejs2.0+可以延迟执行了)，CMD 是延迟执行。
  （2）AMD 推崇依赖前置，CMD 推崇依赖就近。
  （3）AMD 推崇复用接口，CMD 推崇单用接口。
  （4）书写规范的差异。

- umd 是 AMD 和 CommonJS 的糅合。
  AMD 浏览器第一的原则发展 异步加载模块。
  CommonJS 模块以服务器第一原则发展，选择同步加载，它的模块无需包装(unwrapped modules)。这迫使人们又想出另一个更通用的模式 UMD ( Universal Module Definition ), 希望解决跨平台的解决方案。UMD 先判断是否支持 Node.js 的模块( exports )是否存在，存在则使用 Node.js 模块模式。

### 差异

1. `CommonJS 模块输出的是一个值的浅拷贝，ES6 模块输出的是值的引用。`也就是说，一旦输出一个值，模块内部的变化就影响不到这个值。ES6 模块的运行机制与
   CommonJS 不一样。JS 引擎对脚本静态分析的时候，遇到模块加载命令 import，就会生成一个只读引用。等到脚本真正执行时，再根据这个只读引用，到被加载的那
   个模块里面去取值。

2. `CommonJS 模块是运行时加载，ES6 模块是编译时输出接口。`CommonJS 模块就是对象，即在输入时是先加载整个模块，生成一个对象，然后再从这个对象上面读
   取方法，这种加载称为“运行时加载”。而 ES6 模块不是对象，它的对外接口只是一种静态定义，在代码静态解析阶段就会生成。

3. CommonJs 导入的模块路径可以是一个表达式，因为它使用的是 require()方法；而 ES6 Modules 只能是字符串。

4. CommonJS this 指向当前模块，ES6 Modules this 指向 undefined

5. ES6 Modules 中没有这些顶层变量：arguments、require、module、exports、**filename、**dirname

## js 的几种继承方式？

- 使用对象冒充实现继承
- call、apply 改变函数上下文实现继承
- 原型链方式实现继承

## js 原型、原型链，有什么特点？

在 JavaScript 中,一共有两种类型的值,原始值和对象值.每个对象都有一个内部属性[[prototype]],我们通常称之为原型.原型的值可以是一个对象,也可以是 null.如果它的值是一个对象,则这个对象也一定有自己的原型.这样就形成了一条线性的链,我们称之为原型链.

访问一个对象的原型可以使用 ES5 中的 Object.getPrototypeOf 方法,或者 ES6 中的**proto**属性. 原型链的作用是用来实现继承,比如我们新建一个数组,数组的方法就是从数组的原型上继承而来的。

类的继承
特点：基于原型链，既是父类的实例，也是子类的实例
缺点：无法实现多继承

构造继承、组合继承、实例继承和拷贝继承...

## eval 是做什么的？

- 将把对应的字符串解析成 JS 代码并运行； 应该避免使用 eval，不安全，非常耗性能（2 次，一次解析成 js 语句，一次执行）。
- 由 JSON 字符串转换为 JSON 对象的时候可以用 eval，var obj =eval('('+ str +')');

## null 和 undefined

- null 表示一个对象是“没有值”的值，也就是值为“空”；
- undefined 表示一个变量声明了没有初始化(赋值)；
  > Number(null)为 0，而 undefined 为 NaN

## json 的理解？

- JSON（轻量级的数据交换格式），基于 JS 的子集，数据格式简单，易于读写，占用带宽小。

```javascript
JSON.parse(); // 解析成JSON对象

JSON.strinify(); // 解析成JSON字符串
```

## script 引入方式：

- html 静态<script>引入
- js 动态插入<script>
- <script defer>: 延迟加载，元素解析完成后执行
- <script async>: 异步加载，但执行时会阻塞元素渲染只是它的加载过程不会阻塞

## ajax（异步的 js 和 xml）

- ajax 是指一种创建交互式网页应用的网页开发技术。通过后台与服务器进行少量数据交换，AJAX 可以使网页实现异步更新。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。

## 同异步的区别？

- 同步(sync)：按顺序执行。
- 异步(async)：不按顺序执行，可以跳过执行下面的代码。

### 什么是异步

当前一个任务被执行时，不会等待任务执行完成后就去执行下一个任务，等前一个任务执行完成后，将去执行其返回的回调函数，这是异步操作。

### 为什么要异步

js 是单线程的，因此必须等前一个任务完成后，后一个任务才会被执行。因此当执行一段耗时的程序时，会影响整个程序的执行，异步的方法就是为了解决这个问题。

## ajax 的缺点？

- 不支持浏览器的 back 按钮(事件由浏览器内核控制)
- ajax 暴露了与服务器的交互
- 对搜索引擎的支持较弱
- 破坏了程序的异常机制
- 不容易调试

## 跨域问题？

### 同源策略

同源策略限制从一个源加载的文档或脚本如何与来自另一个源的资源进行交互。这是一个用于隔离潜在恶意文件的关键安全机制。

- 协议不同
- 端口不同
- 域名不同
- 常用解决方案：

1. jsonp

```html
<script src="http://example.com/data.php?callback=do"></script>
```

2. iframe
3. window.name
   在一个窗口中，窗口载入的所有页面共享一个 window.name，每个页面都对 window.name 具有读写权限，可以在 window.name 中设置想要的数据。
4. window.postMessage

```js
// iframe通信
iframe.contentWindow.postMessage(msg);
window.onmessage = function (e) {
  e = e || event;
  alert(e.data);
};
```

5. document.domain
   将两个页面的 document.domain 设置成相同域名即可，js 中设置，形如：
   document.domain = "";
6. 服务器设置代理页面/响应 header 配置 cors access-control-allow-origin
   CORS 全称“ Cross-origin resource sharing ”（跨域资源共享），相比 JSONP， CORS 允许任何类型的请求 。

> CORS 需要浏览器和服务器同时支持。目前，所有浏览器都支持该功能，IE 浏览器不能低于 IE10。

> 整个 CORS 通信过程，都是浏览器自动完成，不需要用户参与。对于开发者来说，CORS 通信与同源的 AJAX 通信没有差别，代码完全一样。浏览器一旦发现 AJAX 请求跨
> 源，就会自动添加一些附加的头信息，有时还会多出一次附加的请求，但用户不会有感觉。

> 因此，实现 CORS 通信的关键是服务器。只要服务器实现了 CORS 接口，就可以跨源通信。

7. nginx 反向代理、nodejs 反向代理

- http-proxy-middleware 插件

```js
var express = require("express");
var proxy = require("http-proxy-middleware");

var app = express();

app.use(
  "/cosyer",
  proxy({ target: "http://39.105.136.190:3000/", changeOrigin: true })
);
app.listen(3000);
```

- webpack-dev-server

```js
devServer: {
    port: 3000,
    inline: true,
    proxy: {
        "/cosyer": {
            target: "http://39.105.136.190:3000/",
            changeOrigin: true  //必须配置为true，才能正确代理
        }
    }
}
```

webpack 的 devServer.proxy 就是使用了非常强大的 http-proxy-middleware 包来实现代理的，所以本质上是相通的。

- nginx

```js
server {
  listen  80;
  server_name  client.com;
  location /api {
    proxy_pass server.com;
  }
}
```

8. WebSocket
   WebSocket 是一种通信协议，使用 ws://（非加密）和 wss://（加密）作为协议前缀。该协议不实行同源政策，只要服务器支持，就可以通过它进行跨源通信。

由于发出的 WebSocket 请求中有有一个字段是 Origin，表示该请求的请求源（origin），即发自哪个域名。

正是因为有了 Origin 这个字段，所以 WebSocket 才没有实行同源政策。因为服务器可以根据这个字段，判断是否许可本次通信。

```js
var ws = new WebSocket("wss://echo.websocket.org");
ws.onopen = function (evt) {
  console.log("Connection open ...");
  ws.send("Hello WebSockets!");
};
ws.onmessage = function (evt) {
  console.log("Received Message: ", evt.data);
  ws.close();
};
ws.onclose = function (evt) {
  console.log("Connection closed.");
};
```

```
前后端通信方式
Ajax 支持同源通信
WebSocket 不受同源策略影响
CORS 既支持同源通信也支持跨域通信
```

## 解决异步回调地狱有哪些方案？

- promise
- generator
- async/await(优缺点)
  `async 和await` 相比直接使用 `Promise` 来说,优势在于处理 then 的调用链，能够更清晰准确的写出代码。缺点在于滥用 await 可能会导致性能问题，因为 await 会阻塞代码，也许之后的异步代码并不依赖于前者，但仍然需要等待前者完成，导致代码失去了并发性，导致性能的降低。

## 图片的预加载和懒加载？

- 预加载：提前加载图片，当用户需要查看时可直接从本地缓存中渲染，加快响应速度。
- 懒加载：懒加载的主要目的是作为服务器前端的优化，减少请求数或延迟请求数。

两种技术的本质：两者的行为是相反的，一个是提前加载，一个是迟缓甚至不加载。 懒加载对服务器前端有一定的缓解压力作用，预加载则会增加服务器前端压力。

## mouseover 和 mouseenter 的区别？

- mouseover：当鼠标移入元素或其子元素都会触发事件，所以有一个重复触发，冒泡的过程。对应的移除事件是 mouseout

- mouseenter：当鼠标移入元素本身（不包含元素的子元素）会触发事件，也就是不会冒泡，对应的移除事件是 mouseleave

- onmousedown 当元素上按下鼠标按钮时出发
- onmousemove 当鼠标指针移动到元素上移动触发
- onmouseover 当鼠标指针移动元素上时触发
- onmouseout 当鼠标指针移出指定的对象时发生。
- onmouseup 当在元素上释放鼠标按钮时触发
- onmouseenter 事件在鼠标指针移动到元素上时触发。(不冒泡)
- onmouseleave 事件在鼠标移除元素时触发。(不冒泡)

## 改变函数内部 this 指针的指向函数（bind，apply，call 的区别）？

- 通过 apply 和 call 改变函数的 this 指向，他们两个函数的第一个参数都是一样的表示要改变指向的那个对象(函数作用域)，第二个参数，apply 是数组或者类数组对象 arguments，而 call 则是 arg1,arg2...这种形式。

- 通过 bind 改变 this 作用域会返回一个新的函数，这个函数不会马上执行。

## 说说前端中的事件流

HTML 中与 javascript 交互是通过事件驱动来实现的，例如鼠标点击事件 onclick、页面的滚动事件 onscroll 等等，可以向文档或者文档中的元素添加事件侦听器来预订事件。想要知道这些事件是在什么时候进行调用的，就需要了解一下“事件流”的概念。
什么是事件流：事件流描述的是从页面中接收事件的顺序,DOM2 级事件流包括下面几个阶段。

事件捕获阶段
处于目标阶段
事件冒泡阶段

addEventListener：addEventListener 是 DOM2 级事件新增的指定事件处理程序的操作，这个方法接收 3 个参数：要处理的事件名、作为事件处理程序的函数和一个布尔值。最后这个布尔值参数如果是 true，表示在捕获阶段调用事件处理程序；如果是 false，表示在冒泡阶段调用事件处理程序。
IE 只支持事件冒泡。

## 如何让事件先冒泡后执行？

在 DOM 标准事件模型中，是先捕获后冒泡。但是如果要实现先冒泡后捕获的效果，对于同一个事件，监听捕获和冒泡，分别对应相应的处理函数，监听到捕获事件，先暂缓执行，直到冒泡事件被捕获后再执行捕获事
件。

## 什么是事件委托？（事件代理）

简介：事件委托指的是，不在事件的发生地（直接 dom）上设置监听函数，而是在其父元素上设置监听函数，通过事件冒泡，父元素可以监听到子元素上事件的触发，通过判断事件发生元素 DOM 的类型，来做出不同的
响应。

捕获阶段的实际应用：可以在父元素层面阻止事件向子元素传播，也可以代替子元素执行某些操作。

举例：最经典的就是 ul 和 li 标签的事件监听，比如我们在添加事件时候，采用事件委托机制，不会在 li 标签上直接添加，而是在 ul 父元素上添加。

好处：

1. 减少内存消耗，提高性能(不需要为每一个子元素绑定事件)
2. 动态绑定事件

```html
<ul id="proxy">
  <li><button id="1">1</button></li>
  <li><button id="2">2</button></li>
  <li><button id="3">3</button></li>
</ul>
```

```js
function main() {
  const proxy = document.getElementById("proxy");

  proxy.addEventListener("click", (event) => {
    const currentTarget = event.target;
    const id = currentTarget.id;
    switch (id) {
      case "1":
        alert(`proxy: ${1}`);
        break;
      case "2":
        alert(`proxy: ${2}`);
        break;
      case "3":
        alert(`proxy: ${3}`);
        break;
      default:
        break;
    }
  });
}
```

- event.target & event.currentTarget

```js
<div id="a">
    aaaa
  <div id="b">
      bbbb
    <div id="c">
        cccc
      <div id="d">
          dddd
      </div>
    </div>
  </div>
</div>

<script>
    document.getElementById("a").addEventListener("click", function (e) {
        console.log(
            "target:" + e.target.id + "&currentTarget:" + e.currentTarget.id
        );
    });
    document.getElementById("b").addEventListener("click", function (e) {
        console.log(
            "target:" + e.target.id + "&currentTarget:" + e.currentTarget.id
        );
    });
    document.getElementById("c").addEventListener("click", function (e) {
        console.log(
            "target:" + e.target.id + "&currentTarget:" + e.currentTarget.id
        );
    });
    document.getElementById("d").addEventListener("click", function (e) {
        console.log(
            "target:" + e.target.id + "&currentTarget:" + e.currentTarget.id
        );
    });
</script>

// 当我们点击最里层的元素d的时候，会依次输出:
// target:d&currentTarget:d
// target:d&currentTarget:c
// target:d&currentTarget:b
// target:d&currentTarget:a
```

event.target 始终是事件的真正发出者，而 event.currentTarget 始终是监听事件者。

## 垂直居中

1. margin:auto 法

```css
div {
  width: 200px;
  margin: 0 auto;
}
/* 绝对定位居中 */
div {
  position: absolute;
  width: 300px;
  height: 300px;
  margin: auto;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  background-color: pink; /* 方便看效果 */
}
```

2. margin 负值法 relative -> absolute

```css
div {
  position: relative; /* 相对定位或绝对定位均可 */
  width: 500px;
  height: 300px;
  top: 50%;
  left: 50%;
  margin: -150px 0 0 -250px; /* 外边距为自身宽高的一半 */
  /* transform: translate(-50%, -50%); */
  background-color: pink; /* 方便看效果 */
}
```

3. flex 布局

```css
.container {
  display: flex;
  align-items: center; /* 垂直居中 */
  justify-content: center; /* 水平居中 */
}
.container div {
  width: 100px;
  height: 100px;
  background-color: pink; /* 方便看效果 */
}
```

4. table-cell 未脱离文档流 设置父元素的 display:table-cell,并且 vertical-align:middle，这样子元素可以实现垂直居中。
5. grid 布局
6. line-height 单配 height

## visibility=hidden, opacity=0，display:none

- opacity=0，该元素隐藏起来了，但不会改变页面布局，并且，如果该元素已经绑定一些事件，如 click 事件，那么点击该区域，也能触发点击事件的
- visibility=hidden，该元素隐藏起来了，但不会改变页面布局，但是不会触发该元素已经绑定的事件。
- display=none，把元素隐藏起来，并且会改变页面布局，可以理解成在页面中把该元素删除掉一样。

## 块元素和行内元素的区别

- 块元素：独占一行，并且有自动填满父元素，可以设置 margin 和 padding 以及高度和宽度。
- 行元素：不会独占一行，width 和 height 会失效，并且在垂直方向的 padding 和 margin 会失效。
- 内容上，默认情况下，行内元素只能包含文本和其他行内元素。而块级元素可以包含行内元素和其他块级元素。

## 深拷贝

- 深拷贝的方法 1-2 适用于一般的对象和数组 4-5 适用于数组 3 通用

```JS
let obj = {
    a: 1,
    arr: [1, 2]
};
let obj2 = deepCopy(obj);
obj2.a = 2
console.log(obj) // { a:1, arr: [1,2] };
2.es6
Object.assign()方法(深复制只有一层，之后为浅复制（除非再次使用Object.assign嵌套方式赋值）)
let obj = {
    a: 1,
    arr: [1, 2]
};
let obj1 = Object.assign({}, obj);
obj1.a = 2
//不变
console.log(obj) // { a:1, arr: [1,2] };
3.immutable
4.arr1=arr.slice(0) slice() 返回新数组
5.arr1=arr.concat()
var deepCopy= function(source) {
    var result={};
    for (var key in source) {
        result[key] = typeof source[key]==='object'? deepCoypy(source[key]): source[key];
     }
   return result;
}
```

## 判断一个变量是否是数组

```JS
var a = [];
// 1.基于instanceof
a instanceof Array;
// 2.基于constructor
a.constructor === Array;
// 3.基于Object.prototype.isPrototypeOf
Array.prototype.isPrototypeOf(a);
// 4.基于getPrototypeOf
Object.getPrototypeOf(a) === Array.prototype;
// 5.基于Object.prototype.toString
Object.prototype.toString.apply(a) === '[object Array]';
// 6.Array.isArray
Array.isArray(a); // true
```

以上，除了 Object.prototype.toString 外，其它方法都不能正确判断变量的类型。虽然 Array 继承自 Object，也会有 toString 方法，但是这个方法有可能会被改写而达不到我们的要求，而 Object.prototype 则是老虎的屁股，很少有人敢去碰它的，所以能一定程度保证其“纯洁性”：)😝

- 由于每个 iframe 都有一套自己的执行环境，跨 iframe 实例化的对象彼此是不共享原型链的，因此导致检测代码失效。

举个 🌰

```js
var iframe = document.createElement("iframe"); //创建iframe
document.body.appendChild(iframe); //添加到body中
xArray = window.frames[window.frames.length - 1].Array;
var arr = new xArray(1, 2, 3); // 声明数组[1,2,3]
alert(arr instanceof Array); // false
alert(arr.constructor === Array); // false
```

- 最佳写法

```JS
var arr = [1,2,3,1];
var arr2 = [{ abac : 1, abc : 2 }];
function isArrayFn(value){
if (typeof Array.isArray === "function") {
return Array.isArray(value);
}else{
return Object.prototype.toString.call(value) === "[object Array]";
}
}
console.log(isArrayFn(arr));// true
console.log(isArrayFn(arr2));// true
```

## 优化

- 按需加载（当用户触发了动作时才加载对应的功能）路由
- 业务代码拆分
- 第三方库提取 vendor

- 降低请求量：压缩文件图片，合并文件 减少 http 请求、minify/gzip 压缩，webP，lazyload
- 网络图、字体图标(雪碧图)
- 缓存：HTTP 协议缓存请求，离线缓存 manifest
- 加快请求速度：预解析 DNS，减少域名数，并行加载，上 cdn 分发
- 渲染：js、css 优化，加载顺序，服务端渲染，pipeline

## 行内、块级、空元素

- 行内元素：a、b、span、img、input、strong、select、label、em、button、textarea
- 块级元素：div、ul、li、dl、dt、dd、p、h1-h6、blockquote
- 常见空元素：即没有内容的 HTML 元素，例如：br、meta、hr、link、input、img
- 不常见空元素：area、base、col、command、embed、keygen、param、source、track、wbr

宽高和 margin 可以设置 auto。对于块级元素来说，宽度设置为 auto，则会尽可能的宽；高度设置为 auto，则会尽可能的窄 注意： 如果没有显式声明包含块的 height，则元素的百分数高度会重置为 auto
注意： 不管是上下 padding 还是左右 padding，当我们使用百分比设置的时候，都是基于 width 的。
注意： margin 通过百分比设置的时候同样是基于宽度的。

## px、em、rem 的区别

px 和 em 都是长度单位,px 的只是固定的,em 的值是相对的继承父类元素的字体大小。浏览器的默认字体高位 16px。1em=16px;
rem 单位基于 html 根元素的字体大小。

- vw/vh(css3) vmin(vw 和 vh 的较小值)/vmax(vw 和 vh 的较大值)和百分比的区别

| 单位  | 含义                                                                         |
| :---- | :--------------------------------------------------------------------------- |
| %     | 大部分相对于祖先元素，也有相对于自身的情况比如（border-radius、translate 等) |
| vm/vh | 相对于视窗的尺寸                                                             |

## 路由权限管理

- route render 方法里进行判断 redirect or return null
- 组件内部判断
- 高阶组件
- dva 监听 url subscription

## node 中的事件循环是什么样子的?

- event loop 其实就是一个事件队列，先加入先执行，执行完一次队列，再次循环遍历看有没有新事件加入队列．执行中的叫 IO events, setImmediate 是在当前队列立即执行,setTimout/setInterval 是把执行定时到下一个队列，process.nextTick 是在当前执行完，下次遍历前执行．所以总体顺序是: IO events >> setImmediate >> setTimeout/setInterval >> process.nextTick

## 清空数组

- 直接赋值空数组
- splice(0,数组 length)清空
- 设置数组 length=0

## 判断数组中出现次数最多的元素

1. 临时对象数组，原数组 sort 排序，判断前后位是否相等。临时对象数组排序

```javascript
function f(arr) {
  var temp = []; //对象数组
  var i;
  temp[0] = { value: arr[0], index: 1 }; //保存数组元素出现的次数和值
  arr.sort();
  for (i = 1; i < arr.length; i++) {
    if (arr[i] == arr[i - 1]) {
      temp[temp.length - 1].index++;
    } else {
      //不相同则新增一个对象元素
      temp.push({ index: 1, value: arr[i] });
    }
  }
  temp.sort(function (a, b) {
    //按照出现次数从大到小排列
    return b.index - a.index;
  });
  var max = temp[0].index;
  var maxV = temp[0].value;
  var second = temp[1].index;
  var secondV = temp[1].value;

  return { max, maxV, second, secondV };
}
var arr = [2, 2, 3, 4, 5, 100, 100, , 3, 1, 4, 4, 100, 100];
var { max, maxV, second, secondV } = f(arr);
console.log(max, maxV, second, secondV); // 4 100 3 4
```

2. 临时对象 判断属性名存不存在 2 次遍历

```javascript
var arr = [1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 4, 4];
var obj = {};
for (var i = 0; i < arr.length; i++) {
  if (!obj[arr[i]]) {
    obj[arr[i]] = 1;
  } else {
    obj[arr[i]]++;
  }
}
/*
        此时的obj对象包含了所有元素出现次数的信息
        然后再遍历obj对象就可以查询出出现次数最多/最少的元素了
    */
var maxNum = 0;
var minNum = obj[arr[0]]; //先随意给最少的变量赋值（但保证是数组中的元素出现的次数）
var maxEleArr = [],
  minEleArr = [];
//第一次遍历找出出现次数最多和最少的值
for (var key in obj) {
  if (obj[key] > maxNum) {
    maxNum = obj[key];
  }
  if (obj[key] < maxNum) {
    minNum = obj[key];
  }
}
//第二次遍历找出所有出现次数最多和最少的元素
for (var key in obj) {
  if (obj[key] == maxNum) {
    maxEleArr.push(key);
  }
  if (obj[key] == minNum) {
    minEleArr.push(key);
  }
}
console.log(maxEleArr + ":" + maxNum); // 2:5
console.log(minEleArr + ":" + minNum); // 1,4:2
```

3. reduce 简写

```js
var arr = "abcdaabc";

var info = arr.split("").reduce((p, k) => (p[k]++ || (p[k] = 1), p), {});

console.log(info); //{ a: 3, b: 2, c: 2, d: 1 }
```

4. 临时对象简写

```js
const map = {};
const str = "hello world";

str.split("").forEach((key) => {
  map[key] = -~map[key];
});

console.log(map);
// {" ": 1, d: 1, e: 1, h: 1, l: 3, o: 2, r: 1, w: 1}
// ~i = -(i + 1)，~undefined = -1
```

## 清除浮动

**浮动元素的影响**

- 浮动元素宽度默认为内容的宽度
- 向指定的浮动方向一直移动
- 对它之前的 block 没有影响
- 会掩盖后面的 block 元素，但是不会遮盖其中的文本和内联元素

**多个浮动元素**

- 多个浮动元素不会相互重叠
- 浮动元素按照在父元素中的书写顺序，从上至下排布
- 当同一行有空间的时候，不管左浮动还是右浮动，都优先在同一行排列
- 当同一行没有空间，后续浮动元素会从上至下寻找空间
- 浮动元素的上下左右 margin 不会发生重叠合并

清除浮动是为了清除浮动元素产生的影响。浮动元素的高度会发生坍塌，使页面后面的布局不能正常显示。
设置成浮动后，display 值会自动变成 block。

> 浮动会引起高度塌陷和文字环绕。

1. 使用空标签清除浮动 clear: both （增加了无意义的标签）
2. 使用 overflow: auto/hidden （使用 zoom: 1 兼容 IE）
   zoom:1 的清除浮动原理?
   清除浮动，触发 hasLayout；
   Zoom 属性是 IE 浏览器的专有属性，它可以设置或检索对象的缩放比例。解决 ie 下比较奇葩的 bug。
   譬如外边距（margin）的重叠，浮动清除，触发 ie 的 hasLayout 属性等。

来龙去脉大概如下：
当设置了 zoom 的值之后，所设置的元素就会就会扩大或者缩小，高度宽度就会重新计算了，这里一旦改变 zoom 值时其实也会发生重新渲染，运用这个原理，也就解决了 ie 下子元素浮动时候父元素不随着自动扩大的问题。

3. 给浮动元素的容器也添加浮动(创建父级 BFC)
4. 给浮动元素后面的元素添加 clear 属性
5. 使用 after 伪元素清除浮动（用于非 IE 浏览器）

```css
.clear {
    overflow: auto;
    zoom: 1;
}

.clear::after {
    display: block;
    content: '清除浮动',
    height: 0;
    clear: both;
}

.clearfix::before, .clearfix::after {
    content: " ";
    display: table;
}
```

发现：除了 clear：both 用来闭合浮动的，其他代码无非都是为了隐藏掉 content 生成的内容，这也就是其他版本的闭合浮动为什么会有 font-size：0，line-height：0。

## margin-top 和 padding-left 根据 height 还是 width？

width

## vue 的非父子组件传递

1. vuex 2. 在同一个 vue 实例上调用$emit和$on

## 原生 js 实现拖拽

```html
<div id="div1" ondrop="drop(event)" ondragover="allowDrop(event)"></div>
<img
  id="img1"
  draggable="true"
  ondragstart="drag(event)"
  src="http://dir.mydearest.cn/static/img/avatar.jpg"
/>
<script>
  function allowDrop(ev) {
    ev.preventDefault();
  }

  function drag(ev) {
    ev.dataTransfer.setData("Text", ev.target.id);
  }

  function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("Text");
    ev.target.appendChild(document.getElementById(data));
  }
</script>
```

[拖拽](https://cosyer.github.io/jelly/drag/)

## 实现函数监听函数发布订阅模式 on emit off 方法 类似 iflux

```js
function event() {
  this.elem = document.createElement("div");
}
event.prototype.on = function (name, fn) {
  this.e = new Event(name);
  this.elem.addEventListener(name, fn.call(this, this.e, this.e.type));
};
event.prototype.emit = function (name) {
  this.elem.dispatchEvent(this.e); // 这里接受的参数必须是Event类型的，不然报错
};
event.prototype.off = function (name, fn) {
  this.e = null;
};
var ee = new event();
ee.on("foo", function () {
  console.log(110);
});
ee.emit("foo"); // 110
```

## 左边固定，右边自适应布局

1. float
2. flex 布局
3. 通过 position 父级 relative

## mysql 字符转换

```sql
-- date转字符串
select date_format(now(), '%Y-%m-%d');
--  date转时间戳
select unix_timestamp(now())
--  字符串转时间
select str_to_date("2019-01-15",'%Y-%m-%d %H')
-- 20190115
-- 时间戳转时间
select from_unixtime(1451997924)
-- 时间戳转字符串
select from_unixtime(1451997924,"%Y-%m-%d %H")
```

## empty()和 html("")

推荐使用 empty html 不会清除子组件的事件

## react、vue 多个 class

### react

方法一：ES6 模板字符串 ``

className={title ${index === this.state.active ? 'active' : ''}}

方法二：join("")

className={["title", index === this.state.active?"active":null].join(' ')}

方法三：classnames

### vue

方法一：
:class="[box,shadow]"
方法二：
:class="{box:show1,shadow:show2}"

## vue 组件通信

```
// 父传子
// 父组件
<note-address :data="msg"></note-address>

// 子组件

<div>{{ data.partment }}</div>

export default {
  //props:['data']
  props: {
    data: Object
  }
}
// 子传父
// 父组件
<note-address @new="addNote"></note-address>

// 子组件
<button type="small" class="confirm" @click="add">设为教案</button>

methods: {
 add () {
  this.$emit('new', false)
 }
}
// 兄弟相传
// 1.创建 公共bus.js

//bus.js
import Vue from 'vue'
export default new Vue()

// 2.父组件注册两个子组件
components:{
    firstChild,
    secondChild
}

// 3.firstChild组件

<input type="button" value="点击触发" @click="elementByValue">

<script>
// 引入公共的bus，来做为中间传达的工具
  import Bus from './bus.js'
  export default {
      methods: {
      elementByValue: function () {
        Bus.$emit('val', '兄弟，收到了吗？')
      }
    }
  }
</script>

// 4.secondChild组件

<span>{{msg}}</span>

<script>
  import Bus from './bus.js'
  export default {
      mounted(){
            let self = this;
            Bus.$on('val', function (msg) {
                console.log(msg)
                self.msg = msg
            })
      }
    }
  }
</script>
```

## OSI 七层协议

TCP 传输控制协议(Transmission Control Protocol)
IP 网际协议(Internet Protocol)
![tcp](http://cdn.mydearest.cn/blog/images/tcp.png)

> TCP/IP 五层协议 物理层--数据链路层--网络层--传输层--应用层

- 应用层(为应用程序提供服务)
- 表示层(数据格式转化、数据加密)
- 会话层(建立、管理和维护会话)
- 传输层(建立、管理和维护端到端的连接)
- 网络层(IP 地址及路由选择)
- 数据链路层(提供介质访问和链路管理)
- 物理层(物理层)

- 应用层（HTTP，FTP，NFS，SMTP）
  与其它计算机进行通讯的一个应用，它是对应应用程序的通信服务的。例如，一个没有通信功能的字处理程序就不能执行通信的代码，从事字处理工作的程序员也不关心 OSI 的第 7 层。但是，如果添加了一个传输文件的选项，那么字处理器的程序员就需要实现 OSI 的第 7 层。示例：TELNET，HTTP，FTP，NFS，SMTP 等。

- 表示层
  这一层的主要功能是定义数据格式及加密。例如，FTP 允许你选择以二进制或 ASCII 格式传输。如果选择二进制，那么发送方和接收方不改变文件的内容。如果选择 ASCII 格式，发送方将把文本从发送方的字符集转换成标准的 ASCII 后发送数据。在接收方将标准的 ASCII 转换成接收方计算机的字符集。示例：加密，ASCII 等。

- 传输层（TCP，UDP，SPX）
  这层的功能包括是否选择差错恢复协议还是无差错恢复协议，及在同一主机上对不同应用的数据流的输入进行复用，还包括对收到的顺序不对的数据包的重新排序功能。示例：TCP，UDP，SPX。

- 会话层（RPC，SQL）
  它定义了如何开始、控制和结束一个会话，包括对多个双向消息的控制和管理，以便在只完成连续消息的一部分时可以通知应用，从而使表示层看到的数据是连续的，在某些情况下，如果表示层收到了所有的数据，则用数据代表表示层。示例：RPC，SQL 等

- 网络层（IP，IPX）
  这层对端到端的包传输进行定义，它定义了能够标识所有结点的逻辑地址，还定义了路由实现的方式和学习的方式。为了适应最大传输单元长度小于包长度的传输介质，网络层还定义了如何将一个包分解成更小的包的分段方法。示例：IP，IPX 等。

- 数据链路层（IP，IPX）
  它定义了在单个链路上如何传输数据。这些协议与被讨论的各种介质有关。示例：ATM，FDDI 等。

- 物理层（Rj45，802.3）
  OSI 的物理层规范是有关传输介质的特这些规范通常也参考了其他组织制定的标准。连接头、帧、帧的使用、电流、编码及光调制等都属于各种物理层规范中的内容。物理层常用多个规范完成对所有细节的定义。示例：Rj45，802.3 等。

## call 使用

```js
function add(a, b) {
  console.log(a + b);
}

function sub(a, b) {
  console.log(a - b);
}

add.call(sub, 3, 1); // 4
```

## css 选择器的优先级

选择器：id 选择器，class 选择器，标签选择器，伪元素选择器，伪类选择器等等

同一元素引用多个样式时，排在后面的样式属性的优先级高

样式选择器的类型不同时。优先级顺序为：id>class>标签

标签之间存在层级包含关系时，后代元素会继承祖先元素的样式，如果后代元素定义了与祖先元素相同的样式，则祖先元素的相同的样式会被覆盖。继承的样式优先级较低，至少比标签选择器低。

带有！important 标记的样式属性优先级最高

样式表来源不同时优先级顺序为：内联>内部>外部>浏览器用户自定义的样式>浏览器默认样式

## 事件队列（eventLoop）

```js
// 以下是头条的类似题目，这个考得更全面
async function a1() {
  console.log("a1 start");
  await a2();
  console.log("a1 end");
}
async function a2() {
  console.log("a2");
}
console.log("script start");
setTimeout(() => {
  console.log("setTimeout");
}, 0);
Promise.resolve().then(() => {
  console.log("promise1");
});
a1();
let promise2 = new Promise((resolve) => {
  resolve("promise2.then");
  console.log("promise2");
});
promise2.then((res) => {
  console.log(res);
  Promise.resolve().then(() => {
    console.log("promise3");
  });
});
console.log("script end");

// script start
// a1 start
// a2
// promise2
// script end
// promise1
// a1 end
// promise2.then
// promise3
// setTimeout
```

## vue 中 watch 和 computed 的区别

- computed，计算属性，随着依赖的数据响应式地改变，用于复杂逻辑处理

- watch，命令式地监听数据变化进行操作

## 简单介绍 es6

ES6 在变量的声明和定义方面增加了 let、const 声明变量，有局部变量的概念，赋值中有比较吸引人的结构赋值，同时 ES6 对字符串、 数组、正则、对象、函数等拓展了一些方法，如字符串方面的模板字符串、函数方面的默认参数、对象方面属性的简洁表达方式，ES6 也 引入了新的数据类型 symbol，新的数据结构 set 和 map,symbol 可以通过 typeof 检测出来，为解决异步回调问题，引入了 promise 和 generator，还有最为吸引人了实现 Class 和模块，通过 Class 可以更好的面向对象编程，使用模块加载方便模块化编程，当然考虑到 浏览器兼容性，我们在实际开发中需要使用 babel 进行编译。

## js 模块化

在 ES6 出现之前，js 没有标准的模块化概念，这也就造成了 js 多人写作开发容易造成全局污染的情况，以前我们可能会采用立即执行函数、对象等方式来尽量减少变量这种情况，后面社区为了解决这个问题陆续提出了 AMD 规范和 CMD 规范，这里不同于 Node.js 的 CommonJS 的原因在于服务端所有的模块都是存在于硬盘中的，加载和读取几乎是不需要时间的，而浏览器端因为加载速度取决于网速， 因此需要采用异步加载，AMD 规范中使用 define 来定义一个模块，使用 require 方法来加载一个模块，现在 ES6 也推出了标准的模块加载方案，通过 export 和 import 来导出和导入模块。

## 模块化的理解

一个模块是实现一个特定功能的一组方法。在最开始的时候，js 只实现一些简单的功能，所以并没有模块的概念，但随着程序越来越复杂，代码的模块化开发变得越来
越重要。

由于函数具有独立作用域的特点，最原始的写法是使用函数来作为模块，几个函数作为一个模块，但是这种方式容易造成全局变量的污染，并且模块间没有联系。

后面提出了对象写法，通过将函数作为一个对象的方法来实现，这样解决了直接使用函数作为模块的一些缺点，但是这种办法会暴露所有的所有的模块成员，外部代码可
以修改内部属性的值。

现在最常用的是立即执行函数的写法，通过利用闭包来实现模块私有作用域的建立，同时不会对全局作用域造成污染。

## 图片加载成功或者失败

onload/onerror

## 递归和迭代的区别

程序调用自身称为递归(从前有座山，山里有座庙，庙里有个老和尚在和小和尚讲故事，故事讲的是)，利用变量的原值推出新值称为迭代，递归的优点 大问题转化为小问题，可以减少代码量，同时应为代码精简，可读性好， 缺点就是，递归调用浪费了空间，而且递归太深容易造成堆栈的溢出。迭代的好处 就是代码运行效率好，因为时间只因循环次数增加而增加，而且没有额外的空间开销， 缺点就是代码不如递归简洁

## 原生 JS 操作 DOM 的方法有哪些？

获取节点的方法 getElementById、getElementsByClassName、getElementsByTagName、 getElementsByName、querySelector、querySelectorAll,对元素属性进行操作的 getAttribute、 setAttribute、removeAttribute 方法，对节点进行增删改的 appendChild、insertBefore、replaceChild、removeChild、 createElement 等

## setTimeout 和 setInterval 的区别，包含内存方面的分析？

setTimeout 表示间隔一段时间之后执行一次调用，而 setInterval 则是每间隔一段时间循环调用，直至 clearInterval 结束。 内存方面，setTimeout 只需要进入一次队列，不会造成内存溢出，setInterval 因为不计算代码执行时间，有可能同时执行多次代码， 导致内存溢出。

## addEventListener 有哪些参数？

有三个参数，第一个是事件的类型，第二个是事件的回调函数，第三个是一个表示事件是冒泡阶段还是捕获阶段捕获的布尔值，true 表示捕获，false 表示冒泡

## 将静态资源放在其他域名的目的是什么？

这样做的主要目的是在请求这些静态资源的时候不会发送 cookie，节省了流量，需要注意的是 cookie 是会发送给子域名的（二级域名），所以这些静态资源是不会放在子域名下的， 而是单独放在一个单独的主域名下。同时还有一个原因就是浏览器对于一个域名会有请求数的限制，这种方法可以方便做 CDN。

## http 状态码 301 和 302 的区别

- 301 redirect: 301 代表永久性转移(Permanently Moved)

如何避免 301 跳转 https(在 response 中 header)

- 302 redirect: 302 代表暂时性转移(Temporarily Moved)

详细来说，301 和 302 状态码都表示重定向，就是说浏览器在拿到服务器返回的这个状态码后会自动跳转到一个新的 URL 地址，这个地址可以从响应的 Location 首部中获取（用户看到的效果就是他输入的地址 A 瞬间变成了另一个地址 B）——这是它们的共同点。他们的不同在于。301 表示旧地址 A 的资源已经被永久地移除了（这个资源不可访问了），搜索引擎在抓取新内容的同时也将旧的网址交换为重定向之后的网址；302 表示旧地址 A 的资源还在（仍然可以访问），这个重定向只是临时地从旧地址 A 跳转到地址 B，搜索引擎会抓取新的内容而保存旧的网址。

[重定向](http://cdn.mydearest.cn/blog/images/redirectCache.png)

## 在什么情况下 a === a-1 ?

- Infinity/-Infinity

```js
let a = Infinity;

console.log(a === a - 1); // true

let b = -Infinity;

console.log(b === b - 1); // true

console.log(Infinity + Infinity); // Infinity
console.log(Infinity - Infinity); // NaN
console.log(Infinity * Infinity); // Infinity
console.log(Infinity / Infinity); // NaN
console.log(Infinity * 0); // NaN
```

- 安全数(-2 ** 53 + 1 到 2 ** 53 - 1) 即 Number.MAX_SAFE_INTEGER 和 Number.MIN_SAFE_INTEGER 处理特殊情况

```js
let a = Number.MIN_SAFE_INTEGER - 1;
console.log(a === a - 1); // true
```

- a == a -1

```js
var x = 1;
var a = { x, valueOf: () => a.x };
Object.defineProperty(a, "x", {
  get() {
    return --x;
  },
});

var set = 1;
Object.defineProperty(window, "a", {
  get: function () {
    return set++;
  },
  enumerable: true,
  configurable: true,
});

const a = {
  times: 0,

  valueOf() {
    if (this.times & 1) {
      return 0;
    }
    this.times += 1;
    return 1;
  },
};
```

## placeholder 样式设置

```css
::-webkit-input-placeholder {
} /* 使用webkit内核的浏览器 */
:-moz-placeholder {
} /* Firefox版本4-18 */
::-moz-placeholder {
} /* Firefox版本19+ */
:-ms-input-placeholder {
} /* IE浏览器 */
```

## 巧用 currentColor 自定义 checkbox 样式

```css
/* 无法自定义checkbox样式 */
input[type="checkbox"] {
  background-color: red;
  color: red;
  border: solid red;
}
```

```css
input[type="checkbox"] {
  position: relative;
  color: inherit;
}

input[type="checkbox"]::before,
input[type="checkbox"]::after {
  position: absolute;
  display: inline-block;
  width: 12px;
  height: 12px;
  line-height: 12px;
  border-radius: 3px;
  text-align: center;
}

input[type="checkbox"]:checked::after {
  content: "x";
  color: white;
}

input[type="checkbox"]::before {
  content: " ";
  /* 表示将背景色设置为当前的文字颜色值。 */
  background-color: currentColor;
}
```

## 增补字符不适用 String.prototype.charCodeAt 和 String.fromCharCode

```js
"🀄".length; // 2

const str = "🀄";
console.log(str.codePointAt(0)); // 126980

console.log(String.fromCodePoint(126980)); // 🀄

console.log([..."👨‍👩‍👧‍👦"]);
// ["👨", "‍", "👩", "‍", "👦", "‍", "👦"]
```

## 三次握手、四次挥手

- 建立连接-TCP 的三次握手

(1) 主机向服务器发送一个建立连接的请求

(2) 服务器接到请求后发送同意连接的信号

(3) 主机接到同意连接的信号后，再次向服务器发送了确认信号

发送端首先发送一个带 SYN 标志的数据包给对方。接收端收到后，回传一个带有 SYN/ACK 标志的数据包以示传达确认信息。最后，发送端再回传一个带 ACK 标志的数据包，代表“握手”结束。若在握手过程中某个阶段莫名中断，TCP 协议会再次以相同的顺序发送相同的数据包。

- 断开连接-TCP 的四次挥手
  (1) 主机向服务器发送一个断开连接的请求

(2) 服务器接到请求后发送确认收到请求的信号；(此时服务器可能还有数据要发送至主机)

(3) 服务器向主机发送断开通知；(此时服务器确认没有要向主机发送的数据)

(4) 主机接到断开通知后断开连接并反馈一个确认信号，服务器收到确认信号后断开连接

> 注意：这里的四次挥手中服务器两次向主机发送消息，第一次是回复主机已收到断开的请求，第二次是向主机确认是否断开，确保数据传输完毕。

## 幂等性

其任意多次执行对资源本身所产生的影响均与一次执行的影响相同。

## src 和 href 的区别(引入和引用)

- src  指的是 source ，属性中可以设置 src  的标签多为替换标签，用于将资源加载后替换该标签的内容， src  加载的资源是会阻塞 DOM 解析的。

- href  指的是 hypertext reference ，属性中可以设置 href  的标签多为引用或链接标签，用于引用互联网上的其他资源或设置锚点， href  引用的资源不会阻塞 DOM 解析，而是会并行加载。

## a.b.c.d 和 a['b']['c']['d']，哪个性能更高？

```js
var obj = {
  a: {
    b: {
      c: {
        d: 1,
      },
    },
  },
};
console.time();
console.log(obj.a.b.c.d);
console.timeEnd();
// console.time()
// console.log(obj["a"]["b"]["c"]["d"])
// console.timeEnd()
// default:1.100ms 0.964ms
```

## 对象引用

```js
var a = { n: 1 };
var b = a;
a.x = a = { n: 2 };

console.log(a.x);
console.log(b.x);
// undefined
// {n:2}
```

首先，a 和 b 同时引用了{n:1}对象，接着执行到 a.x = a = {n：2}语句，尽管赋值是从右到左的没错，但是.的优先级比=要高，所以这里首先执行 a.x，相当于为 a（或者 b）所指向的{n:1}对象新增了一个属性 x，即此时对象将变为{n:1;x:undefined}。之后按正常情况，从右到左进行赋值，此时执行 a ={n:2}的时候，a 的引用改变，指向了新对象{n：2},而 b 依然指向的是旧对象。之后执行 a.x = {n：2}的时候，并不会重新解析一遍 a，而是沿用最初解析 a.x 时候的 a，也即旧对象，故此时旧对象的 x 的值为{n：2}，旧对象为 {n:1;x:{n：2}}，它被 b 引用着。
后面输出 a.x 的时候，又要解析 a 了，此时的 a 是指向新对象的 a，而这个新对象是没有 x 属性的，故访问时输出 undefined；而访问 b.x 的时候，将输出旧对象的 x 的值，即{n:2}。

## Doctype 作用？标准模式与兼容模式各有什么区别?

1. <!DOCTYPE>声明位于HTML文档中的第一行，处于 <html> 标签之前。告知浏览器的解析器用什么文档标准解析这个文档。DOCTYPE不存在或格式不正确会导致文档以兼容模式呈现。

2. 标准模式的排版 和 JS 运作模式都是以该浏览器支持的最高标准运行。在兼容模式中，页面以宽松的向后兼容的方式显示,模拟老式浏览器的行为以防止站点无法工作。

3. 有两种模式：严格模式：以该浏览器支持的最高标准运行 混杂模式：向后兼容，模拟老浏览器，防止浏览器无法兼容页面。

## HTML5 为什么只需要写 <!DOCTYPE HTML>？

- HTML5 不基于 SGML，因此不需要对 DTD(文档类型定义)进行引用，但是需要 doctype 来规范浏览器的行为（让浏览器按照它们应该的方式来运行）；

- 而 HTML4.01 基于 SGML,所以需要对 DTD 进行引用，才能告知浏览器文档所使用的文档类型。

- 新增语义化标签

```html
<header>
  、
  <footer>
    、
    <section>
      、
      <article>
        、
        <nav>
          、
          <hgroup>
            、
            <aside>
              、
              <figure></figure>
            </aside>
          </hgroup>
        </nav>
      </article>
    </section>
  </footer>
</header>
```

- 删除的标签

```html
<big
  >、<u
    >、<font
      >、<basefont>
        、
        <center>
          、<s>、<tt></tt></s>
        </center></basefont></font></u
></big>
```

- 多媒体

```html
<audio>、<video></video></audio>
```

```html
<!-- 只写属性名默认为true -->
<input type="checkbox" checked />
<!-- 属性名="属性名"也为true -->
<input type="checkbox" checked="checked" />
```

## 对浏览器内核的理解？

主要分成两部分：渲染引擎(layout engineer 或 Rendering Engine)和 JS 引擎。
渲染引擎：负责取得网页的内容（HTML、XML、图像等等）、整理讯息（例如加入 CSS 等），以及计算网页的显示方式，然后会输出至显示器或打印机。浏览器的内核的不同对于网页的语法解释会有不同，所以渲染的效果也不相同。所有网页浏览器、电子邮件客户端以及其它需要编辑、显示网络内容的应用程序都需要内核。

JS 引擎：解析和执行 javascript 来实现网页的动态效果。

最开始渲染引擎和 JS 引擎并没有区分的很明确，后来 JS 引擎越来越独立，内核就倾向于只指渲染引擎。

## html5 新特性？

- HTML5 现在已经不是 SGML 的子集，主要是关于图像，位置，存储，多任务等功能的增加。

### 绘画 canvas;

### 用于媒介回放的 video 和 audio 元素;

### 本地离线存储 localStorage 长期存储数据，浏览器关闭后数据不丢失;sessionStorage 的数据在浏览器关闭后自动删除;

### 语义化更好的内容元素，比如 article、footer、header、nav、section;

表单控件，calendar、date、time、email、url、search;
新的技术 webworker, websocket, Geolocation;

- 移除的元素：
  纯表现的元素：basefont，big，center，font, s，strike，tt，u;
  对可用性产生负面影响的元素：frame，frameset，noframes；

- 支持 HTML5 新标签：
  IE8/IE7/IE6 支持通过 document.createElement 方法产生的标签，
  可以利用这一特性让这些浏览器支持 HTML5 新标签，
  浏览器支持新标签后，还需要添加标签默认的样式。
  当然也可以直接使用成熟的框架、比如 html5shim;

```js
<!--[if lt IE 9]>
<script> src="http://html5shim.googlecode.com/svn/trunk/html5.js"</script>
<![endif]-->
```

- 如何区分 HTML5： DOCTYPE 声明新增的结构元素功能元素
  语义化标签：header,footer,nav,aside,section 增强表单：为 input 增加了 color,email,data,range 等类型 存储：sessionStorage，localStorage，离线存储 多媒体：audio，vedio canvas 拖放 地理定位 webworker websocket

## 对 HTML 语义化的理解？

用正确的标签做正确的事情。
html 语义化让页面的内容结构化，结构更清晰，便于对浏览器、搜索引擎解析;
即使在没有样式 CSS 情况下也以一种文档格式显示，并且是容易阅读的;
搜索引擎的爬虫也依赖于 HTML 标记来确定上下文和各个关键字的权重，利于 SEO;
使阅读源代码的人对网站更容易将网站分块，便于阅读维护理解。

## iframe 缺点

- iframe 会阻塞主页面的 Onload 事件；
- 搜索引擎的检索程序无法解读这种页面，不利于 SEO;
- iframe 和主页面共享连接池，而浏览器对相同域的连接有限制，所以会影响页面的并行加载。

使用 iframe 之前需要考虑这两个缺点。如果需要使用 iframe，最好是通过 javascript 动态给 iframe 添加 src 属性值。

## 多个标签页通信

1. 使用 WebSocket，通信的标签页连接同一个服务器，发送消息到服务器后，服务器推送消息给所有连接的客户端。
2. 使用 SharedWorker （只在 chrome 浏览器实现了），两个页面共享同一个线程，通过向线程发送数据和接收数据来实现标签页之间的双向通行。
3. 也可以调用 localstorge、cookies 等本地存储方式；localstorge 另一个浏览上下文里被添加、修改或删除时，它都会触发一个 storage 事件，我们通过监
   听 storage 事件，控制它的值来进行页面信息通信。
4. 获取对应标签页的引用，通过 postMessage 方法也是可以实现多个标签页通信的。

## CSS 的盒子模型 border-sizing (border-box)

（1）有两种， IE 盒子模型、W3C 盒子模型；
（2）盒模型： 内容(content)、填充(padding)、边界(margin)、 边框(border)；
（3）区 别： IE 的 content 部分把 border 和 padding 计算了进去;

- W3C 标准盒模型(content-box)：
  ![w3c](http://cdn.mydearest.cn/blog/images/w3c-box.jpg)

- IE 盒模型(border-box)：
  ![ie](http://cdn.mydearest.cn/blog/images/ie-box.jpg)

在 IE 盒模型中，盒子宽高不仅包含了元素的宽高，而且包含了元素的边框以及内边距。

所以在同样的设置下，IE 下的元素会看起来相对于标准盒子来的小。

## CSS 选择器有哪些？哪些属性可以继承？(4+4+2+1)11 种

**4 个属于简单选择器\_**

### id 选择器（#myid）

### 类选择器（.myclassname）

### 标签选择器（div, h1, p）

### 通配符选择器（\*）

**4 个属于组合选择器**
组合选择器是通过多个简单选择器进行组合

### 相邻选择器（h1 + p）

### 同级元素选择器：A~B，作用于 A 后面的所有同级的 B

### 子选择器（ul > li）

### 后代选择器（li a）

### 伪类选择器（a:hover, li:nth-child）

| 常见的伪类选择器   | 功能                                                     |
| :----------------- | :------------------------------------------------------- |
| :hover             | 鼠标移入元素上方                                         |
| :focus             | 元素获得焦点                                             |
| :checked           | 选中的表单元素                                           |
| :empty             | 没有任何子元素的元素                                     |
| :optional          | 表单元素中可以为空的元素                                 |
| :read-only         | 只读属性的元素                                           |
| :read-write        | 没有只读属性的元素                                       |
| :required          | 选择表单必填项的元素                                     |
| :valid             | 选择所有有效值的元素                                     |
| :target            | 当前活动元素                                             |
| :root              | 匹配到文档根元素                                         |
| :enabled           | 匹配到页面上可用状态的元素                               |
| :disabled          | 匹配到不可用的元素                                       |
| :first-child       | 匹配到一个作为第一个子元素的元素                         |
| :last-child        | 匹配到一个作为最后一个子元素的元素                       |
| :nth-child(n)      | 匹配父元素的第 n 个子元素（允许食用乘法因子 n 作为换算） |
| :nth-last-child(n) | 匹配父元素的倒数第 n 个子元素                            |
| :link              | 没有访问过的链接                                         |
| :visited           | 访问过的链接                                             |

### 伪元素选择器（::after）

定义： 伪元素建立了对超出文档语言指定的文档树的抽象。
|伪元素选择器|功能|
|:--|:--|
|::first-letter|选择元素的第一个字母|
|::first-line|选择元素的第一行|
|::before|在元素之前插入内容并定制样式|
|::after|在元素之后插入内容并定制样式|
|::selection|被用户选中的内容|

### 属性选择器（a[rel = "external"]）

```css
/* 第一种 [attr] */
[disabled] {
  background-color: #ccc;
}
/* 第二种 [attr=val] */
[type="button"] {
  background-color: #ccc;
}
/* 第三种 [attr~=val] 属性包含val */
[class~="test"] {
  color: red;
}
/* 第四种 [attr^=val] 属性以val开头 */
[class^="demo"] {
  background-color: red;
}
/* 第五种 [attr|=val] 属性以 val- 开头 */
[class|="demo"] {
  background-color: red;
}
/* 第六种 [attr$=val] 属性以 val 结尾 */
[class$="item"] {
  font-weight: bold;
}
```

- 可继承的样式： font-size font-family color, UL LI DL DD DT;

- 不可继承的样式：border padding margin width height ;

## css 优先级算法

内联样式 > ID 选择器 > 伪类选择器=属性选择器=类选择器 > 标签选择器 > 通用选择器 > 继承样式

- 优先级就近原则，同权重情况下样式定义最近者为准;
- 载入样式以最后载入的定位为准;

优先级为:
同权重: 内联样式表（标签内部）> 嵌入样式表（当前文件中）> 外部样式表（外部文件中）。
!important > 行内样式 > id > class > tag > \* > 继承 > 默认
important 比 内联优先级高，选择器从右往左解析

_权值_

```
内联样式 -> 1000
ID属性值 -> 100
类属性值、属性选择或伪类 -> 10
元素或伪元素 -> 1
结合符和通配选择器 -> 0
```

## css3 新增的伪类、伪元素

举例：
p:first-of-type 选择属于其父元素的首个 <p> 元素的每个 <p> 元素。
p:last-of-type 选择属于其父元素的最后 <p> 元素的每个 <p> 元素。
p:only-of-type 选择属于其父元素唯一的 <p> 元素的每个 <p> 元素。
p:only-child 选择属于其父元素的唯一子元素的每个 <p> 元素。
p:nth-child(2) 选择属于其父元素的第二个子元素的每个 <p> 元素。odd 奇数/even 偶数

::after 在元素之前添加内容,也可以用来做清除浮动。
::before 在元素之后添加内容
:enabled  
:disabled 控制表单控件的禁用状态。
:checked 单选框或复选框被选中。

## display 有哪些值？19 种 这里只列举下常见的

block 块类型。默认宽度为父元素宽度，可设置宽高，换行显示。
none 元素不显示，并从文档流中移除。
inline 行内元素类型。默认宽度为内容宽度，不可设置宽高，同行显示。
inline-block 默认宽度为内容宽度，可以设置宽高，同行显示。
list-item 像块类型元素一样显示，并添加样式列表标记。
table 此元素会作为块级表格来显示。
table-cell
inherit 规定应该从父元素继承 display 属性的值。
flex

## position 有哪些值？7 种

- fixed：固定定位。元素的位置相对于浏览器窗口定位，即是窗口是滚动的他也不会移动。fixed 定位使元素的位置与文档流无关，因此不占据空间。fixed 定位的元素和其它元素重叠

- relative：如果对一个元素进行相对定位，它将出现在它所在的位置上，然后可以通过设置垂直或水平位置，让这个元素相对于它的起点移动，在使用相对定位时，无论是否进行移动，元素仍然占据原来的空间，因此，移动元素将导致它覆盖其他框。

- absolute：绝对定位的元素的位置相对于 static 定位以外的第一个父元素进行定位，如果元素没有已定位的父元素，那么他的位置相对于 html。absolute 定位使元素的位置与文档流无关，因此不占据空间，absolute 定位的元素和其它元素重叠

- sticky：粘性定位。元素先按照普通文档流定位，然后相对于该元素在流中的 flow root（BFC）和 containing block（最近的块级祖先元素）定位。而后，元素定位表现为在跨越特定阈值前为相对定位，之后为 fixed 定位

- static：默认定位。也就是没有特殊定位，元素出现在正常的流中，忽略 top，bottom，left 或者 z-index 声明

- inherit：继承定位。规定应该从父元素继承 position 的值

- initial: 设置该属性为默认值，

`float`元素的 display 为 block。

## CSS3 有哪些新特性？

### 新增各种 CSS 选择器（: not(.input)：所有 class 不是“input”的节点）

### 圆角（border-radius:8px）

### 阴影（border-shadow/border-image）

### 多列布局（multi-column layout）

### 反射（Reflect）

-webkit-box-reflect:方向[ above-上 | below-下 | right-右 | left-左 ]，偏移量，遮罩图片

### 文字特效（text-shadow）

### 文字渲染（text-decoration）

### 线性渐变（gradient）

### 过渡（transition）

### 形状转换（transform）

rotate(30deg);   translate(30px,30px);   scale(.8);        skew(10deg,10deg);        rotateX(180deg);     rotateY(180deg);        rotate3d(10,10,10,90deg);

### 动画（animation keyframes）

### 滤镜（filter）

### 弹性布局（flex）

### 栅格布局（grid）

### 媒体查询（media）

## BFC 规范(块级格式化上下文：block formatting context)的理解？

BFC（Block Formatting Context）块级格式化上下文，是 Web 页面中盒模型布局的 CSS 渲染模式，指一个独立的渲染区域或者说是一个隔离的独立容器。

也就是说 BFC 内部的元素和外部的元素不会互相影响。

- 创建规则：

1. 根元素
2. 浮动元素（float 不是 none）
3. 绝对定位元素（position 取值为 absolute 或 fixed）
4. display 取值为 inline-block,table-cell,table-caption,flex,inline-flex 之一的元素
5. overflow 不是 visible 的元素(hidden、auto、scroll)

- 作用特性：

1. 内部的 Box 会在垂直方向上一个接一个的放置
2. 垂直方向上的距离由 margin 决定；（解决外边距重叠问题）
3. bfc 的区域不会与 float 的元素区域重叠；（防止浮动文字环绕）
4. 计算 bfc 的高度时，浮动元素也参与计算；（清除浮动）
5. 内部的元素和外部的元素不会互相影响

## css 权重

> 标签的权重为 1，class 的权重为 10，id 的权重为 100，以下例子是演示各种定义的权重值
> 如果权重相同，则最后定义的样式会起作用，但是应该避免这种情况出现

```css
/*权重为1*/
div {
}
/*权重为10*/
.class1 {
}
/*权重为100*/
#id1 {
}
/*权重为100+1=101*/
#id1 div {
}
/*权重为10+1=11*/
.class1 div {
}
/*权重为10+10+1=21*/
.class1 .class2 div {
}
```

## .gitignore 说明

```shell
.a # 忽略所有 .a 结尾的文件
!lib.a # 但 lib.a 除外
/TODO # 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
build/ # 忽略 build/ 目录下的所有文件
doc/.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
```

规则很简单，不做过多解释，但是有时候在项目开发过程中，突然心血来潮想把某些目录或文件加入忽略规则，按照上述方法定义后发现并未生效，原因是 .gitignore 只能忽略那些原来没有被 track 的文件，如果某些文件已经被纳入了版本管理中，则修改 .gitignore 是无效的。那么解决方法就是先把本地缓存删除（改变成未 track 状态），然后再提交：

```shell
git rm -r --cached .
git add .
git commit -m update .gitignore
```

## 外边距合并

外边距合并指的是，当两个垂直外边距相遇时，它们将形成一个外边距。合并后的外边距的高度等于两个发生合并的外边距的高度中的较大者。
[w3school 介绍网址](https://www.w3school.com.cn/css/css_margin_collapsing.asp)

## 如何优化 css，提高性能？

- 使用关键选择器，过滤掉无关的规则
- 提取项目公共样式，增强可复用性、模块化编写组件
- 预处理器以及构建工具(postcss`后处理器`补充前缀、打包压缩、自动优雅降级)

## margin 和 padding 分别适合什么场景使用？

margin 是用来隔开元素与元素的间距；padding 是用来隔开元素与内容的间隔。
margin 用于布局分开元素使元素与元素互不相干；
padding 用于元素与内容之间的间隔，让内容（文字）与（包裹）元素之间有一段

## 如何修改 chrome 记住密码后自动填充表单的黄色背景 ？

```css
input:-webkit-autofill,
textarea:-webkit-autofill,
select:-webkit-autofill {
  background-color: rgb(250, 255, 189); /*#FAFFBD;*/
  background-image: none;
  color: rgb(0, 0, 0);
}
```

## 什么是 Cookie 隔离？

如果静态文件都放在主域名下，那静态文件请求的时候都带有的 cookie 的数据提交给 server 的，非常浪费流量，
所以不如隔离开。

因为 cookie 有域的限制，因此不能跨域提交请求，故使用非主要域名的时候，请求头中就不会带有 cookie 数据，
这样可以降低请求头的大小，降低请求时间，从而达到降低整体请求延时的目的。

同时这种方式不会将 cookie 传入 Web Server，也减少了 Web Server 对 cookie 的处理分析环节，
提高了 webserver 的 http 请求的解析速度。

## ajax 缓存问题

1、在 ajax 发送请求前加上 anyAjaxObj.setRequestHeader("If-Modified-Since","0")。

2、在 ajax 发送请求前加上 anyAjaxObj.setRequestHeader("Cache-Control","no-cache")。

3、在 URL 后面加上一个随机数： "fresh=" + Math.random();。

4、在 URL 后面加上时间戳："nowtime=" + new Date().getTime();。

5、如果是使用 jQuery，直接这样就可以了 $.ajaxSetup({cache:false})。这样页面的所有 ajax 都会执行这条语句就是不需要保存缓存记录。

模块化开发，采用立即执行函数不暴露私有成员。

## jquery.extend 与 jquery.fn.extend 的区别？

- jquery.extend：为 jquery 类添加类方法，可以理解为添加静态方法
- jquery.fn.extend: 源码中 jquery.fn = jquery.prototype，所以对 jquery.fn 的扩展，就是为 jquery 类添加成员函数

> jquery.extend 扩展，需要通过 jquery 类来调用，而 jquery.fn.extend 扩展，所有 jquery 实例都可以直接调用。

## jquery 一个对象绑定多个事件

```js
// 多个事件同一个函数
$("div").on("click mouseover", function () {});

// 多个事件不同函数
$("div").on({
  click: function () {},
  mouseover: function () {},
});
```

## 如何不使用 loop 循环，创建一个长度为 100 的数组，并且每个元素的值等于它的下标？

```js
Array.from(Array(100).keys())

[...Array(100).keys()]
```

接着乱序排序

```js
arr.sort(() => (Math.random() > 0.5 ? -1 : 1));
```

前十个数相加

```js
var [a, b, c, d, e, f, g, h, i, j, ...last] = arr3;
var total = a + b + c + d + e + f + g + h + i + j;
```

```js
const foo = ((x, f = (y = x) => x + y) => {
  let y = f();
  x = y++;
  return [x, y, f(y)];
})(2);
// foo = [4,5,9]
```

## link 与@import 的区别

- link 是 html 方式，@import 是 css 方式，link 功能较多，可以定义 RSS，定义 Rel 等作用，而@import 只能用于加载 css

- link 最大限度支持并行下载，@import 过多嵌套导致串行下载

- link 可以通过 rel="alternate stylesheet"指定候选样式。link 标签可以实现资源加载、DNS 预解析等功能。

- 浏览器对 link 支持早于@import，可以使用@import 对老浏览器隐藏样式，@import 需要 IE5 以上才能使用

- @import 必须在样式规则之前，可以在 css 文件中引用其他文件，link 可以使用 js 动态引入，@import 不行

- 总体来说：link 优于@import

## PNG,GIF,JPG 的区别

- GIF:

8 位像素，256 色
无损压缩
支持简单动画
支持 boolean 透明
适合简单动画

- JPEG：

颜色限于 256
有损压缩
可控制压缩质量
不支持透明
适合照片

- PNG：

有 PNG8 和 truecolor PNG
PNG8 类似 GIF 颜色上限为 256，文件小，支持 alpha 透明度，无动画
适合图标、背景、按钮

## 什么是 FOUC?如何避免

Flash Of Unstyled Content：用户定义样式表加载之前浏览器使用默认样式显示文档，用户样式加载渲染之后再从新显示文档，造成页面闪烁。解决方法：把样式表放到文档的 head

## focus/blur 与 focusin/focusout 的区别和联系

1. focus/blur 不冒泡，focusin/focusout 冒泡
2. focus/blur 兼容性好，focusin/focusout 在除 FireFox 外的浏览器下都保持良好兼容性，如需使用事件托管，可考虑在 FireFox 下使用事件捕获 elem.addEventListener('focus', handler, true)
3. 可获得焦点的元素：

- window
- 链接被点击或键盘操作
- 表单空间被点击或键盘操作
- 设置 tabindex 属性的元素被点击或键盘操作

## == 和 === 有什么区别？

== 一般比较，在比较的时候可以转换数据类型，假定 x == y 表达式：

1. 如果 x 和 y 类型相同，则 js 会换成 === 进行比较；如果 x 为 null, y 为 undefined，则返回 true，顺序调换一样;
2. 如果 x 的类型是 number 或者 boolean, y 的类型是 string，那么返回 x == toNumber(y)，顺序调换一样;
3. 如果 x 是 string、symbol 或 number，而 y 是 object 类型，则返回 x == toPrimitive(y)，顺序调换一样;;

toPrimitive 首先在对象中使用 valueOf 方法，然后使用 toString 方法来获取该对象的原始值剩下的返回 false

=== 严格比较，只要类型不匹配就返回 false;

## 对象到字符串的转换

如果对象有 toString()方法，javascript 调用它。如果返回一个原始值（primitive value 如：string number boolean）,将这个值转换为字符串作为结
果。如果对象没有 toString()方法或者返回值不是原始值，javascript 寻找对象的 valueOf()方法，如果存在就调用它，返回结果是原始值则转为字符串作为结
果否则，javascript 不能从 toString()或者 valueOf()获得一个原始值，此时 throws a TypeError

## 对象到数字的转换

如果对象有 valueOf()方法并且返回元素值，javascript 将返回值转换为数字作为结果
否则，如果对象有 toString()并且返回原始值，javascript 将返回结果转换为数字作为结果
否则，throws a TypeError

## <,>,<=,>=的比较规则

所有比较运算符都支持任意类型，但是比较只支持数字和字符串，所以需要执行必要的转换然后进行比较，转换规则如下:

如果操作数是对象，转换为原始值：如果 valueOf 方法返回原始值，则使用这个值，否则使用 toString 方法的结果，如果转换失败则报错
经过必要的对象到原始值的转换后，如果两个操作数都是字符串，按照字母顺序进行比较（他们的 16 位 unicode 值的大小）
否则，如果有一个操作数不是字符串，将两个操作数转换为数字进行比较

## +运算符工作流程

如果有操作数是对象，转换为原始值
此时如果有一个操作数是字符串，其他的操作数都转换为字符串并执行连接
否则：所有操作数都转换为数字并执行加法

## question

```js
let i = 0;
if (function temp() {}) {
  i += typeof temp;
}
console.log(i);
// '0undefined'
```

- Element.getBoundingClientRect() 方法返回元素的大小及其相对于视口的位置。
  属性将会对值四舍五入取整。如果需要小数值

## 什么是构造函数调用？

使用 new 关键字，被称为“构造函数调用”

## 什么是构造函数？

构造函数 ，是一种特殊的方法。主要用来在创建对象时初始化对象， 即为对象成员变量赋初始值，总与 new 运算符一起使用在创建对象的语句中。

## querySelectorAll 与 getElementsBy 系列的区别

1. querySelectorAll 属于 W3C 中 Selectors API 规范， 而 getElementsBy 系列则属于 W3C DOM 规范。

2. querySelectorAll 方法接受参数是 CSS 选择符，当传入的是不符合 CSS 选择符规范时会抛出异常，而 getElementsBy 系列则接受的参数是单一的 className，tagName 等等。

3. 从返回值角度来看，querySelectorAll 返回的是不变的结点列表，而 getElementsBy 系列返回的是动态的结点列表。

```js
// Demo 1
var ul = document.querySelectorAll("ul")[0],
  lis = ul.querySelectorAll("li");
for (var i = 0; i < lis.length; i++) {
  ul.appendChild(document.createElement("li"));
}

// Demo 2
var ul = document.getElementsByTagName("ul")[0],
  lis = ul.getElementsByTagName("li");
for (var i = 0; i < lis.length; i++) {
  ul.appendChild(document.createElement("li"));
}
```

因为 Demo 2 中的 lis 是一个动态的结点列表， 每一次调用 lis 都会重新对文档进行查询，导致无限循环的问题。

而 Demo 1 中的 lis 是一个静态的结点列表，是一个 li 集合的快照，对文档的任何操作都不会对其产生影响。

- 普遍认为：getElementsBy 系列性能比 querySelectorAll 好

- querySelectorAll 返回值为一个 NodeList，而 getElementsBy 系列返回值为一个 HTMLCollection

## NodeList 与 HTMLCollection 区别?

1. HTMLCollection 是元素集合而 NodeList 是节点集合(即可以包含元素，文本节点，以及注释等等)。

2. node.childNodes，querySelectorAll(虽然是静态的) 返回的是 NodeList，而 node.children 和 node.getElementsByXXX 返回 HTMLCollection。

## 如何判断函数是 new 调用还是普通调用?

- instanceof

```js
function Person() {
  if (this instanceof arguments.callee) {
    console.log("new 调用");
  } else {
    console.log("普通调用");
  }
}
let p1 = new Person(); // new 调用
let p2 = Person(); // 函数调用
```

- 通过 constructor

```js
function Person() {
  if (this.constructor === arguments.callee) {
    console.log("new 调用");
  } else {
    console.log("普通调用");
  }
}
let p1 = new Person(); // new 调用
let p2 = Person(); // 函数调用
```

## fetch 会发送两次请求的原因

fetch 发送 post 请求时总是发送两次，第一次状态码是 204，第二次才会成功。 原因是，用 fetch 发送 post 请求时，第一次发送了一个 options 请求(预检、嗅探请求)，询问服务器是否支持修改的请求头，如果支持，则在第二次发送真正的请求

## webworker

在 html 页面中，如果在执行脚本时，页面的状态是不可响应的，直到脚本执行完成后页面才变为可响应。web worker 是运行在后台的 js，独立于其他脚本，不会影响页面。并且通过 postMessage 将结果回转至主线程。

现代浏览器为 JavaScript 创造的多线程环境。可以新建并将部分任务分配到 worker 线程并行运行，两个线程可独立运行，互不干扰，可通过自带的消息机制相互通信。

```js
// 创建 worker
const worker = new Worker("work.js");

// 向主进程推送消息
worker.postMessage("Hello World");

// 监听主进程来的消息
worker.onmessage = function (event) {
  console.log("Received message " + event.data);
};
```

- 限制
  - 同源限制
  - 无法使用 document / window / alert / confirm
  - 无法加载本地资源

## 一句话概括 RESTFUL

用 url 定位资源，用 http 描述操作
[RESTful API 设计指南](http://www.ruanyifeng.com/blog/2014/05/restful_api.html)
[为什么 RESTful 很糟糕](https://blog.csdn.net/weixin_41423450/article/details/85228482)

## 设备像素比（DPR device pixel redio）

1DPR = 物理像素/分辨率 也就是物理像素在屏幕上最佳的逻辑像素大小

在不缩放的情况下，一个逻辑像素就等于一个 DPR，即 1 逻辑像素 = 物理像素/分辨率

- 自适应
- 媒体查询
- 百分比
- rem(都只相对于浏览器的根元素 HTML 默认情况下 html 元素的 font-size 为 16px，所以 1rem=16px 的 font-size)
  为了计算方便

```css
html {
  font-size: 62.5%;
}
```

这个意思是默认字体尺寸的 62.5%，也就是 16\*62.5%=10px，此时我们就有 1rem = 10px。

## click 在 ios 上有 300ms 的延迟，原因和解决办法

苹果上有一个双击缩放网页的功能，当第一次 click 时候浏览器会等待 300ms 判定用户是否要双击，所以点击一次后会延迟 300ms 才发生 click 事件。

解决办法：

1. 禁用缩放：

```js
<meta name="viewport" content="width=device-width;user-scalable=no;">
```

2. 利用 fastClick：(`FastClick.attach(document.body)`)
   检测到 touchend 事件时立即发出模拟 click 事件，并且把浏览器 300ms 后发出的点击事件给阻断掉。

## 浏览器缓存的四种实现方法

按优先级从高到低：

1. Service Worker：本质是一个 web worker，是独立于网页运行的脚本。
2. Memory Cache：Memory Cache 指的是内存缓存，从效率上讲它是最快的。
3. Disk Cache：Disk Cache 就是存储在磁盘中的缓存，从存取效率上讲是比内存缓存慢的，但是他的优势在于存储容量和存储时长。
4. Push Cache：即推送缓存，是 HTTP/2 的内容。

浏览器的三级缓存原理：

1. 先去内存看，如果有，直接加载

2. 如果内存没有，择取硬盘获取，如果有直接加载

3. 如果硬盘也没有，那么就进行网络请求

4. 加载到的资源缓存到硬盘和内存

## 在地址栏里输入一个 url 到页面呈现出来，中间发生了什么？

- 输入 url，查询对应 ip（dns 解析）（DNS 查询分为递归查询和迭代查询）
  - 先查找缓存：浏览器缓存->系统缓存->路由器缓存
  - 没有查到则查找系统的 hosts 文件中是否有记录，
  - 没有则查询 DNS 服务器，缓存
- 建立 tcp 连接（TCP 三次握手）
- 根据 ip 和端口号构建一个 http 请求，封装为 tcp 包，请求传输：应用层->传输层->网络层->数据链路层->物理层（发送请求，解析 url，设置请求报文(头，主体)）
  - 到达服务器，服务器解析请求作出响应
- 浏览器接收到 html 构建 DOM 树（中途如果遇到 js 就会停止构建而去执行下载脚本）（浏览器渲染）
  - 构建 CSSOM 树
  - 合并两树为渲染树（排除了非视觉结点）
  - 布局（确定个元素的尺寸和位置）
  - 渲染绘制页面

## Cache-control 的值有哪些

Cache-control 是一个通用消息头字段，被用于 HTTP 请求和响应中。通过指定指令来实现缓存机制，这个缓存指令是单向的，常见的取值有：

- private(默认)
- no-cache
- max-age
- must-revalidate

## 如何画 0.5px 的线

- 采用视口控制

```html
<meta
  name="viewport"
  content="width=device-width;initial-scale=0.5;user-scalable=no;"
/>
```

- border-image
  需要自己制作一个 0.5px 的线条图片

```css
p {
  border-width: 0 0 1px 0;
  border-image: url(xxx.png) 2 0 round;
}
```

- transform

```css
p {
  transform: scaleY(0.5);
  /* 设置基点 */
  transform-origin: 50% 100%;
}
```

## transition 和 animation 的区别

- animation：动画，不需要触发任何事件就可以改变属性值
- transition：过渡，侦听属性发生变化时触发，搭配其他样式属性能实现大多数过渡动画

创建动画序列，需要使用 animation 属性或者其子属性，该属性允许配置动画时间、时长以及其他动画细节，但该属性不能配置动画的实际表现。动画的实际表现是由@keyframes 规则实现

transition 也可以实现动画，transition 强调过渡，是元素的一个或多个属性发生变化时产生的过渡效果，同一个元素通过两个不同途径获取样式，而第二个途径当某种改变发生时才能获取样式，这样就会产生过渡动画。transition 多个属性用逗号隔开。

```css
transition: transform 2s ease, border-radius 3s ease-out;
```

## 关于 js 动画和 css3 动画的差异性

渲染线程分为 main thread 和 compositor thread。如果 css 动画只改变 transform 和 opacity，这时候整个 css 动画在 compositor thread 得以完成（而 js 动画会在 main thread 执行然后 compositor thread 进行下一步操作），特别注意的是如果改变 transform 和 opacity 是不会 layout 和 paint 的.

- 区别
- 功能覆盖面，js 比 css 大 实现或者重构难度不一，适合效果复杂且动态效果要求高的动画
- css3 比 js 简单，性能调优方向固定 能触发 GPU 加速，调用 GPU 能力，帧率高
- css3 可以做到自然降级 css 动画有天然事件支持 css3 有兼容性问题

`calc属性使用户可以动态计算长度值。任何长度值都可以使用calc()函数来计算`

## 快速下载 git、nodejs

https://npm.taobao.org/mirrors/git-for-windows/
https://npm.taobao.org/mirrors/node/
科学计数法 1e3 === 1000

## 双边距重叠问题（外边距折叠）

现象：多个相邻（兄弟或者父子关系）普通流的块元素垂直方向 margin 会重叠

折叠结果为：

两个相邻的外边距都是正数时，折叠结果是较大者 两个相邻的外边距都是负数时，折叠结果是绝对值较大者 两个相邻的外边距一正一负时，折叠结果是两者的和

## display：table 和本身 table 有什么区别

display：table 和本身 table 是相对应的，区别在于 display：table 的声明能够让一个 html 元素和它的子节点像 table 元素一样，使用基于表格的 css 布局，使我们能够轻松定义一个单元格的边界，背景等样式，而不会产生因为使用了 table 那样的制表标签导致的语义化问题。

之所以现在逐渐淘汰了 table 系列表格元素，是因为使用 div+css 编写出来的文件比用 table 编写出来的小，而 table 必须在页面完全加载完成后才显示，div 则是逐行显示，table 的嵌套性太多，没有 div 简洁

## line-height 和 height 的区别

line-height 一般是指布局里面一段文字上下行之间的高度，是针对字体来设置的。height 一般是指容器的整体高度

## 重绘和重排

### 重绘

当盒子的位置，大小以及其他属性，例如颜色。字体大小等都确定下来之后，浏览器便把这些元素都按各自的特性绘制一遍，将内容呈现在页面上，重绘是指一个元素外观的改变触发的浏览器行为，浏览器会根据元素的新属性重新绘制，使元素呈现新的外观。

触发重绘的条件：改变元素的外观属性

### 重排：当渲染树中的一部分或全部因为元素的规模尺寸，布局，隐藏等改变而需要重新构建，每个页面至少经历一次重排，即首次加载

重绘和重排的关系：在回流的时候，浏览器会使渲染树中受到影响的部分失效，并重新构造这部分渲染树，完成回流后，浏览器会重新绘制受影响的部分到屏幕中，也就是意味着重排意味着重绘操作，而重绘不一定导致重排

引起重排重绘的原因有:

- 添加或者删除可见的 DOM 元素
- 元素尺寸位置的改变
- 浏览器页面的初始化
- 浏览器窗口大小发生改变

减少重绘重排的方法有

- 不在布局信息改变时做 DOM 查询
- 使用 csstext，className 一次性改变属性
- 使用 fragment
- 对于多次重排的元素，比如动画，使用绝对定位脱离文档流，使其不影响其他元素

## ajax 阻止缓存请求

- 在 ajax 发送请求前加上 ajaxObj.setRequestHeader("If-Modified-Since", "0")
- 在 ajax 发送请求前加上 ajaxObj.setRequestHeader("Cache-Control", "no-cache")
- 在 url 后面加一个随机数："fresh="+Math.rendom()
- 在 url 后面加上时间戳："nowtime="+new Date().getTime()

## 实现单例模式(闭包)

- 模仿块级作用域，保存外部函数的变量，封装私有变量

```js
function Person(name) {
    this.name = name;
}

function Singleton = function(constructor) {
    var ret;
    return function() {
        if(!ret) ret = new constructor(...arguments);
        return ret;
    }
}
```

## 三栏等宽图片布局

```css
img {
  display: block;
  width: 30%;
  margin: 2.5% 0 0 2.5%;
  float: left;
}
```

## 表单提交的常用方式是什么，应用层和通信层发生了什么过程？

- 在 form 表单提交时我们最常用的方式时 get 和 post，form 表单提交时最要注意的就是 enctype，enctype 属性默认是 application/x-www-form-urlencoded.
- 在 get 方式时，浏览器会以当前的 enctype 编码方式将 form 数据转化成一个字符串，并将改字符串 append 到 url 上，以？分割。加载该新的 url
- 在 post 方式中：
- 如果 form 中没有 type 为 file 的控件时，form 也会以默认 enctype 进行编码。
- 如果是具有 type 为 file 的控件时，enctype 得设置成 multipart/form-data，这样浏览器会将表单以控件为单位分割，并为每个部分加上 Content-Disposition（form-data 或者时 file）、content-type（默认值为 text/plain）、name 等信息，并加上分割符（boundary）

- 应用层和通信层发生了什么过程？
- 浏览器发送请求后，DNS（Domain Name System）解析域名得到相应的 IP 地址。
- 通过域名访问网页
- 将域名发送到解析域名的服务器上，有很多专门解析.org、.cn、.com 等，最主要有一台根域名服务器
- 找到对应的 IP 地址

- 应用层 http 协议（HyperText Transfer Protocol，超文本传输协议）
  - 发送请求的我们称之为客户端（client）、而做出相应的服务器叫做源服务器（origin server）。在客户端和服务端之间可能存在很多中间层，比如代理，网关，隧道等。
  - http 协议中的请求报文和响应报文（具体格式大家可以百度了解下）
- 通信层（TCP/IP）： - 生成 http 报文及请求 - TCP 协议将 http 请求报文进行分割（为了方便传输），并在每个报文上标记序号和端口号发给网络层（IP 协议） - 网络层增加作为通信目的的 MAC 地址后转发给链路层（建立电路连接，整个网络的物理基础，典型协议为以太网和 ADSL 等） - 链路层处理后生成的数据包通过物理层传输到接收端 - 接收到数据的服务端后按序网上传， - TCP 连接的三次握手四次挥手 - IP 协议实现数据传递到对方计算机 - 解析请求报文并生成响应报文
  TCP 协议是一种面向连接的、可靠的字节流的运输层通信协议，TCP 是全双工模式。

## flex: 0 1 auto 表示什么意思

> flex: 0 1 auto 其实就是弹性盒子的默认值，表示 flex-grow, flex-shrink 和 flex-basis 的简写，分别表示放大比例、缩小比例、分配多余空间之前占据的主轴空间。

## 小程序的技术架构和方案、小程序的出现主要解决什么问题？

包含小程序容器、渲染引擎和 JavaScript 引擎。UI 层运行在 WebView 中，而逻辑层运行在独立的 JS 引擎中。

降低获客成本、打通跨端

## view 层、js 层分别在哪里、怎么通信 ?

业务逻辑的 JS 在独立的 JavaScript 引擎（ServiceWorker）中，每个页面的 view 和 css 运行在各自独立的 webview 里面，页面之间是通过函数 navigateTo 进行页面的切换；JS 层和 view 层通过消息服务 MessageChannel 进行通信。

## AST(抽象语法树)

抽象语法树 (Abstract Syntax Tree)，是将代码逐字母解析成 树状对象 的形式。这是语言之间的转换、代码语法检查，代码风格检查，代码格式化，代码高亮，代码错误提示，代码自动补全等等的基础。例如:

```js
function square(n) {
  return n * n;
}
```

![ast](http://cdn.mydearest.cn/blog/images/ast.png)

## babel 编译原理

- babylon 将 ES6/ES7 代码解析成 AST (解析)
- babel-traverse 对 AST 进行遍历转译，得到新的 AST (转换)
- 新 AST 通过 babel-generator 转换成 ES5 (生成)

## 函数式编程

函数式编程是一种 编程范式，你可以理解为一种软件架构的思维模式。它有着独立一套理论基础与边界法则，追求的是 更简洁、可预测、高复用、易测试。其实在现有的众多知名库中，都蕴含着丰富的函数式编程思想，如 React / Redux 等。

`函数式编程（缩写为FP）是通过编写纯函数，避免共享状态、可变数据、副作用来构建软件的过程。`函数式编程是声明式的而不是命令式的，应用程序的状态是通过纯函数流动的。与面向对象编程形成对比，面向
对象中应用程序的状态通常与对象中的方法共享和共处。

- 常见的编程范式:

  - 命令式编程(过程化编程): 更关心解决问题的步骤，一步步以语言的形式告诉计算机做什么；
  - 事件驱动编程: 事件订阅与触发，被广泛用于 GUI 的编程设计中；
  - 面向对象编程: 基于类、对象与方法的设计模式，拥有三个基础概念: 封装性、继承性、多态性；
  - 函数式编程(面向数学编程)：关心数据的映射。

- 好处

1. 函数副作用小，所有函数独立存在，没有任何耦合，复用性极高；
2. 不关注执行时间，执行顺序，参数，命名等，能专注于数据的流动与处理，能有效提高稳定性与健壮性；
3. 追求单元化，粒度化，使其重构和改造成本降低，可维护、可拓展性较好；
4. 更易于做单元测试。

## 什么是 cdn 及其好处

CDN:CDN(Content Delivery Network，即 内容分发网络。是将源站内容分发至最接近用户的节点，使用户可就近取得所需内容，提高用户访问的响应速度和成功率。解决因分布、带宽、服务器性能带来的访问延迟问
题，适用于站点加速、点播、直播等场景。

工作原理：将源码的资源缓存到位于全国各地的 CDN 节点上，用户请求资源时，就近返回节点上缓存的资源，而不需要每个用户的请求都回源站点获取，避免网络拥塞、分担源站压力，保证用户访问资源
的速度和体验。

- 为了加速网站的访问
- 为了实现跨运营商、跨地域的全网覆盖
- 为了保障网站安全
- 为了异地备源
- 为了节约成本投入
- 为了更专注业务本身

### 好处

1. 多域名加载资源
   一般情况下，浏览器都会对单个域名下的并发请求数（文件加载）进行限制，通常最多有 4 个，那么第 5 个加载项将会被阻塞，直到前面的某一个文件加载完毕。
   因为 CDN 文件是存放在不同区域（不同 IP）的，所以对浏览器来说是可以同时加载页面所需的所有文件（远不止 4 个），从而提高页面加载速度。

2. 文件可能已经被加载过并保存有缓存
   一些通用的 js 库或者是 css 样式库，如 jQuery，在网络中的使用是非常普遍的。当一个用户在浏览你的某一个网页的时候，很有可能他已经通过你网站使用的 CDN 访问过了其他的某一个网站，恰巧这个网站同样也使用了 jQuery，那么此时用户浏览器已经缓存有该 jQuery 文件（同 IP 的同名文件如果有缓存，浏览器会直接使用缓存文件，不会再进行加载），所以就不会再加载一次了，从而间接的提高了网站的访问速度。

3. 高效率
   你的网站做的再 NB 也不会 NB 过百度 NB 过 Google 吧？一个好的 CDN 会提供更高的效率，更低的网络延时和更小的丢包率。

4. 分布式的数据中心
   假如你的站点布置在北京，当一个香港或者更远的用户访问你的站点的时候，他的数据请求势必会很慢很慢。而 CDNs 则会让用户从离他最近的节点去加载所需的文件，所以加载速度提升就是理所当然的了。

5. 使用情况分析
   一般情况下 CDNs 提供商（如百度云加速）都会提供数据统计功能，可以了解更多关于用户访问自己网站的情况，可以根据统计数据对自己的站点适时适当的做出些许调整。

6. 有效防止网站被攻击
   一般情况下 CDNs 提供商也是会提供网站安全服务的

## 网站突然打不开有哪些可能

断网，DNS 解析出现问题，代理服务器出现问题，流量被劫持了等等

## 前端向后端发送请求有几种方式？

1. link src=""
2. script src=""
3. img src="" // audio video
4. ajax 请求
5. 表单提交
6. a href=""
7. iframe src=""

## axios 特点

1. axios 是一个基于 promise 的 HTTP 库，支持 promise 所有的 API

2. 它可以拦截请求和响应

3. 它可以转换请求数据和响应数据，并对响应回来的内容自动转换成 JSON 类型的数据

4. 安全性更高，客户端支持防御 XSRF

5. 取消请求

```js
var app = new Vue({
  el: "#app",
  data: {
    message: "Hello Axios!",
    source: null,
  },
  methods: {
    sendRequest() {
      this.source = this.axios.CancelToken.source(); // 这里初始化source对象
      this.axios
        .get(url, {
          cancelToken: this.source.token, // 这里声明的cancelToken其实相当于是一个标记，
          // 当我们要取消请求的时候，可以通过这个找到该请求
        })
        .then((res) => {
          // 你的逻辑
        })
        .catch((res) => {
          // 如果调用了cancel方法，那么这里的res就是cancel传入的信息
          // 你的逻辑
        });
    },
    cancel() {
      this.source.cancel("这里你可以输出一些信息，可以在catch中拿到");
    },
  },
});
```

默认 Content-Type: application/json;charset=utf-8

- Content-Type: application/json ： 请求体中的数据会以 json 字符串的形式发送到后端
- Content-Type: application/x-www-form-urlencoded：请求体中的数据会以普通表单形式（键值对）发送到后端
- Content-Type: multipart/form-data： 它会将请求体的数据处理为一条消息，以标签为单元，用分隔符分开。既可以上传键值对，也可以上传文件。

数据发送字段：params(get)、data(post、put)

### 配置 axios 请求头中的 content-type 为指定类型

```js
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded'; 或者

{headers:{'Content-Type':'application/x-www-form-urlencoded'}}
```

## Base64 的编码原理

字符选用了"A-Z、a-z、0-9、+、/" 64 个可打印字符，这是标准的 Base64 协议规定。

```js
["A", "B", "C", ..."a", "b", "c", ..."0", "1", ..."+", "/"];
```

### 具体转换步骤

- 第一步 将待转换的字符串每三个字节分为一组，每个字节占 8bit，那么共有 24 个二进制位。
- 第二步 将上面的 24 个二进制位每 6 个一组，共分为 4 组。
- 第三步 在每组前面添加两个 0，每组由 6 个变为 8 个二进制位，总共 32 个二进制位，即四个字节。
- 第四步 根据 Base64 编码对照表获得对应的值。

## {}和[]的 valueOf 和 toString 结果

```js
var a = {};
a.valueOf(); // {}
a.toString(); // [object Object]

var b = [];
b.valueOf(); // []
b.toString(); // ""
```

## 三种事件模型

- 事件(是用户操作网页时发生的交互动作或者网页本身的一些操作)
  原始事件模型（DOM0），DOM2 事件模型，IE 事件模型

### DOM0 级模型

这种模型不会传播，所以没有事件流的概念，但是现在有的浏览器支持以冒泡的方式实现，它可以在网页中直接定义监听函数，也可以通过 js 属性来指定监听函数。这种方式是所有浏览器都兼容的。

- 缺点
  - 逻辑和显示没有分离
  - 相同事件的监听函数只能绑定一个，后面绑定的会覆盖掉前面的
  - 无法处理事件的冒泡和委托

```html
<!-- 在 html 代码中直接指定属性值 -->
<button onclick="doSomeTing()">test</button>

<script>
  // 在 js 代码中
  document.getElementsById("demo").onclick = doSomeTine();
</script>
```

### IE 事件模型

在该事件模型中，一次事件共有两个过程，事件处理(目标)阶段，和事件冒泡阶段。事件处理阶段会首先执行目标元素绑定的监听事件。然后是事件冒泡阶段，冒泡指的是事件从目标元素冒泡到 document，依次检查经过的节点是否绑定了事件监听函数，如果有则执行。这种模型通过 attachEvent 来添加监听函数，可以添加多个监听函数，会按顺序依次执行。

### DOM2 级事件模型

在该事件模型中，一次事件共有三个过程，第一个过程是事件捕获阶段。捕获指的是事件从 document 一直向下传播到目标元素，依次检查经过的节点是否绑定了事件监听函数，如果有则执行。后面两个阶段和 IE 事件模型的两个阶段相同。这种事件模型，事件绑定的函数是 addEventListener，其中第三个参数可以指定事件是否在捕获阶段执行。

所有的事件类型都会经历事件捕获，但是只有部分事件会经历事件冒泡阶段，例如 submit 事件就不会冒泡。

## 简单介绍一下 V8 引擎的垃圾回收机制

```
v8 的垃圾回收机制基于分代回收机制，这个机制又基于世代假说，这个假说有两个特点，一是新生的对象容易早死，另一个是不死的对象会活得更久。基于这个假说，v8 引擎将内存分为了新生代和老生代。

新创建的对象或者只经历过一次的垃圾回收的对象被称为新生代。经历过多次垃圾回收的对象被称为老生代。

新生代被分为 From 和 To 两个空间，To 一般是闲置的。当 From 空间满了的时候会执行 Scavenge 算法进行垃圾回收。当我们执行垃圾回收算法的时候应用逻辑将会停止，等垃圾回收结束后再继续执行。这个算
法分为三步：

（1）首先检查 From 空间的存活对象，如果对象存活则判断对象是否满足晋升到老生代的条件，如果满足条件则晋升到老生代。如果不满足条件则移动 To 空间。

（2）如果对象不存活，则释放对象的空间。

（3）最后将 From 空间和 To 空间角色进行交换。

新生代对象晋升到老生代有两个条件：

（1）第一个是判断是对象否已经经过一次 Scavenge 回收。若经历过，则将对象从 From 空间复制到老生代中；若没有经历，则复制到 To 空间。

（2）第二个是 To 空间的内存使用占比是否超过限制。当对象从 From 空间复制到 To 空间时，若 To 空间使用超过 25%，则对象直接晋升到老生代中。设置 25% 的原因主要是因为算法结束后，两个空间结束后
会交换位置，如果 To 空间的内存太小，会影响后续的内存分配。

老生代采用了标记清除法和标记压缩法。标记清除法首先会对内存中存活的对象进行标记，标记结束后清除掉那些没有标记的对象。由于标记清除后会造成很多的内存碎片，不便于后面的内存分配。所以了解决内存碎
片的问题引入了标记压缩法。

由于在进行垃圾回收的时候会暂停应用的逻辑，对于新生代方法由于内存小，每次停顿的时间不会太长，但对于老生代来说每次垃圾回收的时间长，停顿会造成很大的影响。 为了解决这个问题 V8 引入了增量标记的
方法，将一次停顿进行的过程分为了多步，每次执行完一小步就让运行逻辑执行一会，就这样交替运行。
```

## 获取原型的方法

```js
p.__proto__;

p.construtor.prototype;

Object.getProtorypeOf(p);
```

## 造火箭

- 什么是 xxx
- 讲讲你对 xxx 的理解
- xxx 的原理、xxx 怎么实现
- xxx 的优缺点
- xxx 怎么进行优化
- 讲讲 xxx 的思想，设计思路
- xxx 的作用是什么，怎么做的
- 项目中(react/vue)遇到的问题
- 最满意的项目，什么地方做的好
- 如何实现一个 animate.js
- 三个词描述自己
- 觉得自己为啥能符合这个岗位
- xxx 解决了什么问题
- 如何搭建前端监控体系
- 随机应变

- 人才的定义，想招什么样的人
  过硬的技术基础外，还需要有良好的表达能力、处事能力等软实力。

### 工具

短命令行工具、自动化上传部署、i18n 词条翻译、eslint 校验目录格式、chrome 插件、模板编译、axios 封装、基建

## Iterator 是什么，有什么作用？

terator（迭代器）是一种接口，也可以说是一种规范。为各种不同的数据结构提供统一的访问机制。任何数据结构只要部署 Iterator 接口，就可以完成遍历操作（即
依次处理该数据结构的所有成员）。

```js
const obj = {
  [Symbol.iterator]: function () {},
};
```

迭代器的遍历方法是首先获得一个迭代器的指针，初始时该指针指向第一条数据之前，接着通过调用 next 方法，改变指针的指向，让其指向下一条数据 每一次的
next 都会返回一个对象，该对象有两个属性

- value 代表想要获取的数据
- done 布尔值，false 表示当前指针指向的数据有值，true 表示遍历已经结束

### 作用

1. 为各种数据结构，提供一个统一的、简便的访问接口；
2. 使得数据结构的成员能够按某种次序排列；
3. ES6 创造了一种新的遍历命令 for…of 循环，Iterator 接口主要供 for…of 消费。

## 检测对象中存在某个属性

- prop in obj：返回布尔值，指示指定的属性在指定的对象或其原型链中；

- obj.hasOwnProperty(prop)：返回布尔值，指示对象自身属性中是否具有指定的属性，因此这个方法会忽略掉那些从原型链上继承到的属性；

- obj["prop"]：读取属性值，存在则返回值，否则返回 undefined；

## JS 中的主要有哪几类错误

- 加载时错误：加载 web 页面时出现的错误(如语法错误)称为加载时错误，它会动态生成错误。

- 运行时错误：由于滥用 HTML 语言中的命令而导致的错误。

- 逻辑错误：这些错误是由于对具有不同操作的函数执行了错误的逻辑而导致的

## mul 函数乘法指令

```js
function mul(x) {
  return function (y) {
    return function (z) {
      return x * y * z;
    };
  };
}
```

## js 实现枚举

> 枚举的特点

- 枚举值不能重复
- 不能被修改
- switch case 可以直接判断

```js
const EnumSex = Object.freeze({
  man: Symbol("男"),
  woman: Symbol("女"),
});
```

## 数组和链表的区别

> 数组是我们平时用的最多的数据结构，它的特点是查询数据快，插入数据慢，查询的时间复杂度是 O(1),插入的时间复杂度是 O(n).

> 链表我们平时用的比较少，它的特点是:插入数据快，查询数据慢，查询的时间复杂度是：O(n)，插入的时间复杂度是：O(1)，它的特点是和数组相反的；

1. 数组是将元素在内存中连续存放。链表中的元素在内存中不是顺序存储的，而是通过存在元素中的指针联系到一起。

2. 数组必须事先定义固定的长度，不能适应数据动态的增减的情况。当数据增加时，可能超出原先定义的元素个数；当数据减少时，造成内存浪费；链表动态地进行存储分配，可以适应数据动态地增减的情况。

### 时间复杂度

||数组|链表|
|插入|O(n)慢|O(1)快|
|删除|O(n)慢|O(1)快|
|查询|O(1)快|O(n)慢|

哈希表(数组链表)具有较快（常量级）的查询速度，及相对较快的增删速度，所以很适合在海量数据的环境中使用。一般实现哈希表的方法采用“拉链法”，我们可以理解为“链表的数组”

## 内存有哪些分区？

### 栈区（stack）

由编译器自动分配释放，存放函数的参数值，局部变量的值等。其操作方式类似于数据结构中的栈。

### 堆区（heap）

一般由分配释放，若不释放，程序结束时可能由 OS 回收。注意它与数据结构中的堆是两回事，分配方式倒是类似于链表。

### 全局区（静态区）（static）

全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域，未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。程序结束后由系统释放。

### 文字常量区

常量字符串就是放在这里的。程序结束后由系统释放。

### 程序代码区

存放函数体的二进制代码。

## 单元测试框架

- Unit.js
- Jasmine
- Karma
- Chai
- AVA
- Mocha
- JSUnit
- QUnit
- Jest

## BOM 和 DOM 的关系

- BOM 全称 Browser Object Model，即浏览器对象模型，主要处理浏览器窗口和框架。(location/history/navigator)
- DOM 全称 Document Object Model，即文档对象模型，是 HTML 和 XML 的应用程序接口（API），遵循 W3C 的标准，所有浏览器公共遵守的标准。

BOM 包含了 DOM(对象)，浏览器提供出来给予访问的是 BOM 对象，从 BOM 对象再访问到 DOM 对象，从而 js 可以操作浏览器以及浏览器读取到的文档。

## js 实现 Map(数组存放对象实现 api)，reduce 方法

```js
// 归并方法
const reduceHelper = (f, acc, arr) => {
  if (arr.length === 0) return acc;
  const [head, ...tail] = arr;
  return reduceHelper(f, f(acc, head), tail);
};

Array.prototype.fakeReduce = function (fn, initialValue) {
  return reduceHelper(fn, initialValue, this);
};
```

## reduce 实现数组 map

```js
Array.prototype._map = function (fn, thisArg) {
  const result = [];
  this.reduce((prev, curr, index, array) => {
    result[index] = fn.call(thisArg, array[index], index, array);
  }, 0);
  return result;
};
```

## Label 的作用是什么？是怎么用的？

label 标签来定义表单控制间的关系，当用户选择该标签时，浏览器会自动将焦点转到和标签相关的表单控件上。

```html
<label for="Name">Number:</label> <input type="“text“" name="Name" id="Name" />
```

## Canvas 和 SVG 有什么区别？

> Canvas 是一种通过 JavaScript 来绘制 2D 图形的方法。Canvas 是逐像素来进行渲染的，因此当我们对 Canvas 进行缩放时，会出现锯齿或者失真的情况。依赖于像素，无法高效保真，画布较大时候性能较
> 低。

> SVG 是一种使用 XML 描述 2D 图形的语言。SVG 基于 XML，这意味着 SVG DOM 中的每个元素都是可用的。我们可以为某个元素附加 JavaScript 事件监听函
> 数。并且 SVG 保存的是图形的绘制方法，因此当 SVG 图形缩放时并不会失真。svg:dom 形式，涉及到动画时候需要更新 dom，性能较低。

## 网页验证码是干嘛的，是为了解决什么安全问题？

1. 区分用户是计算机还是人的公共全自动程序。可以防止恶意破解密码、刷票、论坛灌水
2. 有效防止黑客对某一个特定注册用户用特定程序暴力破解方式进行不断的登陆尝试

## 渐进增强和优雅降级的定义

- 渐进增强：针对低版本浏览器进行构建页面，保证最基本的功能，然后再针对高级浏览器进行效果、交互等改进和追加功能达到更好的用户体验。
- 优雅降级：一开始就根据高版本浏览器构建完整的功能，然后再针对低版本浏览器进行兼容。

> 无头浏览器（Headless browser）指没有用户图形界面的(GUI)的浏览器，目前广泛运用于 web 爬虫和自动化测试中。

## Window.getComputedStyle()

`Window.getComputedStyle()`方法返回一个对象，该对象在应用活动样式表并解析这些值可能包含的任何基本计算后报告元素的所有 CSS 属性的值。 私有的 CSS 属性值可以通过对象提供的 API 或通过简单地使用 CSS
属性名称进行索引来访问。

```js
let elem1 = document.getElementById("elemId");
let style = window.getComputedStyle(elem1, null);

// 它等价于
// let style = document.defaultView.getComputedStyle(elem1, null);
```

## 如何取消 fetch 请求

Fetch API 已经成为现在浏览器异步网络请求的标准方法，但 Fetch 也是有弊端的，比如： Fetch 还没有方法终止一个请求，而且 Fetch 无法检测上传进度。

### 流程

- 创建一个 AbortController 实例
- 该实例具有 signal 属性
- 将 signal 传递给 fetch option 的 signal
- 调用 AbortController 的 abort 属性来取消所有使用该信号的 fetch。

```js
const controller = new AbortController();
const { signal } = controller;

fetch("http://localhost:8000", { signal })
  .then((response) => {
    console.log(`Request 1 is complete!`);
  })
  .catch((e) => {
    if (e.name === "AbortError") {
      // We know it's been canceled!
    }
    console.warn(`Fetch 1 error: ${e.message}`);
  });

// Abort request
controller.abort();
```

## 协议相对 URL

如果用户当前访问的页面是通过 HTTPS 协议来浏览的，那么网页中的资源也只能通过 HTTPS 协议来引用，否则浏览器会出现警告信息，不同浏览器警告信息展现形式
不同。

为了解决这个问题，我们可以省略 URL 的协议声明，省略后浏览器照样可以正常引用相应的资源，这项解决方案称为 protocol-relative URL，暂且可译作协议相
对 URL。

## MVC 模式

![mvc](http://cdn.mydearest.cn/blog/images/mvc.png)

用户把对 View 的操作交给了 Controller 处理，在 Controller 中响应 View 的事件调用 Model 的接口对数据进行操作，一旦 Model 发生变化便通知相关视图进行更新。

MVC 模式可以这样理解。将 html 看成 view;js 看成 controller，负责处理用户与应用的交互，响应对 view 的操作（对事件的监听），调用 Model 对数据进行操作，完
成 model 与 view 的同步（根据 model 的改变，通过选择器对 view 进行操作）;将 js 的 ajax 当做 Model，也就是数据层，通过 ajax 从服务器获取数据。

## MVVM 模式

![mvvm](http://cdn.mydearest.cn/blog/images/mvvm.png)

MVVM 与 MVC 两者之间最大的区别就是：MVVM 实现了对 View 和 Model 的自动同步，也就是当 Model 的属性改变时，我们不用再自己手动操作 Dom 元素来改变 View 的变化，
而是改变其属性后，该属性对应的 View 层数据会自动改变。

- Model 代表数据模型，也可以在 Model 中定义操作数据变化的业务逻辑；
- View 代表 UI 视图，它负责将数据模型转化成 UI 展现出来；
- ViewModel 监听 Model 中数据的改变和控制 View 层的展现；

### 不同空格符合的区别

- &nbsp; 半角的不断行的空白格（推荐使用）

- &ensp; 半角的空格

- &emsp; 全角的空格

_详细的含义：_

1. `&nbsp;`：这是我们使用最多的空格，也就是按下 space 键产生的空格。在 HTML 中，如果你用空格键产生此空格，空格是不会累加的（只算 1 个）。要使用 html 实体表示才可累加。该空格占据宽度受字体影响明显而强烈。在 inline-block 布局中会搞些小破坏，在两端对齐布局中又是不可少的元素。

2. `&ensp;`：此空格有个相当稳健的特性，就是其占据的宽度正好是 1/2 个中文宽度，而且基本上不受字体影响。

3. `&emsp;`：此空格也有个相当稳健的特性，就是其占据的宽度正好是 1 个中文宽度，而且基本上不受字体影响。

### 浏览器私有属性

|-webkit-|-moz-|-ms-|-o-|
|chrome,safari|firefox||||

### CSS 变量

自从 CSS3，我们可以在 CSS 中定义变量，从而使得页面的样式更统一。

```css
/* 声明全局变量 */
:root {
  --color-main-font: #303133;
  --color-normal-font: #606266;
  --color-secondary-font: #909399;
  --size-main-title: 20px;
  --size-title: 18px;
  --size-second-title: 16px;
  --size-body: 14px;
  --size-tip: 12px;
}
/* 声明局部变量 */
div {
  --color: green;
}
/* 使用变量 */
.example {
  color: var(--color-main-font);
  /* 如果变量不存在就会使用逗号后面的值 */
  font-size: var(--color-body, 20px);
}
```

注： 当有重复变量名的时候，遵循优先级规则覆盖！

#### 媒体查询(@media)

```csss
@media only screen and (max-width: 600px) {
    .example {background: red;}
}
```

我们也可以在 HTML 文件中通过媒体查询判断是否引入一个 CSS

```html
<link rel="stylesheet" media="(min-width:480px)" href="mystylesheet.css" />
```

#### 自定义字体(@font-face)

```css
@font-face {
  font-family: "myFont";
  src: url("./font/example.svg") format("svg"), url("./font/example.ttf") format("truetype");
}

/* 可以直接将上面定义好的的 `my-font` 作为字体 */
.my-font {
  font-family: "myFont";
}
/* 如果是小图标，可以作为伪元素插入到页面中 */
.icon-back:before {
  content: "\800";
}

/* <span class="my-font icon-back"></span> */
```

### 装饰器的原理

语法糖，实则调用 Object.defineProperty，可以添加、修改对象属性

### 堆栈的区别

- 申请方式
  内存中的堆和栈第一个区别就是申请方式的不同：栈是系统自动分配空间的，而堆则是程序员根据需要自己申请的空间。由于栈上的空间是自动分配自动回收的，所以栈上的数据的生存周期只是在函数的运行过程中，
  运行后就释放掉，不可以再访问。而堆上的数据只要程序员不释放空间，就一直可以访问到，不过缺点是一旦忘记释放会造成内存泄露。
  申请效率的比较：栈由系统自动分配，速度较快。但程序员是无法控制的。堆是由 new 分配的内存，一般速度比较慢，而且容易产生内存碎片，不过用起来最方便。

- 申请大小的限制：
  栈：在 Windows 下，栈是向低地址扩展的数据结构，是一块连续的内存的区域。这句话的意思是栈顶的地址和栈的最大容量是系统预先规定好的，在 Windows 下，栈的大小是 2M（也有的说是 1M，总之是一个编译时就确
  定的常数），如果申请的空间超过栈的剩余空间时，将提示 overflow。因此，能从栈获得的空间较小。
  堆：堆是向高地址扩展的数据结构，是不连续的内存区域。这是由于系统是用链表来存储空闲内存地址的，自然是不连续的，而链表的遍历方向是由低地址向高地址。堆的大小受限于计算机系统中有效的虚拟内存。由
  此可见，堆获得的空间比较灵活，也比较大。

### 为什么不要扩展 js 内置对象

如果浏览器或 javascript 本身就会实现这个方法，而且和你扩展的实现有不一致的表现。到时候你的 javascript 代码可能已经在无数个页面中执行了数年，而浏览器的实现导致所有使用扩展原型的代码都崩溃。

### 可变 (mutable) 和不变 (immutable) 对象的区别

- Mutable 对象：
  在 JavaScript 中，对象是引用类型的数据，其优点在于频繁地修改对象时都是在原对象的基础上修改，并不需要重新创建，这样就可以有效地利用内存，不会造成内存空间的浪费

- Immutable 对象：(string, number)
  每次修改一个 immutable 对象时都会创建一个新的不可变对象，在新对象上的操作不会影响到原对象的数据

- 区别：
  Immutable 对象在修改数据时并不会复制一整份数据，而是将变化的节点与未变化的节点的父子关系转移到一个新节点上(结构共享)，而 Mutable 在复制时是“全量”。Immutable 对象需要通过 set 和 get 来对数据进行
  读和写。

#### 不可变优点

- 降低 Mutable 带来的复杂度
- 节省内存空间
- 方便实现撤销重做功能
- 拥抱函数式编程

#### 不可变缺点

- 容易与原生对象搞混

### 防止重复发送 ajax 请求

1. 点击按钮后 disabled
2. 函数节流
3. abort 上一个请求

### Ajax 和 Fetch 区别

- fetch 优点
  语法简洁，更加语义化
  基于标准 Promise 实现，支持 async/await
  同构方便，使用 isomorphic-fetch

- ajax 是使用 XMLHttpRequest 对象发起的，但是用起来很麻烦，所以 ES6 新规范就有了 fetch，fetch 发一个请求不用像 ajax 那样写一大堆代码。
- 使用 fetch 无法取消一个请求，这是因为 fetch 基于 Promise，而 Promise 无法做到这一点。
- 在默认情况下，fetch 不会接受或者发送 cookies
- fetch 没有办法原生监测请求的进度，而 XMLHttpRequest 可以(xhr.upload.onprogress)
- fetch 只对网络请求报错，对 400，500 都当做成功的请求，需要封装去处理
- fetch 由于是 ES6 规范，兼容性上比不上 XMLHttpRequest

### setTimeout() 的第二个参数的最小值不得小于 4 毫秒，如果低于这个值，则默认是 4 毫秒

### 面向过程、面向对象

面向对象特点：封装、继承、多态

- 面向过程就是分析出解决问题所需要的步骤，然后用函数把这些步骤一步一步实现。
- 面向对象是把构成问题事务分解成各个对象，建立对象的目的不是为了完成一个步骤，而是为了描叙某个事物在整个解决问题的步骤中的行为。面向对象是以功能来划分问题，而不是步骤

面向对象思想：
基本思想是使用对象，类，继承，封装等基本概念来进行程序设计。
优点

1. 易维护
   采用面向对象思想设计的结构，可读性高，由于继承的存在，即使改变需求，那么维护也只是在局部模块，所以维护起来是非常方便和较低成本的
2. 易扩展
   开发工作的重用性、继承性高，降低重复工作量。缩短了开发周期

### 100 \* 100 的 Canvas 占内存多大

我们在定义颜色的时候就是使用 rgba(r,g,b,a) 四个维度来表示，而且每个像素值就是用十六位 00-ff 表示，即每个维度的范围是 0~255，即 2^8 位，即 1 byte, 也就是 Uint8 能表示的范围。
所以 100 _ 100 canvas 占的内存是 100 _ 100 \* 4 bytes = 40,000 bytes

### 实现 Object.create

```js
function create(proto) {
  function Fn() {}
  Fn.prototype = proto;
  Fn.prototype.constructor = Fn;
  return new Fn();
}
```

### 10 进制转换

```js
function convert(number, base = 2) {
  let rem,
    res = "",
    digits = "0123456789ABCDEF",
    stack = [];

  while (number) {
    rem = number % base;
    stack.push(rem);

    number = Math.floor(number / base);
  }

  while (stack.length) {
    res += digits[stack.pop()].toString();
  }

  return res;
}
```

### 相邻的两个 inline-block 节点出现间隔的原因以及解决方法

原因：元素被当成行内元素排版的时候，原来 HTML 代码中的回车换行被转成一个空白符，在字体不为 0 的情况下，空白符占据一定宽度，所以 inline-block 的元素之间
就出现了空隙。这些元素之间的间距会随着字体的大小而变化，当行内元素 font-size:16px 时，间距为 8px。

解决方案：

1. 给父级元素设置 font-size： 0；子元素设置相应的 font-size
2. 改变书写方式(去掉空格)
3. margin 负值和字体大小有关不推荐
4. 设置父元素，display:table 和 word-spacing:0

### Promise.reject

```js
Promise.reject(2)
  .catch((e) => e)
  .then((d) => {
    console.log(d);
  });
// 2
```

### 字符编码

- ASCII：编码的规范标准
- Unicode：将全
  世界所有的字符包含在一个集合里，计算机只要支持这一个字符集，就能显示所有的字符，再也不会有乱码了。Unicode 码是 ASCII 码的一个超集
  (superset)
- UTF-32 UTF-8 UTF-16 都是 Unicode 码的编码形式
- UTF-32：用固定长度的四个字节来表示每个码点
- UTF-8：用可变长度的字节来表示每个码点,如果只需要一个字节就能表示的,就用一个字节,一个不够,就用两个…所以,在 UTF-8 编码下,一个字符有可能由 1-4 个字节组成.
- UTF-16：结合了固定长度和可变长度,它只有两个字节和四个字节两种方式来表示码点

### 前后端分离的项目如何 seo

1. 使用 prerender。
2. 先去 `https://www.baidu.com/robots.txt` 找出常见的爬虫，然后在 nginx 上判断来访问页面用户的 User-Agent 是否是爬虫，如果是爬虫，就用 nginx 方向代理到我们自己用 nodejs +
   puppeteer 实现的爬虫服务器上，然后用你的爬虫服务器爬自己的前后端分离的前端项目页面，增加扒页面的接收延时，保证异步渲染的接口数据返回，最后得到了页面的数据，返还给来访问的爬虫即
   可。

### 常见模板语言

- jade
- pug
- thymeleaf

### BFF(Back-end for Front-end)中间层

![bff](http://cdn.mydearest.cn/blog/images/bff.png)
前端分层和建模，实现上没太大限制，就是一层 nodejs，能做请求转发和数据转化即可。

- 优点

1. 前后端彻底分离，即便是后期有微服务迁移，也不需改动前端代码

2. 业务更向前靠拢，琐碎的 api 由前端开发自己决定，更适配前端框架

3. BFF 可以自开 mock，插件也能生成 API 文档，相比后端单开这类服务要方便些吧

4. 留给后端更清晰的服务边界，只需要提供粗粒度的接口即可

- 缺点

1. 中间层转发会增加请求延迟。

2. 需要保证端到端测试

3. 必须随时准备好后端异常请求

4. BFF 分层会增加开发成本
