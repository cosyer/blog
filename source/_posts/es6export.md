---
title: export/export default/import的区别以及用法
tags:
  - es6
copyright: true
comments: true
date: 2018-07-06 14:41:12
categories: JS
photos:
---

ES6模块主要有两个功能：export和import

export用于对外输出本模块（一个文件可以理解为一个模块）变量的接口

import用于在一个模块中加载另一个含有export接口的模块。

也就是说使用export命令定义了模块的对外接口以后，其他JS文件就可以通过import命令加载这个模块（文件）。

---
<!-- more -->

## export和import（一个导出一个导入）
```javascript
// a 文件 
export var name="cosyer" // 导出单个变量

// 引用a文件 
import {name} from './a'
export default {
    data(){

    },
    howl:function (){
    console.log(name) // cosyer
    }
}

// 导出多个变量 
let name1='张三';
let name2='李四';
export {name1,name2}

// 引用多个变量
import {name1,name2} from './a'

// 导出函数
function mini(num){
    console.log(num)
}

export {mini}

// 引用函数
import {mini} from './a'
export default{
    howl:function(){
        mini(1) // 1
    }
}
```

## export和export default

1. export与export default均可用于导出常量、函数、文件、模块等。

2. 你可以在其它文件或模块中通过import + (常量 | 函数 | 文件 | 模块)名的方式，将其导入，以便能够对其进行使用。

3. 在一个文件或模块中，export、import可以有多个，export default仅有一个。

```javascript
export name1;
export name2;
```

4. 通过export方式导出，在导入时要加{}，export default则不需要。

其实很多时候export与export default可以实现同样的目的，但使用export default命令，为模块指定默认输出，这样就不需要知道加载模块的变量名。

```javascript
export default name
import name from './a'
```

- 当用export default people导出时，就用 import people 导入（不带大括号）。
- 一个文件里，有且只能有一个export default。但可以有多个export。
- 当用export name 时，就用 import{name} 导入（记得带上大括号）。
- 当一个文件里，既有一个export default people, 又有多个export name 或者 - export age时，导入就用 import people,{name,age}。
- 当一个文件里出现n多个 export 导出很多模块，导入时除了一个一个导入，也可以用 import * as example。