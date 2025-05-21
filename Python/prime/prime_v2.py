from selene import browser, be, have
import time
#import pytest
#import selenium
#import selene

login = input("Введитие логин  "); Psword = input("Введитие пароль   "); Updates_Keys = input("Введите подстроку или полное имя для поиска пользователя. Например: Полное имя = PIS_1_MIG 8929 или pis  ")
browser.config.timeout = 10
browser.open('https://smp2.bestsafety.tech:2443/auth/authentication/password?flow=password&returnUrl=%2Fauth%2Fauthority%2Fflow%2Fpassword%3FreturnUrl%3D%252Fauth%252Fconnect%252Fauthorize%252Fcallback%253Fresponse_type%253Dcode%2526client_id%253Dsmp-webapp%2526state%253DS2thdm1wMXYtUUo5WS1ENEh6M0szZXNyX3htSTZWZ3lyalZ4cFlUd1J1MzFE%2526redirect_uri%253Dhttps%25253A%25252F%25252Fsmp2.bestsafety.tech%25253A2443%2526scope%253Dsmp-org-api%252520smp-department-api%252520smp-user-api%252520smp-device-api%252520smp-asset-state-api%252520smp-access-api%252520smp-authorization-api%252520smp-module-view-api%252520smp-module-management-api%252520smp-authentication-provider-api%252520smp-ad-import-settings%252520smp-graphql-api%252520smp-user-account-api%252520smp-reporting-api%252520smp-billing-api%252520smp-activity-log-api%252520smp-license-api%252520smp-endpoints-api%252520smp-messaging-api%252520smp-backup-api%252520smp-address-book-api%252520openid%252520profile%2526code_challenge%253DC8cZocHRIvz4X4Jtvb-LgpYPsvL6DjdV_XKGjIVspR0%2526code_challenge_method%253DS256%2526nonce%253DS2thdm1wMXYtUUo5WS1ENEh6M0szZXNyX3htSTZWZ3lyalZ4cFlUd1J1MzFE%2526ui_locales%253Dru-RU%252520en-US%252520de-DE')
browser.element('[name="UserName"]').should(be.blank).type(login)
browser.element('[name="Password"]').should(be.blank).type(Psword)
browser.element('[id="login-button"]').press_enter()
browser.element('/html/body/app-root/div/infotecs-modules-section/div[1]/infotecs-navigation-panel/div[3]/div[1]/infotecs-navigation-button/a').click()
browser.element('/html/body/app-root/div/infotecs-modules-section/div[3]/infotecs-module-page-layout/div/itcs-toolbar/mat-toolbar/mat-toolbar-row/div[1]/infotecs-toolbar-tree-dropdown[1]/itcs-dropdown/div/button').click()
browser.element('//*[@id="mat-menu-panel-4"]/div/div/div/itcs-dropdown-item[5]').click()
time.sleep(2)

# Ожидание и переключение на iframe
module_frame = browser.element('iframe.module-frame')
browser.driver.switch_to.frame(module_frame.locate())

# Взаимодействие с элементомcd
browser.element('div.navigation-panel > itcs-nav-item:nth-child(18)').should(be.clickable).click() # ура 
browser.element('input[placeholder="Search"]').should(be.clickable).type(Updates_Keys).press_enter() # ура 
time.sleep(3)
browser.element('div.check').should(be.clickable).click()
#ime.sleep(3)
browser.element('button[e2e="SendDictionariesAndKeys"]').should(be.clickable).click()
time.sleep(3)

print ("Обновления отправлены")
