---
title: vuex学习笔记
tags:
  - vue
copyright: true
comments: true
date: 2019-04-19 00:25:20
categories: 知识
photos:
top: 190
---

## vuex

数据驱动模板（管理共享状态）
核心 store 仓库（响应式的状态存储）
提交 mutation 才能修改内部状态 记录每次改变保存状态快照

```js
const store = new Vuex.Store({
  state: {
    count: 0,
  },
  mutations: {
    increase(state) {
      state.count++;
    },
  },
  // 开启严格模式
  strict: process.env.NODE_ENV !== "production",
  // 在严格模式下，无论何时发生了状态变更且不是由 mutation 函数引起的，将会抛出错误。这能保证所有的状态变更都能被调试工具跟踪到。
});

store.commit("increase");
store.state.count;
```

不要在发布环境下启用严格模式！严格模式会深度监测状态树来检测不合规的状态变更——请确保在发布环境下关闭严格模式，以避免性能损失。

---

<!--more-->

### state（单一状态树）

用一个对象包含所有的应用层级状态

- 从 store 实例中读取状态

```js
// 计算属性
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count() {
      return store.state.count;
    },
  },
};
```

- 从根组件注入实例

```js
const app = new Vue({
  el: "#app",
  // 把 store 对象提供给 “store” 选项，这可以把 store 的实例注入所有的子组件
  store,
  components: { Counter },
  template: `
    <div class="app">
      <counter></counter>
    </div>
  `,
});
// 读取
this.$store.state.count;
```

- 多个属性使用 mapState()辅助函数

```js
computed: mapState({
  count: (state) => state.count,
  name: (state) => state.name,
});
// 如果属性与state子节点名称相同 传入字符串数组
// 映射 this.count 为 store.state.count
mapState(["count"]);
```

### getter 对 state 数据的派生操作（共享数据的共享函数）

```js
const store = new Vuex.Store({
    state:{
        todos: [
            { id: 1, text: '...', done: true },
            { id: 2, text: '...', done: false }
        ]
    },
    getters: {
        doneTodos: state => {
            return state.todos.filter(todo => todo.done)
        }
        // 接收getter参数
        doneTodosCount: (state, getters) => {
            return getters.doneTodos.length
        }
        // 方法
        getTodoById: (state) => (id) => {
            return state.todos.find(todo => todo.id === id)
        }
    }
})
// 访问
store.getters.doneTodos // -> [{ id: 1, text: '...', done: true }]
```

- mapGetters()辅助函数

```js
computed: {
    // 使用对象展开运算符将 getter 混入 computed 对象中
    ...mapGetters([
        'doneTodosCount',
        'anotherGetter',
        // ...
    ])
}
mapGetters({
    // 把 `this.doneCount` 映射为 `this.$store.getters.doneTodosCount`
    doneCount: 'doneTodosCount'
})
```

### mutation

提交 mutation

```js
store.commit("increase");
// 传参
store.commit("increase", 10);
// 最好还是规范传payload对象
store.commit("increase", {
  amount: 10,
});
// 对象风格提交
store.commit({
  type: "increase",
  amount: 10,
});
```

1.最好提前在你的 store 中初始化好所有所需属性。

2.当需要在对象上添加新属性时，你应该

•使用 Vue.set(obj, 'newProp', 123), 或者

•以新对象替换老对象。

```js
state.obj = { ...state.obj, newProp: 123 };
```

- 常量替代事件类型

```js
// mutation-types.js
export const SOME_MUTATION = "SOME_MUTATION";
```

```js
// store.js
import Vuex from 'vuex'
import { SOME_MUTATION } from './mutation-types'

const store = new Vuex.Store({
  state: { ... },
  mutations: {
    // 我们可以使用 ES2015 风格的计算属性命名功能来使用一个常量作为函数名
    [SOME_MUTATION] (state) {
      // mutate state
    }
  }
})
```

**mutation 必须是同步函数**
一条 mutation 被记录，devtools 都需要捕捉到前一状态和后一状态的快照。devtools 不知道什么时候回调函数实际上被调用——实质上任何在回调函数中进行的状态的改变都是不可追踪的。

#### 组件中提交 mutation

1.

```js
this.$store.commit("xxx");
```

2. mapMutations 辅助函数

```js
methods: {
    ...mapMutations([
      'increase', // 将 `this.increase()` 映射为 `this.$store.commit('increase')`

      // `mapMutations` 也支持载荷：
      'increaseBy' // 将 `this.increaseBy(amount)` 映射为 `this.$store.commit('increaseBy', amount)`
    ]),
    ...mapMutations({
      add: 'increase' // 将 `this.add()` 映射为 `this.$store.commit('increase')`
    })
}
```

### action

```js
store.commit("increment");
// 任何由 "increment" 导致的状态变更都应该在此刻完成。
```

Action 类似于 mutation，不同在于：
•Action 提交的是 mutation，而不是直接变更状态。
•Action 可以包含任意异步操作。

```js
const store = new Vuex.Store({
  state: {
    count: 0,
  },
  mutations: {
    increase(state) {
      state.count++;
    },
  },
  actions: {
    increase(context) {
      context.commit("increase");
    },
    increaseOr({ commit }) {
      commit("increase");
    },
    increaseAsync({ commit }) {
      // 支持异步操作
      setTimeout(() => {
        commit("increment");
      }, 1000);
    },
  },
});
```

Action 函数接受一个与 store 实例具有相同方法和属性的 context 对象，因此你可以调用 context.commit 提交一个 mutation，或者通过 context.state 和 context.getters 来获取 state 和 getters。

- 触发 action

```js
store.dispatch("increase");
```

- 支持同样的载荷方式和对象方式分发

```js
// 以载荷形式分发
store.dispatch("increaseAsync", {
  amount: 10,
});

// 以对象形式分发
store.dispatch({
  type: "increaseAsync",
  amount: 10,
});
```

```js
// 购物车操作实例
actions: {
  checkout ({ commit, state }, products) {
    // 把当前购物车的物品备份起来
    const savedCartItems = [...state.cart.added]
    // 发出结账请求，然后乐观地清空购物车
    commit(types.CHECKOUT_REQUEST)
    // 购物 API 接受一个成功回调和一个失败回调
    shop.buyProducts(
      products,
      // 成功操作
      () => commit(types.CHECKOUT_SUCCESS),
      // 失败操作
      () => commit(types.CHECKOUT_FAILURE, savedCartItems)
    )
  }
}
```

#### 组件中分发 action

在组件中使用 this.$store.dispatch('xxx') 分发 action，或者使用 mapActions 辅助函数将组件的 methods 映射为 store.dispatch 调用（需要先在根节点注入 store）

```js
import { mapActions } from "vuex";

export default {
  // ...
  methods: {
    ...mapActions([
      "increase", // 将 `this.increase()` 映射为 `this.$store.dispatch('increase')`

      // `mapActions` 也支持载荷：
      "increaseBy", // 将 `this.increaseBy(amount)` 映射为 `this.$store.dispatch('increaseBy', amount)`
    ]),
    ...mapActions({
      add: "increase", // 将 `this.add()` 映射为 `this.$store.dispatch('increase')`
    }),
  },
};
```

#### action 组合嵌套

store.dispatch 可以处理被触发的 action 的处理函数返回的 Promise，并且 store.dispatch 仍旧返回 Promise

```js
actions: {
  actionA ({ commit }) {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        commit('someMutation')
        resolve()
      }, 1000)
    })
  },
   actionB ({ dispatch, commit }) {
    return dispatch('actionA').then(() => {
      commit('someOtherMutation')
    })
  }
}

store.dispatch('actionA').then(() => {
  // ...
})
```

采用 async await

```js
// getData() 和 getOtherData() 返回的是 Promise
actions: {
  async actionA ({ commit }) {
    commit('gotData', await getData())
  },
  async actionB ({ dispatch, commit }) {
    await dispatch('actionA') // 等待 actionA 完成
    commit('gotOtherData', await getOtherData())
  }
}
```

### module 切分模块

```js
const moduleA = {
  state: { ... },
  mutations: { ... },
  actions: { ... },
  getters: { ... }
}

const moduleB = {
  state: { ... },
  mutations: { ... },
  actions: { ... }
}

const store = new Vuex.Store({
  modules: {
    a: moduleA,
    b: moduleB
  }
})

store.state.a // -> moduleA 的状态
store.state.b // -> moduleB 的状态
```

- 模块内部的 action

```js
const moduleA = {
  // ...
  actions: {
    incrementIfOddOnRootSum({ state, commit, rootState }) {
      if ((state.count + rootState.count) % 2 === 1) {
        commit("increment");
      }
    },
  },
  getters: {
    sumWithRootCount(state, getters, rootState) {
      return state.count + rootState.count;
    },
  },
};
```

- 命名空间

```js
const store = new Vuex.Store({
  modules: {
    account: {
      namespaced: true,

      // 模块内容（module assets）
      state: { ... }, // 模块内的状态已经是嵌套的了，使用 `namespaced` 属性不会对其产生影响
      getters: {
        isAdmin () { ... } // -> getters['account/isAdmin']
      },
      actions: {
        login () { ... } // -> dispatch('account/login')
      },
      mutations: {
        login () { ... } // -> commit('account/login')
      },

      // 嵌套模块
      modules: {
        // 继承父模块的命名空间
        myPage: {
          state: { ... },
          getters: {
            profile () { ... } // -> getters['account/profile']
          }
        },

        // 进一步嵌套命名空间
        posts: {
          namespaced: true,

          state: { ... },
          getters: {
            popular () { ... } // -> getters['account/posts/popular']
          }
        }
      }
    }
  }
})
```

- 在带命名空间的模块内访问全局内容（Global Assets）

```js
modules: {
  foo: {
    namespaced: true,

    getters: {
      // 在这个模块的 getter 中，`getters` 被局部化了
      // 你可以使用 getter 的第四个参数来调用 `rootGetters`
      someGetter (state, getters, rootState, rootGetters) {
        getters.someOtherGetter // -> 'foo/someOtherGetter'
        rootGetters.someOtherGetter // -> 'someOtherGetter'
      },
      someOtherGetter: state => { ... }
    },

    actions: {
      // 在这个模块中， dispatch 和 commit 也被局部化了
      // 他们可以接受 `root` 属性以访问根 dispatch 或 commit
      someAction ({ dispatch, commit, getters, rootGetters }) {
        getters.someGetter // -> 'foo/someGetter'
        rootGetters.someGetter // -> 'someGetter'

        dispatch('someOtherAction') // -> 'foo/someOtherAction'
        dispatch('someOtherAction', null, { root: true }) // -> 'someOtherAction'

        commit('someMutation') // -> 'foo/someMutation'
        commit('someMutation', null, { root: true }) // -> 'someMutation'
      },
      someOtherAction (ctx, payload) { ... }
    }
  }
}
```

- 在带命名空间的模块注册全局 action
  若需要在带命名空间的模块注册全局 action，可添加 root: true，并将这个 action 的定义放在函数 handler 中。

```js
{
  actions: {
    someOtherAction ({dispatch}) {
      dispatch('someAction')
    }
  },
  modules: {
    foo: {
      namespaced: true,

      actions: {
        someAction: {
          root: true,
          handler (namespacedContext, payload) { ... } // -> 'someAction'
        }
      }
    }
  }
}
```

- 带命名空间的绑定函数

```js
computed: {
  ...mapState({
    a: state => state.some.nested.module.a,
    b: state => state.some.nested.module.b
  })
},
methods: {
  ...mapActions([
    'some/nested/module/foo', // -> this['some/nested/module/foo']()
    'some/nested/module/bar' // -> this['some/nested/module/bar']()
  ])
}
```

简化

```js
computed: {
  ...mapState('some/nested/module', {
    a: state => state.a,
    b: state => state.b
  })
},
methods: {
  ...mapActions('some/nested/module', [
    'foo', // -> this.foo()
    'bar' // -> this.bar()
  ])
}
```

也可以通过使用 createNamespacedHelpers 创建基于某个命名空间辅助函数。它返回一个对象，对象里有新的绑定在给定命名空间值上的组件绑定辅助函数

```js
import { createNamespacedHelpers } from "vuex";

const { mapState, mapActions } = createNamespacedHelpers("some/nested/module");

export default {
  computed: {
    // 在 `some/nested/module` 中查找
    ...mapState({
      a: (state) => state.a,
      b: (state) => state.b,
    }),
  },
  methods: {
    // 在 `some/nested/module` 中查找
    ...mapActions(["foo", "bar"]),
  },
};
```

## 定义插件

```js
const myPlugin = (store) => {
  // 传入store初始化时调用
  store.subscribe((mutation, state) => {
    // 每次mutation之后调用
    // mutation 的格式为 {type, payload}
  });
};
```

## 表单处理

因为提交 mutation 才能修改状态，所以 v-model 不适合绑定 vuex 里的 state，不符合 vuex 的思想。

```html
<input v-model="obj.message" />
```

假设这里的 obj 是在计算属性中返回的一个属于 Vuex store 的对象，在用户输入时，v-model 会试图直接修改 obj.message。在严格模式中，由于这个修改不是在 mutation 函数中执行的, 这里会抛出一个错误。

1. 不采用 v-model
   所以需要 input 绑定 value，然后调用 input 或者 change 提交 mutation 修改状态

```html
<input :value="message" @input="updateMessage" />
```

```js
computed: {
    ...mapState({
        message: state => state.obj.message
    })
},
method: {
    updateMessage(e){
        this.$store.commit("updateMessage", e.target.value)
    }
}
```

2. 采用 v-model

```js
// ...
computed: {
  message: {
    get () {
      return this.$store.state.obj.message
    },
    set (value) {
      this.$store.commit('updateMessage', value)
    }
  }
}
```
