---
title: Windows内置Linux子系统实用手册
tags:
  - Linux
categories:
  - 经验与技巧
cover: https://cdn.pixabay.com/photo/2013/07/13/12/31/penguin-159784_1280.png
description: 有没有想过自己的Windows中能原生般的运行Linux？
abbrlink: 41556
date: 2020-03-16 22:01:00
---

# 1. 如何开始？
1. 首先，我们通过`Win + S`快捷键进入搜索，搜索 开启或关闭Windows功能 并进入。开启了该功能后，重启系统。
<!-- {% asset_img 开启适用于Linux的Windows子系统.jpg 开启适用于Linux的Windows子系统 %} -->

2. 随后，我们需要进入Microsoft Store中下载Linux的一个发行版，搜索Linux即可查看各个Linux的发行版。
<!-- {% asset_img 应用商店.jpg 应用商店 %} -->

3. 选择一个喜欢的版本，并下载安装他们，随后启动该应用即可（作者以Ubuntu为例）。
<!-- {% asset_img 子系统.jpg 子系统 %} -->

4. 该Linux子系统可以直接访问windows中的文件，目录举例：
  - 本地磁盘c ： /mnt/c/
  - 本地磁盘d ： /mnt/d/


# 2. 如何更好的使用它？ 
## 2.1 替换软件源
1. Ubuntu系统默认的软件源在国内网速较慢且不稳定，我们可以考虑更换为国内的阿里云的软件源。

2. 首先，我们先创建一个名为 sources.list 文本文件。
```
vi sources.list
```

3. 将以下内容粘贴到编辑器中（Vi编辑器命令：“i”进入编辑，“Esc”结束编辑，“:wq”写入并退出）。
```
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

4. 移动 sources.list 到目标位置，执行更新软件源和软件。
```
sudo mv sources.list /etc/apt/sources.list
sudo apt update
sudo apt upgrade
```

## 2.2 运行图形界面程序
1. 下载安装[**Xming**](https://zhongshijie.coding.net/s/ae5900ca-9554-4110-aea6-0ec5c59725ff)，安装完直接打开Xming即可。

2. 执行下列指令后，重启bash。
```
echo "export DISPLAY=:0.0" >> ~/.bashrc
```
此后，在bash中启动图形界面程序，即可在Window10桌面以窗口形式展现。

## 2.3 为pip更换源
1. 创建 .pip 文件夹，并在该文件夹内创建 pip.conf 文本文件
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