+++
author = "Kntt"
categories = ["2019", "vue", "webview"]
date = "2019-02-17"
featured = "2019-02-17.jpg"
featuredalt = ""
featuredpath = "date"
linktitle = "1"
title = "一个Bug的修复，促使我写了一个package"
description = "一个Bug的修复的经历，促使我写了一个package"
type = "post"

+++

### 项目地址：[vue-webview-js-bridge](https://github.com/Kntt/vue-js-bridge)
> 主要功能：基于[WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)开发的webview-js-bridge的vue插件，后面废话较多，可以直接看项目。如果刚好闲来无事，权当打发时间

### 故事背景
> 本人前端，在一个移动办公APP团队。由于业务简单，并没有使用RN，WEEX等技术。简单的使用native做了一个壳，主要逻辑都是前端控制。主技术栈是Vue.

### bug出现
> 在一段时间内，团队接到多人反馈，APP每天都需要重新登陆。作为团队的前端我很诧异，因为登陆大token在前端保存，有效期是三天，怎么可能会每天都要登陆呢？

### 排查原因
1. token有效期三天这个肯定没有问题
2. 团队成员手机都没出过问题，证明逻辑没问题
3. 收集问题反馈人手机信息，发现所有反馈人员的手机有一个共同点，储存空间都不足（ios），问题也主要集中在苹果手机

> 定位问题原因，可能是因为手机储存空间不足，把储存的token清理了。按着这个思路开始排查...
难道是手机内存空间不足，把储存的token当作没用的信息清理了？（token存在localstorage里面）。
通过google发现，ios确实存在这种情况，当手机储存空间不足时候会把系统认为无用的信息清理掉，给主要程序提供运行环境。

### 问题复现
> 找到一台储存空间不足的苹果测试机，登陆到APP后，找一部非常大的电影下载。这时候系统就会清理空间来满足下载电影的需求。结果发现APP需要重新登陆了。问题复现，原因确认。

### 解决问题
> 一个小APP，仅仅为了储存token而引入sqlite之类的本地数据库，很有些大材小用。但是localstorage，cookie等能储存的地方又都在系统清理的范围内。最后决定把token储存在native端。

### 解决方案
1. native开发类似localstorage的功能
2. token存入native端
3. 前端启动时查询native端是否存在token，存在就同步到localstorage，不存在，跳转登陆页面。
4. 其他逻辑不变

> 方案确定，一个字，撸起袖子一顿猛干。。。

### 坑中有坑
> 你说难受不难受...，就不描述经过了，心疼。直接说结论了
前端和Native端通信采用的是[WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)，问题就出在这里，见代码：
```js
import jsBridge from './utils/native'
// 省略n行...
router.beforeEach((to, from, next) => {
  if (to.meta.auth) {
    // 问题出在这里，从APP启动到vue运行到这里，jsBridge实例还未初始化完成，导致jsBridge是undifined
    jsBridge.callHandler('getStorage', {key: 'token'}).then(res => {
      let token = res.body
      if (token && token !== 'null') {
        next()
      } else {
        next('/login')
      }
      store.commit('UPDATE_TOKEN', {token})
    })
  } else {
    next()
  }
})
// 省略n行...

```
问题已经确定了，是调用jsBridge实例时，它还未初始化完成。感兴趣的可以去看下[WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)源码，虽然初始化时间很短，但是已经造成了问题，APP到这里启动报错。

继续解决问题：既然未初始化完成，那我们等它完成再用不就完了。有人提议用`setTimeout`,但是延时多少时间呢？时间短了不一定hold住啊，毕竟不同手机初始化时间还是有差别的。设置长了影响体验，作为一个前端如果用户体验都不顾那还做什么前端，所以这个最容易也是最low的方法被pass了。

### 想一个优雅的解决办法
> 这就是我写的这个package的初衷，废话说了这么多，进入正题了

1. 从解决问题的角度出发

> 既然使用jsBridge实例时你还没初始化完成，那我们就每次等你初始化完成，把实例回传回来后我再调用，这样就不同担心bridge实例不可用的问题了

核心代码
```js
// ...
init (callback) {
    if (window.WebViewJavascriptBridge) {
      return callback(window.WebViewJavascriptBridge)
    }
    if (window.WVJBCallbacks) {
      return window.WVJBCallbacks.push(callback)
    }
    window.WVJBCallbacks = [callback]
    var WVJBIframe = document.createElement('iframe')
    WVJBIframe.style.display = 'none'
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__'
    document.documentElement.appendChild(WVJBIframe)
    setTimeout(function () {
      document.documentElement.removeChild(WVJBIframe)
    }, 0)
}
callHandler (payload) {
    let _resolve
    let _reject
    const readyPromise = new Promise((resolve, reject) => {
      _resolve = resolve
      _reject = reject
    })
    this.init(function (bridge) {
      try {
        bridge.callHandler(nativeHandlerName, payload, (response) => {
          _resolve(response)
        })
      } catch (e) {
        _reject(e)
      }
    })
    return readyPromise
}
// ...
```
> 习惯了使用Promise的调用方式，顺手把调用方法Promise化处理。

### 后续
> 为了开发效率，不能一直在APP里面调试，又增加了mock功能，debug功能。

项目地址：[vue-webview-js-bridge](https://github.com/Kntt/vue-js-bridge) 如果刚好对你还有些帮助，欢迎star，欢迎pr
