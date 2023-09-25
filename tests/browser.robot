*** Settings ***
Documentation    Test strony sucedemo.com

Library    Browser
Library    lib.py

Resource    open_page.resource

*** Variables ***
${item_element}    //a[@id="item_4_title_link"]
${expected_item_element_value}    Sauce Labs Backpack
${shopping_cart}    //a[@class="shopping_cart_link"]
${item_element_price}    //div[@class="inventory_item_price"]
${expected_item_element_price}    $29.99

${checkout_button}    //button[@id="checkout"]
${first_name_input}    //input[@id="first-name"]
${last_name_input}    //input[@id="last-name"]
${postal_code_input}    //input[@id="postal-code"]
${continiue_buy}    //input[@class="submit-button btn btn_primary cart_button btn_action"]
${finish_button}    //button[@class="btn btn_action btn_medium cart_button"]
${tax_item}    //div[@class="summary_tax_label"]
${expected_final_price_item}    //div[@class="summary_info_label summary_total_label"]
${back_home_button}    //button[@id="back-to-products"]

*** Test Cases ***
Login Test
    [Documentation]    Test testujacy logowanie
    [Tags]    login_sucedemo.com
    [Timeout]    3s

    open_page.Open Webpage And Login_standard_user

Add Product
    [Documentation]    Test testujacy dodawanie produktu do koszyka
    [Tags]    add_sucedemo.com
    [Timeout]    3s

    open_page.Open Webpage And Login_standard_user
    Add First Product To Cart
    Click Shopping Cart
    Check Shopping Cart

Buy Product
    [Documentation]    Test testujacy kupowanie produktu
    [Tags]    buy_sucedemo.com
    [Timeout]    3s

    open_page.Open Webpage And Login_standard_user
    Add First Product To Cart
    Click Shopping Cart
    Check Shopping Cart
    Click Checkout
    Input User_Data And Continiue
    Check Tax And Finish Buying

*** Keywords ***
Open Webpage
    Browser.Open Browser    ${URL}

Login Input
    Browser.Fill Text    ${login_input}    standard_user
    Log    xpath

Password Input
    Browser.Fill Text    ${password_input}    secret_sauce

Click Login
    Browser.Click    ${login_button}

Click Element
    Browser.Click    ${item_element}

Add First Product To Cart
    ${text_1} =   Browser.Get Text    ${item_element}
    IF    $text_1 == $expected_item_element_value
        Log    ${text_1}
        Click Element
        ${item_element} =    Set Variable    //button[@id="add-to-cart-sauce-labs-backpack"]
        Browser.Click    ${item_element}
    END

Click Shopping Cart
    Browser.Click    ${shopping_cart}

Check Shopping Cart
    ${item_element} =    Set Variable    //div[@class="inventory_item_name"]
    ${text_1} =   Browser.Get Text    ${item_element}
        IF    $text_1 == $expected_item_element_value
            Log    ${text_1}
            ${price_text} =   Browser.Get Text    ${item_element_price}
            ${price_text_int}    lib.price_to_int    ${price_text}
            IF    $price_text == $expected_item_element_price
                IF    $price_text_int <= 30
                    Log    ${price_text_int}
                END
            END 
        END

Click Checkout
    Browser.Click    ${checkout_button}

Input User_Data And Continiue
    Browser.Fill Text    ${first_name_input}    test_user_name
    Browser.Fill Text    ${last_name_input}    test_user_last
    Browser.Fill Text    ${postal_code_input}    12-345
    Click    ${continiue_buy}

Check Tax And Finish Buying
    ${product_price_int}    lib.price_to_int    ${expected_item_element_price}

    ${tax_text} =    Browser.Get Text    ${tax_item}
    ${tax_int}    lib.price_to_int    ${tax_text}

    ${expected_final_price_text} =    Browser.Get Text    ${expected_final_price_item}
    ${expected_final_price_int}    lib.price_to_int    ${expected_final_price_text}

    IF    $product_price_int + $tax_int == $expected_final_price_int
        Log    Final price correct
    END
    
    Click    ${finish_button}
    Click    ${back_home_button}