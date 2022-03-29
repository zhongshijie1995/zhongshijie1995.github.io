---
title: Anaconda+JupyterNotebook+Venv+GPU配置
tags:
  - Python
  - Anaconda
  - Jupyter
categories:
  - 经验
index_img: https://zhongshijie1995.github.io/zhongshijie-pic/img/20220329145923.png
description: 安装Anaconda默认将会获得Jupyter的能力，在此基础之上，梳理了一些通常作用在科学计算领域的常用配置功能。
abbrlink: 30004
date: 2022-03-29 13:01:00
---

## 服务配置
1. 运行配置。
  - 生成配置`jupyter_notebook_config.py`文件。
    ```shell
    jupyter notebook --generate-config
    ```
  - 开启一个`ipython`窗口，生成密码哈希值
    ```python
    from notebook.auth import passwd
    passwd()
    ```
  - 访问生成的配置文件，修改配置文件
    ```py
    c.NotebookApp.ip = '0.0.0.0'
    c.NotebookApp.port = 26000
    c.NotebookApp.open_browser = False
    c.NotebookApp.password = '【上一步生成的密码哈希值】'
    c.NotebookApp.notebook_dir = '【希望的启动目录】'
    ```
2. 编写启动脚本`rjupyter`（可添加在环境变量），具有不重复启动、无多余日志功能。
  ```shell
  if test $( netstat -nltp | grep 26000 | wc -l ) -eq 0
  then
  nohup jupyter notebook >/dev/null 2>&1 &
  fi
  ```

## 依赖源
1. 添加镜像源
  ```shell
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge 
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
  conda config --set show_channel_urls yes
  ```
2. （可选）更新依赖
  ```shell
  conda upgrade --all
  ```

## 内核切换
1. 安装包`nb_conda`，重新启动`jupyter`
  ```shell
  conda install nb_conda
  ```
2. 解决根目录重复导致的`jupyter-conda`页报错：修改`【Anaconda3安装目录】/pkgs/【nb_conda-2.2.1-py39hf3d152e_4】/lib/【python3.9】/site-packages/nb_conda/envmanager.py`文件,其中`【】`是可变的需要参考本机目录。
  - 原文:
  ```python
  return {
    "environments": [root_env] + [get_info(env) for env in info['envs']]
  }
  ```
  - 修改后:
  ```python
  return {
    "environments": [root_env] + [get_info(env) for env in info['envs'] if env != root_env['dir']]
  }
  ```
3. 在`LinuxShell`中查看已有虚拟环境.
  ```shell
  conda info -e
  ```
4. 在`LinuxShell`中查看切换虚拟环境.
  ```shell
  conda activate 【要切换的虚拟环境名】
  ```

## Pytroch+GPU
1. 使用`conda`源安装`pytorch`，它将会自动帮助我们匹配安装`cudatoolkit`。
  ```shell
  conda install pytorch
  ```
2. 在`Jupyter`中运行如下代码，进行GPU加速测试：
  ```python
  import torch
  import time

  print('pytorch版本[%s],CUDA是否可用[%s]' % (torch.__version__, torch.cuda.is_available())) # 返回pytorch的版本

  a = torch.randn(10000, 1000)    # 返回10000行1000列的张量矩阵
  b = torch.randn(1000, 2000)     # 返回1000行2000列的张量矩阵

  # 直接CPU计算
  t0 = time.time()
  c = torch.matmul(a, b)
  t1 = time.time()
  print('[%s]运行时间[%s]，运行结果[%s]' % (a.device, t1 - t0, c.norm(2)))

  # 指定GPU计算（数据未压入CUDA，包含初始化）
  device = torch.device('cuda')
  a = a.to(device)
  b = b.to(device)
  t0 = time.time()
  c = torch.matmul(a, b)
  t2 = time.time()
  print('[%s]运行时间[%s](含CUDA初始化），运行结果[%s]' % (a.device, t2 - t0, c.norm(2)))

  # 指定GPU计算（数据已压入CUDA，不含初始化，仅计算时间）
  t0 = time.time()
  c = torch.matmul(a, b)
  t3 = time.time()
  print('[%s]运行时间[%s](不含CUDA初始化），运行结果[%s]' % (a.device, t3 - t0, c.norm(2)))
  ```
