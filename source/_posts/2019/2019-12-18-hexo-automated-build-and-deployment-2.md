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
updated: 2019-12-18 21:32:06
keywords: [hexo,next,自动化构建,自动化部署,github]
description:
---

{% cq %} 静态博客网站自动化构建和部署（二）自动构建和部署 {% endcq %}

<!-- more -->

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

### .travis.yml 文件分析

#### 基本环境

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

#### 构建工作

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


### script 分析

#### 版本号获取

```shell
VERSION=$(node ./source/scripts/auto-versioning.js)
```
熟悉shell的应该不陌生，这条命令就是将node运行js文件输出的内容赋值到临时变量 `VERSION` 上，实际查看这个脚本文件，其实就是获取package.json中version的值，所以你如果觉得这个阶段结束了，需要保存下，则在下阶段开始的第一次将version改为其他版本号，则就会生成新的tag，如果一直不修改，则会每次构建都会覆盖掉远程仓库的旧tag。

#### 自动打Tag

```shell
git tag -a -f v$VERSION -m "Travis CI Auto Tag `date +"%Y-%m-%d %H:%M:%S"`"
```

切记，标签一定要在添加静态文件，切换静态文件分支，push静态文件之前。命令意思是强制打一个新tag，无论是否存在，配置message信息。

#### Tag push origin

```shell
git push -f https://${GITHUB_USERNAME}:${GITHUB_PASSWD}@github.com/SpiritLing/blog.git v$VERSION
```
强制push tag 时，远程仓库用户名和密码分别为：`GITHUB_USERNAME` 和 `GITHUB_PASSWD` ，这个在travis仓库构建设置中可以设置变量，有个选项，默认为加密状态，意思在构建日志中不显示，达到隐藏你的敏感信息，保护账户安全。通过这个方法，你可以在此仓库构建，但是可以推送到任何一个网站一个仓库中去，只需要应用密码也就是token（每个网站叫法和获取都不相同）。

#### Docker build

```shell
docker login -u ${DOCKER_USERNAME} --password ${DOCKER_PASSWD}
docker build -t ${DOCKER_RPO}:latest .
docker push ${DOCKER_RPO}
```

目前我只在dev分支构建中直接使用Docker命令来进行，Master分支我是通过Docker网站连接到github上，一旦gh-pages分支改变，Docker官网会自动构建响应的镜像。

首先第一行是docker登录命令，一般保险起见，不支持直接使用docker网站密码，而是生成token来进行登录，所以我这里的 `DOCKER_PASSWD` 实际上是一个token值

第二行是构建镜像 -t 代表打的标签；`DOCKER_RPO` 代表标签名，一般为 `{Docker UserName}/{Docker Repository}` ，这样不用后续push时，再更改标签；latest代表这个镜像版本，一般Docker默认都为latest；`.` 代表构建当前目录

第三行是push镜像到Docker仓库中去，一般如果出现错误，请确认你的 `DOCKER_RPO` 是否等于 `{Docker UserName}/{Docker Repository}`，如果不是用户名加仓库名，将无法push上去。


其余脚本和上面类似，一般熟悉一点linux操作命令和git命令应该都没什么问题，具体参数可以查看官方文档，这里推荐一个[Linux命令查询网站](https://man.linuxde.net/)

## Docker 构建镜像

关于[Docker学习](https://www.kancloud.cn/spirit-ling/docker-study)

Docker知识可以查看上面的文档，也可以直接点击站点概览中的Docker导航

### Dockerfile 分析

```Dockerfile
FROM nginx

COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html/

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
```
以上为Dockerfile文件内容
- FROM: 通过什么镜像构建，这里直接选择nginx，毕竟要直接将静态文件当网站访问
- COPY: 复制文件到什么地方去，这里首先将 `config/nginx.conf` 网站配置文件复制到 `Nginx` 服务配置目录，直接覆盖掉默认的配置文件 `default.conf`
- COPY: 第二个复制，将当前目录下的所有文件复制到 `Nginx` 静态网站目录下，当然静态网站目录也是可以在 `nginx.conf` 中配置的
- EXPOSE 80 443: 对外放开的端口号，一般 `Nginx` 放通 80 和 443 端口
- CMD ["nginx", "-g", "daemon off;"]: CMD运行命令，一个Dockerfile中只允许出现一次，代表运行 nginx 服务

### Docker 部署镜像

构建完毕并且推送到Docker镜像仓库后，可以使用下面命令来启动一个容器

```shell
# dev-blog-pages镜像部署，不是开发版的博客网站
docker run \
-u root \
--name=dev-blog-pages \
-d \
--restart=on-failure:10 \
-p 80:80 \
${Docker UserName}/${Docker Repository}
```

-p 80:80 代表开放的端口，第一个代表对外放开的端口，也就是公网访问端口，第二个80端口指的是你的容器端口，相当于给外层系统和你的容器建立了一个端口映射。

其他具体命令意思可以直接看我上面的Docker文档。

## 具体流程

单分支：

1. 首先本地master分支开发，撰写博客，当前version:0.0.3
2. 提交代码到远程仓库
3. 触发Travis自动构建
4. 首先先强制push标签v0.0.3
5. 通过复制，移动，删除，将public移到最外层，全部添加，push到gh-pages分支上
6. github自动将gh-pages生成新的静态网站，Docker通过gh-pages变化来构建新的镜像
7. 本地撰写下一个阶段 版本改为0.0.4，可以多次提交，最终此阶段满意为止，换新版本号，继续即可

只需要本地写好文章，push到仓库后，什么事情也不需要管，过个几分钟，你的博客网站将会出现新的版本。

多分支：

- master：发布版 域名：blog.example.com
- dev：开发版 域名：dev.example.com

1. 本地始终开发dev分支，撰写博客，当前版本0.0.3
2. 提交代码到远程仓库
3. 触发Travis自动构建
4. 首先先强制push标签v0.0.3
5. 通过复制，移动，删除，将public移到最外层，全部添加，push到dev-blog分支上(这里我使用的是国内coding构建静态网站，自定义域名为：[dev.blog.spiritling.pub](https://dev.blog.spiritling.pub))
6. coding设置静态网站部署会自动将dev-blog生成新的静态网站
7. 通过docker命令构建镜像并推送
8. 这时候你想给博客网站添加个百度统计，然后修修改改，再次上传
9. 继续前面的过程，一旦你觉得更改的差不多了，可以发布了
9. 那么直接将dev合并至master分支，然后需要反向合并，因为我使用的是 `git merge -squash` 命令，所以需要反向一次，保证下次合并不会出现问题。
10. 接下来的步骤就是自动构建自动发布。
11. 开始新的时，将version改为新的，继续新一轮的使用