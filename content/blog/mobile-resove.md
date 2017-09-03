+++
author = "Kntt"
categories = ["HTML5","CSS3"]
date = "2016-09-20"
featured = "2016-09.png"
featuredalt = ""
featuredpath = "date"
linktitle = "1"
title = "移动端网页布局方法总结"
description = "移动端网页布局中需要注意事项以及解决方法总结"
type = "post"

+++

### 1. 移动端，a、input标签被点击时查实的半透明灰色背景

描述：发生在wp操作系统中

```
<meta name="msapplication-tap-highlight" content="no">
```

--------------------------------------------------------------------------------

### 2.关闭IOS键盘首字母大写

描述：

```
<input type="text" autocapitalize="off" />
```

--------------------------------------------------------------------------------

### 3.禁止文本缩放

描述：

```
html {
    -webkit-text-size-adjust: 100%;
}
```

--------------------------------------------------------------------------------

### 4.清除输入框内阴影

描述：IOS中，输入框默认有内部阴影，但是无法用box-shadow来清除

```
input,
textarea {
    border: 0;
    -webkit-appearance: none;
}
```

--------------------------------------------------------------------------------

### 5.忽略页面的数字为电话，忽略email

描述：

```
<meta name="format-detection" content="telephone=no, email=no"/>
```

--------------------------------------------------------------------------------

### 6.快速回弹滚动

描述：可以选择相应插件，iscroll，idangero swiper，文档一大堆；

```
.xxx {
    overflow: auto;
    -webkit-overflow-scrolling: touch;
}
```

--------------------------------------------------------------------------------

### 7.禁止选中内容

描述：如果你不想用户可以选中页面中的内容，那么你可以在css中禁掉;

```
.user-select-none {
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
}
// 兼容ie6-9
<any onselectstart="return false;" unselectable="on"></any>
```

--------------------------------------------------------------------------------

### 8.移动端取消touch高亮效果

描述：移动端页面，所有a标签在触发点击时或者所有设置了伪类 :active 的元素，默认都会在激活状态时，显示高亮框，如果不想要这个高亮，那么你可以通过css以下方法来禁止：

```
.xxx {
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}
```

--------------------------------------------------------------------------------

### 9.移动端禁止保存或拷贝图像

描述：手机或者pad上长按图像 img ，会弹出选项 存储图像 或者 拷贝图像，如果你不想让用户这么操作，那么你可以通过以下方法来禁止：（IOS有效）

```
img {
    -webkit-touch-callout: none;
}
```

--------------------------------------------------------------------------------

### 10.解决字体在移动端比例缩小后出现锯齿的问题

描述：

```
html {
    -webkit-font-smoothing: antialiased;
}
```

--------------------------------------------------------------------------------

### 11.box-sizing：border-box；改变盒子模型的计算方式

描述：不仅仅是移动端应用，响应式页面都这么玩，根据需要给元素设置，*只代表元素；

```
* {
    box-sizing：border-box；
}
```

--------------------------------------------------------------------------------

### 12.按钮被按下效果

描述：

```
button:active  {
    按下样式；
}
document.body.addEventListener('touchend', function () { });
```

--------------------------------------------------------------------------------

### 13.按钮被按下效果

描述：

```
button:active  {
    按下样式；
}
document.body.addEventListener('touchend', function () { });
```

--------------------------------------------------------------------------------

### 14.设置input里面placeholder字体的大小

描述：

```
::-webkit-input-placeholder{ font-size:10pt;}
```

--------------------------------------------------------------------------------

### 15.移动端，图片技巧

描述：记得加上display：block；属性来解决img的边缘空白间隙的1px像素。 图片要适应不同的手机要设置width:100%;而且不能添加高度。

```
img{
    display:block
}
```

--------------------------------------------------------------------------------

### 16.audio元素和video元素在IOS和Android中无法自动播放

描述：可以做成触屏就播放，来解决

```
$('html').one('touchstart',function(){
    audio.play()
})
```

--------------------------------------------------------------------------------

### 17.消除transition闪屏

描述：可以开启硬件加速，见18

```
.css{
    -webkit-transform-style: preserve-3d;
    -webkit-backface-visibility: hidden;
}
```

--------------------------------------------------------------------------------

### 18.开启硬件加速，解决页面闪白，保证动画流畅

描述：设计高性能CSS3动画的几个要素，尽可能地使用合成属性transform和opacity来设计CSS3动画，不使用position的left和top来定位，**利用translate3D开启GPU加速**

```
.css {
    -webkit-transform: translate3d(0, 0, 0);
    -moz-transform: translate3d(0, 0, 0);
    -ms-transform: translate3d(0, 0, 0);
    transform: translate3d(0, 0, 0);
}
```

--------------------------------------------------------------------------------

### 19.针对适配等比缩放的方法

描述：神器~

```
@media only screen and (min-width: 1024px){
    body{zoom:3.2;}
}
@media only screen and (min-width: 768px) and (max-width: 1023px) {
    body{zoom:2.4;}
}
@media only screen and (min-width: 640px) and (max-width: 767px) {
    body{zoom:2;}
}
@media only screen and (min-width: 540px) and (max-width: 639px) {
    body{zoom:1.68;}
}
@media only screen and (min-width: 480px) and (max-width: 539px) {
    body{zoom:1.5;}
}
@media only screen and (min-width: 414px) and (max-width: 479px) {
    body{zoom:1.29;}
}
@media only screen and (min-width: 400px) and (max-width: 413px) {
    body{zoom:1.25;}
}
@media only screen and (min-width: 375px) and (max-width: 413px) {
    body{zoom:1.17;}
}
@media only screen and (min-width: 360px) and (max-width:374px) {
    body{zoom:1.125;}
}
```

[^本文摘自互联网，以及工作中遇到的问题和处理过程]
