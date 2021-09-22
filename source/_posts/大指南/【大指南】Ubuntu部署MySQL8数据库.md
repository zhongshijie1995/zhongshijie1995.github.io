---
title: 【大指南】Ubuntu部署MySQL8数据库操作指北
date: 2021-04-04 12:35:05
tags:
  - Ubuntu
  - MySQL
categories:
  - 大指南
cover: https://zhongshijie1995.github.io/zhongshijie-pic/img/20210404143948.png
abbrlink: 10002
description: 其实总共就那么几步，不用去网上看半天。
---

1. 卸载MySQL及其依赖项
```shell
sudo apt remove mysql-common
sudo apt autoremove --purge mysql-server
dpkg -l|grep ^rc|awk '{print$2}'|sudo xargs dpkg -P
```
2. 清除MySQL数据文件
```shell
sudo rm /var/lib/mysql/ -R
sudo rm /etc/mysql/ -R
```
3. 安装MySQL
```shell
sudo apt install mysql-server
```
4. 更改MySQL配置文件以允许远程连接
```shell
vi /etc/mysql/mysql.conf.d/mysqld.cnf

# 将bind-address的值改为0.0.0.0
# 将mysqlx-bind-address的值改为0.0.0.0
```
5. 配置root用户允许远程连接
```shell
update user set host='%' where user='root';
alter user 'root'@'%' identified with mysql_native_password by 'password';
```
6. 创建用户和数据库
```sql
create user 'user_a'@'%' identified by 'user_a_password' ;
create schema user_a default character set utf8mb4 collate utf8mb4_general_ci ;
grant all on user_a.* to user_a ;
flush privileges ;
```
