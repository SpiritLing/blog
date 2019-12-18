---
title: JavaScript 创建对象和继承
tags:
  - [JavaScript]
  - [Object]
  - [Inheritance]
categories:
  - [JavaScript]
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
abbrlink: 5c3d9c03
date: 2019-11-28 10:39:07
keywords: [javascript,对象,继承]
description:
---

{% cq %}  JavaScript 创建对象和继承 {% endcq %}

<!-- more -->

## 创建对象

JS中可以有许多设计模式，在这些中推荐使用组合构造函数和原型模式；
因为不太善于写文章，所以下面简化文字叙述，直接看代码

### 工厂模式

```js
function person(name,age){
    var obj={}
    obj.name=name;
    obj.age=age;
    obj.sayName=function(){
        console.log(this.name);
    }
    return obj;
}
```

### 构造函数模式

正常情况下我们将函数名起为大写字母开头

```js
function Person(name,age){
    this.name=name;
    this.age=age;
    this.sayName=function(){
        console.log(this.name);
    }
}

var a=new Person("张三",29);
var b=new Person("李四",22);

a.sayName();
b.sayName();
```

构造函数可以通过 `new` 关键字来进行处理，使其实例化，每个都有独有数据，也就是私有变量

### 原型模式

```js
function Person(){
    
}
Person.prototype.name = "Li Si";
Person.prototype.age = 21;
Person.prototype.sayName=function(){
    console.log(this.name);
}

var person1=new Person();
person1.sayName(); //"Li Si"
var person2=new Person();
person2.sayName(); //"Li Si"
```

原型模式所有的都共用同一个数据，相当于公有变量

### 组合模式：构造函数和原型模式结合

通过上面两个例子，两个都有独有的特性，所以我们可以组合两者了来进行处理，一般推荐使用组合模式

```js
function Person(name,age){
    this.name=name;
    this.age=age;
}
Person.prototype.sayName=function(){
    console.log(this.name);
}

var person1=new Person("张三");
person1.sayName(); //"张三"
var person2=new Person("李四");
person2.sayName(); //"李四"
```

这样各自经过实例化后，都有自己的独有数据，但是却有着公共方法；

## 继承

ES5 继承有许多中方式，我们这里只说普通常用的继承方式

### 原型链赋值继承

```js
function father(name){
    this.name=name;
}

father.prototype.sayName=function(){
    console.log(this.name);
}

function sub(age){
    this.age=age;
}
sub.prototype=new father();
sub.prototype.sayAge=function(){
    console.log(this.age);
}
```

上面就是典型的原型链赋值继承，但是这个继承是有缺点的，在继承时需要 `new` 关键字进行处理。

### 构造函数继承

```js
function father(name){
    this.name=name;
    this.age=22;
}

father.prototype.sayName=function(){
    console.log(this.name);
}

function sub(){
	  father.apply(this,arguments)
}

var s=new sub("a")
> s
> sub {name: "a", age: 22}
    age: 22
    name: "a"
    __proto__:
    constructor: ƒ sub()
    __proto__: Object
```

构造函数继承最后在输出中会发现并没有 父级的方法 ，但是可以将数据传到父级，与原型链继承互补，所以衍生出组合继承的方式

### 组合继承

```js
function Father(name) {
    this.name = name;
    this.className = "Father"
}
Father.prototype.sayName = function () {
    console.log(this.name)
}
function Sub(name) {
    Father.apply(this, arguments)
}
//继承原型
Sub.prototype = new Father();

var s=new Sub("张三",12);


```

不仅会继承构造函数中的属性，也会复制父类原型链中的属性

但是在 `Sub.prototype = new Father();` 之后

Sub 的原型变成这样的了

```js
> Sub.prototype
> {name: undefined, className: "person"}
```

也就是说Sub的原型中已经有了一个name属性，而之后创建 s 时传给构造的函数的name则是通过this重新定义了一个name属性，相当于只是覆盖掉了原型的name属性（原型中的name依然还在），这样很不优雅。

### 寄生组合继承


```js
function Father(name) {
    this.name = name;
    this.className = "Father"
}
Father.prototype.sayName = function () {
    console.log(this.name)
}
function Sub(name,age) {
    this.age=age;
    Father.call(this, name)
}
// 注意此处
Sub.prototype=Object.create(Father.prototype)

Sub.prototype.sayAge=function(){
    console.log(this.age)
}
```

这里用到了 `Object.creat(obj)` 方法，该方法会对传入的obj对象进行浅拷贝。和上面组合继承的主要区别就是：将父类的原型复制给了子类原型。这种做法很清晰：

1. 构造函数中继承父类属性／方法，并初始化父类。
2. 子类原型和父类原型建立联系。

还有一个问题，就是constructor属性，我们来看一下：

```js
> Father.prototype.constructor
< Father(name){
   this.name=name;
   this.className="Father" 
 }
> Sub.prototype.constructor
< Father(name){
   this.name=name; 
   this.className="Father" 
  }
```

constructor是类的构造函数，我们发现，Father和Sub实例的constructor指向都是Father，当然，这并不会改变instanceof的结果，但是对于需要用到construcor的场景，就会有问题。所以一般我们会加上这么一句：

```js
Sub.prototype.constructor = Sub
```
