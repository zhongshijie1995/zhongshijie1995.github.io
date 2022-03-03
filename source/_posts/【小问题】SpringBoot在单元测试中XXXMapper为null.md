---
title: 【小问题】SpringBoot单元测试中XXXMapper为null
tags:
  - Java
  - SpringBoot
categories:
  - 小问题
index_img: https://zhongshijie1995.github.io/zhongshijie-pic/img/20200921095000.png
description: SpringBoot单元测试中XXXMapper为null一般出现在
abbrlink: 30001
date: 2020-09-19 22:12:00
---

# 1. 假设你来面试～看图找问题
![看图找问题](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220303233556.png)

图中进行如下内容，最后在单元测试中`userMapper`为null而报错。
1. 准备了一个`HelloController`，其中通过`userMapper`进行了数据库交互并查询到数据列表；
2. 准备了一个`MockMvc`，通过`StandaloneSetup`加载了一个`HelloController`进行单元测试；

# 2. 答案与解析
很多人第一反应是去排查图中的`user()`测试方法，首先任务`Mock`这里肯定没问题，但实际上，问题恰恰就仅仅出现在这里。先看看行之有效的修复：
1. 准备了一个`WebApplicationContext`中测试类内；
2. 准备了一个`MockMvc`，通过`WebAppContextSetup`加载`applicationContext`进行单元测试；
![答案](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220303234110.png)

其实，通过阅读`MockMvc`的源码可以得知，`StandaloneSetup`加载只会初始化`Controller`的底层的依赖，不会包括`Component`和其他用户的`Bean`，那么其中的`userMapper`自然也就没有被初始化了。
![解析](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220303234137.png)