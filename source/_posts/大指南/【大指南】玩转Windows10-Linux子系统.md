---
title: 【大指南】玩转Windows10-Linux子系统
tags:
  - WSL
  - Linux
  - Windows
categories:
  - 大指南
cover: https://zhongshijie.gitee.io/mirrors-pic/img/20200829192900.png
description: 厌倦了双系统和虚拟机中的Linux？如果你是一个Windows10用户，直接配置一个Linux子系统不是更爽吗？一起探索一下如何让WSL更畅快好用吧~
abbrlink: 10000
date: 2020-03-16 22:01:00
---

> 针对Windows 10中的Ubuntu 20.04 LTS并使用WSL2版本

# 软件源
软件源配置文件：`/etc/apt/sources.list`
## 软件源内容
### 原生软件源
```conf
# 适用于Ubuntu20.04的原生镜像源
deb http://archive.ubuntu.com/ubuntu/ focal main restricted
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted
deb http://archive.ubuntu.com/ubuntu/ focal universe
deb http://archive.ubuntu.com/ubuntu/ focal-updates universe
deb http://archive.ubuntu.com/ubuntu/ focal multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-backports mainrestricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ focal-security mainrestricted
deb http://security.ubuntu.com/ubuntu/ focal-security universe
deb http://security.ubuntu.com/ubuntu/ focal-security multiverse
```
### 清华软件源
```conf
# 适用于Ubuntu20.04的清华镜像源
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricteduniverse multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security mainrestricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates mainrestricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed mainrestricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports mainrestricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricteduniverse multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security mainrestricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates mainrestricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed mainrestricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports mainrestricted universe multiverse
```
## 启用和更新软件源
```shell
sudo apt update
sudo apt upgrade
```

# 开发环境
## 编程语言
### Java
```shell
sudo apt install openjdk-8-jdk-headless
```

### Python
1. 下载Anaconda
```shell
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2020.11-Linux-x86_64.sh
```
2. 安装
```shell
sh Anaconda3-2020.11-Linux-x86_64.sh
```
3. 更换源

### C/C++

### JavaScript

# 远程服务
## 开启SSH
1. 重新安装`openssh-server`
```shell
sudo apt remove openssh-server
```

```shell
sudo apt install openssh-server
```

2. 编辑`sudo vi /etc/ssh/sshd_config`
```shell
# 找到该项
PasswordAuthentication yes
```

3. 启动监听
```shell
sudo service ssh restart
```
