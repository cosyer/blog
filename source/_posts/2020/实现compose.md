---
title: 实现compose
tags:
  - 设计模式
copyright: true
comments: true
date: 2020-04-02 23:54:34
categories: JS
photos:
---

实现compose函数的五种思路

- 面向过程
- 函数组合（reduce）
- 函数交织（AOP编程）
- Promise（sequence）
- Generator（yield）

---
<!--more-->

## 什么是compose

compose就是执行一系列的任务（函数），比如有以下任务队列：
```js
let tasks = [step1, step2, step3, step4]
```

每一个step都是一个步骤，按照步骤一步一步的执行到结尾，这就是一个compose。

- 第一个函数是多元的（接受多个参数），后面的函数都是单元的（接受一个参数）
- 执行顺序的自右向左的
- 所有函数的执行都是同步的（异步的后面文章会讲到）

举个例子:
```js
let init = (...args) => args.reduce((ele1, ele2) => ele1 + ele2, 0)
let step2 = (val) => val + 2
let step3 = (val) => val + 3
let step4 = (val) => val + 4

// 组成任务队列
steps = [step4, step3, step2, init]
// 使用compose组合这个队列并执行
let composeFunc = compose(...steps)
console.log(composeFunc(1, 2, 3))
```

执行过程
> 6 -> 6 + 2 = 8 -> 8 + 3 = 11 -> 11 + 4 = 15

所以流程就是从init自右到左依次执行，下一个任务的参数是上一个任务的返回结果，并且任务都是同步的，这样就能保证任务可以按照有序的方向和有序的时间执行。

## 实现compose的五种思路

### 面向过程

这个思路就是使用递归的过程思想，不断的检测队列中是否还有任务，如果有任务就执行，并把执行结果往后传递，这里是一个局部的思维，无法预知任务何时结束。直观上最容易结束和理解。

```js
const compose = function(...args) {
  let length = args.length
  let count = length - 1
  let result
  return function f1 (...arg1) {
    result = args[count].apply(this, arg1)
    if (count <= 0) {
      count = length - 1
      return result
    }
    count--
    return f1.call(null, result)
  }
}
```

### 函数组合
这个思路是一种函数组合的思想，将函数两两组合，不断的生成新的函数，生成的新函数挟裹了函数执行的逻辑信息，然后再两两组合，不断的传递下去，这种思路可以提前遍历所有任务，将任务组合成一个可以展开的组合结构，最后执行的时候就像推导多米诺骨牌一样。
```js
// 组合过程
f1 = (...arg) => step2.call(null, init.apply(null, arg))
f2 = (...arg) => step3.call(null, f1.apply(null, arg))
f3 = (...arg) => step4.call(null, f2.apply(null, arg))

// 实现
const _pipe = (f, g) => (...arg) => g.call(null, f.apply(null, arg))
const compose = (...args) => args.reverse().reduce(_pipe, args.shift())
```

### 函数交织（AOP）
这个实现的灵感来自javascript设计模式中的高阶函数，因为compose的任务在本质上就是函数执行，再加上顺序，所以可以把实现顺序执行放到函数本身，对函数的原型进行方法的绑定。方法的作用对象是函数，面向对象封装的数据，面向函数封装的是函数的行为。

需要对函数绑定两个行为 before 和 after，before执行函数多元部分（启动），after执行函数单元部分。
```js
Function.prototype.before = function(fn) {
  const self = this
  return function(...args) {
    let result = fn.apply(null, args)
    return self.call(null, result)
  }
}
 
Function.prototype.after = function(fn) {
  const self = this
  return function(...args) {
    let result = self.apply(null, args)
    return fn.call(null, result)
  }
}
```
这里对函数进行方法的绑定，返回的是带着函数执行的规则的另外一个函数，在这里是次序的排列规则，对返回的函数依然可以进行链式调用。
```js
// compose实现
const compose = function(...args) {
  let before = args.pop()
  let start = args.pop()
  if (args.length) {
    return args.reduce(function(f1, f2) {
      return f1.after(f2)
    }, start.before(before))
  }
  return start.before(before)
}

// 执行过程
const compose = function(...args) {
  let before = args.pop()
  let start = args.pop()
  if (args.length) {
    return args.reduce(function(f1, f2) {
      return f1.after(f2)
    }, start.before(before))
  }
  return start.before(before)
}
```

### Promise
ES6引入了Promise，Promise可以指定一个sequence，来规定一个执行then的过程，then函数会等到执行完成后，再执行下一个then的处理。启动sequence可以使用Promise.resolve()这个函数。构建sequence可以使用reduce。
```js
const compose = function(...args) {
  let init = args.pop()
  return function(...arg) {
    return args.reverse().reduce(function(sequence, func) {
      return sequence.then(function(result) {
        return func.call(null, result)
      })
    }, Promise.resolve(init.apply(null, arg)))
  }
}
```

### Generator
Generator主要使用yield来构建协程，采用中断，处理，再中断的流程。可以事先规定好协程的执行顺序，然后再下次处理的时候进行参数（结果）交接，有一点要注意的是，由于执行的第一个next是不能传递参数的，所以第一个函数的执行需要手动调用，再空耗一个next，后面的就可以同步执行了。
```js
// 构建generator
function* iterateSteps(steps) {
  let n
  for (let i = 0; i < steps.length; i++) {
    if (n) {
      n = yield steps[i].call(null, n)
    } else {
      n = yield
    }
  }
}

// 实现compose
const compose = function(...steps) {
  let g = iterateSteps(steps)
  return function(...args) {
    let val = steps.pop().apply(null, args)
    // 这里是第一个值
    console.log(val)
    // 因为无法传参数 所以无所谓执行 就是空耗一个yield
    g.next()
    return steps.reverse.reduce((val, val1) => g.next(val).value, val)
  }
}
```
