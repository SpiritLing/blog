---
title: React 使用 Proxy 代理（create-react-app）
tags:
  - [react]
  - [proxy]
categories:
  - [react]
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
abbrlink: 74e1ae39
date: 2020-02-19 10:21:16
keywords: [react,proxy,create-react-app,代理]
description:
---

{% cq %} React 使用 Proxy 代理（create-react-app） {% endcq %}

<!-- more -->

## 在create-react-app 中配置proxy代理

proxy，默认为NULL，类型为URL，一个为了发送http请求的代理
在平时开发时，尤其前后端分离时，需要假数据来进行模拟请求，这个时候就需要`proxy`代理来处理

### create-react-app < 2.0

package.json 中配置

```js
"proxy":{
   "/api/**":{
      "target":"https://easymock.spiritling.pub/",
      "changeOrigin": true
    }
}
```

### create-react-app > 2.0

#### package.json 中配置（不推荐）

```js
"proxy": "https://easymock.spiritling.pub/",
```

#### 配置文件 `/src/setupProxy.js` （推荐）

将 `create-react-app` 解包后，可以在 `config` 文件夹下找到配置

在 `config/path.js` 中存在 `proxySetup: resolveApp('src/setupProxy.js'),`

而 `proxySetup` 是只在 `webpackDevServer.config.js` 文件中使用，也就是说只在开发时使用

所以，可以在 /src/setupProxy.js 中配置

首先安装 `http-proxy-middleware`

```bash
npm install http-proxy-middleware -D
```

然后文件配置

```js
const proxy = require('http-proxy-middleware');
module.exports = function (app) {
    app.use(
        '/api/v1/',
        proxy({
            target : 'https://easymock.spiritling.pub/',
            changeOrigin : true,  // 设置跨域请求
            PathRewrite : {
                '^/api/v1' : '' // 将/api/v1 变为 ''
            }
        })
    );
};
```

### 使用例子

#### 01

```js
const proxy = require('http-proxy-middleware');
module.exports = function (app) {
    app.use(
        '/api/v1/',
        proxy({
            target : 'https://easymock.spiritling.pub/',
            changeOrigin : true
        })
    );
};
```

游览器中请求为 `https://example.com/api/v1/login`

则经过代理后可以转为 `https://easymock.spiritling.pub/api/v1/login`

#### 02

```js
const proxy = require('http-proxy-middleware');
module.exports = function (app) {
    app.use(
        '/api/v1/',
        proxy({
            target : 'https://easymock.spiritling.pub/',
            changeOrigin : true,
            PathRewrite : {
                '^/api/v1' : ''
            }
        })
    );
};
```

游览器中请求为 `https://example.com/api/v1/login`

则经过代理后可以转为 `https://easymock.spiritling.pub/login`

> [create-react-app官方-Proxying API Requests in Development](https://create-react-app.dev/docs/proxying-api-requests-in-development/)

## `http-proxy-middleware` 新版本 ≧ 1.0.0

在新版本大于等于 1.0.0 时使用会出现如下问题

```
proxy is not a function
```

也就是说 `http-proxy-middleware` 或者 `setupProxy` 会出现报错 `proxy is not a function`

所以需要使用新版本的写法才可以

```js
const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function (app) {
    app.use('/api/v1/',
        createProxyMiddleware({
            target : ' https://easymock.spiritling.pub',
            changeOrigin : true
        }));
};
```
