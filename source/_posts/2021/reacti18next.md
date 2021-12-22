---
title: reacti18next实践
tags:
  - react
copyright: true
comments: true
date: 2021-2-23 14:04:11
categories: JS
top: 107
photos:
---

## 安装依赖

```
yarn add react-i18next i18next i18next-browser-languagedetector
```

## 配置多语言 JSON

```js
// en-us.json
{
  "common": {
    "cancel": "Cancel"
  },
  "join": "join",
  "retry": "Retry after {{timer}}s",
  "choosePerson": "Selected <0>{{num}}</0> person"
}

// zh-cn.json
{
  "common": {
    "cancel": "取消"
  },
  "join": "加入",
  "retry": "{{timer}}秒后重试",
  "choosePerson": "选择人数<0>{{num}}</0>, 没选择人数<1>{{num1}}</1>"
}

// 变量需要通过{{}}格式包裹，组件需要通过<数字></数字>格式包裹
```

## 定义 i18n.tsx

```tsx
import LanguageDetector from "i18next-browser-languagedetector";
import i18n from "i18next";
import enUsTrans from "../public/locales/en-us.json";
import zhCnTrans from "../public/locales/zh-cn.json";
import { initReactI18next } from "react-i18next";

i18n
  .use(LanguageDetector) //嗅探当前浏览器语言
  .use(initReactI18next) //init i18next
  .init({
    //引入资源文件
    resources: {
      en: {
        translation: enUsTrans,
      },
      zh: {
        translation: zhCnTrans,
      },
    },
    //选择默认语言，选择内容为上述配置中的key，即en/zh
    fallbackLng: "en",
    debug: false,
    interpolation: {
      escapeValue: false, // not needed for react as it escapes by default
    },
  });

export default i18n;
```

## 主文件引用

```tsx
import React from "react";
import App from "next/app";
import "../config/i18n";

class MyApp extends App {
  render() {
    const { Component, pageProps } = this.props;
    return <Component {...pageProps} />;
  }
}

export default MyApp;
```

## 使用方式

```tsx
import React from "react";
import { NextPage } from "next";
import { useTranslation, Trans, Translation } from "react-i18next";
// import i18n from "i18next";

const Home: NextPage = () => {
  let { t, i18n } = useTranslation();

  return (
    <div>
      <div>
        <button
          onClick={() =>
            i18n.changeLanguage(i18n.language == "en" ? "zh" : "en")
          }
        >
          {i18n.language == "en" ? "zh" : "en"}
        </button>
      </div>

      {/* 3种常用使用方式 */}
      <h1>{t("home")}</h1>
      <h2>
        <Trans>home</Trans>
      </h2>
      <Translation>{(t) => <h3>{t("home")}</h3>}</Translation>

      <h1>
        {i18n.t("common.cancel")}
        <div>{i18n.t("retry", { retry: 3 })}</div>
        <Trans
          i18nKey={"choosePerson"}
          values={{ num: 3, num1: 4 }}
          components={[<div>content</div>, <span>content</span>]}
        ></Trans>
      </h1>
    </div>
  );
};

export default Home;
```
