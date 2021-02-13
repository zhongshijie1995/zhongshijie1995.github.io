---
title: WSL实用手册
tags:
  - WSL
  - Linux
  - Winodws
categories:
  - 经验与技巧
cover: https://zhongshijie.gitee.io/mirrors-pic/img/20200829192900.png
description: 在Windows10中玩转Linux的骚操作
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
