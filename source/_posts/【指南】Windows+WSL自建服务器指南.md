---
title: Windows+WSL2自建专属个人服务器
tags:
  - Windows
  - WSL2
  - CUDA
categories:
  - 指南
index_img: https://zhongshijie1995.github.io/zhongshijie-pic/img/20220322221801.png
description: WSL2是Windows内建的Linux子系统，带来真正无缝双系统的体验，在宽带申请公网IP后，我们可以将Windows的Linux子系统装备成一个独立精悍的个人服务器。
abbrlink: 20003
date: 2022-03-11 21:20:00
sticky: 100
---

> 通过启用Windows10或者Windows11中的WSL2的Ubuntu，在Ubuntu中构建一个属于自己的Linux服务器。

# 宿主计算机配置
## 开启WSL2
1. 通过Windows的“启用或关闭Windows功能”开启Linux子系统功能：
  - 勾选“适用于Linux的Windows子系统”
  - 勾选“虚拟机平台”
    ![启用或关闭Windows功能](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220329083615.png)
2. 配置WSL使用的版本为WSL2。
  - 安装[WSL2内核](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
  - 在PowerShell中运行命令：
    ```powershell
    wsl --set-default-version 2
    ```
3. 通过Windows的“应用商店”安装如下内容：
  - 安装“Ubuntu”
    ![应用商店](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220329084250.png)

## WSL自启动
1. 在Windows用户开机启动目录中添加`C:\Users\用户名\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`文件`linux-start.vbs`，文件内容如下：
  ```vb
  Set ws = WScript.CreateObject("WScript.Shell")        
  ws.run "wsl -d Ubuntu -u root /etc/init.wsl"
  ```
  - 上述文件内容包含如下信息：
    - 指定`linux-start.vbs`为Windows启动时运行的程序；
    - `vbs`中运行`Ubuntu`的WSL内的`/etc/init.wsl`，指定`-u root`执行运行的用户。
    - `vbs`中运行`Ubuntu`的WSL内的`/etc/init.wsl`，所以，我们需要提前在WSL2中创建好该文件，内容为需要开机启动的项目）。

## 端口监听
1. 通过Windows自带的`netsh`工具的端口代理功能，可以讲将WSL2的内部监听端口作用在宿主计算机上，达到端口转发的效果。  
  ```powershell
  # 查看所有端口代理
  netsh interface portproxy show all
  # 增加一个IPV4到IPV4的端口代理
  netsh interface portproxy add v4tov4 listenport=外部端口 connectaddress=localhost connectport=内部端口
  # 增加一个IPV4到IPV6的端口代理
  netsh interface portproxy add v4tov6 listenport=外部端口 connectaddress=localhost connectport=内部端口
  # 删除指定的端口代理
  netsh interface portproxy delete v4tov4 listenport=外部端口
  ```

## 释放磁盘
1. 由于WSL2的特殊设计，其使用过的磁盘空间需要**宿主计算机**中通过如下命令才可以真正释放。
  ```powershell
  # 关闭虚拟机
  wsl --terminate Ubuntu
  ```
2. 通过`Powershell`运行`diskpart`进入磁盘管理工具命令行内，再输入如下内容进行磁盘压缩
  ```shell
  select vdisk file="C:\Users\【用户名】\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx"
  compact vdisk
  ```

## (可选）显卡驱动（NVIDIA + CUDA）
1. 下载并安装[英伟达官方显卡驱动](https://www.nvidia.cn/Download/index.aspx?lang=cn)

# WSL配置
## SSH
1. 安装OpenSSH
    ```shell
    sudo apt autoremove openssh-server
    sudo apt install openssh-server
    ```
2. 配置OpenSSH
  - 编辑文件`/etc/ssh/sshd_config`的如下配置：
    ```conf
    # 将监听端口定在222用于将22预留给宿主计算机暴露给外部网络
    Port 222
    # 在IPV4上进行监听
    ListenAddress 0.0.0.0
    # 允许公钥进行登录
    PubkeyAuthentication yes
    # 运行密码进行登录
    PasswordAuthentication yes
    # 指定公钥存储目录
    AuthorizedKeysFile .ssh/authorized_keys
    ```
  - 重新启动服务。
    ```shell
    sudo service ssh restart
    ```
  - （可选）在可信设备中，通过`ssh-copy-id`将公钥传入WSL配置免密登录。
    ```shell
    ssh-copy-id 用户名@地址 -p 端口
    ```
  - 编辑`/etc/init.wsl`，将启动SSH作添加到Windows开机自启动脚本中。
    ```shell
    #! /bin/sh
    /etc/init.d/ssh start
    ```

## Java
1. 下载[OpenJDK11](https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/11/jdk/x64/linux/OpenJDK11U-jdk_x64_linux_hotspot_11.0.14.1_1.tar.gz)并解压。
2. 添加环境变量到`.bashrc`。
  ```shell
  # OpenJDK11
  export PATH=$PATH:/home/zsj/Desktop/00-DevBuild/jdk-11.0.14.1+1/bin
  ```

## Anaconda（Python）
1. 下载[Anaconda3](https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2021.11-Linux-x86_64.sh)运行安装，在安装阶段已经包含添加环境变量的配置。

## NodeJS
1. 下载[NodeJS16](https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/v16.14.2/node-v16.14.2-linux-x64.tar.xz)并解压。
2. 添加环境变量到`.bashrc`。
```shell
# NodeJS16
export PATH=$PATH:/home/zsj/Desktop/00-DevBuild/node-v16.14.2-linux-x64/bin
```

## Github
1. 通过`ssh-keygen-t`生成密钥对
  ```
  ssh-keygen -t rsa
  ```
2. 读出`~/.ssh/id_rsa.pub`内的公钥，将其添加到Github账户中
  ![Github公钥](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220329104826.png)
3. 配置Git本地作者信息
  ```shell
  git config --global user.name "zhongshijie"
  git config --global user.email "zhongshijie1995@outlook.com"
  ```

## 运行exe在宿主计算机上
1. WSL2在执行`.exe`文件时会自动使用宿主计算机Windows来运行，所以要想运行宿主计算机的应用程序，直接运行它即可：
  ```shell
  # 创建一个快捷方式在WSL中
  ln -s '/mnt/c/Program Files (x86)/ToDesk/ToDesk.exe' /home/zsj/WindowsApp/ToDesk.exe
  # 直接运行快捷方式
  /home/zsj/WindowsApp/ToDesk.exe
  ```
