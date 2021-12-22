---
title: \[1,2,3\]是JSON吗？
tags:
  - 知识
copyright: true
comments: true
date: 2018-11-21 11:17:20
categories: 知识
photos:
top: 120
---

A: “这个接口我传个 JSON 给你，格式是这样的 '[1, 2, 3]'”

B: “等下，这不是数组吗，JSON 应该有键啊，类似这样才行'{ "key": [1, 2, 3] }'”

A: “不，这就是 JSON 格式的数据”

B: “啊，是吗？”
你是否也有这样的疑惑？ wappalyzer chrome 网页分析插件

---

<!-- more -->

## 什么是 JSON

**JSON(JavaScript Object Notation) 是一种轻量级的数据交换格式。**

它仅仅是一种格式，就好比厨师脑中的食谱，这道菜有什么材料。而从原材料变成成品给顾客食用，这个过程食谱并没有实际参与，只是一个指导作用。

所以 JSON 也是不存在于我们的程序中，不存在任何地方，只是一个思维，存在我们脑海里。

这个思维，就是 JSON 这种格式应该包含哪些元素。

- “名称/值”对的集合
- 值的有序列表

> 所以"[1,2,3]"是符合 JSON 格式的数据结构的

> 但不能说[1, 2, 3]是一个 JSON，它在 javascript 中可以被转换为数组，也可以在其他语言中被转换为数组（如果有这种类型）。而之所以只有这两种，是因为大部分现代计算机语言都支持。
> 那[1, 2, undefined, 3]符合 JSON 格式吗？
> “既然结构要是计算机语言都支持的，那结构中的值也需要吧，而 undefined 是 javascript 独有的，其他语言并没有，所以不符合 JSON 格式。”

合法的 JSON 值有以下 6 种

- string
- number
- boolean
- null
- object
- array

```javascript
{
    "person": {
        "name": "cosyer",
        "age": 18,
        "skills": ["javascript", "html", "css"]
    },
    "happy": true
}
```

## JS 中的 JSON

在 JavaScript 中，如果在请求接口时要传递数据，我们往往会说“传一个 JSON”，从上面已经知道 JSON 只是一个格式，那我们传递的到底是什么？

```javascript
// 一个简单的 post 请求
const body = {
  name: "cosyer",
  age: 18,
};

fetch(
  "https://easy-mock.com/mock/5a1d30028e6ddb24964c2d91/business/api/login",
  {
    method: "POST",
    body,
  }
)
  .then((res) => res.json())
  .then((data) => {
    console.log(data);
  });
```

> 但实际上并没有将参数传递过去，即 Headers 中并不存在 Request Payload，需要将 body 使用 JSON.stringify()方法转换为一个字符串后，才能成功传递。
> body:JSON.stringify(body) or '{"name": 'cosyer',"age": 18}'

但两者还是有区别的

```javascript
const body = {
  name: "cosyer",
  skills: undefined,
};
console.log(JSON.stringify(body)); // {"name":"cosyer"}
// 格式化JSON
JSON.stringify(obj, null, "\t");
```

```javascript
const body = {
  name: "cosyer",
  skills: [undefined],
};
console.log(JSON.stringify(body)); // {"name":"cosyer","skills":[null]}。
```

### JSON.parse

> JSON.parse() 方法用来解析 JSON 字符串，构造由字符串描述的 JavaScript 值或对象。
> 可以用来判断某个字符串是否符合 JSON 格式

### 和 XML 的区别

- 数据体积方面
  JSON 相对于 XML 来讲，数据的体积小，传递的速度更快些。
- 数据交互方面
  JSON 与 JavaScript 的交互更加方便，更容易解析处理，更好的数据交互
- 数据描述方面
  JSON 对数据的描述性比 XML 较差
- 传输速度方面
  JSON 的速度要远远快于 XML

## 总结

JSON 是日常开发中最常使用的，但仅限于“会用”，实际上 JSON 的用途已经不局限在“数据交换”，NoSQL、配置文件也有 JSON 的身影，深入了解是有必要的，毕竟看起来这么“简单”。
