---
title: JavaScript停止冒泡和阻止浏览器默认行为
tags:
  - 前端
copyright: true
comments: true
date: 2018-06-18 19:16:48
categories: JS
top: 107
photos:
---

## 防止冒泡

w3c的方法是e.stopPropagation()，IE则是使用e.cancelBubble = true

stopPropagation也是事件对象(Event)的一个方法，作用是阻止目标元素的冒泡事件，但是会不阻止默认行为。什么是冒泡事件？如在一个按钮是绑定一个”click”事件，那么”click”事件会依次在它的父级元素中被触发 。stopPropagation就是阻止目标元素的事件冒泡到父级元素。

---
<!-- more -->

## 阻止默认行为

w3c的方法是e.preventDefault()，IE则是使用e.returnValue = false

preventDefault它是事件对象(Event)的一个方法，作用是取消一个目标元素的默认行为。既然是说默认行为，当然是元素必须有默认行为才能被取消，如果元素本身就没有默认行为，调用当然就无效了。什么元素有默认行为呢？如链接`<a>`，提交按钮`<input type=”submit”>`等。当Event 对象的 cancelable为false时，表示没有默认行为，这时即使有默认行为，调用preventDefault也是不会起作用的。

```javascript
 <!DOCTYPE html>
<html>
<head>
	<title></title>
</head>
<body>
<div id="box" style="width: 300px;height: 300px;background: pink;">
	<input type="button" name="按钮" value="按钮" id="btn">
</div>
<script type="text/javascript">
	var box1=document.getElementById("box");
	var btn1=document.getElementById("btn");
	btn1.onclick=function(e){
		alert("按钮");
		//阻止冒泡；
		var e=e|| window.event;
		//w3c取消冒泡
		e.stopPropagation();
		//ie取消冒泡
		//判断他现在的状态，然后给他赋值true，
		if(typeof e.cancelBubble=='undefined'){
			e.stopPropagation();
		}else{
			e.cancelBubble=true;
		}
	}
	box1.onclick=function(){
		alert("div");
	}
	document.body.onclick=function(){
		alert("body");
	}
	document.documentElement.onclick=function(){
		alert("html");
	}
	document.onclick=function(){
		alert("document");
	}
</script>
</body>
</html>
```