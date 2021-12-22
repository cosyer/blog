---
title: 动手实现redux
date: 2018-10-03 19:24:18
tags:
  - redux
  - react
categories: JS
copyright: true
comments: true
top: 106
photos:
---

概念：

- 一个 app 只有一个 store，一个 store 管理着一个全局 state 含有以下方法
  - getState: 获取 state；
  - dispatch: 触发 action, 更新 state；
  - subscribe: 订阅数据变更，注册监听器；
- createStore 传入 reducer，返回 getState, dispatch, subscribe
- action 是一个至少有 type 这个键的对象，可以写一个 creactAction 函数去 return 生成 action 对象
- createStore.dispatch(action) 根据 action 这个对象去更新 state
- dispatch 是一个函数，内部又将执行 reducer 函数
- reducer 也是一个函数，传入 state,action, 输出一个新的 state . (switch case return…)
  - 遵守数据不可变，不要去直接修改 state，而是返回出一个 新对象；
  - 默认情况下需要 返回原数据，避免数据被清空；
  - 最好设置 初始值，便于应用的初始化及数据稳定；

![redux](http://cdn.mydearest.cn/blog/images/redux.png)

---

<!-- more -->

```html
<div id="title"></div>
<input type="button" id="changeTheme" value="变成蓝色主题" />
```

```javascript
// 实现createStore 传入reducer
function createStore(reducer){
    // 存储数据
    let state = null
    // 订阅列表
    const listenerList=[]
    // 增加订阅
    const subscribe=(listener)=>listenerList.push(listener)
    // 返回state
    const getState=()=>state
    // dispatch
    const dispatch=(action)=>{
      // 新的state
      state=reducer(state,action)
      // 遍历执行
      listenerList.forEach(item)=>item()
    }
    // 初始化state
    dispatch({})
    return {getState,subscribe,dispatch}
}

// 实现reducer
function reducer(state,action){
  if(!state){
    return {
      title:'红色',
      color:'red'
    }
  }
  switch(action.type){
    case 'UPDATE_TITLE':
    return {...state,title:action.title}
    case 'UPDATE_COLOR':
    return {...state,color:action.color}
    default:return state
  }
}

// 传入reducer生成store
const store = createStore(reducer)

// 渲染代码
function renderDom(state){
  const titleDOM = document.getElementById('title');
  titleDOM.innerHTML = state.title;
  titleDOM.style.color = state.color;
}

// 监听数据变化重新渲染页面
store.subscribe(() => renderDom(store.getState()));// 让每次dispatch时都会执行传入的这个函数，渲染页面

// 首次渲染页面
renderDom(store.getState());

// createAction
// const MAIN_PAGE_TYPE = 'mainPage'
// export function getMainPage({ name }) {
//   return {
//     type: MAIN_PAGE_TYPE,
//     payload: {
//       name
//     }
//   }
// }

// action
const updateThemeName = () => ({
  type: 'UPDATE_TITLE',
  title: '蓝色'
});
const updateThemeColor = () => ({
  type: 'UPDATE_COLOR',
  color: 'blue'
});

// 绑定事件
document.getElementById('changeTheme').onclick = () => {
  store.dispatch(updateThemeName());
  store.dispatch(updateThemeColor());
};
```

## 实现`bindActionCreator`

```js
// 将actionCreator转化成dispatch形式
function bindActionCreator(actionCreator, dispatch) {
  return function () {
    return dispatch(actionCreator.apply(this, arguments));
  };
}

// 参数actionCreators是一个对象或者函数，dispatch即store.dispatch

export default function bindActionCreators(actionCreators, dispatch) {
  // 如果传入是函数，直接返回一个包裹dispatch的函数
  if (typeof actionCreators === "function") {
    return bindActionCreator(actionCreators, dispatch);
  }
  // 传入参数不符合规范情况
  if (typeof actionCreators !== "object" || actionCreators === null) {
    throw new Error(
      `bindActionCreators expected an object or a function, instead received ${
        actionCreators === null ? "null" : typeof actionCreators
      }. ` +
        `Did you write "import ActionCreators from" instead of "import * as ActionCreators from"?`
    );
  }
  // 传入参数是Object的情况，遍历对象，根据相应的key，生成包裹dispatch的函数
  const keys = Object.keys(actionCreators);
  const boundActionCreators = {};
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i];
    const actionCreator = actionCreators[key];
    if (typeof actionCreator === "function") {
      boundActionCreators[key] = bindActionCreator(actionCreator, dispatch);
    }
  }
  // 返回每个value都是包裹dispatch函数的对象
  return boundActionCreators;
}
```
