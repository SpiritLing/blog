---
title: 静态博客网站自动化构建和部署（二）自动构建和部署
tags:
  - [Hexo]
  - [Next]
  - [Auto CI]
  - [Auto Deploy]
  - [Github]
  - [Pages]
categories:
  - [Hexo]
  - [Hexo静态网站自动化构建和部署系列]
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
abbrlink: f35d4de6
date: 2019-12-18 14:01:33
keywords: [hexo,next,自动化构建,自动化部署,github]
description:
---

{% cq %} 静态博客网站自动化构建和部署（二）自动构建和部署 {% endcq %}

<!-- more -->

# Hexo 静态博客网站自动化构建和部署（二）自动构建和部署

{% post_link 2019-12-18-hexo-automated-build-and-deployment-1 %}

{% post_link 2019-12-18-hexo-automated-build-and-deployment-2 %}

想要自动化构建需要 `.travis.yml` 文件

想要保存版本，可以自动对其打标签，需要使用到 `source/scripts/auto-versioning.js` 文件来获取版本号

想自动构建Docker镜像，需要 `source/Dockerfile` 和 `source/config/nginx.conf` 文件来构建Docker镜像和nginx的配置

这四个主要文件代码片段都在以下地址：

- [gist 代码片段](https://gist.github.com/SpiritLing/306900cfe70f704343fefaef5bb26571) 一般会被限制访问，原因你们懂得
- [gitee 代码片段](https://gitee.com/SpiritLing/codes/ydpsxq4ahn2jk1fimbwoc82) 国内代码托管平台码云的代码片段

## Travis 网站自动化构建

[Travis](https://travis-ci.com/) 网站是一个对开源项目免费提供自动化构建的网站。

travis 目前只支持 Github 开源项目，其他暂不支持，在 travis 上使用github登录，可以直接获取你自己的仓库

在仓库列表中，每个仓库后面有一个 `Trigger a build` 按钮，点击这个按钮即可对这个仓库进行自动化构建，当然前提是你的仓库根路径有 `.travis.yml` 文件。

对于 `.travis.yml` 文件具体更细的讲解可以之间看[官方文档](https://docs.travis-ci.com/)，这里只说涉及到的一些问题

```yml
language: node_js
services:
  - docker
node_js:
  - 12
```

对于上面部分代码来说：
language: 就是说指定什么语言来出来，这里选择node_js，则会在构建的虚拟环境中使用nodejs环境。你可以直接使用 npm 和 node 命令。
services: 提供的服务，这里选择docker，因为我们需要将编译后的静态网站文件打包成镜像，有了这个就可以直接使用docker命令
node_js： 指定nodejs版本

```yml
jobs:
  include:
    - stage: xxx
      name: "xxx"
      if: branch = master
```

建立一个工作，它包含以下阶段，可以分成很多阶段。比如：install，build，deploy等等阶段
stage: 阶段
name: 你为这个阶段起的名字，可有可无
if: 是否指定那些的分支可以执行，.travis.yml 在不同分支使用同一个文件，所以进行各自分支走各自的构建阶段，共同阶段可以提出来，取消掉if，目前我的没有提出来，原因在于每个阶段和每个阶段几乎没有相互联系，导致我的需求下无法提取使用

每种语言都有自己的默认 install 脚本，nodejs为 `npm install` ，所以我们这里不执行install，有构建默认自己执行

install和script都是由travis提供的钩子，在script期间nodejs默认执行为`npm test`，但是我们这里写了新的脚本，所以相当于替换掉默认的执行脚本

```
before_install：install 阶段之前执行
before_script：script 阶段之前执行
after_failure：script 阶段失败时执行
after_success：script 阶段成功时执行
before_deploy：deploy 步骤之前执行
after_deploy：deploy 步骤之后执行
after_script：script 阶段之后执行
```
完整的生命周期为：
```
1. before_install
2. install
3. before_script
4. script
5. aftersuccess or afterfailure
5. [OPTIONAL] before_deploy
7. [OPTIONAL] deploy
8. [OPTIONAL] after_deploy
9. after_script
```

其余都和在linux中执行脚本一致，一步一步来即可。

其余的接下啦继续补充...