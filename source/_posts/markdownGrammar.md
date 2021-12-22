---
title: 如何使用 markdown 语法写博客
tags:
  - markdown
copyright: true
comments: true
date: 2018-04-07 07:25:19
categories: 工具
top: 104
photos:
---

{% fi http://cdn.mydearest.cn/blog/images/markdown.png, Markdown, Markdown %}

{% note info %}

{% endnote %}

{% centerquote %}

{% endcenterquote %}

# 标题 1

## 标题 2

_斜体_
**粗体**
**_粗斜体_**<br/>
~~删除线~~
<u>下划线文本</u>

1. I
2. Love
3. You

- 点

* Foo
* Bar

---

<!-- more -->

分隔线

---

---

---

---

> 一级引用
>
> > 二级引用

`#include<iostream>`

```
#include <iostream>
int main()
{
return 0;
}
```

```
#include <iostream>
int main()
{
return 0;
}
```

| 标题             |       标题       |             标题 |
| :--------------- | :--------------: | ---------------: |
| 居左测试文本     |   居中测试文本   |     居右测试文本 |
| 居左测试文本 1   |  居中测试文本 2  |   居右测试文本 3 |
| 居左测试文本 11  | 居中测试文本 22  |  居右测试文本 33 |
| 居左测试文本 111 | 居中测试文本 222 | 居右测试文本 333 |

- [x] 已完成事项
- [ ] 待办事项 1
- [ ] 待办事项 2

### 反斜杠

`Markdown` 可以利用反斜杠来插入一些在语法中有其它意义的符号，例如：如果你想要用星号加在文字旁边的方式来做出强调效果（但不用 `<em>` 标签），你可以在星号的前面加上反斜杠：

```
\*literal asterisks\*
```

效果如下：

\*literal asterisks\*

`Markdown` 支持以下这些符号前面加上反斜杠来帮助插入普通的符号：

```
  \   反斜线
  `   反引号
  *   星号
  _   底线
  {}  花括号
  []  方括号
  ()  括弧
  #   井字号
  +   加号
  -   减号
  .   英文句点
  !   惊叹号
```

登录[百度](http://www.baidu.com)
![Teddy Bear](http://img2.everychina.com/img/d7/f7/1b580dfa9315111397ef93fd24ea-250x250c1-77f7/love_valentine_plush_teddy_bear.jpg)

### 徽章

![](https://img.shields.io/badge/github-cosyer-brightgreen.svg)

### 折叠

<details>
<summary>点我打开关闭折叠</summary>
 折叠内容
 <ul>
     <li>1</li>
     <li>2</li>
     <li>3</li>
 </ul>
</details>
