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

第一次接触的后端为 Nodejs，如果使用NodeJS绑定80和443端口总是不太好，而且应为刚开始使用的是 windows 服务器。直接让Nodejs使用80端口很不方便，所以便接触到URL重写

比如我的网站是：https://demo.example.com:4436/posts/82f57ccc

{% asset_img 20200114183921.png URL重写之前NodeJS的URL %}

经过URL重写后就改为这样的：https://demo.example.com/4436/posts/82f57ccc

{% asset_img 20200114184235.png URL重写之后 %}

