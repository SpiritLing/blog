---
title: Hexo 静态博客网站自动化构建和部署（一）Hexo 介绍
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
abbrlink: b90941ba
date: 2019-12-18 10:17:39
keywords: [hexo,next,自动化构建,自动化部署,github]
description:
---

{% cq %}  Hexo 静态博客网站自动化构建和部署（一）Hexo 介绍 {% endcq %}

<!-- more -->

# Hexo 静态博客网站自动化构建和部署（一）

{% post_link 2019-12-18-hexo-automated-build-and-deployment-1 %}

{% post_link 2019-12-18-hexo-automated-build-and-deployment-2 %}

## 前提

如果你只需要在一个分支开发，一个分支发布，则只需要本地写好后直接提交到远程仓库，然后等待几分钟后，直接看你的网站就会发现已经更新上去了。

如果你需要和我一样一个开发版一个发布版，那么在自动化构建中只需要多一个手动将 `dev` 合并至 `master` 的步骤操作，其余和单分支开发一样都是自动构建自动部署。

开发推荐使用 Github 来使用，因为接下来的自动化构建的网站一般对 Github 支持较好，还有就是国内国外都可以访问 Github，并且速度还算可以。

以下是我的博客相关网站，如果需要对源码加密，可以将 Maste源码 和 Master Pages 分支分别存放在私有仓库和公开仓库

| 名称 | 地址 |
| --- | --- |
| Master 源码 | https://github.com/SpiritLing/blog |
| Dev 源码 | https://github.com/SpiritLing/blog/tree/dev |
| Master Pages | https://github.com/SpiritLing/blog/tree/gh-pages |
| Dev Pages | https://spiritling.coding.net/p/dev/d/dev/git/tree/dev-blog |

## 开始前的工作

### 环境和账号

首先需要准备环境

* Nodejs
* 一款编辑器-Vscode
* Github 账号
* Coding 账号（单分支可以不用，如果博客主要面对的是国内，可以使用这个来当静态网站站点）

### 本地开发安装

首先全局安装 Hexo

```bash
npm install hexo-cli -g
```

使用 Hexo 创建一个项目

```bash
$ hexo init hexo-blog
$ cd <folder>
$ npm install
```

之后大概目录如下所示

```tree
.
├── _config.yml
├── package.json
├── scaffolds
├── source
|   ├── _drafts
|   └── _posts
└── themes
```

## 关联 Github 仓库

创建仓库时，不要选择初始化文件，如果选了，就需要将仓库克隆下来，在将 Hexo 生成的目录内的内容迁移过去

不选择初始化文件时，在仓库首页会有提示如何添加已有的本地仓库。

首先进入`hexo-blog`目录下
逐步运行下面命令
```shell
git init
git add -A
git commit -m "first commit"
```

添加完已修改的文件后（切记不要把node_modules加入进去），一般情况下 hexo 创建的初始化项目都含有 `.gitignore` 文件，其中自动包含 `node_modules`

接下来需要添加远程仓库地址，有两种协议，一种http一种git

使用http协议会弹出一个窗口，需要进行 GitHub 账号登录，以后使用 http 就不会再次弹出

使用git协议需要先在账户中添加本地私钥，才能够下载下来

```shell
git remote add origin git@github.com:{Your Name}/{Your repository}.git
git remote add origin https://github.com/{Your Name}/{Your repository}.git
```

接下来将其推送到远程仓库，并和远程仓库保持连接（-u）

```shell
git push -u origin master
```

推送成功后，你的本地和远程就会构建起关联。

## Hexo 文件说明

### _config.yml

网站的 [官方配置](https://hexo.io/zh-cn/docs/configuration) 信息，您可以在此配置大部分的参数。

### package.json

做过nodejs项目和前端构建的工作的，应该对其不陌生

### scaffolds 文件夹

[官方模版](https://hexo.io/zh-cn/docs/writing) 文件夹。当您新建文章时，Hexo 会根据 scaffold 来建立文件。

Hexo的模板是指在新建的文章文件中默认填充的内容。例如，如果您修改scaffold/post.md中的Front-matter内容，那么每次新建一篇文章时都会包含这个修改。

### source 文件夹

资源文件夹是存放用户资源的地方。除 _posts 文件夹之外，开头命名为 _ (下划线)的文件 / 文件夹和隐藏的文件将会被忽略。Markdown 和 HTML 文件会被解析并放到 public 文件夹，而其他文件会被拷贝过去。

### themes

[主题](https://hexo.io/zh-cn/docs/themes) 文件夹。Hexo 会根据主题来生成静态页面。

## 生成静态网站和其他

使用Hexo内置的就可以生成静态网站，静态网站放置在 public 文件夹下，其他配置，比如 Next主题，google分析，百度通知，gitalk评论，版权声明等等，在此次不在进一步详细说明。

## 自动化构建网站

### Travis 网站自动化构建

[Travis](https://travis-ci.com/) 网站是一个对开源项目免费提供自动化构建的网站。

travis 目前只支持 Github 开源项目，其他暂不支持，在 travis 上使用github登录，可以直接获取你自己的仓库

在仓库列表中，每个仓库后面有一个 `Trigger a build` 按钮，点击这个按钮即可对这个仓库进行自动化构建，当然前提是你的仓库根路径有 `.travis.yml` 文件。