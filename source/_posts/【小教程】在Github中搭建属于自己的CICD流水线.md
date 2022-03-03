---
title: 【小教程】在Github中搭建属于自己的CICD流水线
tags:
  - DevOps
categories:
  - 小教程
index_img: https://zhongshijie1995.github.io/zhongshijie-pic/img/20220304001311.png
description: Github Action免费为我们提供了性能优异的跨国DevOps流水线运行代理机器
abbrlink: 20001
date: 2022-01-13 22:01:00
---

在 GitHub Actions 的仓库中自动化、自定义和执行软件开发工作流程。 您可以发现、创建和共享操作以执行您喜欢的任何作业（包括 CI/CD），并将操作合并到完全自定义的工作流程中。让你的Github仓库中提交代码拉取请求后能自动的单元测试、通过代码覆盖率门禁、自动的部署测试和生产，并可以提供精美的发版说明。
![](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220304002810.png)
![](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220304003343.png)

> 对于Github Action最好的学习使用方法，我推荐直接从套用世杰提供的`DevOps`模版开始，假如填写时有地方看不懂，再查看[官方文档](https://docs.github.com/cn/actions)

# 基于Springboot的应用程序持续集成+发布模版
1. 在你的项目目录下创建如下目录结构，其中`.github`即是你的持续集成+发布流水线的配置文件
![文件结构](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220304001610.png)

2. 填写持续集成流水线
```CICD for PR.yml
name: CICD for PR

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  # 准备步骤
  prepare:
    runs-on: ubuntu-latest
    outputs:
      myhost: ${{ steps.get-my-host.outputs.host_ip }}
    steps:
      - id: get-my-host
        run: echo "::set-output name=host_ip::$(curl https://zhongshijie1995.github.io/about/ | grep -m1 -o "【.*】" | tr -d ['【】'])"
  # 构建步骤
  build:
    # 运行环境
    runs-on: ubuntu-latest
    # 前置步骤
    needs: prepare
    # 执行步骤
    steps:
      # 打印我的地址
      - name: Print my host
        run: echo ${{ needs.prepare.outputs.myhost }}
      # 拉取代码
      - uses: actions/checkout@v2
      # 设置构建参数
      - name: Set up JDK 11
        uses: actions/setup-java@v2
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: maven
      # 通过maven clean install构建
      - name: Build with Maven
        run: mvn -B clean install
      # 生成单元测试报告（always）
      - name: JUnit Report Action
        uses: mikepenz/action-junit-report@v2.8.4
        if: always()
        with:
          report_paths: '**/TEST-*.xml'
      # 生成覆盖率到拉取请求的评论区
      - name: Add coverage to PR
        id: jacoco
        uses: madrapps/jacoco-report@v1.2
        if: ${{ github.event_name == 'pull_request' }}
        with:
          paths: target/site/jacoco/jacoco.xml
          token: ${{ secrets.GITHUB_TOKEN }}
          min-coverage-overall: 90
          min-coverage-changed-files: 90
      # 加入发版草稿
      - name: Add release draft
        uses: release-drafter/release-drafter@v5
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      # 上传构件和部署脚本
      - name: scp jar & deploy.sh
        uses: cross-the-world/ssh-scp-ssh-pipelines@latest
        if: ${{ github.event_name == 'push' }}
        with:
          host: ${{ needs.prepare.outputs.myhost }}
          user: ${{ secrets.DEEPIN_USER }}
          pass: ${{ secrets.DEEPIN_PASSWORD }}
          scp: |
            ./target/big_boot-*.jar => /home/${{ secrets.DEEPIN_USER }}/Desktop/00-SystemTest/big_boot/
            deploy.sh => /home/${{ secrets.DEEPIN_USER }}/Desktop/00-SystemTest/big_boot/
      # 执行部署脚本
      - name: run deploy
        uses: cross-the-world/ssh-scp-ssh-pipelines@latest
        if: ${{ github.event_name == 'push' }}
        with:
          host: ${{ needs.prepare.outputs.myhost }}
          user: ${{ secrets.DEEPIN_USER }}
          pass: ${{ secrets.DEEPIN_PASSWORD }}
          last_ssh: |
            cd /home/${{ secrets.DEEPIN_USER }}/Desktop/00-SystemTest/big_boot && sh deploy.sh 02_sys_test
```

3. 填写持续部署流水线
```CD for release.yml
name: CD for release

on:
  release:
    types: [ published ]

jobs:
  # 准备步骤
  prepare:
    runs-on: ubuntu-latest
    outputs:
      myhost: ${{ steps.get-my-host.outputs.host_ip }}
    steps:
      - id: get-my-host
        run: echo "::set-output name=host_ip::$(curl https://zhongshijie1995.github.io/about/ | grep -m1 -o "【.*】" | tr -d ['【】'])"
  # 构建步骤
  build:
    # 运行环境
    runs-on: ubuntu-latest
    # 前置步骤
    needs: prepare
    # 执行步骤
    steps:
      # 打印我的地址
      - name: Print my host
        run: echo ${{ needs.prepare.outputs.myhost }}
      # 拉取代码
      - uses: actions/checkout@v2
      # 设置构建参数
      - name: Set up JDK 11
        uses: actions/setup-java@v2
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: maven
      # 通过maven clean install构建
      - name: Build with Maven
        run: mvn -B clean package
      # 上传构件和部署脚本
      - name: scp jar & deploy.sh
        uses: cross-the-world/ssh-scp-ssh-pipelines@latest
        with:
          host: ${{ needs.prepare.outputs.myhost }}
          user: ${{ secrets.DEEPIN_USER }}
          pass: ${{ secrets.DEEPIN_PASSWORD }}
          scp: |
            ./target/big_boot-*.jar => /home/${{ secrets.DEEPIN_USER }}/Desktop/00-Production/big_boot/
            deploy.sh => /home/${{ secrets.DEEPIN_USER }}/Desktop/00-Production/big_boot/
      # 执行部署脚本
      - name: run deploy
        uses: cross-the-world/ssh-scp-ssh-pipelines@latest
        with:
          host: ${{ needs.prepare.outputs.myhost }}
          user: ${{ secrets.DEEPIN_USER }}
          pass: ${{ secrets.DEEPIN_PASSWORD }}
          last_ssh: |
            cd /home/${{ secrets.DEEPIN_USER }}/Desktop/00-Production/big_boot && sh deploy.sh 03_prod
```

4. 填写发布草稿配置
```release-drafter.yml
name-template: 'v$RESOLVED_VERSION 🌈'
tag-template: 'v$RESOLVED_VERSION'
categories:
  - title: '🚀 Features'
    labels:
      - 'feature'
      - 'enhancement'
  - title: '🐛 Bug Fixes'
    labels:
      - 'fix'
      - 'bugfix'
      - 'bug'
  - title: '🧰 Maintenance'
    label: 'chore'
change-template: '- $TITLE @$AUTHOR (#$NUMBER)'
change-title-escapes: '\<*_&' # You can add # and @ to disable mentions, and add ` to disable code blocks.
version-resolver:
  major:
    labels:
      - 'major'
  minor:
    labels:
      - 'minor'
  patch:
    labels:
      - 'patch'
  default: patch
template: |
  ## Changes

  $CHANGES
```

5. 最后，在此处配置你的隐私变量，对应上述CI/CD的流水线中的变量
![](https://zhongshijie1995.github.io/zhongshijie-pic/img/20220304003601.png)
