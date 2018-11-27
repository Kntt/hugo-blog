+++
author = "Kntt"
categories = ["2018", "flutter", "dart"]
date = "2018-08-06"
featured = "2018-08-06.png"
featuredalt = ""
featuredpath = "date"
linktitle = "1"
title = "[Flutter-前端视角]dart语言学习笔记（1）"
description = "学习flutter过程，个人对于dart的见解，以及学习过程的记录，欢迎指正～"
type = "post"

+++

#### 一. 基础数据类型 - 一切皆对象

- Numbers
- Strings
- Booleans
- Lists
- Maps
- Runes (用于在字符串中表示 Unicode 字符) -- 后面继续看
- Symbols

---
1. 声明变量 关键字```var``` ```const``` ```final```

```
a. var
    // 通过var声明变量，这一点和js没什么区别
b. const , final
    // 这两个关键字都是声明常量的（重点看下面的区别）
    
    final time = new DateTime.now(); //Ok
    const time = new DateTime.now(); //Error，new DateTime.now()不是const常量
    
    // const 声明的常量不能是变量， 也就是说不能是官方文档所说的运行时常量
    // final 声明的常量可以是运行时常量也可以是编译时常量（final包含const）
    // 例如：声明 PI 是个运行时常量  就用const PI = 3.14159
    
    // var、final等在左边定义变量的时候，并不关心右边是不是常量
    // 但是如果右边用了const，那么不管左边如何，右边都必须是常量
    
    const list = const[1,2,3];//Ok
    const list = [1,2,3];//Error
    
    final list = [1,2,3];//Ok
    final list = const[1,2,3];//Ok
    final list = const[new DateTime.now(),2,3];//Error,const右边必须是常量
    
```