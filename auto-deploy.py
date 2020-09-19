import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.alert import Alert

# Driver path config
driver_path = '/usr/local/bin/MicrosoftWebDriver'

# Gitee user
user_name = '15521002256'
user_pwd = 'zsj19951026'

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
        print('----------',  '更新部署', gitee_page_name, '----------')
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
