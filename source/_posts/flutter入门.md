---
title: flutter入门
tags:
  - flutter
copyright: true
comments: true
date: 2018-12-25 01:22:30
categories: JS
top: 142
photos:
---

## 什么是flutter
> Flutter is Google’s mobile UI framework for crafting high-quality 
> native interfaces on iOS and Android in record time. Flutter works 
> with existing code, is used by developers and organizations around 
> the world,and is free and open source.

## 环境安装

### 下载SDK
https://flutter.io/docs/development/tools/sdk/archive?tab=macos#macos
或者
git clone -b beta https://github.com/flutter/flutter.git

### 镜像
添加环境变量 .bash_profile
```bash
export ANDROID_HOME=~/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PATH=/Users/chenyu/treasure/flutter/flutter/bin:$PATH
```

### 运行`flutter doctor`查看是否需要安装其它依赖项来完成安装：

该命令检查您的环境并在终端窗口中显示报告。Dart SDK已经在捆绑在Flutter里了，没有必要单独安装Dart。 仔细检查命令行输出以获取可能需要安装的其他软件或进一步需要执行的任务（以粗体显示）

## 创建项目
1. 在AndroidStudio安装Dart插件。启动studio，搜索flutter，自动安装Dart插件，完成后重启studio。 

2. Android Studio - File - New -New Flutter Project

### 文件入口
项目路径下的lib文件夹下的main.dart文件

```java
import 'package:flutter/material.dart'; //导包
void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialAp
}
```