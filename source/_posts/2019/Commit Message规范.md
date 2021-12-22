---
title: Commit Message规范
tags:
  - 杂谈
copyright: true
comments: true
date: 2019-08-13 01:55:40
categories: 杂谈
photos:
---

在团队开发中，commit message（提交说明）就如同代码注释一样重要。良好的 commit message 能让团队中的其他成员对你的每次提交的目的、

涉及的代码范围及作用一目了然，方便日常的查询和帮助其他成员更好的帮你 Code Review，必要时还能方便的生成 Change log。

---

<!--more-->

## Commit message 格式

```js
// 格式：<type>(<scope>): <subject>
```

1. type：
   `必填` 用于说明 commit 的类型。总共 7 个标识：

- feat： 新增 feature
- fix: 修复 bug
- docs: 仅仅修改了文档，比如 README, CHANGELOG, CONTRIBUTE 等等
- style: 仅仅修改了空格、格式缩进、变量名等等，不改变代码逻辑
- refactor: 代码重构，没有加新功能或者修复 bug
- perf: 优化相关，比如提升性能、体验
- test: 测试用例，包括单元测试、集成测试等
- chore: 改变构建流程、或者增加依赖库、工具等
- revert: 回滚到上一个版本

2. scope：
   `可选` scope 用于说明 commit 影响的范围，比如数据层、控制层、视图层或者目录甚至文件等等，视项目不同而不同。

3. subject：
   `必填` subject 是 commit 目的的简短描述，不超过 50 个字符。

- 约定好 commit message 的语言，对我们来说最好使用中文
- 最好以动词开头（如使用英文请使用第一人称现在时，并且第一个字母小写）
- `<scope>`之后的冒号后面留一个英文输入法的空格
- 结尾不加句号或其他标点符号
- 若此次 commit 是解决某个 issue 应该在行末尾注明并加链接，如：...(#101)

## git commit 中使用 emoji

```js
git commit -m ":tada: Initialize Repo"
```

| emoji           | emoji 代码                 | Commit 说明           |
| :-------------- | :------------------------- | :-------------------- |
| 🎨 (调色板)     | :art:                      | 改进代码结构/代码格式 |
| ⚡️ (闪电)      | :zap:                      | 提升性能              |
| 🐎 (赛马)       | :racehorse:                | 提升性能              |
| 🔥 (火焰)       | :fire:                     | 移除代码或文件        |
| 🐛 (bug)        | :bug:                      | 修复 bug              |
| 🚑 (急救车)     | :ambulance:                | 重要补丁              |
| ✨ (火花)       | :sparkles:                 | 引入新功能            |
| 📝 (铅笔)       | :pencil:                   | 撰写文档              |
| 🚀 (火箭)       | :rocket:                   | 部署功能              |
| 💄 (口红)       | :lipstick:                 | 更新 UI 和样式文件    |
| 🎉 (庆祝)       | :tada:                     | 初次提交              |
| ✅ (白色复选框) | :white_check_mark:         | 增加测试              |
| 🔒 (锁)         | :lock:                     | 修复安全问题          |
| 🍎 (苹果)       | :apple:                    | 修复 macOS 下的问题   |
| 🐧 (企鹅)       | :penguin:                  | 修复 Linux 下的问题   |
| 🏁 (旗帜)       | :checked_flag:             | 修复 Windows 下的问题 |
| 🔖 (书签)       | :bookmark:                 | 发行/版本标签         |
| 🚨 (警车灯)     | :rotating_light:           | 移除 linter 警告      |
| 🚧 (施工)       | :construction:             | 工作进行中            |
| 💚 (绿心)       | :green_heart:              | 修复 CI 构建问题      |
| ⬇️ (下降箭头)   | :arrow_down:               | 降级依赖              |
| ⬆️ (上升箭头)   | :arrow_up:                 | 升级依赖              |
| 👷 (工人)       | :construction_worker:      | 添加 CI 构建系统      |
| 📈 (上升趋势图) | :chart_with_upwards_trend: | 添加分析或跟踪代码    |
| 🔨 (锤子)       | :hammer:                   | 重大重构              |
| ➖ (减号)       | :heavy_minus_sign:         | 减少一个依赖          |
| 🐳 (鲸鱼)       | :whale:                    | Docker 相关工作       |
| ➕ (加号)       | :heavy_plus_sign:          | 增加一个依赖          |
| 🔧 (扳手)       | :wrench:                   | 修改配置文件          |
| 🌐 (地球)       | :globe_with_meridians:     | 国际化与本地化        |
| ✏️ (铅笔)       | :pencil2:                  | typo                  |

## Commit message 检查工具

1. [commitizen](https://github.com/commitizen/cz-cli): 一个撰写合格 Commit message 的工具；

2. [validate-commit-msg](https://github.com/kentcdodds/validate-commit-msg): 用于检查 Node 项目的 Commit

message 是否符合格式。
