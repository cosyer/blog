---
title: chrome插件扩展程序开发指南
tags:
  - 整理
copyright: true
comments: true
date: 2018-11-26 14:30:10
categories: 知识
photos:
top: 124
---

### 什么是chrome extensions
Chrome Extensions，中文名叫 “Chrome浏览器扩展程序”。引用官方文档的描述，翻译一下就是 “可以修改和增强浏览器功能的 H5 小程序”。
它的入口在浏览器窗口的右上角，地址栏的最右边

---
<!-- more -->

### 入门
#### manifest.json
manifest.json 是整个插件扩展程序中最重要的一个描述文件，这个 json 格式的文件包含了你整个扩展程序的一些重要描述，比如 “扩展程序名称”、“扩展程序图标”、“权限申请” 等。

```json
{
  // Required
  "manifest_version": 2, // manifest 版本号，这里都写 2 就好了，从 Google Chrome 18 开始，就开始升级到 2 版本了
  "name": "My Extension",
  "version": "1.0.0", // 扩展程序版本，这个是自定义的，建议参考 semver 规范(http://semver.org/)

  // Recommended
  "default_locale": "zh", // 默认语言，具体可以看 i18n 文档(https://developer.chrome.com/extensions/i18n)
  "description": "A plain text description", // 项目描述
  "icons": { // icon，不同的位置支持不同大小的 icon，具体看文档(https://developer.chrome.com/extensions/manifest/icons)
    "128": "icons/icon_128.png",
    "48": "icons/icon_48.png",
    "16": "icons/icon_16.png"
  },

  // Pick one (or none)
  "browser_action": { // 多数都是使用这个，插件扩展程序针对的是浏览器行为（图标是在地址栏外面）
    "default_icon": "icons/24.png", // 最佳大小为19*19，地址栏上的插件扩展程序的 icon（一般作为主入口）
    "default_popup": "popup.html", // 点击插件扩展程序 icon 后弹出来的窗口的主页面 html
    "default_title": "extentsions demo" // 当鼠标放到扩展程序图标上时显示的文字
  },
  "page_action": { // 插件扩展程序针对的是页面行为（图标是在地址栏里面的）
    ...
  },

  // Optional
  "author": ...,
  "automation": ...,
  "background": {
    // Recommended
    "persistent": false
  },
  "background": {
    "scripts": ["eventPage.js"],
    "persistent": false
  },
  "chrome_settings_overrides": {...},
  "chrome_ui_overrides": {
    "bookmarks_ui": {
      "remove_bookmark_shortcut": true,
      "remove_button": true
    }
  },
  "chrome_url_overrides": {...},
  "commands": {...},
  "content_capabilities": ...,
  "content_scripts": [{...}],
  "content_security_policy": "policyString",
  "converted_from_user_script": ...,
  "current_locale": ...,
  "declarative_net_request": ...,
  "devtools_page": "devtools.html",
  "event_rules": [{...}],
  "externally_connectable": {
    "matches": ["*://*.example.com/*"]
  },
  "file_browser_handlers": [...],
  "file_system_provider_capabilities": {
    "configurable": true,
    "multiple_mounts": true,
    "source": "network"
  },
  "homepage_url": "http://path/to/homepage",
  "import": [{"id": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}],
  "incognito": "spanning, split, or not_allowed",
  "input_components": ...,
  "key": "publicKey",
  "minimum_chrome_version": "versionString",
  "nacl_modules": [...],
  "oauth2": ...,
  "offline_enabled": true,
  "omnibox": {
    "keyword": "aString"
  },
  "optional_permissions": ["tabs"],
  "options_page": "options.html",
  "options_ui": {
    "chrome_style": true,
    "page": "options.html"
  },
  "permissions": ["tabs"],
  "platforms": ...,
  "plugins": [...],
  "requirements": {...},
  "sandbox": [...],
  "short_name": "Short Name",
  "signature": ...,
  "spellcheck": ...,
  "storage": {
    "managed_schema": "schema.json"
  },
  "system_indicator": ...,
  "tts_engine": {...},
  "update_url": "http://path/to/updateInfo.xml",
  "version_name": "aString",
  "web_accessible_resources": [...]
}
```

#### 学做一个demo
1. manifestjson(该文本文件需要用UTF8字符集保存)
```json
{
  "name": "第一个Chrome插件",
  "manifest_version": 2,
  "version": "1.0",
  "description": "我的第一个Chrome插件，还不错吧",
  "browser_action": {
    "default_icon": "1.png"
  },
  "content_scripts": [
    {
      "matches": ["https://www.baidu.com/"],
      "js": ["test.js"]
    }
  ]
}
```

2. test.js
```javascript
alert("Hello World");
document.body.style.backgroundColor="gray";
```
content_scripts是运行在打开页面的脚本，可以拿到整个页面的DOM对象，所以可以利用该脚本对页面进行操作。

3. 添加图片1.png

4. 打开chrome，打开菜单，找到扩展程序选项更多工具>扩展程序路径下。点击加载已解压的扩展程序，添加文件夹就OK啦！


### 常用api 
- bookmarks: 书签管理接口，可以对浏览器的书签进行增删改查等管理
- tabs: 标签管理接口，可以对浏览器的标签进行增删改查等管理
- contextMenus: 右键菜单管理
- cookies: 浏览器 cookie 的管理
- notifications: 消息通知
- desktopCapture: 可针对 “窗口” 或者 ”标签“ 的截图接口
- i18n: 国际化（多语言支持）

### 程序发布和分享
打包扩展程序，第一次打包只需要设置根目录，打包完成后会生成.crx和.pem密钥文件(版本的迭代需要此文件，否则则会生成新的程序文件)，将.crx文件发给其他人拖入扩展程序页面即可安装。

### 发布到chrome商店
当一切准备就绪，就可以准备发布上线了，Chrome 有个官方的插件扩展程序市场，还自带了发布和更新等一体化管理的流程，非常方便。
传送门：[Chrome商店dashboard](https://chrome.google.com/webstore/developer/dashboard)

注意，上传的是 zip 而不是生成的 crx 文件，具体参考：[https://developer.chrome.com/webstore/publish](https://developer.chrome.com/webstore/publish)

### 常见问题
1. 引入外部 js 时报 Refused to load the script 的问题
```javascript
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
```
解决方案：修改 content_security_policy，把对应的域名加上去即可，比如以上的问题可以解决：

```json
{
    "content_security_policy": "https://code.jquery.com"
}
```
> 以上表示允许 https://code.jquery.com 域名下的外部 js 的引入。
2. Chrome 插件扩展程序是开源的方式安装的，可以去安装目录通过扩展程序 ID 来找到源码。
正常情况下，Chrome 插件扩展程序的默认安装目录如下：

- Windows XP：C:\Documents and Settings\用户名\Local Settings\Application Data\Google\Chrome\User Data\Default\Extensions
- Windows7：C:\Users\用户名\AppData\Local\Google\Chrome\User Data\Default\Extensions
- Mac：~/Library/Application Support/Google/Chrome/Default/Extensions
- Ubuntu：~/.config/google-chrome/Default/Extensions
如果在这些不同操作系统中的默认安装位置没找到插件，那么还有一种方法可以查询到。

地址栏访问 chrome:version
找到 “个人资料路径”，该路径下的 extensions 文件夹就是 Chrome 插件扩展程序的安装路径了
安装路径下的插件扩展程序，是以 ID 为目录区分的
地址栏访问 chrome://extensions/，可以查看每个插件扩展程序的 ID

### 高级教程-chrome插件合集
[项目地址](https://github.com/cosyer/chrome-extensions)

### 参考资料
[官方文档](https://developer.chrome.com/extensions/overview)