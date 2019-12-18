---
title: webpack 4.x 初级学习记录
tags: 
  - [Webpack]
categories:
  - [Webpack]
abstract: 'Welcome to my blog, This posts can enter password to read.'
message: 请输入密码进行访问.
abbrlink: 26369b4c
date: 2019-11-28 11:18:09
keywords: [webpack4.x,webpack]
description:
---

{% cq %}  webpack 4.x 初级学习记录 {% endcq %}

<!-- more -->

## webpack 4.x 安装

1. 首先需要在全局中安装

```
npm install webpack -g
npm install webpack-cli -g  // 与webpack 3.x 的区别
```

2. 接下来打开新的文件夹，创建package.json

```
npm init
```

初始化 `package.json` 文件。

3. 局部安装

```
npm install webpack --save
npm install webpack-cli --save
```

### webpack 4.x 基本打包编译

1. webpack 3.x 编译

```
webpack a.js b.js
```

```bash
# {extry file}出填写入口文件的路径，本文中就是上述main.js的路径，
# {destination for bundled file}处填写打包文件的存放路径
# 填写路径的时候不用添加{}
webpack {entry file} {destination for bundled file}
```

以上就是4版本之前的使用方式，但是这种方式在4版本中就不能使用了，4版本有自己的新的方式

2. webpack 4.x 默认打包编译

为什么上面要写默认打包编译，是因为webpack可以自定义打包编译配置，我们首先说下默认的打包编译。

```
entry: "/src/index.js"  // 默认入口文件
output: "/dist/main.js"  // 默认输入文件
```

上面路径及文件中，`src` 和 `index.js` 需要我们手动去创建，在 `index.js` 中写好js代码即可，其余的 `dist` 和 `main.js` 都是由系统自动生成的，并且当你再一次编译时，会自动的在 `dist` 中覆盖同名文件。


而webpack 4.x 的编译命令也发生变化了，如下所示，分为开发环境和生产环境的命令

```
webpack --mode development
webpack --mode production
```

使用命令后，会自动生成文件。

配置 `package.json` 文件

```js
"scripts": {
    "dev": "webpack --mode development",
    "build": "webpack --mode production"
}
```

可以使用 `npm ruin dev` 和 `npm run build` 进行执行命令

## webpack 配置

### 概念

>本质上，webpack 是一个现代 JavaScript 应用程序的静态模块打包器(static module bundler)。在 webpack 处理应用程序时，它会在内部创建一个依赖图(dependency graph)，用于映射到项目需要的每个模块，然后将所有这些依赖生成到一个或多个bundle。
>

从 webpack 4.0.0 版本开始，可以不用通过引入一个配置文件打包项目。然而，webpack 仍然还是 高度可配置的，并且能够很好的满足需求。

webpack 的核心概念：

1. 入口（entry）
2. 输出（output）
3. loader
4. 插件（plugins）

我们需要在根目录下创建一个 `webpack.config.js` 的文件，使用 Commonjs 规范来进行书写。

#### 入口（entry）

入口起点(entry point)指示 webpack 应该使用哪个模块，来作为构建其内部依赖图的开始。进入入口起点后，webpack 会找出有哪些模块和库是入口起点（直接和间接）依赖的。

可以通过在 webpack 配置中配置 `entry` 属性，来指定一个入口起点（或多个入口起点）。默认值为 `./src` 。

```js
module.exports = {
  entry: "./src/index.js",
};
```
`entry` 属性的单个入口语法，是下面的简写：

```js
module.exports = {
  entry: {
    main: "./src/index.js",
  }
};
```

> 当你向 `entry` 传入一个数组时会发生什么？向 `entry` 属性传入「文件路径(file path)数组」将创建“多个主入口(multi-main entry)”。在你想要多个依赖文件一起注入，并且将它们的依赖导向(graph)到一个“chunk”时，传入数组的方式就很有用。
> 

多个入口文件处理

```js
module.exports = {
  entry: {
    main: "./src/index.js",
    app: './src/app.js'
  }
};
```

> 根据经验：每个 HTML 文档只使用一个入口起点。 当然也可以使用多个，但是推荐一个使用一个

[了解更多](https://www.webpackjs.com/concepts/entry-points/)

#### 输出（output）

`output` 属性告诉 `webpack` 在哪里输出它所创建的 `bundles`，以及如何命名这些文件，默认值为 `./dist`。基本上，整个应用程序结构，都会被编译到你指定的输出路径的文件夹中。你可以通过在配置中指定一个 `output` 字段，来配置这些处理过程：

```js
const path = require('path');

module.exports = {
  entry: "./src/index.js"
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  }
};
```

当然上面的位置文件名都是可以改变的，可以自定义配置。

在上面的示例中，我们通过 `output.filename` 和 `output.path` 属性，来告诉 `webpack bundle` 的名称，以及我们想要 bundle 生成(emit)到哪里

[了解更多](https://www.webpackjs.com/concepts/output/)

#### loader
'
loader 让 webpack 能够去处理那些非 JavaScript 文件（webpack 自身只理解 JavaScript）。loader 可以将所有类型的文件转换为 webpack 能够处理的有效模块，然后你就可以利用 webpack 的打包能力，对它们进行处理。

本质上，webpack loader 将所有类型的文件，转换为应用程序的依赖图（和最终的 bundle）可以直接引用的模块。

> 注意，loader 能够 `import` 导入任何类型的模块（例如 .css 文件），这是 webpack 特有的功能，其他打包程序或任务执行器的可能并不支持。我们认为这种语言扩展是有很必要的，因为这可以使开发人员创建出更准确的依赖关系图。

在更高层面，在 webpack 的配置中 loader 有两个目标：

1. `test` 属性，用于标识出应该被对应的 loader 进行转换的某个或某些文件。
2. `use` 属性，表示进行转换时，应该使用哪个 loader。

```js
const path = require('path');

const config = {
  entry: "./src/index.js"
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      { test: /\.txt$/, use: 'raw-loader' }
    ]
  }
};

module.exports = config;
```

以上配置中，对一个单独的 module 对象定义了 rules 属性，里面包含两个必须属性：test 和 use。这告诉 webpack 编译器(compiler) 如下信息：

>“嘿，webpack 编译器，当你碰到「在 require()/import 语句中被解析为 '.txt' 的路径」时，在你对它打包之前，先使用 raw-loader 转换一下。”
>

[了解更多](https://www.webpackjs.com/concepts/loaders/)

#### 插件（plugins）

loader 被用于转换某些类型的模块，而插件则可以用于执行范围更广的任务。插件的范围包括，从打包优化和压缩，一直到重新定义环境中的变量。插件接口功能极其强大，可以用来处理各种各样的任务。

想要使用一个插件，你只需要 `require()` 它，然后把它添加到 `plugins` 数组中。多数插件可以通过选项(option)自定义。你也可以在一个配置文件中因为不同目的而多次使用同一个插件，这时需要通过使用 `new` 操作符来创建它的一个实例。

```js
const HtmlWebpackPlugin = require('html-webpack-plugin'); // 通过 npm 安装
const webpack = require('webpack'); // 用于访问内置插件

const config = {
  module: {
    rules: [
      { test: /\.txt$/, use: 'raw-loader' }
    ]
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin(),
    new HtmlWebpackPlugin({template: './src/index.html'})
  ]
};

module.exports = config;
```

webpack 提供许多开箱可用的插件！查阅[插件列表](https://www.webpackjs.com/plugins/)获取更多信息。

在 webpack 配置中使用插件是简单直接的，然而也有很多值得我们进一步探讨的用例。

[了解更多](https://www.webpackjs.com/concepts/plugins/)


## webpack-dev-server

本地服务器

### 安装

```shell
npm install webpack-dev-server -S
```

### 基本概念

可以构建一个本地服务器进行启动测试

### 配置webpack.config.js

webpack.config.js

```js
devServer: {
    contentBase: path.join(__dirname, "/dist"),  //启动路径
    port: 9001,  // 端口号
    hot: true,  // 热更新
    inline:true  // 内联模式
}
```

当然在使用上面 `hot` 热更新时需要开启一个插件 `HotModuleReplacementPlugin` 此插件属于内置插件，可以直接使用 `new webpack.HotModuleReplacementPlugin()` 来进行启用

以上使 `webpack-dev-server` 的基本参数用法，具体的可以查看[此处](https://www.webpackjs.com/configuration/dev-server/)

### 配置package.json

```js
"scripts": {
    "start": "webpack-dev-server --open"
}
```

使用 `npm start` 开启启动命令

## webpack loader处理

loader ： 加载程序

loader 用于对模块的源代码进行转换。loader 可以使你在 import 或"加载"模块时预处理文件。因此，loader 类似于其他构建工具中“任务(task)”，并提供了处理前端构建步骤的强大方法。loader 可以将文件从不同的语言（如 TypeScript）转换为 JavaScript，或将内联图像转换为 data URL。loader 甚至允许你直接在 JavaScript 模块中 import CSS文件！

### 安装

```shell
cnpm install css-loader style-loader -S
```

### 配置

当新建文件 `*.css` 文件时进行css文件处理

webpack.config.js

```js
module:{
    rules:[
        {
            test:/\.css$/,
            use:['style-loader','css-loader']
        }
    ]
}
```
在其中需要注意的就是 `style-loader` 在 `css-loader` 之前。

当 css 有 `background-image: url('./1.jpg')` 有图片插入进来时，需要使用 `file-loader` 来进行处理

```js
module:{
    rules:[
        {
            test:/\.css$/,
            use:['style-loader','css-loader']
        },
        {
            test:/\.(jpg|png|jpeg)$/,
            use:['file-loader']
        }
    ]
}
```
设置图片保存地方及是否使用base64进行处理

```js
{
    test:/\.(jpg|png|jpeg)$/,
    use:'file-loader?limit=1024&name=./images/[hash:8].[name].[ext]'
}
```


### HTML的img标记处理

#### 安装

```shell
cnpm install html-withimg-loader -S
```


#### 配置

```shell
{
    test:/\.html$/,
    use:["html-withimg-loader"]
}
```

### CSS 打包分离

#### 安装

```shell
cnpm install extract-text-webpack-plugin@next -S
```

#### 配置


```js
const ExtractTextPlugin=require('extract-text-webpack-plugin');

//插件
new ExtractTextPlugin('./css/[name].css')

// rules
{
    test:/\.css$/,
    use:ExtractTextPlugin.extract({
        fallback:"style-loader",
        use:[{
            loader:"css-loader",
            options:{
                // 压缩
                minimize:true
            }
        }],
        // 添加公共路径
        publicPath:"../"
    })
}
```

## webpack 插件

插件是 webpack 的支柱功能。webpack 自身也是构建于，你在 webpack 配置中用到的相同的插件系统之上！

插件目的在于解决 loader 无法实现的其他事。

### 剖析

webpack 插件是一个具有 apply 属性的 JavaScript 对象。apply 属性会被 webpack compiler 调用，并且 compiler 对象可在整个编译生命周期访问。

**ConsoleLogOnBuildWebpackPlugin.js**

```js
const pluginName = 'ConsoleLogOnBuildWebpackPlugin';

class ConsoleLogOnBuildWebpackPlugin {
    apply(compiler) {
        compiler.hooks.run.tap(pluginName, compilation => {
            console.log("webpack 构建过程开始！");
        });
    }
}
```

compiler hook 的 tap 方法的第一个参数，应该是驼峰式命名的插件名称。建议为此使用一个常量，以便它可以在所有 hook 中复用。

### 用法


由于插件可以携带参数/选项，你必须在 webpack 配置中，向 `plugins` 属性传入 `new` 实例。

根据你的 webpack 用法，这里有多种方式使用插件。

### 配置

webpack.config.js

```js
const HtmlWebpackPlugin = require('html-webpack-plugin'); //通过 npm 安装
const webpack = require('webpack'); //访问内置的插件
const path = require('path');

const config = {
  entry: './path/to/my/entry/file.js',
  output: {
    filename: 'my-first-webpack.bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        use: 'babel-loader'
      }
    ]
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin(),
    new HtmlWebpackPlugin({template: './src/index.html'})
  ]
};

module.exports = config;
```

当然上面的 `HtmlWebpackPlugin` 插件只使用了基本的功能，更多的参数可以去github上查看。

## webpack babel

### 安装

核心
	babel-core
    
功能
	babel-loader
	babel-preset-env
    babel-preset-react
    
#### babel-loader 7.x 版本安装

```shell
cnpm install babel-core babel-loader@7 babel-preset-env babel-preset-react --save
```

安装的 `babel-loader` 是7.x版本，8.x版本目前会出现报错，具体如何解决还没有了解清楚，所以安装 `babel-loader` 时需要写成这样的 `babel-loader@7`

#### babel-loader 8.x 版本安装

```shell
cnpm install -D babel-loader @babel/core @babel/preset-env @babel/preset-react -S
```
上面为 `babel-loader 8.x`  版本安装，需要匹配下面的 8.x 配置

### 配置

#### babel-loader 7.x 版本配置

第一种 全在 `webpack.config.js` 中配置

```js
rules:[
    {
        test:/\.(jsx|js)$/,
        use:{
            loader:'babel-loader',
            options:{
                presets:['env','react']
            }
        },
        // 排除node_modules 文件
        exclude:/node_modules/
    }
]
```

第二种 新建 `.babelrc` 文件 （推荐使用第二种）

webpack.config.js

```js
rules:[
    {
        test:/\.(jsx|js)$/,
        use:{
            loader:'babel-loader'
        },
        // 排除node_,modules 文件
        exclude:/node_modules/
    }
]
```
.baelrc

```
{
    "presets": [
        "env",
        "react"
    ]
}
```

#### babel-loader 8.x 版本配置

第一种 全在 `webpack.config.js` 中配置

```js
rules:[
    {
        test:/\.(jsx|js)$/,
        use:{
            loader:'babel-loader',
            options:{
                presets:['"@babel/preset-env','"@babel/preset-react']
            }
        },
        // 排除node_modules 文件
        exclude:/node_modules/
    }
]
```

第二种 新建 `.babelrc` 文件 （推荐使用第二种）

webpack.config.js

```js
rules:[
    {
        test:/\.(jsx|js)$/,
        use:{
            loader:'babel-loader'
        },
        // 排除node_,modules 文件
        exclude:/node_modules/
    }
]
```
.baelrc

```
{
    "presets": [
        ""@babel/preset-env",
        ""@babel/preset-react"
    ]
}
```

## webpack 引入第三方库

### 安装

```shell
cnpm install jquery -S
```

### 使用

在webpack 3.x 中需要大量配置，但是在webpack中则少了很多

```js
const $ = require("jquery");

$("body").html("<p>我是由JQuery写出来的</p>")
```

欢迎到 [看云阅读](https://www.kancloud.cn/spirit-ling/blog)