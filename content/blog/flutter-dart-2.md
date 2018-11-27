+++
author = "Kntt"
categories = ["2018", "flutter", "dart"]
date = "2018-08-09"
featured = "2018-08-06.png"
featuredalt = ""
featuredpath = "date"
linktitle = "1"
title = "[Flutter-前端视角]dart语言学习笔记（2）"
description = "学习flutter过程，个人对于dart的见解，以及学习过程的记录，欢迎指正～"
type = "post"

+++

### 标记特殊需要记忆的点

1. 取整```~/```操作符之前可能很少看到，代码如下

```
int a = 3；
int b = 2；
print(a~/b);//输出1
```

2.级联操作符，当你要对一个单一的对象进行一系列的操作的时候，
可以使用级联操作符 `..`(相当于js的链式调用，隐式的返回原对象)

```
class Person {
    String name;
    String country;
    void setCountry(String country){
      this.country = country;
    }
    String toString() => 'Name:$name\nCountry:$country';
}
void main() {
  Person p = new Person();
  p ..name = 'Wang'
    ..setCountry('China');
  print(p);
}
```

3. `If`语句的判断条件为==bool==值，用法和大多语言一样（只接受布尔值， 其他类型的值都译为`false`）

```
if(i<0){
  print('i < 0');
}else if(i ==0){
  print('i = 0');
} else {
  print('i > 0');
}
```

4. 循环 ```for forEach for-in```

```
for(int i = 0; i<3; i++) {
  print(i);
}
```

如果迭代的对象是容器，那么可以使用`forEach`或者`for-in`

```
var collection = [0, 1, 2];

// forEach的参数为Function
collection.forEach(print);

for(var x in collection) {
  print(x);
}
```

另外，`while`和`do-while`没有什么变化

```
while(boolean){
  //do something
}
 
do{
  //do something
} while(boolean)
```

5.`swith`的参数可以是`num`，或者`String`

```
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    break;
  case 'OPEN':
    break;
  default:
    print('Default');
}
```

特殊用法，使用==continue== & flag ,其他和js没什么区别

```
var command = 'CLOSED';
  switch (command) {
    case 'CLOSED':
      print('CLOSED');
      continue nowClosed; // Continues executing at the nowClosed flag.
    case 'OPEN':
      print('OPEN');
      break;
    nowClosed: // Runs for both CLOSED and NOW_CLOSED.
    case 'NOW_CLOSED':
      print('NOW_CLOSED');
      break;
  }
```