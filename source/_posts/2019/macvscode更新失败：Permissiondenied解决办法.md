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

## 场景 -- mac vscode不能安装更新
> Could not create temporary directory: Permission denied

## 原因分析
mac下`/Users/username/Library/Caches/`用户文件不一样，root和username

导致

> drwxr-xr-x   6 username  staff   204B Jan 17 20:33 com.microsoft.VSCode
> drwxr--r--   2 root    staff    68B Dec 17 13:51 com.microsoft.VSCode.ShipIt

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

## 重新安装更新 完成😁

## Mac版本下的Chrome，双击html文件打不开
原因其实是因为在Mac OS系统下，在Finder(访达)中做任何操作，文件都会不可避免的被附加上一个特有的拓展属性(extend attributes)，可以通过终端命令ls -l查看，这些文件通常都会有@作为标记，因此，由于产品的原型是由Axure来制作的，然后导出了tar的压缩包，因此我们解压之后，通常都不能直接在浏览器打开！

怎么解决这种问题呢？

我们可以清除掉这个属性(extend attributes)！

1. 可以针对单个文件做清除操作（filename就是要文件名，例如：index.html）
```js
xattr -c filename
```

2. 也可以针对整个目录做清除操作（directory就是目录名，例如：content）
```js
xattr -rc directory
```

## 重启电池smc
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
