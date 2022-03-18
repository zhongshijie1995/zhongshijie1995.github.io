import requests
import re
import os
import subprocess
import time

BLOG_PATH = os.getcwd()
ABOUT_FILE = r'source/about/index.md'
ABOUT_PATH = os.path.join(BLOG_PATH, ABOUT_FILE)


def show_log(msg, **args):
    with open('lan_update.log', mode='a', encoding='utf-8') as f:
        f.write(msg, **args)
        f.write('\n')


def get_about_ip() -> str:
    s = requests.get('https://zhongshijie1995.github.io/about/')
    return re.search(r'【.*】', s.content.decode()).group()[1: -1].strip()


def get_lan_ip() -> str:
    s = requests.get('https://ifconfig.me')
    return s.content.decode()


def update_about_ip() -> bool:
    ai = get_about_ip()
    li = get_lan_ip()
    show_log('about ip %s' % ai)
    show_log('lan ip %s' % li)
    if ai != li:
        with open(ABOUT_PATH, mode='r', encoding='utf-8') as f:
            content = f.read()
        content = content.replace(ai, li)
        with open(ABOUT_PATH, mode='w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False


def deploy_blog():
    result = [
        subprocess.call('git pull', shell=True),
        subprocess.call('git add .', shell=True),
        subprocess.call('git commit -m "AutoCommit"', shell=True),
        subprocess.call('git push', shell=True),
        subprocess.call('npx hexo clean', shell=True),
        subprocess.call('npx hexo g', shell=True),
        subprocess.call('npx hexo deploy', shell=True),
        subprocess.call('npx hexo clean', shell=True)
    ]
    show_log('Finished update at %s' % time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))


if __name__ == '__main__':
    while True:
        try:
            if update_about_ip():
                deploy_blog()
        except Exception as e:
            show_log("部署失败 %s" % str(e))
        
        show_log('%s 等待1*5小时' % time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
        time.sleep(3600*5)
