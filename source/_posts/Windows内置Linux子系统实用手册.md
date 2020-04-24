---
title: Windows内置Linux子系统实用手册
tags:
  - Linux
  - Windows
categories:
  - 经验与技巧
cover: https://cdn.pixabay.com/photo/2013/07/13/12/31/penguin-159784_1280.png
description: 有没有想过自己的Windows中能原生般的运行Linux？
abbrlink: 41556
date: 2020-03-16 22:01:00
---

# 1. 如何开始？
## 1.1 方法一：使用Win10自带的安装方法（Microsoft Store）和路径（C:）
|步骤 |过程 |
|-|-|
|1.首先，我们通过`Win + S`快捷键进入搜索，搜索 开启或关闭Windows功能 并进入。开启了该功能后，重启系统。 |![开启功能](https://zhongshijie.gitee.io/mirrors-pic/img/20200317175850.jpg) |
|
2. 随后，我们需要进入Microsoft Store中下载Linux的一个发行版，搜索Linux即可查看各个Linux的发行版。|![应用商店](https://zhongshijie.gitee.io/mirrors-pic/img/20200317180238.jpg)
|3. 选择一个喜欢的版本，并下载安装他们，随后启动该应用即可（作者以Ubuntu为例）。|![启动后](https://zhongshijie.gitee.io/mirrors-pic/img/20200317180327.jpg) |
|4. 该Linux子系统可以直接访问windows中的文件 |例：本地磁盘c（`/mnt/c/`），本地磁盘d（`/mnt/d/`）|

## 1.2 方法二：使用离线安装方法
1. 下载离线安装工具+LinuxOnWindows镜像

|内容 |下载路径 |
|-|-|
|离线安装工具 |[LxRunOffline-v3.4.0.zip](https://zhongshijie.coding.net/s/cb632d56-a551-4682-bb47-28707af49d9d) |
|Ubuntu1804OnWindows镜像 |[Ubuntu18.04onWindows.zip](https://zhongshijie.coding.net/s/d829e2cc-a473-4683-9a5a-e64cab7adcd3) |

2. 安装如下说明使用离线安装工具

> 注意：<安装文件>为镜像文件夹中的install.tar.gz

①安装WSL到指定目录： LxRunOffline i -n <安装名称> -d <安装路径> -f <安装文件>

②设置默认启动系统： LxRunOffline sd -n <安装名称>

③查看安装名称： LxRunOffline list

④启动默认系统： wsl

⑤备份WSL： LxRunOffline.exe export -n <安装名称> -f <安装文件>

⑥恢复WSL： LxRunOffline.exe install -n <安装名称> -d <安装路径> -f <安装文件>

⑦卸载WSL：LxRunOffline.exe ui -n <安装名称>


# 2. 如何更好的使用它？ 
## 2.1 替换软件源
1. Ubuntu系统默认的软件源在国内网速较慢且不稳定，我们可以考虑更换为国内的阿里云的软件源。

2. 首先，我们先创建一个名为 sources.list 文本文件。
```shell
vi sources.list
```

3. 将以下内容粘贴到编辑器中（Vi编辑器命令：“i”进入编辑，“Esc”结束编辑，“:wq”写入并退出）。
```vi
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


# 3. Python相关
## 3.1 调整python和pip
1. 首先安装pip3
```
sudo apt install python3-pip
```

2. 将python和pip指定为python3和pip3
```
ln -s /usr/bin/python3.6 /usr/bin/python
ln -s /usr/bin/pip3 /usr/bin/pip
```

## 3.2 为pip更换源
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

# 4. Node.js相关
## 4.1 安装指定版本的Node.js
```
wget https://nodejs.org/dist/v12.16.2/node-v12.16.2-linux-x64.tar.xz
tar -xvf node-v12.16.2-linux-x64.tar.xz
mv node-v12.16.2-linux-x64 /usr/local/
ln -s /usr/local/node-v12.16.2-linux-x64/bin/node /usr/local/bin/node
ln -s /usr/local/node-v12.16.2-linux-x64/bin/npm /usr/local/bin/npm
```

## 4.2 为npm切换源
```
npm config set registry https://registry.npm.taobao.org
```
