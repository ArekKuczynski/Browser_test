*** Settings ***

Library    Browser

*** Variables ***
${URL}    https://www.saucedemo.com/
${login_input}    //input[@placeholder="Username"]
${password_input}    //input[@placeholder="Password"]
${login_button}    //input[@id="login-button"]

*** Keywords ***
Open Webpage And Login_standard_user
    Browser.Open Browser    ${URL}
    Browser.Fill Text    ${login_input}    standard_user
    Log    xpath
    Browser.Fill Text    ${password_input}    secret_sauce
    Browser.Click    ${login_button}