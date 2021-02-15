---
title: 【大指南】Windows配置多种数据库环境
tags:
  - Windows
  - Oracle
  - MySQL
  - MongoDB
  - VMware
categories:
  - 大指南
cover: https://zhongshijie.gitee.io/mirrors-pic/img/20210213124100.jpg
description: 一步一步在Windows中配置各种数据库服务的实验环境，建造于VMware中使得它随时可以移植起其他硬件设备继续实验
abbrlink: 50000
date: 2020-03-16 22:01:00
---

也许，你也曾经遇到过这样的问题：企业数据库服务器资源有限且自己不具备DBA权限，你想要在自己的PC中搭建出各种数据库环境以进行对比实验，例如：进行Oracle数据库迁移到MySQL中的对比实验等等……于是，我们企图运行一个专用的数据库服务器，让你享受一次自己做DBA的感觉，让你的实验更加方便和快捷。

我们其实希望达到**在Windows中配置各种数据库服务的实验环境，建造于VMware中使得它随时可以移植起其他硬件设备继续实验**的效果，为此，解决方案就可以是：在我们的VMware中安装一个Windows10环境，让它作为一个全职数据库服务器（既不污染开发环境，又方便迁移到其他计算机中），对数据库的安装和配置操作均在这个虚拟环境中进行，当然，你也可以直接在你的物理机中执行这些操作，只是便不具备上述所说的优点罢了。

![VMware中运行一个属于自己的多功能数据库服务器](https://zhongshijie.gitee.io/mirrors-pic/img/20210214224333.png)

话不多说，这里直接提供一个已经安装好了 Oracle19c + MySQL8 + MongoDB4.4 的数据库服务Windows10环境，使用VMware Player 16直接打开即可使用，免去安装和配置的烦恼，点击[此处下载](https://cloud.189.cn/t/eIFraefAZjIr)

# Oracle
## 安装Oracle数据库
1. 下载Oracle数据库 [安装程序](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)
2. 通过安装程序`setup.exe`进行安装
3. 填写必要的信息，**取消勾选“创建为容器数据库”**
4. 实例名为默认为ORCL，如果修改了需要自己牢记。

## 管理Oracle数据库
0. 打开`SQLPlus`或其他数据连接工具，用户名为system，密码为安装时提供的口令
1. 创建Oracle用户和表空间（以用户名zsj，密码zsjpwd，表空间名zsj为例）
```SQL
create user zsj identified by zsjpwd;
create tablespace zsj datafile 'C:\Users\zhong\Desktop\usr\zsj.dbf'
size 32m autoextend on next 32m maxsize 2048m;
alter user zsj default tablespace zsj;
grant create session,create table,unlimited tablespace to zsj;
```

2. 删除Oracle用户和表空间（以用户名zsj，表空间名zsj为例）
```SQL
drop user zsj;
drop tablespace zsj including contents and datafiles CASCADE CONSTRAINTS;
```

## 连接Oracle数据库
### 类DataGrip软件
1. 安装Oracle驱动后直接按照IP、USER、PWD配置进行连接

### Python (cx_oracle) + OracleClient
1. 下载 [OracleClient](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html)，将起解压后目录添加至系统环境变量
2. 为Python环境安装cx_oracle，`pip install cx_oracle`

# MySQL
## 安装MySQL数据库
1. 下载MySQL数据库[安装程序](https://dev.mysql.com/downloads/installer/)
（或从清华镜像源中[安装程序镜像](https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQLInstaller/)）
2. 通过msi进行安装，填写必要的信息，**选择Server Only选项**
3. 打开`MySQLX.X Command Line Client`，执行如下命令
```SQL
use mysql;
update user set host='%';
GRANT ALL ON *.* TO 'root'@'%';
flush privileges;
```

## 管理MySQL数据库
0. 打开任意数据库连接工具，用户名为root，密码为安装时提供的口令
1. 创建MySQL用户和表空间（以用户名zsj，密码zsjpwd，表空间名zsj为例）
```SQL
create user 'zsj'@'%' identified by 'zsjpwd' ;
create schema zsj default character set utf8mb4 collate utf8mb4_general_ci ;
grant all on zsj.* to zsj ;
flush privileges ;
```
2. 删除MySQL用户和表空间（以用户名zsj,表空间名zsj为例）
```SQL
drop user zsj cascade;
```

# MongoDB
## 安装MongoDB数据库
1. 下载MongoDB数据库[安装程序](https://www.mongodb.com/try/download/community)
2. 通过msi进行安装，使用`Complete`模式（直接安装到系统盘）或`Custom`模式（手动指定安装位置）
3. 编辑安装目录下的`XXX\bin\mongod.conf`中的`bindIp`为`0.0.0.0`，使其可以被任何IP连接访问

## 管理MongoDB数据库
0. 打开任意数据库连接工具，无须用户名和密码
1. 创建or切换到数据库
```sql
use zsj
```
2. 删除数据库
```sql
use zsj
db.dropDatabase()
```
