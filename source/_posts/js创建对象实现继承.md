---
title: js创建对象实现继承
tags:
  - 整理
copyright: true
comments: true
date: 2018-10-31 10:21:48
categories: 知识
photos:
top: 114
---

今天10月31日，万圣节前夜。希望ff的病早点好，身体健康。

## 创建对象(字面量、构造函数、create方法、调用函数返回对象)
```javascript
var obj = {} // 字面量 
var obj = new Object() // 很少见，性能低 没有形参时可省略()
var obj = Object.create(null) // 以xx为原型创建对象
var obj = Object.assign({})   // 复制到目标对象
// Object.assign()还可以去除多余的参数覆盖
Object.assign({ a: 1, b: 2 }, { b: 3, c: 3 })
const newObj = { ...{ a: 1, b: 2 }, ...{ b: 3, c: 3 } }
// {a: 1, b: 3, c: 3}
// Object() ==> {}
```

---
<!--more-->

### 复制一个对象
```javascript
var obj = { a: 1 };
var copy = Object.assign({}, obj);
console.log(copy); // { a: 1 }
```

### 浅拷贝

Object.assign()拷贝的是属性值。假如源对象的属性值是一个指向对象的引用，它也只拷贝那个引用值。

```javascript
let obj1 = { a: 0 , b: { c: 0}};
let obj2 = Object.assign({}, obj1);
console.log(JSON.stringify(obj2)); // { a: 0, b: { c: 0}}

obj1.a = 1;
console.log(JSON.stringify(obj1)); // { a: 1, b: { c: 0}}
console.log(JSON.stringify(obj2)); // { a: 0, b: { c: 0}}

obj2.a = 2;
console.log(JSON.stringify(obj1)); // { a: 1, b: { c: 0}}
console.log(JSON.stringify(obj2)); // { a: 2, b: { c: 0}}

obj2.b.c = 3;
console.log(JSON.stringify(obj1)); // { a: 1, b: { c: 3}}
console.log(JSON.stringify(obj2)); // { a: 2, b: { c: 3}}

// Deep Clone
obj1 = { a: 0 , b: { c: 0}};
let obj3 = JSON.parse(JSON.stringify(obj1));
obj1.a = 4;
obj1.b.c = 4;
console.log(JSON.stringify(obj3)); // { a: 0, b: { c: 0}}
```

### 合并对象
```javascript
var o1 = { a: 1 };
var o2 = { b: 2 };
var o3 = { c: 3 };

var obj = Object.assign(o1, o2, o3);
console.log(obj); // { a: 1, b: 2, c: 3 }
console.log(o1);  // { a: 1, b: 2, c: 3 }, 注意目标对象自身也会改变。
```

### 合并相同属性的对象
```javascript
var o1 = { a: 1, b: 1, c: 1 };
var o2 = { b: 2, c: 2 };
var o3 = { c: 3 };

var obj = Object.assign({}, o1, o2, o3);
console.log(obj); // { a: 1, b: 2, c: 3 }
```

### 创建对象模式(6种)
#### 工厂模式

在一个函数内创建一个空对象，给空对象添加属性和属性值，return这个对象。然后调用这个函数并传入参数来使用。

```javascript
function createPerson(name, age, job){ 
    var o = new Object();
    o.name = name;
    o.age = age;
    o.sayName = function(){ alert(this.name); }; 
    return o;
}
var person1 = createPerson("cosyer", 23); 
console.log(person1.name) //cosyer
console.log(person1.sayName()) //cosyer
```
优点：解决了创建多个相似对象的问题
缺点：没有解决对象识别的问题（即怎样知道一个对象的类型）

#### 构造函数模式

创建一个构造函数，然后用new 创建构造函数的实例。

```javascript
function Person(name, age, job){
    this.name = name; 
    this.age = age; 
    this.sayName = function(){ 
        console.log(this.name); 
    }; 
}

var person1 = new Person("cosyer", 22); 
console.log(person1.name) //cosyer
console.log(person1.sayName()) //cosyer
```

优点：

1. 子类型构造函数中可向超类型构造函数传递参数。
2. 方法都在构造函数中定义，对于属性值是引用类型的就可通过在每个实例上重新创建一遍，避免所有实例的该属性值指向同一堆内存地址，一个改其他也跟着改。
原始 复杂(引用) 
缺点：
对于一些可共用的属性方法（比如这边的this.sayName）没必要都在每个实例上重新创建一遍，占用内存。(无法复用)


- 对象字面量vs构造函数创建对象对比

字面量的优势：

1. 代码量更少，更易读；

2. 可以强调对象就是一个简单的可变的散列表，而不必一定派生自某个类；

3. 对象字面量运行速度更快，因为它们可以在解析的时候被优化：它们不需要作用域解析(scope resolution)；因为存在我们创建了一个同名的构造函数Object()的可能，当我们调用Object()的时候，解析器需要顺着作用域链从当前作用域开始查找，如果在当前作用域找到了名为Object()的函数就执行，如果没找到，就继续顺着作用域链往上照，直到找到全局Object()构造函数为止；

4. Object()构造函数可以接收参数，通过这个参数可以把对象实例的创建过程委托给另一个内置构造函数，并返回另外一个对象实例，而这往往不是你想要的。

#### 原型模式

创建一个函数，给函数原型对象赋值。利用函数的prototype属性指向函数的原型对象，从而在原型对象添加所有实例可共享的属性和方法。

```javascript
function Person(){ }
Person.prototype.name = "cosyer"; 
Person.prototype.age = 23; 
Person.prototype.sayName = function(){
     console.log(this.name); 
};
var person1 = new Person();
console.log(person1.name) //cosyer
console.log(person1.sayName()) //cosyer
```
优点：
可以让所有对象实例共享它所包含的属性和方法(复用性)。
缺点：

1. 在创建子类型的实例时，不能向超类型的构造函数中传递参数。
2. 如果包含引用类型值的属性，那一个实例改了这个属性（引用类型值），其他实例也跟着改变。

#### 组合模式

构造函数模式用于定义实例属性，而原型模式用于定义方法和共享的属性。简单来说就是属性值是引用类型的就用构造函数模式，方法和属性能共享的就用原型模式，取精去糟。

```javascript
function Person(name, age){ //构造函数模式
    this.name = name; 
    this.age = age; 
    this.friends = ["aa", "bb"]; 
}
Person.prototype = {  //原型模式
    constructor : Person, 
    sayName : function(){ 
        console.log(this.name); 
    }
}
Person.prototype.hobby = {exercise:"ball"}; //原型模式

var person1 = new Person("cosyer", 23);
var person2 = new Person("cuby", 27)
person1.friends.push("cc");   
console.log(person1.friends);   //"aa,bb,cc"
console.log(person2.friends);   //"aa,bb"
person1.sayName = function(){console.log(this.age)};
person1.sayName();  //22
person2.sayName();  //cuby
person1.hobby.exercise = "running";
console.log(person1.hobby);  //{exercise: "running"}
console.log(person2.hobby); //{exercise: "running"}
```

#### 动态原型模式
```javascript
function Person(name, age){ //构造函数模式
    this.name = name; 
    this.age = age; 
    this.friends = ["aa", "bb"]; 
    if(typeof Person.prototype.hobby !== 'object'){
        // 只写入1次
        Person.prototype.hobby = {exercise:"ball"};  
    }
}
```

#### 寄生构造函数模式

## 继承方式(9种)
### 构造函数继承(复制父类的实例属性给子类)
```javascript
function SuperType(){ 
    this.colors = ["red", "blue", "green"]; 
}
function SubType(){ //继承了 SuperType 
    SuperType.call(this); 
}

var instance1 = new SubType(); 
instance1.colors.push("black"); 
console.log(instance1.colors); //"red,blue,green,black"
var instance2 = new SubType(); 
console.log(instance2.colors); //"red,blue,green"
```
优点：
1. 简单，易于实现
2. 父类新增原型方法、原型属性，子类都能访问到
缺点：
1. 无法实现多继承，因为原型一次只能被一个实例更改
2. 来自原型对象的所有属性被所有实例共享（上诉例子中的color属性）
3. 创建子类实例时，无法向父构造函数传参

### 原型链继承(将父类的实例作为子类的原型)
```javascript
function SuperType(){ 
    this.colors = ["red", "blue", "green"];
}
function SubType(){};
SubType.prototype = new SuperType();

var instance1 = new SubType();
var instance2 = new SubType(); 
console.log(instance1.colors); //["red", "blue", "green"]
console.log(instance2.colors);//["red", "blue", "green"]

instance1.colors.push("black"); 
console.log(instance1.colors);//["red", "blue", "green", "black"]
console.log(instance2.colors);//["red", "blue", "green", "black"]
```
优点：
1. 简单，易于实现
2. 父类新增原型方法、原型属性，子类都能访问到
缺点：
1. 无法实现多继承，因为原型一次只能被一个实例更改
2. 来自原型对象的所有属性被所有实例共享（上诉例子中的color属性）
3. 创建子类实例时，无法向父构造函数传参

### 组合继承(将原型链和借用构造函数的技术组合到一块。使用原型链实现对原型属性和方法的继承，而通过构造函数来实现对实例属性的继承)
```javascript
function SuperType(name){  //父类（构造函数）
    this.name = name;
}

SuperType.prototype.sayName = function(){  //父类的原型添加一个方法
    console.log(this.name);
}

function SubType(name, age){  //借用构造函数来实现对实例属性的继承 
    SuperType.call(this, name);    //继承实例属性 这边继承this.name = name;
    this.age = age;     //自己的属性
}

SubType.prototype = new SuperType();    //使用原型链实现对原型属性和方法的继承  这边是继承
SubType.prototype.constructor = SubType;
SubType.prototype.sayAge = function(){ 
    alert(this.age); 
};
var instance1 = new SubType("cosyer", 23);
console.log(instance1.age)   //23
console.log(instance1.name)  //cosyer
instance1.sayName(); //cosyer
instance1.sayAge(); //23
```
优点：
1. 弥补了构造继承的缺点，现在既可以继承实例的属性和方法，也可以继承原型的属性和方法
2. 既是子类的实例，也是父类的实例
3. 可以向父类传递参数
4. 函数可以复用
缺点：
1. 调用了两次父类构造函数，生成了两份实例
2. constructor指向问题

### 实例继承(为父类实例添加新特征，作为子类实例返回)
```js
function Son(name) {
    let f=new Father('传给父类的参数')
    f.name=name||'son'
    return f
}

let s = new Son("son"); //或者直接调用子类构造函数 let s = Son("son");
console.log(s.name); // son
s.sayAge(); // 18
s.sayName(); // son
console.log(s.age); // 18
console.log(s instanceof Father); // true
console.log(s instanceof Son); // false
console.log(s.constructor === Father); // true
console.log(s.constructor === Son); // false=
```
优点：
1. 不限制调用方式，不管是new 子类()还是子类(),返回的对象具有相同的效果
缺点：
1. 实例是父类的实例，不是子类的实例
2. 不支持多继承

### 拷贝继承(对父类实例中的的方法与属性拷贝给子类的原型)
```js
function Son(name) {
    let f = new Father("传给父类的参数");
    for (let k in f) {
    Son.prototype[k] = f[k];
    }
    Son.prototype.name = name;
}

let s = new Son("son");
console.log(s.name); // son
s.sayAge(); // 18
s.sayName(); // son
console.log(s.age); // 18
console.log(s instanceof Father); // false
console.log(s instanceof Son); // true
console.log(s.constructor === Father); // false
console.log(s.constructor === Son); // true
```
优点：
1. 支持多继承
缺点：
1. 效率低，性能差，占用内存高（因为需要拷贝父类属性）
2. 无法获取父类不可枚举的方法（不可枚举的方法，不能使用for-in访问到)

### 寄生组合继承(通过寄生方式，砍掉父类的实例属性，避免了组合继承二次执行父类构造函数的缺点)
```js
function Son(name) {
    Father.call(this);
    this.name = name || "son";
}

// 方法一  自己动手创建一个中间类
// (function() {
//   let NoneFun = function() {};
//   NoneFun.prototype = Father.prototype;
//   Son.prototype = new NoneFun();
//   Son.prototype.constructor = Son;
// })();

// 方法二  直接借用Object.create()方法
Son.prototype = Object.create(Father.prototype);
// 修复构造函数指向
Son.prototype.constructor = Son;

let s = new Son("son");
console.log(s.name); // son
s.sayAge(); // 18
s.sayName(); // son
console.log(s.age); // 18
console.log(s instanceof Father); // true
console.log(s instanceof Son); // true
console.log(s.constructor === Father); // false
console.log(s.constructor === Son); // true
```
优点：
1. 比较完美（js实现继承首选方式）
缺点：
1.实现起来较为复杂（可通过Object.create简化）

```js
function Person(obj) {
    this.name = obj.name
    this.age = obj.age
}
Person.prototype.add = function(value){
    console.log(value)
}
var p1 = new Person({name:"番茄", age: 18})

function Person1(obj) {
    Person.call(this, obj)
    this.sex = obj.sex
}
// 这一步是继承的关键
Person1.prototype = Object.create(Person.prototype)
Person1.prototype.play = function(value){
    console.log(value)
}
var p2 = new Person1({name:"鸡蛋", age: 118, sex: "男"})
```

### es6 class继承(使用extends表明继承自哪个父类，并且在子类构造函数中必须调用super) 
```js
class Son extends Father {
    constructor(name) {
    super(name);
    this.name = name || "son";
    }
}

let s = new Son("son");
console.log(s.name); // son
s.sayAge(); // 18
s.sayName(); // son
console.log(s.age); // 18
console.log(s instanceof Father); // true
console.log(s instanceof Son); // true
console.log(s.constructor === Father); // false
console.log(s.constructor === Son); // true
```

### 原型式继承
利用一个空对象作为中介，将某个对象直接赋值给空对象构造函数的原型。
```js
function object(obj){
  function F(){}
  F.prototype = obj;
  return new F();
}
```
缺点：
- 原型链继承多个实例的引用类型属性指向相同，存在篡改的可能。
- 无法传递参数

### 寄生式继承
核心：在原型式继承的基础上，增强对象，返回构造函数。
```js
function createAnother(original){
  var clone = object(original); // 通过调用 object() 函数创建一个新对象
  clone.sayHi = function(){  // 以某种方式来增强对象
    alert("hi");
  };
  return clone; // 返回这个对象
}
```
缺点（同原型式继承）

## ES5/ES6 的继承除了写法以外还有什么区别
- ES5 的继承，实质是先创造子类的实例对象this，然后再将父类的方法添加到this上面（Parent.apply(this)）。
```js
function Super() {}
function Sub() {}

Sub.prototype = new Super();
Sub.prototype.constructor = Sub;

var sub = new Sub();

Sub.__proto__ === Function.prototype;
```

- ES6 的继承机制完全不同，实质是先将父类实例对象的属性和方法，加到this上面（所以必须先调用super方法），然后再用子类的构造函数修改this。
```js
class A extends B{}
A.__proto__ === B;  //继承属性
A.prototype.__proto__ == B.prototype;//继承方法
```

`Happy Halloween!`
