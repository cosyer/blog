---
title: 实现trim的3种方法
tags:
  - 整理
copyright: true
comments: true
date: 2018-10-29 15:57:48
categories: 知识
photos:
top: 112
---

trim 方法 (字串) (JavaScript) 移除字串前后的空白字元以及行结束字元。
- 用法
string.trim()

1. 递归截取(不推荐)
```javascript
function trim(str){
// 加入类型判断 
if(str[0]===' '||str[str.length-1]===' '){
    if(str[0]===' '){
      str=str.substring(1,str.length)
    }
    if(str[str.length-1]===' '){
      str=str.substring(0,str.length-1)
    }
    trim(str)
  }else{
    console.log(str)
    return str
  }
}
```

2. 2次遍历记录不为空格的索引，最后截取
```javascript
function trim(str) {
    let start, end // 开始和结束为止 遍历记录不为空格的索引
    for (let i = 0; i < str.length; i++) {
        if (str[i] !== ' ') {
            start = i
            break
        }
    }
    for (let i = str.length - 1; i > 0; i--) {
        if (str[i] !== ' ') {
            end = i
            break
        }
    }
    return str.substring(start, end + 1)
}
```

3. 正则替换
```javascript
function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "")
}

// 1. value.toString()
// 2. String('123213') 
// 3. '' + value
```