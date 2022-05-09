---
title: vue面试题记录
tags:
  - vue
  - 面试
copyright: true
comments: true
date: 2020-04-23 00:10:18
categories: Vue
photos:
---

### vue 双向绑定的原理

采用数据劫持结合发布者-订阅者模式的方式，通过 Object.defineProperty()来劫持各个属性的 setter，getter，在数据变动时发布消息给订阅者，触发相应的监听回调，实现视图刷新。

具体流程：
Vue 中先遍历 data 选项中所有的属性（发布者）用 Object.defineProperty 劫持这些属性将其转为 getter/setter。读取数据时候会触发 getter。修改数据时会触发 setter。

然后给每个属性对应 new Dep()，Dep 是专门收集依赖、删除依赖、向依赖发送消息的。先让每个依赖设置在 Dep.target 上，在 Dep 中创建一个依赖数组，先判断 Dep.target 是否已经在依赖中存在，不存在的话添加到依赖数组中完成依赖收集，随后将 Dep.target 置为上一个依赖。

组件在挂载过程中都会 new 一个 Watcher 实例。这个实例就是依赖（订阅者）。Watcher 第二参数是一个函数，此函数作用是更新且渲染节点。在首次渲染过程，会自动调用 Dep 方法来收集依赖，收集完成后组件中每个数据都绑定上该依赖。当数据变化时就会在 setter 中通知对应的依赖进行更新。在更新过程中要先读取数据，就会触发 Wacther 的第二个函数参数。一触发就再次自动调用 Dep 方法收集依赖，同时在此函数中运行 patch（diff 运算)来更新对应的 DOM 节点，完成了双向绑定。

- 每一个组件默认都会创建一个 Watcher，自定义的 watch 和 computed 方法也会创建 Watcher

### Object.defineProperty()实现双向绑定的缺点

1. 只能监听某个属性，不能监听整个对象
2. 需要使用 for in 遍历对象属性绑定监听
3. 不能监听数组，需要重写数组方法进行特异性操作
4. 会污染原对象

---

<!--more-->

### v-show 和 v-if 有什么区别

- v-if（初始化不会渲染）
  v-if 是真正的条件渲染，因为它会确保在切换过程中条件块内的事件监听和子组件适当地被销毁和重建，也是惰性的，如果在初始渲染条件为假时，则什么也不做——直到条件第一次变为真时才开始渲染条件块，能用在<template>上。

- v-show（初始化会渲染）
  v-show 就简单得多，不管初始条件是什么，元素总是会被渲染，并且只是简单地基于 css 的 display 进行切换。

所以，v-if 适用于切换不频繁的场景，v-show 适用于切换频繁的场景，不能用在<template>上。

### class 和 style 如何动态绑定

class 可以通过对象语法和数组语法进行动态绑定：

- 对象语法

```js
<div v-bind:class="{active: isActive, 'text-danger': hasError }"></div>
data: {
    isActive: true,
    hasError: false
}
```

- 数组语法

```js
<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>
data: {
    activeClass: 'active',
    errorClass: 'text-danger'
}
```

style 也可以通过对象语法和数组语法进行动态绑定

### 理解 vue 里的单向数据流

所有的 prop 都使得其父子 prop 之间形成一个单向下行绑定：父级 prop 的更新会向下流动到子组件中，但是反过来不行，这样会防止从子组件意外改变父级组件的状态，从而导致你的应用的数据流难以解释.

额外地，每次父级组件发生更新时，子组件中的所有 prop 都会刷新为最新的值，这意味着你不应该在一个子组件内部改变 prop，如果你这样做了，vue 会在浏览器的控制台发出警告，子组件想修改时，只能通过$emit 派发一个自定义事件，父组件接收到后，由父组件修改.

> 双向数据流是指数据从父级向子级传递数据，子级可以通过一些手段改变父级向子级传递的数据。

### computed 和 watch 的区别和运用场景

- computed：是计算属性，依赖其他属性值，并且 computed 的值有缓存，只有它依赖的属性值发生改变时下一次获取 computed 的值时候才会重新计算 computed 的值。避免在模板中放入太多的逻辑，导致模板过重且难以维护。当未发生改变时，则会返回上一次的数据。

- watch：更多的是观察作用，类似于某些数据的监听回调，每当监听的数据发生变化时都会执行回调进行后续操作。

- methods: 每次渲染时都需要重新执行。

运用场景：

- 当我们需要进行数值计算，并依赖于其他数据时，应该使用 computed，因为可以利用 computed 的缓存特性，避免每次获取值时都要重新计算。

- 但我们需要在数据变化时执行异步或开销较大的操作时应该使用 watch，使用 watch 选项允许我们执行异步操作，限制我们执行该操作的频率，并在我们得到最终结果前，设置中间状态，这些都是计算属性无法做到的。

### 直接给一个数组项赋值，vue 能检测到吗

- 由于 js 的限制(引用类型)，vue 不能检测到以下数组的变动(对象属性的添加和删除)：

- 当你利用索引直接设置一个数组项时，例如 vm.item[indexOfItem] = newValue
- 当你修改数组的长度时，例如 vm.items.length = newLength

为了解决第一个问题，vue 提供了以下操作方法：

```js
Vue.set(vm.items, indexOfItem, newValue)

Vue.$set(vm.items, indexOfItem, newValue)

Vue.$set(this.data,”key”,value) // 动态添加单个属性

// 动态添加多个属性
this.obj = Object.assign({}, this.obj, {
  age: 18,
  name: 'Chocolate',
})

Vue.items.splice(indexOfItem, 1, newValue)
```

为了解决第二个问题，vue 提供了以下操作方法：

```js
vm.items.splice(newLength);
```

- Vue 是不能检测对象属性的添加或删除

```js
data() {
    return {
        obj:{
            name:'Vue'
        }
    };
},
mounted() {
    this.name = 'zs' // 不是响应式的
    this.$set(this.obj,'name','lisi') //响应式 解决添加
    // 用Object.assign来解决第二种情况。解决对象的删除
    // Vue.delete
},
```

### delete 和 Vue.delete 的区别

delete 只是被删除的元素变成了 empty/undefined，其他元素的键值还是不变的。而 Vue.delete 直接删除了数组，改变了数组的键值。

### vue 生命周期的理解（10 个）

- 生命周期是什么(创建到销毁的过程)
  vue 实例有一个完整的生命周期，也就是从开始创建，初始化数据，编译模板，挂载 dom->渲染更新->渲染卸载等一些过程，我们称这是 vue 的生命周期

- 各个生命周期的作用

  - beforeCreate：组件被创建之初，组件的属性生效之前
  - created：组件实例已经完全创建，属性也绑定，但是真实的 dom 还没有生成，$el 还不能用(vue 实例的数据对象 data 有了，el 和数据对象 data 都为 undefined，还
    未初始化。)
  - beforeMount：在挂载开始之前被调用，相关的 render 函数首次被调用
  - mounted：el 被新创建的 vm.$el 替换，并挂载到实例上去后调用该钩子
  - beforeUpdate：组件数据更新之前调用，发生在虚拟 dom 打补丁之前
  - updated：组件数据更新之后
  - activated：keep-alive 专属，组件被激活时调用
  - deactivated：keep-alive 专属，组件被销毁时调用
  - beforeDestroy：组件被销毁前
  - destroyed：组件被销毁后调用

- _init_

  - initLifecycle/Event，往 vm 上挂载各种属性
  - callHook: beforeCreate: 实例刚创建
  - initInjection/initState: 初始化注入和 data 响应性
  - created: 创建完成，属性已经绑定， 但还未生成真实 dom
  - 进行元素的挂载： $el / vm.$mount()
  - 是否有 template: 解析成 render function
    - \*.vue 文件: vue-loader 会将<template>编译成 render function
  - beforeMount: 模板编译/挂载之前
  - 执行 render function，生成真实的 dom，并替换到 dom tree 中
  - mounted: 组件已挂载

- update:

  - 执行 diff 算法，比对改变是否需要触发 UI 更新
  - flushScheduleQueue
    - watcher.before: 触发 beforeUpdate 钩子
    - watcher.run(): 执行 watcher 中的 notify，通知所有依赖项更新 UI
  - 触发 updated 钩子: 组件已更新

- actived / deactivated(keep-alive): 不销毁，缓存，组件激活与失活
- destroy:
  - beforeDestroy: 销毁开始
  - 销毁自身且递归销毁子组件以及事件监听
    - remove(): 删除节点
    - watcher.teardown(): 清空依赖
    - vm.$off(): 解绑监听
  - destroyed: 完成后触发钩子

```js
new Vue({})

// 初始化Vue实例
function _init() {
	 // 挂载属性
    initLifeCycle(vm)
    // 初始化事件系统，钩子函数等
    initEvent(vm)
    // 编译slot、vnode
    initRender(vm)
    // 触发钩子
    callHook(vm, 'beforeCreate')
    // 添加inject功能
    initInjection(vm)
    // 完成数据响应性 props/data/watch/computed/methods
    initState(vm)
    // 添加 provide 功能
    initProvide(vm)
    // 触发钩子
    callHook(vm, 'created')

	 // 挂载节点
    if (vm.$options.el) {
        vm.$mount(vm.$options.el)
    }
}

// 挂载节点实现
function mountComponent(vm) {
	 // 获取 render function
    if (!this.options.render) {
        // template to render
        // Vue.compile = compileToFunctions
        let { render } = compileToFunctions()
        this.options.render = render
    }
    // 触发钩子
    callHook('beforeMount')
    // 初始化观察者
    // render 渲染 vdom，
    vdom = vm.render()
    // update: 根据 diff 出的 patchs 挂载成真实的 dom
    vm._update(vdom)
    // 触发钩子
    callHook(vm, 'mounted')
}

// 更新节点实现
funtion queueWatcher(watcher) {
	nextTick(flushScheduleQueue)
}

// 清空队列
function flushScheduleQueue() {
	 // 遍历队列中所有修改
    for(){
	    // beforeUpdate
        watcher.before()

        // 依赖局部更新节点
        watcher.update()
        callHook('updated')
    }
}

// 销毁实例实现
Vue.prototype.$destory = function() {
	 // 触发钩子
    callHook(vm, 'beforeDestory')
    // 自身及子节点
    remove()
    // 删除依赖
    watcher.teardown()
    // 删除监听
    vm.$off()
    // 触发钩子
    callHook(vm, 'destoryed')
}
```

### vue 父子组件生命周期钩子函数的执行顺序

- 加载渲染过程
  父 beforeCreate->父 created->父 beforeMount->子 beforeCreate->子 created->子 beforeMount->子 mounted->父 mounted

- 子组件更新过程
  父 beforeUpdate->子 beforeUpdate->子 updated->父 updated

- 父组件更新过程
  父 beforeUpdate->父 updated

- 销毁过程
  父 beforeDestroy->子 beforeDestroy->子 destroyed->父 destroy

### 在哪个生命周期内调用异步请求

可以在函数 created，beforeMount，mounted 中进行调用，因为在这三个钩子函数中 data 已经可以创建，可以将服务端返回的数据进行赋值，但是比较推荐在 created 钩子函数中调用异步请求，因为：

- 能更快的获取到服务端数据，减少页面 loading 时间
- ssr 不支持 beforeMount，mounted 钩子函数，所以放在 created 中有助于一致性

- mounted 里能够操作 dom

### 在什么阶段才能访问操作 DOM

在钩子函数 mounted 被调用之前，vue 已经把编译好的模板挂载到页面上，所以在 mounted 中可以访问操作 dom，vue 具体的生命周期。

### 父组件可以监听到子组件的生命周期吗

- 手动设置$emit 来发布监听

```js
// parent
<Child @mounted="fn" />
// child
mounted() {
    this.$emit("mounted");
}
```

- @hook

```js
// parent
<Child @hook:mounted="fn" />
fn() {
    console.log('get')
}
// child
mounted() {
    console.log('emit');
```

### 谈谈你对 keep-alive 的了解

keep-alive 是 vue 内置的一个组件，可以使被包含的组件保留状态，避免重复渲染，其有以下特性：

- 一般结合路由和动态组件使用，用于缓存组件
- 提供 include 和 exclude 属性，两者都支持字符串或正则表达式，include 表示只有名字匹配的组件会被缓存，exclude 表示任何名称匹配的组件都不会被缓存，其中 exclude 的优先级比 include 高
- 对应两个钩子函数 actived 和 deactivated

### 组件中的 data 为什么是个函数

因为组件是拿来复用的，且 js 里的对象是引用关系，如果组件中的 data 是一个对象，那么这样作用域没有隔离，子组件中的 data 属性值会相互影响，如果组件中的 data 是一个函数，那么每个实例可以维护一份被返回对象的独立的拷贝，组件实例之间的 data 属性值不会互相影响，而 new Vue 的实例是不会被复用的，因此不存在引用对象的问题。

### v-model 的原理

我们在 vue 项目中主要使用 v-model 指令在表单 input，textarea，select 等元素上创建双向绑定，我们知道 v-model 本质上不过是语法糖，v-model 在内部为不同的输入元素使用不同的属性并抛出不同的事件：

- text 和 textarea 元素使用 value 属性和 input 事件
- checkbox 和 radio 使用 checked 和 change
- select 字段将 value 作为 prop 并将 change 作为事件

### vue 组件间通信有哪几种方式（6 种）

- props 和$emit
  适用父子组件通信

- ref 和$parent $children
ref：如果在普通dom上使用，引用指向的就是dom元素，如果用在子组件上，引用就指向组件实例 $parent/$children：访问父子实例

- EventBus（$emit/$on）
  这种方法通过一个空的 vue 实例作为中央事件总线（事件中心），用它来触发事件和监听事件，从而实现任何组件间的通信，包括父子，隔代，兄弟组件

- $attrs/$listeners
  $attrs：包含了父作用域里不被prop所识别（且获取）的特性绑定（class和style除外）。当一个组件没有声明任何prop时，这里会包含所有父作用域的绑定（class和style除外），并且可以通过v-bind="$attrs"传入内部组件。通常配合 inheritAttrs 选项一起使用

$listeners：包含了父作用域中的v-on事件监听器，它可以通过v-on="$listeners"传入内部组件

- provide、inject
  祖先组件通过 provide 来提供变量，然后在子孙组件中通过 inject 来注入变量，provide / inject API 主要解决了跨级组件间的通信问题，不过他的使用场景，主要是子组件获取上级组件的状态，跨级组件间建立一种主动提供和依赖注入的关系

- vuex
  vuex 是一个专为 vue 应用程序开发的状态管理模式，每一个 vuex 应用的核心就是 store，store 基本上就是一仓库，它包含着你的应用中大部分的状态

vuex 的状态存储是响应式的，当 vue 从 store 中读取状态时候，若 store 中的状态发生变化，那么相应的组件也会相应的得到高效更新

改变 store 中的状态的唯一的途径就是显式地提交 mutation，这样使我们可以方便地跟踪每一个状态的变化

### 你使用过 vuex 吗

vuex 是一个专门为 vue 应用程序开发的状态管理模式，每一个 vuex 应用的核心是 store，store 基本上就是一个容器，它包含着你的应用中大部分的状态（state）

主要包括以下几个模块：

- state：定义了应用状态的数据结构，可以在这里设置默认的初始状态
- Getters：允许组件从 State 中获取数据，mapGetters 辅助函数仅仅是将 store 中的 getter 映射到局部计算属性
- Mutations：是唯一更改 store 中状态的方法，且必须是同步函数
- Actions：用于提交 mutation，而不是直接更改状态，可以包含任意的异步操作
- Modules：允许将单一的 Store 拆分成多个 store 且同时保存在单一的状态树里

### vuex 解决了什么问题

1. 多个组件依赖同一状态，多层嵌套繁琐，兄弟组件没办法传值通信。

2. 不同组件的行为需要修改同一状态

### Vuex 中状态是对象时，使用时要注意什么？

因为对象是引用类型，复制后改变属性还是会影响原始数据，这样会改变 state 里面的状态，是不允许，所以先用深度克隆复制对象，再修改。

### 组件中批量使用 Vuex 的 state 状态

```js
import { mapState } from "vuex";
export default {
  computed: {
    ...mapState(["price", "number"]),
  },
};
```

### Vuex 中要从 state 派生一些状态出来，且多个组件使用它

使用 getter 属性，相当 Vue 中的计算属性 computed，只有原状态改变派生状态才会改变。

```js
const store = new Vuex.Store({
  state: {
    price: 10,
    number: 10,
    discount: 0.7,
  },
  getters: {
    total: (state) => {
      return state.price * state.number;
    },
    discountTotal: (state, getters) => {
      return state.discount * getters.total;
    },
    getTodoById: (state) => (id) => {
      return state.todos.find((todo) => todo.id === id);
    },
  },
});
```

```js
computed: {
    total() {
        return this.$store.getters.total
    },
    discountTotal() {
        return this.$store.getters.discountTotal
    },
    getTodoById() {
        return this.$store.getters.getTodoById
    },
    ...mapGetters(['total','discountTotal']), // 批量使用getter属性
    ...mapGetters({
        myTotal:'total',
        myDiscountTotal:'discountTotal',
    }) // 取别名
},
mounted(){
    console.log(this.getTodoById(2).done)//false
}
```

- 在 getter 中可以通过第三个参数 rootState 访问到全局的 state,可以通过第四个参数 rootGetters 访问到全局的 getter。
- 在 mutation 中不可以访问全局的 state 和 getter，只能访问到局部的 state。
- 在 action 中第一个参数 context 中的 context.rootState 访问到全局的 state，context.rootGetters 访问到全局的 getter。

### 在组件中多次提交同一个 mutation,action

```js
methods:{
    ...mapMutations({
        setNumber:'SET_NUMBER',
    }),
    ...mapActions({
        setNumber:'SET_NUMBER',
    })
}
```

this.setNumber(10)相当调用 this.$store.commit('SET_NUMBER',10)

### Vuex 中 action 和 mutation 有什么区别？

1. action 提交的是 mutation，而不是直接变更状态。mutation 可以直接变更状态。
2. action 可以包含任意异步操作。mutation 只能是同步操作。
3. 提交方式不同，action 是用 this.$store.dispatch('ACTION_NAME',data)来提交。mutation是用this.$store.commit('SET_NUMBER',10)来提交。
4. 接收参数不同：

```js
{
  state, // 等同于 `store.state`，若在模块中则为局部状态
    rootState, // 等同于 `store.state`，只存在于模块中
    commit, // 等同于 `store.commit`
    dispatch, // 等同于 `store.dispatch`
    getters, // 等同于 `store.getters`
    rootGetters; // 等同于 `store.getters`，只存在于模块中
}
```

多个 actions，A 结束后再执行其他操作

```js
actions:{
    async actionA({commit}){
        //...
    },
    async actionB({dispatch}){
        await dispatch ('actionA')//等待actionA完成
        // ...
    }
}
```

### 命名空间

```js
export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
```

- 怎么在带命名空间的模块内提交全局的 mutation 和 action？

```js
this.$store.dispatch("actionA", null, { root: true });
this.$store.commit("mutationA", null, { root: true });
```

### 在 Vuex 插件中怎么监听组件中提交 mutation 和 action？

```js
export default function createPlugin(param) {
  return (store) => {
    store.subscribe((mutation, state) => {
      console.log(mutation.type); //是那个mutation
      console.log(mutation.payload);
      console.log(state);
    });
    // store.subscribeAction((action, state) => {
    //     console.log(action.type)//是那个action
    //     console.log(action.payload)//提交action的参数
    // })
    store.subscribeAction({
      before: (action, state) => {
        //提交action之前
        console.log(`before action ${action.type}`);
      },
      after: (action, state) => {
        //提交action之后
        console.log(`after action ${action.type}`);
      },
    });
  };
}
```

### 在 v-model 上怎么用 Vuex 中 state 的值？

```js
<input v-model="message">
// ...
computed: {
    message: {
        get () {
            return this.$store.state.message
        },
        set (value) {
            this.$store.commit('updateMessage', value)
        }
    }
}
```

### vue router 全局导航守卫

三个参数

- to：即将要进入的目标 路由对象。
- from：当前导航正要离开的路由对象。
- next：函数，必须调用，不然路由跳转不过去。

next()：进入下一个路由。
next(false)：中断当前的导航。
next('/')或 next({ path: '/' }) : 跳转到其他路由，当前导航被中断，进行新的一个导航。

- router.beforeEach：全局前置守卫。
- router.beforeResolve：全局解析守卫。
- router.afterEach：全局后置钩子。

### 路由独享守卫

```js
const router = new VueRouter({
  routes: [
    {
      path: "/foo",
      component: Foo,
      beforeEnter: (to, from, next) => {
        // ...
      },
    },
  ],
});
```

### 组件内导航守卫

- beforeRouteLeave：在失活的组件里调用离开守卫。
- beforeRouteUpdate：在重用的组件里调用,比如包含<router-view />的组件。
- beforeRouteEnter：在进入对应路由的组件创建前调用。

### router-link

<router-link>是 Vue-Router 的内置组件，在具有路由功能的应用中作为声明式的导航使用。类似 react 的 Link 标签

```html
<router-link to="home">Home</router-link>
<router-link :to="'home'">Home</router-link>
<router-link :to="{ path: 'home' }">Home</router-link>
<router-link :to="{ name: 'user', params: { userId: 123 }}">User</router-link>
<router-link :to="{ path: 'user', query: { userId: 123 }}">User</router-link>
```

注册在 router-link 上事件无效解决方法:
使用@click.native。原因：router-link 会阻止 click 事件，.native 指直接监听一个原生事件

在 ie 和 firefox 无效：

1. 使用 a 标签不用 Button
2. 使用 Button 和 Router.navigate 方法

### params 和 query 的区别

query 需要 path 引入，params 需要 name 引入
this.$route.query.name、this.$route.params.query
注意点：query 刷新不会丢失 query 数据，params 刷新会丢失数据

### 组件内监听路由的变化

只能用在包含<router-view />的组件内

1.

```js
watch: {
    '$route'(to, from) {
        //这里监听
    },
}
```

2.

```js
beforeRouteUpdate (to, from, next) {
    //这里监听
},
```

### 切换新路由的滚动条处理

```js
const router = new Router({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { x: 0, y: 0 };
    }
  },
});
```

### 路由传参获取方式

1. meta：路由元信息，写在 routes 配置文件中。

```js
{
    path: '/home',
    name: 'home',
    component: load('home'),
    meta: {
        title: '首页'
    },
},
```

> this.$route.meta.title

2. query

```js
this.$router.push({
  path: "/home",
  query: {
    userId: 123,
  },
});
```

> this.$route.query.userId

3. params

```js
{
    path: '/home/:userId',
    name: 'home',
    component: load('home'),
},
// 注意用params传参，只能用命名的路由（用name访问）
const userId = '123'
this.$router.push({ name: 'home', params: { userId } })
// this.$route.params
```

### 实现动态加载路由

- 使用 Router 的实例方法 addRoutes 来实现动态加载路由，一般用来实现菜单权限。

- 使用时要注意，静态路由文件中不能有 404 路由，而要通过 addRoutes 一起动态添加进去。

```js
webpack< 2.4 时
{
    path:'/',
    name:'home',
    components:resolve=>require(['@/components/home'],resolve)
}
webpack> 2.4 时
{
    path:'/',
    name:'home',
    components:()=>import('@/components/home')
}
```

### 路由之间跳转

1. 声明式
   通过使用内置组件<router-link :to="/home">来跳转 or router-link :to="{name:'index'}">

2. 编程式

```js
this.$router.push({ path:'home' })
this.$router.replace({ path: '/home' })
this.$router.push({name:'组件名')};
```

$router和$route 的区别

> $route为当前router跳转对象，里面可以获取name、path、query、params等
> $router 为 VueRouter 实例，想要导航到不同 URL，则使用 router.push 方法，返回上一个历史$router.to(-1)

### 打开新窗口

```js
const obj = {
  path: xxx, //路由地址
  query: {
    mid: data.id, //可以带参数
  },
};
const { href } = this.$router.resolve(obj);
window.open(href, "_blank");
```

### 动态绑定 Class 和 Style

```html
<!--第一种对象语法 -->
<div
  class="test"
  :class="{active:actived,'active-click': clicked&&actived}"
></div>
<!-- 第二种数组语法 -->
<div
  class="test"
  :class="[actived?activeClass : '', clicked&&actived?activeClickClass : '']"
></div>
<!-- 第三种对象和数组混合 -->
<div
  :class="[testClass,{active:actived},{'active-click':clicked&&actived}]"
></div>
<!-- 第四种对象和计算属性(推荐) -->
<div :class="classObject"></div>
```

### 过滤器(filter)

```js
<div><span>{{money | moneyFilter(0.15)}}</span>美元</div>
<div><span>{{money | moneyFilter(0.12)}}</span>英镑</div>
filters: {
    moneyFilter: function(val, ratio) {
        return Number(val * ratio).toFixed(2);
    }
}
```

除了用在插值上还可以用在 v-bind 表达式上。

### computed 中的属性名和 data 中的属性名可以相同吗？也不能和 method 中属性同名

不能同名，因为不管是 computed 属性名还是 data 数据名还是 props 数据名都会被挂载在 vm 实例上，因此这三个都不能同名。

### watch 的属性使用箭头函数定义可以吗？

不可以。this 会是 undefind,因为箭头函数中的 this 指向的是定义时的 this，而不是执行时的 this，所以不会指向 Vue 实例的上下文。

### watch 怎么深度监听对象变化

监听的函数接收两个参数，第一个参数是最新的值；第二个参数是输入之前的值；

```js
watch:{
   a:{
       handler:function(val,oldval){

       },
       deep:true, // 一层层遍历给属性都加上监听器
       immediate: true // 组件加载立即触发回调函数执行
   },
   'obj.a': {

   }
}
```

### 强制刷新组件

- this.$forceUpdate()。
- 组件上加上 key，然后变化 key 的值。

### 访问子组件实例或者子元素

1. ref
   先用 ref 特性为子组件赋予一个 ID 引用<base-input ref="myInput"></<base-input>

比如子组件有个 focus 的方法，可以这样调用 this.$refs.myInput.focus()；
比如子组件有个value的数据，可以这样使用this.$refs.myInput.value。

2. 子组件访问父组件
   this.$parent

### 组件什么时候下被销毁

- 没有使用 keep-alive 切换
- v-if="false"
- 执行 vm.$destroy()

### $event.target和$event.currentTarget 有什么区别

$event.currentTarget始终指向事件所绑定的元素，而$event.target 指向事件发生时的元素。

### 事件修饰符和表单修饰符

- 事件修饰符

.stop：阻止事件传递；
.prevent： 阻止默认事件；
.capture ：在捕获的过程监听，没有 capture 修饰符时都是默认冒泡过程监听；
.self：当前绑定事件的元素才能触发；
.once：事件只会触发一次；
.passive：默认事件会立即触发，不要把.passive 和.prevent 一起使用，因为.prevent 将不起作用。

- 表单修饰符.number .lazy .trim

```
<comp :foo.sync="bar"></comp>
```

相当于

```
<comp :foo="bar" @update:foo="val => bar = val"></comp>

// this.$emit('update:foo', newValue)
```

要注意顺序很重要，用@click.prevent.self 会阻止所有的点击，而@click.self.prevent 只会阻止对元素自身的点击。

### 说说你对 Vue 的表单修饰符.lazy 的理解。

input 标签 v-model 用 lazy 修饰之后，并不会立即监听 input 的 value 的改变，会在 input 失去焦点之后，才会监听 input 的 value 的改变。

### 监听键盘事件

使用按键修饰符 <input @keyup.enter="submit">按下回车键时候触发 submit 事件。

- .enter
- .tab
- .delete (捕获“删除”和“退格”键)
- .esc
- .space
- .up
- .down
- .left
- .right

### v-on 绑定多个方法

```html
<template>
  <div v-on:{click:a,dblclick:b}></div>
</template>
<script>
  methods:{
      a(){
          alert(1)
      },
      b(){
          alert(2)
      }
  }
</script>
```

### css 样式当前组件有效

```html
<style lang="less" scoped></style>
```

原理：vue 通过在 DOM 结构以及 css 样式上加上唯一的标记`data-v-xxxxxx`，保证动态属性唯一，达到样式私有化，不污染全局的作用。

编译后：

```html
<template>
  <span data-v-3e5b2a80 class="textScoped">scoped测试</span>
</template>
<script></script>
<style scoped>
  .textScoped[data-v-3e5b2a80] {
    color: red;
  }
</style>
```

### 渲染模板保留注释

- 在组件中将 comments 选项设置为 true
- <template comments> ... <template>

### 在 created 和 mounted 这两个生命周期中请求数据有什么区别呢？

在 created 中，页面视图未出现，如果请求信息过多，页面会长时间处于白屏状态，DOM 节点没出来，无法操作 DOM 节点。在 mounted 不会这样，比较好。

### Vue 组件里的定时器要怎么销毁？

- 如果页面上有很多定时器，可以在 data 选项中创建一个对象 timer，给每个定时器取个名字一一映射在对象 timer 中，
  在 beforeDestroy 构造函数中 for(let k in this.timer){clearInterval(k)}；

- 如果页面只有单个定时器，可以这么做。

```js
const timer = setInterval(() => {}, 500);
this.$once("hook:beforeDestroy", () => {
  clearInterval(timer);
});
```

### Vue 中能监听到数组变化的方法有哪些？为什么这些方法能监听到呢？

- push()、pop()、shift()、unshift()、splice()、sort()、reverse()，这些方法在 Vue 中被重新定义了，故可以监听到数组变化；
- filter()、concat()、slice()，这些方法会返回一个新数组，也可以监听到数组的变化。

### 定义全局方法

1. 挂载在 Vue 的 prototype 上
2. 利用全局混入 mixin
3.

```js
this.$root.$on('demo',function(){
    console.log('test');
})
this.$root.$emit('demo')；
this.$root.$off('demo')；
// Mustache的web模板引擎
```

### 捕获组件的错误信息

- errorCaptured 是组件内部钩子，当捕获一个来自子孙组件的错误时被调用，接收 error、vm、info 三个参数，return false 后可以阻止错误继续向上抛出。

- errorHandler 为全局钩子，使用 Vue.config.errorHandler 配置，接收参数与 errorCaptured 一致，2.6 后可捕捉 v-on 与 promise 链的错误，可用于统一错误
  处理与错误兜底。

### vue SSR

vue 是构建客户端应用程序的框架，默认情况下，可以在浏览器中输出 vue 组件，进行生成 dom 和操作 dom，然而，也可以将同一个组件渲染为服务端的 html 字符串，将他们直接发送到客户端，然后将这些静态标记激活为客户端上可以交互的应用程序。

即 ssr 的意思就是 vue 在服务端完成将标签渲染成整个 html 片段的工作，然后将片段直接返回给客户端使用

- ssr 优点：

  - 更好的 seo：因为 spa 页面的内容是通过 ajax 获取，而搜索引擎爬取工具并不会等待 ajax 一步完成后再抓取页面内容，所以在 spa 中是抓取不到页面通过 ajax 获取到的内容；而 ssr 是直接由服务器返回已经渲染好的页面（数据已经包含在页面中），所以搜索引擎爬取工具可以抓取到渲染好的页面

  - 更快的内容到达时间（首屏加载快）：spa 会等待所有 vue 编译后的 js 文件都下载完成后，才开始进行也免得渲染，文件下载需要一定的时间等，所以首屏加载需要时间，而 ssr 直接由服务器渲染好页面返回显示，无需等待 js 文件再去渲染，所以 ssr 有更快的内容到达时间

- ssr 缺点：

  - 更多的开发条件限制：例如服务端渲染只支持 beforeCreate 和 created 两个钩子函数，这会导致一些外部扩展库需要特殊处理，才能在服务端渲染程序中运行；并且与可以部署在任何静态文件服务器上的完全静态单页面应用程序 spa 不同，服务端渲染应用程序，需要处于 nodejs server 中才能运行

  - 更多的服务器负载

### nextTick

在下次 dom 更新循环结束之后执行延迟回调，可用于获取更新后的 dom 状态。

- 新版本中默认是 microtasks, v-on 中会使用 macrotasks

```js
// 修改数据
vm.msg = 'Hello'
// DOM 还没有更新
Vue.nextTick(function () {
  // DOM 更新了
  ...   //DOM操作
})

// 作为一个 Promise 使用
Vue.nextTick()
    .then(function () {
    // DOM 更新了
    })
```

```
Vue 在更新 DOM 时是异步执行的。只要侦听到数据变化，Vue 将开启一个队列，并缓冲在同一事件循环中发生的所有数据变更。如果同一个 watcher 被多次触发，只会被推入到队列中一次。这种在缓冲时去除重复数据对于避免不必要的计算和 DOM 操作是非常重要的。然后，在下一个的事件循环“tick”中，Vue 刷新队列并执行实际 (已去重的) 工作。Vue 在内部对异步队列尝试使用原生的 Promise.then、MutationObserver 和 setImmediate，如果执行环境不支持，则会采用 setTimeout(fn, 0) 代替。
例如，当你设置 vm.someData = 'new value'，该组件不会立即重新渲染。当刷新队列时，组件会在下一个事件循环“tick”中更新。多数情况我们不需要关心这个过程，但是如果你想基于更新后的 DOM 状态来做点什么，这就可能会有些棘手。虽然 Vue.js 通常鼓励开发人员使用“数据驱动”的方式思考，避免直接接触 DOM，但是有时我们必须要这么做。为了在数据变化之后等待 Vue 完成更新 DOM，可以在数据变化之后立即使用 Vue.nextTick(callback)。这样回调函数将在 DOM 更新完成后被调用。
```

> dom 更新为什么是一个异步操作因为它提升了渲染效率。

### 数据响应(数据劫持)

数据响应的实现由两部分构成: 观察者( watcher ) 和 依赖收集器( Dep )，其核心是 defineProperty 这个方法，它可以重写属性的 get 与 set 方法，从而完成监听数据的改变。

> 1. 对需要 observe 的数据对象进行递归遍历，包括子属性对象的属性，都加上 setter 和 getter 这样的话，给这个对象的某个值赋值，就会触发 setter，那么就能监听到了数据变化

> 2. compile 解析模板指令，将模板中的变量替换成数据，然后初始化渲染页面视图，并将每个指令对应的节点绑定更新函数，添加监听数据的订阅者，一旦数据有变动，收到通知，更新视图

> 3. Watcher 订阅者是 Observer 和 Compile 之间通信的桥梁，主要做的事情是:
>    ① 在自身实例化时往属性订阅器(dep)里面添加自己
>    ② 自身必须有一个 update()方法
>    ③ 待属性变动 dep.notice()通知时，能调用自身的 update()方法，并触发 Compile 中绑定的回调

> 4、MVVM 作为数据绑定的入口，整合 Observer、Compile 和 Watcher 三者，通过 Observer 来监听自己的 model 数据变化，通过 Compile 来解析编译模板指令，最终利用 Watcher 搭起 Observer 和 Compile 之间的通信桥梁，达到数据变化 -> 视图更新；视图交互变化(input) -> 数据 model 变更的双向绑定效果。

```js
let data = { a: 1 };
// 数据响应性
observe(data);

// 初始化观察者
new Watcher(data, "name", updateComponent);
data.a = 2;

// 简单表示用于数据更新后的操作
function updateComponent() {
  vm._update(); // patchs
}

// 监视对象
function observe(obj) {
  // 遍历对象，使用 get/set 重新定义对象的每个属性值
  Object.keys(obj).map((key) => {
    defineReactive(obj, key, obj[key]);
  });
}

function defineReactive(obj, k, v) {
  // 递归子属性
  if (type(v) == "object") observe(v);

  // 新建依赖收集器
  let dep = new Dep();
  // 定义get/set
  Object.defineProperty(obj, k, {
    enumerable: true,
    configurable: true,
    get: function reactiveGetter() {
      // 当有获取该属性时，证明依赖于该对象，因此被添加进收集器中
      if (Dep.target) {
        dep.addSub(Dep.target);
      }
      return v;
    },
    // 重新设置值时，触发收集器的通知机制
    set: function reactiveSetter(nV) {
      v = nV;
      dep.nofify();
    },
  });
}

// 依赖收集器
class Dep {
  constructor() {
    this.subs = [];
  }
  addSub(sub) {
    this.subs.push(sub);
  }
  notify() {
    this.subs.map((sub) => {
      sub.update();
    });
  }
}

Dep.target = null;

// 观察者
class Watcher {
  constructor(obj, key, cb) {
    Dep.target = this;
    this.cb = cb;
    this.obj = obj;
    this.key = key;
    this.value = obj[key];
    Dep.target = null;
  }
  addDep(Dep) {
    Dep.addSub(this);
  }
  update() {
    this.value = this.obj[this.key];
    this.cb(this.value);
  }
  before() {
    callHook("beforeUpdate");
  }
}
```

### 虚拟 dom 原理实现

- 创建 dom 树

- 树的 diff，同层对比，输出 patchs(listDiff/diffChildren/diffProps)

  - 没有新的节点，返回
  - 新的节点 tagName 与 key 不变， 对比 props，继续递归遍历子树

    - 对比属性(对比新旧属性列表):
      - 旧属性是否存在与新属性列表中
      - 都存在的是否有变化
      - 是否出现旧列表中没有的新属性

  - tagName 和 key 值变化了，则直接替换成新节点

- 渲染差异

  - 遍历 patchs， 把需要更改的节点取出来
  - 局部更新 dom

- patch 函数 oldvnode vnode
  - 如果两个节点不一样，直接用新节点替换老节点；
  - 如果两个节点一样，
    ​ - 新老节点一样，直接返回；
    ​ - 老节点有子节点，新节点没有：删除老节点的子节点；
    ​ - 老节点没有子节点，新节点有子节点：新节点的子节点直接 append 到老节点；
    ​ - 都只有文本节点：直接用新节点的文本节点替换老的文本节点；
    ​ - 都有子节点：updateChildren

```js
// diff算法的实现
function diff(oldTree, newTree) {
  // 差异收集
  let pathchs = {};
  dfs(oldTree, newTree, 0, pathchs);
  return pathchs;
}

function dfs(oldNode, newNode, index, pathchs) {
  let curPathchs = [];
  if (newNode) {
    // 当新旧节点的 tagName 和 key 值完全一致时
    if (oldNode.tagName === newNode.tagName && oldNode.key === newNode.key) {
      // 继续比对属性差异
      let props = diffProps(oldNode.props, newNode.props);
      curPathchs.push({ type: "changeProps", props });
      // 递归进入下一层级的比较
      diffChildrens(oldNode.children, newNode.children, index, pathchs);
    } else {
      // 当 tagName 或者 key 修改了后，表示已经是全新节点，无需再比
      curPathchs.push({ type: "replaceNode", node: newNode });
    }
  }

  // 构建出整颗差异树
  if (curPathchs.length) {
    if (pathchs[index]) {
      pathchs[index] = pathchs[index].concat(curPathchs);
    } else {
      pathchs[index] = curPathchs;
    }
  }
}

// 属性对比实现
function diffProps(oldProps, newProps) {
  let propsPathchs = [];
  // 遍历新旧属性列表
  // 查找删除项
  // 查找修改项
  // 查找新增项
  forin(olaProps, (k, v) => {
    if (!newProps.hasOwnProperty(k)) {
      propsPathchs.push({ type: "remove", prop: k });
    } else {
      if (v !== newProps[k]) {
        propsPathchs.push({ type: "change", prop: k, value: newProps[k] });
      }
    }
  });
  forin(newProps, (k, v) => {
    if (!oldProps.hasOwnProperty(k)) {
      propsPathchs.push({ type: "add", prop: k, value: v });
    }
  });
  return propsPathchs;
}

// 对比子级差异
function diffChildrens(oldChild, newChild, index, pathchs) {
  // 标记子级的删除/新增/移动
  let { change, list } = diffList(oldChild, newChild, index, pathchs);
  if (change.length) {
    if (pathchs[index]) {
      pathchs[index] = pathchs[index].concat(change);
    } else {
      pathchs[index] = change;
    }
  }

  // 根据 key 获取原本匹配的节点，进一步递归从头开始对比
  oldChild.map((item, i) => {
    let keyIndex = list.indexOf(item.key);
    if (keyIndex) {
      let node = newChild[keyIndex];
      // 进一步递归对比
      dfs(item, node, index, pathchs);
    }
  });
}

// 列表对比，主要也是根据 key 值查找匹配项
// 对比出新旧列表的新增/删除/移动
function diffList(oldList, newList, index, pathchs) {
  let change = [];
  let list = [];
  const newKeys = getKey(newList);
  oldList.map((v) => {
    if (newKeys.indexOf(v.key) > -1) {
      list.push(v.key);
    } else {
      list.push(null);
    }
  });

  // 标记删除
  for (let i = list.length - 1; i >= 0; i--) {
    if (!list[i]) {
      list.splice(i, 1);
      change.push({ type: "remove", index: i });
    }
  }

  // 标记新增和移动
  newList.map((item, i) => {
    const key = item.key;
    const index = list.indexOf(key);
    if (index === -1 || key == null) {
      // 新增
      change.push({ type: "add", node: item, index: i });
      list.splice(i, 0, key);
    } else {
      // 移动
      if (index !== i) {
        change.push({
          type: "move",
          form: index,
          to: i,
        });
        move(list, index, i);
      }
    }
  });

  return { change, list };
}
```

### Proxy 相比于 defineProperty 的优势

- 数组变化也能监听到
- 不需要深度遍历监听(遍历每一个属性)

```js
let data = { a: 1 };
let reactiveData = new Proxy(data, {
  get: function (target, name) {
    // ...
  },
  // ...
});
```

### vue-router

- mode
  - hash
  - history
- 跳转
  - this.$router.push()
  - <router-link to=""></router-link>
- 占位
  - <router-view></router-view>

### 为什么在 v-for 中使用 key？

为了标识每个唯一的节点，方便比较，v-for 中加 key 可以减少渲染次数，提升渲染性能。

### Vuex 页面刷新数据丢失怎么解决？

使用 vuex-persist 插件，它就是为 Vuex 持久化存储而生的一个插件。不需要你手动存取 storage ，而是直接将状态保存至 cookie 或者 localStorage 中

### vue 项目的优化

1. v-if 和 v-show 区分场景使用

2. computed 和 watch 区分场景使用

3. v-for 遍历必须加 key，key 最好是 id 值，如果采用 index 当插入数据时索引会发生变化，且避免同时使用 v-if(用计算属性过滤数据)

4. 图片懒加载

5. 路由懒加载

6. 第三方插件按需引入

7. 长列表(虚拟列表)

   > 无限列表加载到底部请求 api，用 v-for 循环数据这样是欠妥当的。随着数据的加载，dom 会越来越多，造成性能的开销大，对客户端造成压力。虚拟列表保证 dom 数量一定，渲染可视区的 dom，通过替换数据来实现长列表的显示。

8. 释放组件资源(beforeDestroy 移除监听)

9. 首屏优化 mixins 抽离公共代码

### vue 父子组件实现双向绑定实例

```
<Child :name="name" :change="changeName"/>

props:{
    name:{
        type:String,
        required: false
    }
},
data() {
    newName:''
},
watch:{
    name(val){
        this.newName = val
    },
    newName(val){
        this.$emit('change', val)
    }
}
```

### 自定义 v-model

自定义 v-model，设置子组件 model 属性，设置 v-model 侦听的属性值，同时绑定属性变化时执行的事件，实现自定义 v-model，即双向绑定。

```
// v-model只是一个语法糖
<input type="text" v-model="price"/>

<input type="text" :value="price" @input="price=$event.target.value" />
```

- Vue.extend 方法创建一个组件

```js
// 注册组件
Vue.component("base-checkbox", {
    model:{
        prop:'checked', // 绑定属性
        event:'change', // 抛出事件
    },
    props:{
        checked: boolean
    },
    templete:`<input type="checkbox" v-bind:checked="checked" v-on:change="$emit('change',$event.target.value)"/>`
})

<base-checkbox v-model="value"></base-checkbox>
```

### provide/inject 有什么用？

> 常用的父子组件通信方式都是父组件绑定要传递给子组件的数据，子组件通过`props`属性接收，一旦组件层级变多时，采用这种方式一级一级传递值非常麻烦，而且代码可读性不高，不便后期维护。

> vue 提供了`provide`和`inject`帮助我们解决多层次嵌套嵌套通信问题。在`provide`中指定要传递给子孙组件的数据，子孙组件通过`inject`注入祖父组件传递过来的数据。

> `provide`和`inject`主要为高阶插件/组件库提供用例。并不推荐直接用于应用程序代码中。

```js
provide() {
    return {
        elForm: this
    }
}

inject: ['elForm']


provide: {
    name: 'cosyer'
}

inject:{
    newName: {
        from: 'name',
        default: ''
    }
}
```

### vue is 的作用

#### 简单来说就是扩展 html 标签的限制

```html
<ul>
  <li></li>
</ul>
<!-- ul里面嵌套li是固定的写法 -->
```

当我们使用自定义的组件时会被当作无效内容 ↓

```html
<ul>
  <my-li></my-li>
</ul>
```

可以通过 is 来扩展

```html
<ul>
  <li is="my-li"></li>
</ul>
```

#### 动态切换组件

```
<div :is="变量名称"></div>
```

### assets 和 static 的区别

- assets 中的文件在运行 npm run build 的时候会打包，简单来说就是会被压缩体积，代码格式化之类的。打包之后也会放到 static 中。

- static 中的文件则不会被打包。

> 建议：将图片等未处理的文件放在 assets 中，打包减少体积。而对于第三方引入的一些资源文件如 iconfont.css 等可以放在 static 中，因为这些文件已经经过处理了。

### slot 插槽分发

很多时候，我们封装了一个子组件之后，在父组件使用的时候，想添加一些 dom 元素，这个时候就可以使用 slot 插槽了，但是这些 dom 是否显示以及在哪里显示，则是看子组件
中 slot 组件的位置了。

### v-clock 指令的作用

- 解决页面闪烁问题(会显示插值表达式{{message}})
  如果网速慢，而该标签内容是变量没有请求响应回来的时候，页面上先不显示该标签（vue 给该标
  签加了 css 样式），当响应回来的时候改标签默认将 css 样式去除。

`此指令可以解决使用插值表达式页面闪烁问题`将该指令加在 html 标签中时，可以在该文件中加
style 属性为 display：none

```js
<div class="#app" v-cloak>
    <p>{{name}}</p>
</div>

[v-cloak]{
    display: none;
}
```

### 封装 vue 组件的过程

1. 建立组件模板、架子写写样式，考虑好组件的基本逻辑
2. 准备好组件的数据输入，定好 props 里面的数据、类型
3. 准备好组价的数据输出，定好暴露出来的方法

### 常用组件库

- [文本比对:vue-code-diff](https://github.com/ddchef/vue-code-diff)
- [JSON 代码编辑器:vue-codemirror](https://github.com/surmon-china/vue-codemirror)
- [国际化:vue-i18n](https://github.com/kazupon/vue-i18n)
- [富文本编辑器:wangEditor](https://github.com/wangeditor-team/wangEditor)
- [富文本编辑器:tinymce](https://github.com/tinymce/tinymce)
- [monaco 编辑器:vue-monaco](https://github.com/egoist/vue-monaco)
- [ace 编辑器:vue2-ace-editor](https://github.com/chairuosen/vue2-ace-editor)
- [剪切板:vue-clipboard2](https://github.com/Inndy/vue-clipboard2)
- [操作 cookie:vue-cookies](https://github.com/cmp-cc/vue-cookies)
- [fragment 元素:vue-fragment](https://github.com/Thunberg087/vue-fragment)
- [代码高亮:vue-highlightjs](https://github.com/metachris/vue-highlightjs)
- [command 界面:xterm.js](https://github.com/xtermjs/xterm.js)
- [command 界面:hterm](https://github.com/chromium/hterm)
- [处理 yaml:yaml.js](https://github.com/jeremyfa/yaml.js)
- [yaml:js-yaml](https://github.com/nodeca/js-yaml)
- [vue 的 echarts 封装:v-charts](https://github.com/ElemeFE/v-charts)
- [mock:mockjs](https://github.com/nuysoft/Mock)
- [判断是否是黑色:is-dark-color](https://github.com/gion/is-dark-color)
- [XSS 过滤:DOMPurify](https://github.com/cure53/DOMPurify)

### 常用 UI 库

#### 移动端

- [mint-ui](http://mint-ui.github.io/#!/zh-cn)

- [Vant](https://youzan.github.io/vant/#/zh-CN/home)

- [VUX](https://vux.li/)

- [cube-ui](https://didi.github.io/cube-ui/)

#### pc 端

- [element-ui](https://element.eleme.cn/2.13/#/zh-CN/component/
  installation）

- [Ant Design of Vue](https://www.antdv.com/docs/vue/introduce-cn/)

- [iview/viewui/view-design](https://iviewui.com/)

- [Avue](https://avuejs.com/)

- [vuetify](https://vuetifyjs.com/)

### 常用配置

#### publicPath

1. cli2 config/index.js

```js
build: {
  assetsPublicPath: "./";
}
```

2. cli3 vue.config.js

```js
module.exports = {
  publicPath: "./",
};
```

部署应用包时的基本 URL。默认情况下，Vue CLI 会假设你的应用是被部署在一个域名的根路径
上，例如https://www.my-app.com/。如果应用被部署在一个子路径上，
你就需要用这个选项指定这个子路径。例如，如果你的应用被部署在https://www.my-app.
com/my-app/，则设置 publicPath 为/my-app/

```js
proxy: {
    "/api": { //如果ajax请求的地址是http://192.168.0.118:9999/api1那么你就可以在ajax中使用/api/api1路径,其请求路径会解析
    // http://192.168.0.118:9999/api1，当然你在浏览器上看到的还是http://localhost:8080/api/api1;
    target: "http://192.168.0.118:9999",
    //是否允许跨域，这里是在开发环境会起作用，但在生产环境下，还是由后台去处理，所以不必太在意
    changeOrigin: true,
    pathRewrite: {
        //把多余的路径置为''
        "api": ""
    }
}
```

### vue3

1. createApp

- vue2.x

```js
import Vue from "vue";
import App from "./App.vue";

new Vue({
  render: (h) => h(App),
}).$mount("#app");
```

- vue3 新特性
  > createApp 会产生一个 app 实例，该实例拥有全局的可配置上下文

```js
import { createApp } from "vue";
import App from "./App.vue";

createApp(App).mount("#app");
```

2. globalProperties

```js
app.config.globalProperties.foo = "bar";

app.component("child-component", {
  mounted() {
    console.log(this.foo); // 'bar'
  },
});
```

> 添加可在程序内的任何组件实例中访问的全局属性。当存在键冲突时，组件属性将优先替代掉 Vue2.x 的 Vue.prototype 属性放到原型上的写法

```js
// Vue2.x
Vue.prototype.$http = () => {};

// Vue3
const app = Vue.createApp({});
app.config.globalProperties.$http = () => {};
```

3. 更快

- 重写虚拟 DOM (Virtual DOM Rewrite)

随着虚拟 DOM 重写，我们可以期待更多的 编译时（compile-time）提示来减少 运行时（runtime）开销。重写将包括更有效的代码来创建虚拟节点。

- 优化插槽生成(Optimized Slots Generation)

在当前的 Vue 版本中，当父组件重新渲染时，其子组件也必须重新渲染。 使用 Vue 3 ，可以单独重新渲染父组件和子组件。

- 静态树提升(Static Tree Hoisting)

使用静态树提升，这意味着 Vue 3 的编译器将能够检测到什么是静态组件，然后将其提升，从而降低了渲染成本。它将能够跳过未整个树结构打补丁的过程。

- 静态属性提升（Static Props Hoisting）

此外，我们可以期待静态属性提升，其中 Vue 3 将跳过不会改变节点的打补丁过程。

- 基于 Proxy 的观察者机制

- 更小
  Vue 已经非常小了，在运行时（runtime）压缩后大约 20kb 。 但我们可以期待它会变得更加小，新的核心运行时压缩后大概 10kb 。
- 使其更具可维护性
  不仅会使用 TypeScript（允许在编辑器中进行高级的类型检查和有用的错误和警告） ，而且许多软件包将被解耦，使所有内容更加模块化。
- 更多的原生支持
  运行时内核也将与平台无关，使得 Vue 可以更容易地与任何平台（例如 Web，iOS 或 Android）一起使用。
- 更易于开发使用
  当我们需要在 Vue 中共享两个组件之间的行为时，我们通常使用 Mixins 。然而，Evan 正在尝试使用 Hooks API 来避免来自 Mixins 的一些问题，并且更适合
- 使用惯用的 Vue 代码。
  使用 Time Slicing，将 JS 的执行分解为几个部分，如果有用户交互需要处理，这些部分将提供给浏览器。

### element-ui 使用中遇到的坑 疑难杂症

1. 不支持 v-model 修饰符导致如果使用.trim 当数据拼接了' '后，第一次点击数据中间编辑，光标会跳到末尾

2. el-table 当注入的 data 经过过滤，所对应的$index 还是原来的，导致删除 splice 对应的 index 不准确

3. 在 disabled 的 button 上使用 Tooltip 失效，el-tooltip 不显示(disable 属性)

4. input-number 输入精度 precision 既要编辑又要显示超出最小值

5. 页面刷新、局部刷新、需不需要 loading

6. 自动刷新，记录状态且不能打断操作

7. 分页删除pageNum没变但这也没数据了

8. abort 上个页面的接口

9. Input Number 计数器触控板点击 bug https://github.com/ElemeFE/element/issues/19088

10. hterm 火狐浏览器发生嵌套 https://github.com/dbkaplun/hterm-umdjs/issues/6

11. 切换路由，上个路由的异步接口setState，取消接口
