---
title: Angular组件通讯
tags:
  - angular
copyright: true
comments: true
date: 2020-03-15 22:54:18
categories: Ng
photos:
---

组件通讯，意在不同的指令和组件之间共享信息。

## 父->子 input
```
// parent.html
<child [content]="i"></child>

// child.ts
@Input() content:string;
```

## 子->父 output
```
// parent.html
<child (changeNumber)="changeNumber($event)"></child>

// child.ts
@Output() changeNumber: EventEmitter<number> = new EventEmitter();

this.changeNumber(1);
```

---
<!-- more -->

## 子获取父实例
```
// child.ts
import { Component, Input, EventEmitter, Output,Host,Inject,forwardRef } from '@angular/core';

constructor( @Host() @Inject(forwardRef(() => ParentPage)) app: ParentPage) {
    app.content // 获取父实例的参数
}
```

## 父获取子实例
```
@ViewChild(ChildPage) child:ChildPage;

this.child.content //获取子实例的参数
```

## service 公共的
```
// parent.ts
import{myService}from '../child/myService'

实例化 service.i++;

// child.ts
service.i
```
记得在app.module.ts 加上providers

## EventEmitter(eventbus)
```
// eventbus.service.ts
import {Component,Injectable,EventEmitter} from '@angular/core';
@Injectable()
export class myService {
    change: EventEmitter<number>;

    constructor(){
        this.change = new EventEmitter();
    }
}

// parent.ts
service.change.emit('123');

// child.ts
service.change.subscribe((value:string)=>{})
```

## 订阅
```
// service
import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';

@Injectable()
export class myService {

    private Source = new Subject<any>();
    Status$ = this.Source.asObservable();
    StatusMission(message: any) {
        this.Source.next(message);
    }
}
// parent.ts
this.service.StatusMission('123');

// child.ts
this.subscription = service.Status$.subscribe(message => {});

ngOnDestroy() {
    this.subscription.unsubscribe();
}
```

以上七种组件与组件的通讯方式，可以选择应用于适合的场景。

顺带介绍下重载当前路由，在Angular中，当点击当前路由的链接时，默认是忽略的。

## 糟糕的解决方案
1. 跳出去，再跳回来。
2. 让浏览器刷新整个页面。
然而目前我们可以通过 `onSameUrlNavigation` 来解决这个问题。

`onSameUrlNavigation` 有两个值'reload'和'ignore'。默认为'ignore'。
- 定义当路由器收到一个导航到当前 URL 的请求时应该怎么做。 默认情况下，路由器将会忽略这次导航。但这样会阻止类似于 "刷新" 按钮的特性。 使用该选项可以配置导航到当前 URL 时的行为。

- 路由启动配置
```js
// app.routing.module.ts
imports: [RouterModule.forRoot(routes, {onSameUrlNavigation: 'reload'})]
```
`reload`并不会真正的执行加载工作，它只是重新触发了路由上的events事件循环。也可以动态配置reload
```js
this.router.onSameUrlNavigation = 'reload';
this.router.navigateByUrl(this.router.url).then(() => {
    this.router.onSameUrlNavigation = 'ignore';
});
```

- Route配置
一系列的路由事件在何种情况下应该被触发，此时我们需要配置 runGuardsAndResolvers 选项，它有3个可选值。
1. paramsChange 只有当参数变化时才重新启动，例如 'article/:id'，参数指的就是这里的id。

2. paramsOrQueryParamsChange 当参数或查询参数变化时重新启动。例如：'article/:category?limit=10，参数指 'category'，查询参数指'limit'；

3. always 无论何种情况都重新启动

```js
export const routes: Routes = [
   {
       path: 'article/:id',
       component: ArticleComponent,
       runGuardsAndResolvers: 'paramsChange',
   }
]
```

- 组件中处理路由事件
```js
export class ArticleComponent implement OnInit, OnDestroy {
   subscription: Subscription;
   constructor(private router: Router) { }
   ngOnInit() {
       this.subscription = this.router.events.pipe(
           filter(event => event instanceOf NavigationEnd)
       ).subscribe(_ => {...}) // 执行业务操作
   }
   ngOnDestroy() {
       this.subscription.unsubscribe(); // 不要忘记处理手动订阅
   }
}
```