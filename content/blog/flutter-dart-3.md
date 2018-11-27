+++
author = "Kntt"
categories = ["2018", "flutter", "dart"]
date = "2018-08-20"
featured = "2018-08-06.png"
featuredalt = ""
featuredpath = "date"
linktitle = "1"
title = "[Flutter-前端视角]dart语言学习笔记（3）"
description = "学习flutter过程，个人对于dart的见解，以及学习过程的记录，欢迎指正～"
type = "post"

+++

### 类和对象
Dart是一门使用类和单继承的面向对象语言
>所有的对象都是类的实例，并且所有的类都是`Object`的子类

1. 定义

>类的定义用`class`关键字

>如果未显式定义构造函数，会默认一个空的构造函数

>使用`new`关键字和构造函数来创建对象

2.构造函数

>如果只是简单的参数传递，可以在构造函数的参数前加`this`关键字定义或者参数后加` :` 再赋值

>没有函数体的函数可以直接写`;`来结束函数声明

```
class Point {
    num x;
    num y;
    num z;
     // 第一个值传递给this.x，第二个值传递给this.y, 类似js中的解构赋值
    Point(this.x, this.y, z) {
            this.z = z;
    }
    // 命名构造函数，格式为Class.name(var param)
    Point.fromList(var list): x = list[0], y = list[1], z=list[2];

    //当然，上面句你也可以简写为：this相当于自身的构造函数
    //Point.fromList(var list):this(list[0], list[1], list[2]);

     String toString() => 'x:$x  y:$y  z:$z';
}

void main() {
    var p1 = new Point(1, 2, 3);
    var p2 = new Point.fromList([1, 2, 3]);
    print(p1);//默认调用toString()函数
}
```
>如果你要创建一个不可变的对象，你可以定义编译时常量对象，需要在构造函数前加`const`

```
class ImmutablePoint {
    final num x;
    final num y;
    const ImmutablePoint(this.x, this.y); // 常量构造函数
}
static final ImmutablePoint origin = const ImmutablePoint(0, 0); 
// 创建一个常量对象不能用new，要用const
```

>在flutter中使用方式的差异

```
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final title;
  final subtitle;
  final textColor;
  ProfileTile({this.title, this.subtitle, this.textColor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: textColor
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            color: textColor
          ),
        ),
      ],
    );
  }
}
// 我们有注意到构造函数的参数多了｛｝
// 在使用时的不同就是:

new ProfileTile(
    title: 'xxx',
    subtitle: 'xxxx'
)
// 这样通过构造函数我们可以直观的看出每个参数的含义
// 总结就是：不使用｛｝包裹参数的构造函数，是按着参数的顺序去相应的赋值
// 使用｛｝包裹的构造函数，参数是具名的， 不用关心顺序
```

3. Getters And Setters

>Getter和Setter是用来读写一个对象属性的方法每个字段都对应一个隐式的`Getter`和`Setter`但是调用的时候是`obj.x`，而不是`obj.x()`

>你可以使用get和set关键字扩展功能如果字段为final或者const的话，那么它只有一个getter方法

```
class Rectangle {
    num left;
    num top;
    num width;
    num height;

    Rectangle(this.left, this.top, this.width, this.height);
    
    // right 和 bottom 两个属性的计算方法
    num get right => left + width;
    set right(num value) => left = value - width;
    num get bottom => top + height;
    set bottom(num value) => top = value - height;
}

main() {
    var rect = new Rectangle(3, 4, 20, 15);
    assert(rect.left == 3);
    rect.right = 12;
    assert(rect.left == -8);
}
```

4. 抽象类

>在Dart中类和接口是统一的，类就是接口

>如果你想重写部分功能，那么你可以继承一个类，关键字 ==`extends`==

>如果你想实现某些功能，那么你也可以实现一个类，关键字 ==`implements`==

>使用 ==`abstract`== 关键字来定义抽象类，并且抽象类==不能被实例化==

>抽象方法不需要关键字，直接以分号 ; 结束即可

```
abstract class Shape { // 定义了一个 Shape 类/接口
    num perimeter(); // 这是一个抽象方法，不需要abstract关键字，是隐式接口的一部分。
}

class Rectangle implements Shape { // Rectangle 实现了 Shape 接口
    final num height, width; 
    Rectangle(num this.height, num this.width);  // 紧凑的构造函数语法
    num perimeter() => 2*height + 2*width;       // 实现了 Shape 接口要求的 perimeter 方法
}

class Square extends Rectangle { // Square 继承 Rectangle
    Square(num size) : super(size, size); // 调用超类的构造函数
}
```
5. 工厂构造函数

>Factory单独拿出来讲，因为这不仅仅是构造函数，更是一种模式

>有时候为了返回一个之前已经创建的缓存对象，原始的构造方法已经不能满足要求

>那么可以使用工厂模式来定义构造函数

>并且用关键字new来获取之前已经创建的缓存对象

>私有变量前面增加下划线，dart没有private前缀

```
class Logger { 
    final String name; 
    bool mute = false; 
    
    // 变量前加下划线表示私有属性 
    static final Map<String, Logger> _cache = <String, Logger>{}; 
    
    factory Logger(String name) { 
        if (_cache.containsKey(name)) { 
            return _cache[name]; 
        } else { 
            final logger = new Logger._internal(name); 
            _cache[name] = logger; 
            return logger; 
        } 
    }
    // 私有命名构造函数
    Logger._internal(this.name); 
    
    void log(String msg) { 
        if (!mute) { 
            print(msg); 
        } 
    } 
} 

var logger = new Logger('UI'); 
logger.log('Button clicked');
```