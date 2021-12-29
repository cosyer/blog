---
title: macvscode更新失败：Permissiondenied解决办法
tags:
  - 工具
copyright: true
comments: true
date: 2019-04-09 23:15:24
categories: 工具
photos:
---

## 场景 -- mac vscode 不能安装更新

> Could not create temporary directory: Permission denied

## 原因分析

mac 下`/Users/username/Library/Caches/`用户文件不一样，root 和 username

导致

> drwxr-xr-x 6 username staff 204B Jan 17 20:33 com.microsoft.VSCode
> drwxr--r-- 2 root staff 68B Dec 17 13:51 com.microsoft.VSCode.ShipIt

## 解决方案

```
// 1. 关闭vscode

// 2. 这一步是需要输入密码的
sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/

// 3. 这一步是不需要输入密码的, 如果不进行第一步，第二步会报错
sudo chown $USER ~/Library/Caches/com.microsoft.VSCode.ShipIt/*

// 4. 更新xattr
xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app
```

## 重新安装更新 完成 😁

## Mac 版本下的 Chrome，双击 html 文件打不开

原因其实是因为在 Mac OS 系统下，在 Finder(访达)中做任何操作，文件都会不可避免的被附加上一个特有的拓展属性(extend attributes)，可以通过终端命令 ls -l 查看，这些文件通常都会有@作为标记，因此，由于产品的原型是由 Axure 来制作的，然后导出了 tar 的压缩包，因此我们解压之后，通常都不能直接在浏览器打开！

怎么解决这种问题呢？

我们可以清除掉这个属性(extend attributes)！

1. 可以针对单个文件做清除操作（filename 就是要文件名，例如：index.html）

```js
xattr -c filename
```

2. 也可以针对整个目录做清除操作（directory 就是目录名，例如：content）

```js
xattr -rc directory
```

## 重启电池 smc

```
将 Mac 关机。
在内建键盘上，按住以下所有按键。Mac 可能会开机。
键盘左侧的 Control
键盘左侧的 Option (Alt)
键盘右侧的 Shift
按住全部三个按键 7 秒钟，然后在不松开按键的情况下按住电源按钮。如果 Mac 处于开机状态，它将在您按住这些按键时关机。
继续按住全部四个按键 7 秒钟，然后松开这些按键。
等待几秒钟，然后按下电源按钮以将 Mac 开机。
```

## vscode 插件

1. 韭菜盒子
2. Bookmarks
3. Chinese
4. Code Spell Checker
5. ESlint
6. filesize
7. Live Server
8. Path Intellisense
9. Prettier
10. Qwerty Learner
11. TODO Tree
12. Vetur
13. Tubor Console Log

## mac vscode 常用快捷键

1. 新建文件 cmd + n
2. 新建窗口 cmd + shift + n
3. 分屏 cmd + 数字
4. 切换文件 option + 数字 、ctrl + tab
5. 关闭当前窗口 cmd + w
6. 关闭所有窗口 cmd + k + w
7. 隐藏显示侧边栏 cmd + b
8. 文件重命名 选中文件回车或者 F2
9. 注释 cmd + /
10. 多行注释 option + shift + a
11. 多行编辑 option + 左键
12. 终端 cmd + ~
13. 查找文件 cmd + p
14. 选中当前单词 cmd + d
15. 选中所有单词 cmd + shift + l
16. 查找 cmd + f
17. 项目查找 cmd + shift + f
18. 项目替换 cmd + shift + h
19. 移动当前行 option + 箭头方向
20. 当前行上方插入一行 cmd + shift + enter
21. 选中部分 shift + 箭头方向
22. 删除当前行 cmd + delete / cmd + shift + k
23. 移动到单词的最前面 option + ←
24. 移动到单词最末尾 option + →
25. 移动到当前行的最前面 cmd + ←
26. 移动到当前行最末尾 cmd + →
27. 跳转文件第一行或者最后一行 cmd + ↑ / cmd + ↓
28. 格式化 option + shift + f
29. 命令选择 cmd + shift + p
30. 选中当前行 左键单击行号
31. 跳转对应行 ctrl + 行号
32. 向下复制一行 shift + option + ↓
