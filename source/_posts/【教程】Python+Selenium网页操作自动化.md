---
title: Python+Selenium网页操作自动化
tags:
  - Python
  - Selenium
  - 自动化
categories:
  - 教程
index_img: https://zhongshijie1995.github.io/zhongshijie-pic/img/20200919235000.jpg
description: 用Python+Selenium让一切繁琐的网页操作自动化
abbrlink: 20002
date: 2020-09-19 23:00:00

---

# 1.背景

## 1.1 无人值守的需要

日常工作生活中，有很多令人厌烦的、必须要进行的网页操作，每次都需要我们输入一些信息，进行千篇一律的点按操作，毫无技术含量却还要我们专程进行，我们希望有一个定时任务帮自动我们完成，例如：网页打卡、签到领奖……

![登录操作](https://zhongshijie1995.github.io/zhongshijie-pic/img/20200919204534.png)

## 1.2 频繁无趣的解放

在博客等部署在Gitee Pages中的同学们都知道，将静态资源推送到了Gitee仓库中后是不会自动刷新的，它需要我们手动进入到仓库的GiteePages中点击更新才能将博客的最新内容发布，由于每次更新博客，都需要进行这样的操作，频繁而无趣。

![GiteePage服务的更新页面](https://zhongshijie1995.github.io/zhongshijie-pic/img/20200919204533.png)

## 1.3 用Python来完成它！

接下来，我们来一步一步的学习如何用Python+Selenium让这个过程实现自动化，学有所成的你甚至可以完成更多更难的自动化场景……至于Python和Selenium是什么？这里假设你已经有所了解，或者你可以现在去搜索了解一下。

# 2. 学习自动化

## 2.1 准备驱动

首先，我们需要为自己的浏览器寻找一个驱动，这个驱动需要放在Python运行时能够查找到的位置。

下面，我将以我使用的新版MicroSoft Edge浏览器为例进行讲解：

1. 通过网络渠道找到符合自己电脑中浏览器的 操作系统+品牌+版本 的浏览器驱动，例如我通过MicroSoft Edge官方的[开发者网站](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/)查找并获取浏览器驱动。
2. 将驱动放置在Python运行时能够查找到的位置，案例中我放在了`/usr/local/bin`目录下。

## 2.2 掌握Selenium的基本用法

Selenium的使用通常包括3个步骤：

1. 获得浏览器控制器

   ```python
   from selenium import webdriver
   from selenium.webdriver.chrome.service import Service
   
   service = Service('/usr/local/bin/MicrosoftWebDriver')
   service.start()
   dr = webdriver.Remote(service.service_url)
   ```

   上述代码（仅适用于新版MicroSoft Edge浏览器）通过指定驱动获取到了浏览器控制器。如果你使用的是其他浏览器，不用担心，因为只会更简单，例如火狐浏览器：

   ```python
   import selenium import webdriver
   
   dr = webdriver.Firefox()
   ```

   不同浏览器的代码可以通过Seleunium的文档得到。

2. 操作浏览器访问某个网址

   ```python
   dr.get('https://baidu.com')
   ```

   上述代码将使得被启动的浏览器访问指定的网址，就是那么简单。

3. 对浏览器的元素进行操作

   ```python
   a = dr.find_element_by_xpath('//*[@id="user_login"]')
   a.click()
a.send_keys('zhongshijie')
   ```
   
   上述代码在当前网页中，通过XPath查找到一个元素，进行了一次点击，并传入了值，同样是那么简单。
   

如果你备好[Selenium文档](https://python-selenium-zh.readthedocs.io/zh_CN/latest/)并随时查看，你会发现它能够如此优雅简单的指定你能想到的一切对浏览器的操作，运行代码，它将自动按照你的指示操作浏览器。

# 3. 示例代码

最后，提供一份第1节中提到的自动更新部署在GiteePages的博客的完整代码，执行这段代码，它将会自动帮我完成已经推送到仓库的博客内容的更新，希望达到抛砖引玉的效果。

```python
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.alert import Alert

# Driver path config
driver_path = '/usr/local/bin/MicrosoftWebDriver'

# Gitee user
user_name = 'Gitee用户名'
user_pwd = 'Gitee用户密码'

# Gitee pages urls
gitee_page_urls = {
    'zhongshijie': 'https://gitee.com/zhongshijie/zhongshijie/pages',
    'mirrors-pic': 'https://gitee.com/zhongshijie/mirrors-pic/pages'
}


def login_gitee(_us: str, _pwd: str):
    print('----------', '开始登录gitee', '----------')
    dr.get('https://gitee.com/login')
    dr.implicitly_wait(10)
    user_name_field = dr.find_element_by_xpath('//*[@id="user_login"]')
    user_pwd_field = dr.find_element_by_xpath('//*[@id="user_password"]')
    user_login_btn = dr.find_element_by_xpath('//*[@id="new_user"]/div[2]/div/div/div[4]/input')
    user_name_field.send_keys(_us)
    user_pwd_field.send_keys(_pwd)
    user_login_btn.click()
    dr.implicitly_wait(10)
    dr.find_element_by_xpath('//*[@id="rc-users__container"]/div[1]/div[2]/div/div[1]/div[1]/div[1]/div[1]/strong/a')


def deploy_all():
    for gitee_page_name, gitee_page_url in gitee_page_urls.items():
        print('----------',  '更新部署'， gitee_page_name, '----------')
        dr.get(gitee_page_url)
        dr.implicitly_wait(10)
        deploy_update = dr.find_element_by_xpath('//*[@id="pages-branch"]/div[7]')
        deploy_update.click()
        Alert(dr).accept()
        time.sleep(3)


if __name__ == '__main__':
    
    # Get browser by driver path
    service = Service(driver_path)
    service.start()
    dr = webdriver.Remote(service.service_url)

    # Deploy
    try:
        login_gitee(user_name, user_pwd)
        deploy_all()
    except Exception as e:
        print('Login Failed', e)

    # Quit browser
    dr.quit()

```

