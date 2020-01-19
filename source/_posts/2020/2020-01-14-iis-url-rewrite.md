---
title: IIS进行URL重写——实现https重定向，文件类型隐藏访问重写，nodejs等服务重写等等
tags:
  - 无标签
categories:
  - 未分类
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
abbrlink: 82f57ccc
date: 2020-01-14 17:53:46
keywords:
password: xA123456
description:
---

{% cq %} IIS进行URL重写——实现https重定向，文件类型隐藏访问重写，nodejs等服务重写等等 {% endcq %}

<!-- more -->

## Why?

### 什么是URL重写

URL重写就是首先获得一个进入的URL请求然后把它重新写成网站可以处理的另一个URL的过程。

举个例子来说，如果通过浏览器进来的URL是“UserProfile.aspx?ID=1”那么它可以被重写成 “UserProfile/1.aspx”，这样的URL，这样的网址可以更好的被网站所阅读。

根据不同的服务器就会有不同的URL重写规则，比如 iis apache nginx 这三种重写方式都是不同的，并非完全一样的。

今天只说 IIS 的重写

### 为什么要使用

首先有需求就有使用，所以，是我的需求诞生了我去使用重写功能

第一次接触的后端为 Nodejs，一个80或者443端口只能绑定一个程序。使用 windows 自带的iis服务器来使用，想要一个服务器上部署多个站点程序，则需要使用到反向代理才行。

不使用反向代理如下图所示：

比如我的网站是：https://demo.example.com:4436/posts/82f57ccc

{% asset_img 20200119161522.png URL重写之前NodeJS的URL %}

明眼一看就是有点不够友好，正准备记下网址，这一瞅，直接放弃了，太麻烦了，还有端口

但是经过URL重写，也就是反向代理后就改为这样的：https://demo.example.com/4436/posts/82f57ccc ，只需要记域名即可

{% asset_img 20200119161557.png URL重写之后 %}

只有你的服务器够大，一个通过一个服务代理无数个本地服务，哪怕本地无数个nodejs服务器从 10000-65535 监听，都可以的，只需要做好反向代理即可

## 前置条件

1. 首先需要有个 IIS 服务器
2. 然后去官网下载 [web平台安装工具](https://www.iis.net/downloads/microsoft/web-platform-installer)
3. 然后安装工具并打开

{% asset_img 1076304-20180412200431336-787173232.png web平台安装工具 %}

4. 搜索 Application Request Routing 或者 应用程序请求路由 ，和 url 重写工具 或者 url rewrite；因为有可能是英文也有可能是中文，所以当一个搜索不到时，搜索另一个语言，一定要在产品全部中搜索

{% asset_img 1076304-20180412200848094-824241073.png web平台安装工具 %}

5. 最近（2019低2020初）不知道 web平台安装工具出什么问题了，一直安装不了，有时候甚至会打不开，所以这里留个官网下载单模块的链接：[url rewrite](https://www.iis.net/downloads/microsoft/url-rewrite)，[Application Request Routing](https://www.iis.net/downloads/microsoft/application-request-routing)，[All Modules Downloads](https://www.iis.net/downloads)；拉到底下会有下载链接，url rewrite 有对应的中文版本。
6. 下载安装即可

## 应用程序请求路由设置

1. 打开IIS工具，选择上面安装的请求路由

{% asset_img 1076304-20180412201157869-978989213.png 应用程序请求路由设置 %}

2. 选择 Server Proxy Settings

{% asset_img 1076304-20180412201244421-675549952.png 应用程序请求路由设置 %}

3. 在中间区域，选择勾选Enable proxy，不用修改内容，当然也可以根据需求自己修改

{% asset_img 1076304-20180412201358722-1759010199.png 应用程序请求路由设置 %}

4. 点击应用即可，完成请求路由的设置

{% asset_img 1076304-20180412201437572-1668674268.png 应用程序请求路由设置 %}

## url重写设置：这里讲基本参数，后面才会是例子

1. 打开站点，选择需要url重写的站点

{% asset_img 1076304-20180412201808214-1496956504.png url重写设置 %}

2. 当安装完成url重写时，会出现url重写这个工具，选择工具，名字也有可能是英文

{% asset_img 1076304-20180412201916597-1448053593.png url重写设置 %}

3. 打开工具，选在右侧栏第一行添加规则，打开对话框，选择空白规则

{% asset_img 1076304-20180412202043308-320482397.png url重写设置 %}