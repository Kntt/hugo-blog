+++
author = "Kntt"
categories = ["2018", "flutter", "dart"]
date = "2018-08-28"
featured = "2018-08-06.png"
featuredalt = ""
featuredpath = "date"
linktitle = "1"
title = "[Flutter-前端视角]学习总结"
description = "学习flutter过程的一些个人简介，包括前三篇笔记，能容不多，仅是个人觉得需要注意的地方，后续还会继续更新，欢迎一起探讨～"
type = "post"

+++

> [[Flutter-前端视角]dart语言学习笔记（1）](/blog/flutter-dart-1/ "[Flutter-前端视角]dart语言学习笔记（1）")

> [[Flutter-前端视角]dart语言学习笔记（2）](/blog/flutter-dart-2/ "[Flutter-前端视角]dart语言学习笔记（2）")

> [[Flutter-前端视角]dart语言学习笔记（3）](/blog/flutter-dart-3/ "[Flutter-前端视角]dart语言学习笔记（3）")

### 对应的前端HTML标签

> HTML里面的标签在flutter里面叫做`Widget`,但是`Widget`并不是html里面的标签，因为css里面的一些属性也处理成相应的`Widget`了。

> 也就是说`Widget`包含标签和CSS属性

1. h1～h6,p,span文字相关标签

```
// Text类，可以看作是块级的文字显示
new Text(
    "Lorem ipsum",
    style: new TextStyle(
        fontSize: 24.0
        fontWeight: FontWeight.w900,
        fontFamily: "Georgia",
    ),
)

// 行内文字使用TextSpan类
new TextSpan(
    style: bold24Roboto,
    children: <TextSpan>[
    new TextSpan(text: "Lorem "),
    new TextSpan(
      text: "ipsum",
      style: new TextStyle(
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        fontSize: 48.0,
      ),
    ),
    ],
)
```
> 这两个类都只能处理文字样式，fontsize， fontweight等。间距等属性要借助其他类去处理

2. img标签

```
// 网络图片
Image.network('networkUrl')
// or
NetworkImage('networkUrl')

// 本地图片
Image.asset('assetsUrl')
// or
AssetImage('assetsUrl')

```
> 第一个使用方式是`Image`类的命名构造函数，第二种用法是针对命名构造函数单独声明的类，没什么区别；

3. div标签

```
new Container(
    color: Color(0xFFDDDDDD), // decoration
    width: 100.0,
    height: 100.0,
    padding: EdgeInsets.all(10.0), // decoration
    margin: EdgeInsets.all(10.0), // decoration
    child: new Text('lorem ~~'),
)
// 等价于HTML
<style>
.container {
    width: 100px;
    height: 100px;
    background-color: #DDDDDD;
    padding: 10px;
    margin: 10px;
}
</style>
<div class="container">
    <p>lorem ~~</p>
</div>

```
> `Container`类，还有其他参数，注释有decoration的参数，可以统一在decoration参数中实现，decoration参数和注释有decoration的参数是互斥的（如果decoration参数存在，其他属性就不需要了，都需要在decoration参数中去处理） decoration参数的类型是实现`Decoration`类的类或子类

```
new Container(
    decoration: new BoxDecoration(
        // color: Colors.red,
        gradient: new LinearGradient(
            colors: [
                Colors.red,
                Colors.blue,
            ],
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        border: Border.all(width: 1.0, color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
    ),
)
```

> decoration参数 <===> HTML 属性 `background`, `border`, `border-radius`, `margin`, `padding`，`box-shadow`

### HTML中的常见场景在flutter中的实现

[flutter文档于web开发者视角](https://flutterchina.club/web-analogs/)

这里我讲一些没有介绍的， 以及我学习过程中遇到的

1. 复杂背景的实现

> 最简单的办法是使用图片作为背景， 但是使用图片有些弊端，比如适配～。背景带动画效果的，使用图片也实现不了～

解决思路：通过Widget来实现复杂的效果，最终把实现的Widget作为页面背景

和web开发类比一下：两个div标签，一个div用来实现背景，一个div装内容，最终通过定位，使得两个div重叠在一起，通过zindex控制层级，最终达到想要的视觉效果

当然在flutter里面的思路也是一样的：不同的是flutter中有一个Widget，叫`Stack`
[可以允许其子widget简单的堆叠在一起](https://docs.flutter.io/flutter/widgets/Stack-class.html)

```
Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color(0xFF0071EF),
            boxShadow: <BoxShadow>[
              new BoxShadow (
                color: const Color(0xFF0071EF),
                offset: new Offset(0.0, 16.0),
                blurRadius: 24.0,
                spreadRadius: -16.0
              ),
            ]
          ),
        ), // 实现boxshadow
        Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: new ClipPath(
                clipper: new ClipperOne(),
                child: Container(
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF0071EF),
                        Color(0xFF2688F6),
                      ],
                    )
                  ),
                  height: 184.0,
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new ClipPath(
                clipper: new ClipperTwo(),
                child: Container(
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF0071EF),
                        Color(0xFF2688F6),
                      ],
                    )
                  ),
                  height: 184.0,
                ),
              ),
            ),
          ],
        ), // 复杂的背景
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Text('lorem content'),
        ), // 上层的内容
      ],
    )

```

2.滚动

> web中可以直接通过overflow来实现，在flutter中提供的特定功能的Widget
`SingleChildScrollView`, `ListView` 等～

```
new ListView.builder(
  padding: new EdgeInsets.all(8.0),
  itemExtent: 20.0,
  itemBuilder: (BuildContext context, int index) {
    return new Text('entry $index');
  },
)

SingleChildScrollView(
    child: Column(
        children: <Widget>[
            appBarColumn(),  // 自定义组件
            swiperCard(), // 自定义组件
            actionsCard(), // 自定义组件
        ],
    ),
)

```

3. 滚动容器显示滚动条

> 使用`ScrollBar`这个Widget

```
Scrollbar(
    child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemExtent: 20.0,
        itemBuilder: (BuildContext context, int index) {
            return new Text('entry $index');
        },
    )
)
```
4. 点击事件

> `InkWell`或者button相关的Widget都有onPressed或onTap参数来实现点击

```
InkWell(
    onTap: () { print('onTap'); },
    child: Container(
        child: Text('tap')
    ),
)

FlatButton(
    onPressed: () { print('onPressed'); },
    child: Text('button'),
)
// 图片点击跳转 没有a标签之类的Widget, 可以考虑自定义Widget，模拟web方式

InkWell(
    onTap: () { Navigator.push(context, route) },
    child: Image.asset('assetUrl'),
)

```

5. 事件监听


### flutter中常用的Widget
[Widgets 目录](https://flutterchina.club/widgets/)

1. `Container`, `BoxDecoration`，相当于div标签
2. `Text`, `TextStyle` 文字
3. `Flex`, `Row`, `Collumn`, `Expanded`, `Flexible` 使用flex布局的相关Widget
4. `Image` 图片
5. `ListView`, `SingleChildScrollView` 滚动容器
6. `FlatButton`, `RaisedButton`, `IconButton`, `FloatingActionButton`, `PopupMenuButton`, `ButtonBar` 按钮
7. `Padding`, `Center`, `Stack`, `Color` 属性相关的Widget
8. `Icons`, `Colors`, `Alignment`, `Axis` 枚举
9. 


## 总结

1. HTML通过标签嵌套来实现的tree结构，flutter通过child或者children参数实现tree结构
2. flutter中没有css中class的概念， 想实现样式复用，可以通过自定义Widget来实现（虽然可以实现，但是复用率不高，好多样式还是要重复写的，比如背景颜色是红色，不同的widget没办法抽离通用class，这里没有css方便）
3. 等待补充～
4. 学习过程写的项目
[项目地址:https://github.com/Kntt/flutter-app-study](https://github.com/Kntt/flutter-app-study)

