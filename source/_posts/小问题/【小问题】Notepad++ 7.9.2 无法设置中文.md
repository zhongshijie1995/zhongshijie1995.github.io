---
title: 【小问题】Notepad++ 7.9.2 无法设置中文？
tags:
  - Windows
  - Notepad++
categories:
  - 经验与技巧
cover: https://zhongshijie.gitee.io/mirrors-pic/img/20210213132154.png
description: 看到 Notepad++ 7.9.2 的发版名称，除了感受到作者的恶意，还发现他故意留了一个bug，让用户无法直接设置简体中文作为语言环境，我们当然不能惯着他了
abbrlink: 50002
date: 2020-03-16 22:01:00
---

## 症状
使用Notepad++ 7.9.2，将“首选项”-“常用”-“页面语言”设置为“简体中文”后无法生效。

## 症结和解决方案
找到安装目录下的如下文件`XXX\localization\chineseSimplified.xml`，你就会发现在第852行的XML节点是非对应的，就是这个原因导致了无法设置简体中文作为语言环境，只需要将852行的XML节点改为正确，便可以正常使用了。

![NotePad++7.9.2作者刻意留下的bug](https://zhongshijie.gitee.io/mirrors-pic/img/20210213131811.png)
