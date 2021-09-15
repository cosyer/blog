---
title: NodeJSHttp加载静态资源
tags:
  - NodeJS
copyright: true
comments: true
date: 2019-03-12 00:36:52
categories: Node
top: 166
photos:
---

问题场景：浏览器向后台发送请求后，后台返回一个html界面。但是在浏览器中没有加载js、css等静态资源，查找原因后发现是Content-Type的原因。浏览器不知道css、js等文件的文件格式，无法成功加载静态文件。所以，需要设置正确的文件格式。

---
<!--more-->

## 搭建简单的本地服务
```js
var http = require('http');//引入http模块

//开启服务，监听8888端口
//端口号最好为6000以上
var server = http.createServer(function(req,res){
    /*
        req用来接受客户端数据
        res用来向客户端发送服务器数据
    */

    console.log('有客户端连接');//创建连接成功显示在后台

    //一参是http请求状态，200连接成功
    //连接成功后向客户端写入头信息
    res.writeHeader(200,{
        'content-type' : 'text/html;charset="utf-8"'
    });

    res.write('这是正文部分');//显示给客户端
    res.end();

}).listen(8888);

console.log('服务器开启成功');
```

## 访问本地站点
```js
var http = require('http');
var fs = require('fs');//引入文件读取模块

var documentRoot = 'E:/PhpProject/html5/websocket/www';
//需要访问的文件的存放目录

var server= http.createServer(function(req,res){

    var url = req.url; 
    //客户端输入的url，例如如果输入localhost:8888/index.html
    //那么这里的url == /index.html 

    var file = documentRoot + url;
    console.log(url);
    //E:/PhpProject/html5/websocket/www/index.html 


    fs.readFile( file , function(err,data){
    /*
        一参为文件路径
        二参为回调函数
            回调函数的一参为读取错误返回的信息，返回空就没有错误
            二参为读取成功返回的文本内容
    */
        if(err){
            res.writeHeader(404,{
                'content-type' : 'text/html;charset="utf-8"'
            });
            res.write('<h1>404错误</h1><p>你要找的页面不存在</p>');
            res.end();
        }else{
            res.writeHeader(200,{
                'content-type' : 'text/html;charset="utf-8"'
            });
            res.write(data);//将index.html显示在客户端
            res.end();

        }

    });



}).listen(8888);

console.log('服务器开启成功');
```

## 无法加载静态文件

### 解决方案一
- 手动设置Content-Type
```js
var http = require('http');
var fs = require('fs');//引入文件读取模块

var documentRoot = './dist';
//需要访问的文件的存放目录

http.createServer(function(req,res){

    var url = req.url; 
    //客户端输入的url，例如如果输入localhost:8888/index.html
    //那么这里的url == /index.html 

    var file = documentRoot + url;
    console.log(file);

    fs.readFile(file , function(err,data){
    /*
        一参为文件路径
        二参为回调函数
            回调函数的一参为读取错误返回的信息，返回空就没有错误
            二参为读取成功返回的文本内容
    */
        if(err){
            res.writeHeader(404,{
                'content-type' : 'text/html;charset="utf-8"'
            });
            res.write('<h1>404错误</h1><p>你要找的页面不存在</p>');
            res.end();
        }else{
            var type = file.substr(file.lastIndexOf(".")+1,file.length)
            res.writeHeader(200,{'Content-type':"text/"+type+';charset="utf-8"'});	//在这里设置文件类型，告诉浏览器解析方式
            // 根据后缀名判断文件类型不太准确 可以使用mime模块 mime.getType(filePath)
            res.write(data);//将index.html显示在客户端
            res.end();
        }
    });
}).listen(8888);

console.log('服务器开启成功');


// // 手动设置content-type
// http.createServer(function(req,res){
// 	var path = req.url;	
// 	console.log("path: "+path)
// 	if(path == "/"){
// 		path = "/index.html";
// 	}
// 	sendFile(res,path);
// }).listen(8888)

// function sendFile(res,path){
//   var path = process.cwd()+'/dist'+path;
// 	fs.readFile(path,function(err,stdout,stderr){
// 		if(!err){
// 			var data = stdout;
// 			var type = path.substr(path.lastIndexOf(".")+1,path.length)
// 			res.writeHead(200,{'Content-type':"text/"+type+';charset="utf-8"'});	//在这里设置文件类型，告诉浏览器解析方式
// 			res.write(data);
// 		}
// 		res.end();
//   })
// }
```

### 解决方案二

- 使用mime模块，npm install mime.
- mime.getType(filePath)