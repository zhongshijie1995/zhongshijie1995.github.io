---
title: MacOS实用手册
tags:
  - MacOS
categories:
  - 经验与技巧
cover: https://zhongshijie.gitee.io/mirrors-pic/img/keyboard-690066_960_720.jpg
description: 有没有想过自己的Windows中能原生般的运行Linux？
abbrlink: 41556
date: 2020-03-16 22:01:00
---

# 1. 设置环境变量

以MacOS 10.15为例，很多pkg安装包或者是用户们，会习惯性的添加环境变量在`~/.bash_profile`中，但由于我们知道MacOS的`终端.app`默认使用了`zsh`导致我们启动终端时，这使得我们写在`~/.bash_profile`中的内容不会生效，于是这里提供一种Mac设置环境变量的方法。

1. 为`zsh`准备环境变量。

```
vi ~/.zshrc
```

2. 让我们写在`~/.bash_profile`中的内容生效，将以下内容粘贴到编辑器中（Vi编辑器命令：“i”进入编辑，“Esc”结束编辑，“:wq”写入并退出）。

```
source ~/.bash_profile
```

# 2. Python相关

1. 创建 .pip 文件夹，并在该文件夹内创建 pip.conf 文本文件。
```
mkdir ~/.pip
vim ~/.pip/pip.conf
```

2. 将以下内容粘贴到编辑器中（Vi编辑器命令：“i”进入编辑，“Esc”结束编辑，“:wq”写入并退出）。
```
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
```
该 index-url 为 **阿里云源**。

此后，使用pip时将从阿里云镜像进行下载。

# 4. Node.js相关
1. 运行以下命令为npm切换源

```
npm config set registry https://registry.npm.taobao.org
```
