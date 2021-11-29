---
title: 【大指南】Linux部署MySQL8数据库操作指北
date: 2021-04-04 12:35:05
tags:
  - Linux
  - MySQL
categories:
  - 大指南
cover: https://zhongshijie1995.github.io/zhongshijie-pic/img/20210404143948.png
abbrlink: 10002
description: 其实总共就那么几步，不用去网上看半天。
---

> 本文中使用的Linux为Ubuntu，其中涉及的apt命令在非某些Linux上可由其他命令替代

# 完全卸载
## 卸载MySQL及其依赖项
```shell
sudo apt remove mysql-common
sudo apt autoremove --purge mysql-server  
```
## 清除MySQL数据文件
```shell
sudo rm /var/lib/mysql/ -R
sudo rm /etc/mysql/ -R
```

# 安装与配置
## 安装MySQL
```shell
sudo apt install mysql-server
```
## 配置
### 更改MySQL配置文件以允许远程连接
1. 使用
  ```shell
  vi /etc/mysql/mysql.conf.d/mysqld.cnf
  ```
2. 将`bind-address`的值改为`0.0.0.0`
3. 将`mysqlx-bind-address`的值改为`0.0.0.0`

### 配置root用户允许远程连接
1. 使用`mysql`进入数据库连接，使用`use mysql`指定数据库，然后执行如下语句：
```sql
update user set host='%' where user='root';
alter user 'root'@'%' identified with mysql_native_password by 'password';
```
2. 创建用户和数据库
```sql
create user 'big_sql'@'%' identified by 'big_sql';
create schema big_sql default character set utf8mb4 collate utf8mb4_general_ci;
grant all on big_sql.* to big_sql;
flush privileges;
```
3. 删除用户和数据库
```sql
drop user big_sql;
drop schema big_sql;
```

# 进程重启
```shell
service mysql restart
```