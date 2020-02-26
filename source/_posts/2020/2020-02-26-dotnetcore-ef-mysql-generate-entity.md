---
title: .Net Core + EF + mysql 从数据库生成实体
tags:
  - [dotNet]
  - [EF]
  - [mysql]
categories:
  - [dotnet]
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
abbrlink: daefc0a4
date: 2020-02-26 20:48:25
keywords: [.netcore,EF,mysql,实体]
description:
---

{% cq %} .Net Core + EF + mysql 从数据库生成实体 {% endcq %}

<!-- more -->

原文地址：https://www.cnblogs.com/yangjinwang/p/9516988.html

## 安装NuGet包

点击 `工具` -> `NuGet包管理器` -> `程序包管理器控制台`

分别安装以下几个包

Mysql 版本：

```
Install-Package MySql.Data.EntityFrameworkCore -Pre
Install-Package Pomelo.EntityFrameworkCore.MySql
Install-Package Microsoft.EntityFrameworkCore.Tools
Install-Package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

Sql server 版本：

```
Install-Package Microsoft.EntityFrameworkCore
Install-Package Microsoft.EntityFrameworkCore.SqlServer
Install-Package Microsoft.EntityFrameworkCore.Tools
Install-Package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

## 运行命令生成实体

Mysql 版本：

```
Scaffold-DbContext "server=.;userid=tech5_kj;pwd=xxx;port=3306;database=tech5_kj;sslmode=none;" Pomelo.EntityFrameworkCore.MySql -OutputDir Models -Force

或者

Scaffold-DbContext "server=.;userid=tech5_kj;pwd=xxx;port=3306;database=tech5_kj;sslmode=none;" Pomelo.EntityFrameworkCore.MySql -OutputDir Models -UseDatabaseNames -Force
```

Sql server版本:

```
Scaffold-DbContext "Data Source=.;Initial Catalog=EFCore_dbfirst;User ID=sa;Password=sa.123" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Force
```

## 参数说明

```
-OutputDir *** 实体文件所存放的文件目录
-ContextDir *** DbContext文件存放的目录
-Context *** DbContext文件名
-Schemas *** 需要生成实体数据的数据表所在的模式
-Tables *** 需要生成实体数据的数据表的集合
-DataAnnotations
-UseDatabaseNames 直接使用数据库中的表名和列名（某些版本不支持）
-Force 强制执行，重写已经存在的实体文件
```