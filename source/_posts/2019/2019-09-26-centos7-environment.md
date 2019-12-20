---
title: Centos7 安装需要的软件环境
tags:
  - [Centos]
  - [Mysql]
  - [Nodejs]
  - [Nginx]
  - [Java]
  - [Jenkins]
  - [Git]
categories:
  - [Linux环境安装]
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
keywords: [centos7,linux,mysql,nodejs,nginx,jdk,java,yum,jenkins,git,centos7安装,安装]
abbrlink: 7bba76b6
date: 2019-08-02 19:06:23
updated: 2019-09-29 16:07:26
description: 
---

{% cq %} Centos7 安装需要的软件环境（mysql, nodejs, nginx, jdk, Jenkins, Git） {% endcq %}

<!-- more -->

## Mysql 安装

### 下载安装

1. 下载并安装MySQL官方的 Yum Repository

```bash
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
```

2. Yum 安装源

```bash
yum -y install mysql57-community-release-el7-10.noarch.rpm
```
3. 安装Mysql

```bash
yum -y install mysql-community-server
```
4. 设置开机 Mysql

```bash
systemctl enable mysqld.service
```

5 启动 Mysql

```bash
service mysqld start
```

### Mysql 设置

1. 访问Mysql之前需要先查看默认密码


```bash
grep "password" /var/log/mysqld.log
```

2. 登录Mysql

```bash
mysql -u root -p
```

然后输入刚才查到的密码，密码不可见隐藏显示。

3. 修改密码策略

```bash
> show VARIABLES like "%password%"
+---------------------------------------+---------+
| Variable_name                         | Value   |
|---------------------------------------+---------|
| default_password_lifetime             | 0       |
| disconnect_on_expired_password        | ON      |
| log_builtin_as_identified_by_password | OFF     |
| mysql_native_password_proxy_users     | OFF     |
| old_passwords                         | 0       |
| report_password                       |         |
| sha256_password_proxy_users           | OFF     |
| validate_password_dictionary_file     |         |
| validate_password_length              | 8       |
| validate_password_mixed_case_count    | 1       |
| validate_password_number_count        | 1       |
| validate_password_policy              | MEDIUM  |
| validate_password_special_char_count  | 1       |
+---------------------------------------+---------+
```
介绍几个主要的的参数说明：

| 参数 | 说明 |
| - | - |
| validate_password_number_count | 参数是密码中至少含有的数字个数，当密码策略是MEDIUM或以上时生效。 |
| validate_password_special_char_count | 参数是密码中非英文数字等特殊字符的个数，当密码策略是MEDIUM或以上时生效。 |
| validate_password_mixed_case_count | 参数是密码中英文字符大小写的个数，当密码策略是MEDIUM或以上时生效。 |
| validate_password_length | 参数是密码的长度，这个参数由下面的公式生成。 |

```sql
# 更改密码长度
set global validate_password_length=0;

# 更改数字个数
set global validate_password_number_count=0;

# 更改大小写字母个数
set global validate_password_mixed_case_count=0;

# 更改特殊字符个数
set global validate_password_special_char_count=0;
```

4. 修改密码

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Your New Pssword';
```
5. 开启远程访问

```sql
grant all privileges on *.* to 'root'@'You IP or ALL %' identified by 'Your Password' with grant option;
# 刷新权限
flush privileges;
```
6.  配置默认字符

在 `my.cnf`（`/etc/my.cnf`） 或者 `my.ini` 文件中

在 `my.cnf` 配置中插入下面语句
```
[client]
default-character-set=utf8
```
一定要在 `[mysqld]` 之前插入这两句，否则就会出现下面报错

```bash
mysql: [ERROR] unknown variable 'datadir=/var/lib/mysql'
```

主要原因就是`[client]`的配置信息，放在了`[mysqld]`配置信息的中间，导致其他`[mysqld]`的配置都归在`[client]`下。

在 `socket` 之后插入下面两行

```
character-set-server=utf8
collation-server=utf8_general_ci
```

7. 事务隔离（可选：`confluence 安装需要设置`）

[Mysql四种事务隔离](https://www.cnblogs.com/shihaiming/p/11044740.html)

在 `my.cnf` 或者 `my.ini` 文件中
```sql
transaction_isolation = READ-COMMITTED
```
<blockquote class="blockquote-center">做完上面的可以重启下Mysql服务。</blockquote>

```
service mysqld restart
```

## 使用 `rpm` 安装 `JDK`

### 下载

先通过[官网](https://www.oracle.com/technetwork/java/javase/downloads/index.html)下载如下图标注的红色文件

{% asset_img 20190802195857.png jdk下载 %}

现在下载jdk需要登录oracle账户才可以下载

在此特别贡献一个账号密码，千万不要修改密码

```
username：oracle@spiritling.uu.me
password：NkzKx!5fsx5Tj4@
```


### 传输

将下载的文件通过[FileZilla](https://filezilla-project.org/)软件上传到服务器

### 安装

使用 `rpm` 命令安装

```bash
rpm -ivh jdk-8u152-linux-x64.rpm
```

{% asset_img 20190802200348.png jdk下载 %}

## Nginx 下载安装

### 添加 `yum` 源

```bash
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
```

安装完 `yum` 源之后，可以使用下面命令查看

```
yum repolist
```

### 安装

```bash
yum install nginx
```

### 配置服务

设置开机启动

```bash
systemctl enable nginx
```

启动服务

```bash
service nginx start
```

## 安装NodeJS

### 通过 `yum` 安装nodejs

#### 更新 nodejs 各种版本 `yum` 源

* Nodejs v10.x 安装命令

```bash
$ curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -
```
* Nodejs v8.x 安装命令

```bash
$ curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
```
其他版本如上所示

#### 直接安装

```bash
yum install nodejs -y
```

### 通过压缩包安装

首先需要去官网下载对应的安装包

选择全部镜像 > 阿里云镜像

找到 `node-v12.10.0-linux-x64.tar.gz` 形似这个文件名，具体版本号会发生变化

```bash
wget https://npm.taobao.org/mirrors/node/v12.10.0/node-v12.10.0-linux-x64.tar.gz
```

下载完毕后解压到指定目录

```bash
tar xf node-v12.10.0-linux-x64.tar.gz -C /usr/local/
```

重命名文件夹

```bash
cd /usr/local/
mv node-v12.10.0-linux-x64/ nodejs
```

设置全局命令

```bash
ln -s /usr/local/nodejs/bin/node /usr/local/bin

ln -s /usr/local/nodejs/bin/npm /usr/local/bin
```

然后就可以愉快的使用了

## Jenkins 安装

### 官方安装

[官方链接RPM安装](https://pkg.jenkins.io/redhat/)

在正式安装之前，需要先安装好 `java` 环境

安装源

```shell
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
```

导入key

```shell
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
```

安装 `jenkins`

```shell
yum install jenkins
```

修改端口

```
vim /etc/sysconfig/jenkins
```

找到 `JENKINS_PORT="8080"` 修改为 `JENKINS_PORT="你需要的端口"`

如果你需要在自动化构建中运行 `root` 权限的 shell ，那么还需要修改上面文件中

```
JENKINS_USER="root"
```

进行重启服务

```
systemctl restart jenkins.service
```

启动访问后，提示从 `/var/lib/jenkins/secrets/initialAdminPassword` 获取密码

登录后进行其他操作

当使用http访问时，插件按装时会出现一些失败，所以需要先进入以下链接

```
HOST/pluginManager/advanced
```

修改最底下的升级站点

```
http://updates.jenkins.io/update-center.json
```

也可以使用国内清华源

```
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
```

然后安装插件，添加管理员即可使用

### Docker 镜像安装

直接看[官网安装](https://jenkins.io/zh/doc/book/installing/#docker)，需要基本的Docker操作知识。

## Git 安装新版

### 下载编辑工具

```
yum -y groupinstall "Development Tools"
```

### 下载依赖包

```
yum -y install zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto openssl-devel
```

### 删除自带的git

安装依赖时，yum自动安装了Git，需要卸载旧版本Git，命令为：

```
yum remove git
```

### 下载 `git` 最新版本的源代码

#### 去GitHub网站直接下载发布版

[Github Release版本](https://github.com/git/git/releases)

当然在国内下载github的发布版可能会很慢，所以可以推荐去官网下载

#### 官网下载

[git官网](https://git-scm.com/) 点击 `Downloads` ，进入下载页面

点击 `Linux/Unix` 下载 Linux 版本的git

拉到最下方，点击[download a tarball](https://mirrors.edge.kernel.org/pub/software/scm/git/) 调转到 git 压缩包压在页面，选择你需要的版本进行下载

### 解压 git 压缩包

```
tar -zxvf git-2.30.0.tar.gz
```

### 进入 git 目录，配置安装路径

```
cd git-2.13.3
./configure --prefix=/usr/local/git
```

### 安装

```
make && make install
```

### 配置全局路径

```
export PATH="/usr/local/git/bin:$PATH"
source /etc/profile
```

### 查看 git 版本

```
git --version
```

### 配置软连接

在有些系统或者软件中有可能会使用git默认地址，所以上面的配置也许有可能无法访问到git命令，所以需要添加软连接，添加到你所需要的地方

```
ln -s /usr/local/git/bin/git /usr/bin/git
```

前方是自己安装的位置，后面是需要软连接到需要的位置。

至于加不加 `-s` ，可以看这里 [Linux Ln 命令](https://man.linuxde.net/ln)

{% centerquote %} 只记录自己曾经使用过的方式，如果有其他更好的，欢迎留言! {% endcenterquote %}
