---
title: 如何用js实现JSON.parse()
tags:
  - 前端
copyright: true
comments: true
date: 2018-12-22 23:50:52
categories: JS
top: 141
photos:
---

## eval
```javascript
var json = '{"a":"1", "b":2}';
var obj = eval("(" + json + ")");  // obj 就是 json 反序列化之后得到的对象
```
> 为什么要加括号呢？
因为js中{}通常是表示一个语句块，eval只会计算语句块内的值进行返回。加上括号就变成一个整体的表达式。

```javascript
console.log( eval('{}') );      // undefind
console.log( eval('({})') );    // Object {}
```

> eval作用域问题
```javascript
var s = 1;
function a() {
    eval('var s=2');
    console.log(s);
}
a();                // 2
console.log(s);     // 1
```
在局部环境使用eval便会创建局部变量。可以显示指定eval调用者来改变上下文环境。

```javascript
var s = 'global';
function a() {
    eval('var s = "local"');
    console.log(s);                 // local
    console.log(eval('s'));         // local
    console.log(window.eval('s'));  // global
}
```

### 对参数json进行校验防止xss漏洞
```javascript
var rx_one = /^[\],:{}\s]*$/;
var rx_two = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g;
var rx_three = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g;
var rx_four = /(?:^|:|,)(?:\s*\[)+/g;

if (
    rx_one.test(
        json
            .replace(rx_two, "@")
            .replace(rx_three, "]")
            .replace(rx_four, "")
    )
) {
    var obj = eval("(" +json + ")");
}
```

## 递归手动扫描每个字符

## new Function 函数声明的传参形式
```javascript
var add = new Function('a, b', 'return a+b;');
console.log( add(2, 3) );    // 5
```

```javascript
var jsonStr = '{ "age": 20, "name": "jack" }',
    json = (new Function('return ' + jsonStr))();
```

## 插入script
> 模拟jsonP的方式拼接字符串然后以callBack的方式返回。