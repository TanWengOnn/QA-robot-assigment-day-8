*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/keywords-login.robot

*** Variables ***

${token_name}    token_1
${token_name_2}    token_2
${token_name_3}    token_3


${enabled_create_button}    //span[text()='Create']
${disabled_create_button}    //button[@disabled]/span[text()='Create']
${token_name_field}     //input[@name='token_name']
${api_token_card}    //span[@class='dc-text' and contains(., '${token_name}')]
${api_token_card_2}    //span[@class='dc-text' and contains(., '${token_name_2}')]
${api_token_card_3}    //span[@class='dc-text' and contains(., '${token_name_3}')]



${checkbox_read}    //label[@class='dc-checkbox' and contains(.,'Read')]
${checkbox_payments}    //label[@class='dc-checkbox' and contains(.,'Payments')]
${checkbox_admin}    //label[@class='dc-checkbox' and contains(.,'Admin')]
${checkbox_trade}    //label[@class='dc-checkbox' and contains(.,'Trade')]
${checkbox_trading_information}    //label[@class='dc-checkbox' and contains(.,'Trading information')]

*** Keywords ***
Clear All Fields
    Wait Until Page Contains Element    //input[@name='read']    30 

    ${read_checkbox_status}=    Get Element Attribute    ${checkbox_read}/input    value
    ${payments_checkbox_status}=    Get Element Attribute    ${checkbox_payments}/input    value
    ${admin_checkbox_status}=    Get Element Attribute    ${checkbox_admin}/input    value
    ${trade_checkbox_status}=    Get Element Attribute    ${checkbox_trade}/input    value
    ${trade_info_checkbox_status}=    Get Element Attribute    ${checkbox_trading_information}/input    value

    IF  ${read_checkbox_status == 'true'}
        Click Element    ${checkbox_read} 
    END

    IF  ${payments_checkbox_status == 'true'}
        Click Element    ${checkbox_payments}
    END

    IF  ${admin_checkbox_status == 'true'}
        Click Element    ${checkbox_admin}
    END
    
    IF  ${trade_checkbox_status == 'true'}
        Click Element    ${checkbox_trade}
    END

    IF  ${trade_info_checkbox_status == 'true'}
        Click Element    ${checkbox_trading_information}
    END

    Press Keys    ${token_name_field}     CTRL+a+DELETE

Open Delele Prompt
    Click Element    ${api_token_card}//ancestor::tr//*[@data-testid="dt_token_delete_icon"]
    Wait Until Page Contains Element    //div[@class='dc-modal']    30
    Page Should Contain Element    //div[@class='dc-modal']

Enable Token Visibility
    [Arguments]    ${token_card}
    Click Element   ${token_card}//ancestor::tr//*[name()='svg' and @class='dc-icon da-api-token__visibility-icon']
    Page Should Not Contain Element    ${token_card}//ancestor::tr//*[@class='da-api-token__pass-dot-container']

Delete All API Token
    ${api_token_count}=    Get Element Count    //*[name()='svg' and @data-testid='dt_token_delete_icon']
    
    IF  ${api_token_count} != 0
        FOR  ${api_token}    IN RANGE     ${api_token_count}
            Click Element    //*[name()='svg' and @data-testid='dt_token_delete_icon']
            Page Should Contain Element    //div[@class='dc-modal']
            Wait Until Page Contains Element    //div[@class='dc-modal']    30
            Click Element    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button']
            Sleep    3
        END
    END
    
*** Test Cases ***
Login To Deriv
    Login To Deriv API Token Setting Key

Validate Real Account 
    Validate Real Account Key

Navigate To Virtual Account
    Navigate To Virtual Account Key

All Fields are empty
    Clear All Fields
    Page Should Contain Element    ${disabled_create_button}

Delete All Api Token
    Delete All API Token

One Checkbox with no token name
    Clear All Fields
    Click Element   ${checkbox_read}
    Page Should Contain Element    ${disabled_create_button}

Multiple Checkbox with no token name
    Clear All Fields
    Click Element    ${checkbox_read}
    Click Element    ${checkbox_admin}
    Page Should Contain Element    ${disabled_create_button}
    
With Valid Token Name But No Checkbox
    Clear All Fields
    Input Text    ${token_name_field}     ${token_name} 
    Page Should Contain Element    ${disabled_create_button}

One Checkbox With Valid Token Name
    Clear All Fields
    Click Element   ${checkbox_read}
    Input Text    ${token_name_field}     ${token_name}
    Wait Until Page Does Not Contain Element    ${disabled_create_button}    30   
    Click Element    ${enabled_create_button}//parent::button
    Wait Until Page Contains Element    //table[@class='da-api-token__table']//tr[contains(.,'${token_name}')]
    Page Should Contain Element    ${api_token_card}
    Page Should Contain Element    ${api_token_card}//following::div/div[@class='da-api-token__table-scope-cell' and contains(.,'Read')]


Multiple Checkbox with valid token name
    Clear All Fields
    Click Element   ${checkbox_read}
    Click Element   ${checkbox_payments}
    Click Element   ${checkbox_admin}
    Input Text    ${token_name_field}     ${token_name_2}
    Wait Until Page Does Not Contain Element    ${disabled_create_button}    30   
    Click Element    ${enabled_create_button}//parent::button
    Wait Until Page Contains Element    //table[@class='da-api-token__table']//tr[contains(.,'${token_name_2}')]
    Page Should Contain Element    ${api_token_card_2}//following::div/div[@class='da-api-token__table-scope-cell']
    Page Should Contain Element    ${api_token_card_2}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Read')]
    Page Should Contain Element    ${api_token_card_2}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Payments')]
    Page Should Contain Element    ${api_token_card_2}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Admin')]

All Checkbox with valid token name
    Clear All Fields
    Click Element   ${checkbox_read}
    Click Element   ${checkbox_payments}
    Click Element   ${checkbox_admin}
    Click Element   ${checkbox_trade}
    Click Element   ${checkbox_trading_information}
    Input Text    ${token_name_field}     ${token_name_3}
    Wait Until Page Does Not Contain Element    ${disabled_create_button}    30   
    Click Element    ${enabled_create_button}//parent::button
    Wait Until Page Contains Element    //table[@class='da-api-token__table']//tr[contains(.,'${token_name_3}')]
    Page Should Contain Element    ${api_token_card_3}//following::div/div[@class='da-api-token__table-scope-cell']
    Page Should Contain Element    ${api_token_card_3}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Read')]
    Page Should Contain Element    ${api_token_card_3}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Payments')]
    Page Should Contain Element    ${api_token_card_3}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Admin')]
    Page Should Contain Element    ${api_token_card_3}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Trade')]
    Page Should Contain Element    ${api_token_card_3}//following::div/div[contains(@class,'da-api-token__table-scope-cell') and contains(.,'Trading information')]

Checkbox with invalid token name (minimum)
    Clear All Fields
    Press Keys    ${token_name_field}     a
    Page Should Contain Element    //div[@class='dc-field dc-field--error']

Checkbox with invalid token name (Maximum)
    Clear All Fields
    Press Keys    ${token_name_field}     aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    Page Should Contain Element    //div[@class='dc-field dc-field--error']

Checkbox with valid token name (minimum)
    Clear All Fields
    Click Element   ${checkbox_read}
    Press Keys    ${token_name_field}     aa
    Page Should Not Contain Element    disabled_create_button

Checkbox with valid token name (Maximum)
    Press Keys    ${token_name_field}     aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    Page Should Not Contain Element    disabled_create_button

Default Token visibility  
    Page Should Contain Element    //tr[1]/td[2]/div/div[1][@class='da-api-token__pass-dot-container']

Enable Token Visibility
    Enable Token Visibility    ${api_token_card}

Disable Token Visibility
    Click Element    ${api_token_card}//ancestor::tr//*[name()='svg' and @class='dc-icon da-api-token__visibility-icon']
    Page Should Contain Element    ${api_token_card}//ancestor::tr//*[@class='da-api-token__pass-dot-container']

Copy Token
    Clear All Fields
    Scroll Element Into View    ${api_token_card}//ancestor::tr//*[@data-testid="dt_copy_token_icon"]    
    Click Element     ${api_token_card}//ancestor::tr//*[@data-testid="dt_copy_token_icon"]
    Press Keys    ${token_name_field}    CTRL+a    CTRL+v
    ${copied_token}=    Get Element Attribute    ${token_name_field}    value
    Enable Token Visibility    ${api_token_card}
    ${actual_token}=    Get Text    ${api_token_card}//ancestor::tr//p[@class='dc-text']
    Should Be Equal As Strings    ${copied_token}    ${actual_token}

Copy Token Admin
    Clear All Fields
    Scroll Element Into View    ${api_token_card_2}//ancestor::tr//*[@data-testid="dt_copy_token_icon"]    
    Click Element     ${api_token_card_2}//ancestor::tr//*[@data-testid="dt_copy_token_icon"]
    Wait Until Page Contains Element    //div[@class='dc-modal']    30
    Page Should Contain Element    //div[@class='dc-modal']
    Click Element    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button']
    Press Keys    ${token_name_field}    CTRL+a    CTRL+v
    ${copied_token}=    Get Element Attribute    ${token_name_field}    value
    Enable Token Visibility    ${api_token_card_2}
    ${actual_token}=    Get Text    ${api_token_card_2}//ancestor::tr//p[@class='dc-text']
    Should Be Equal As Strings    ${copied_token}    ${actual_token}

Delete API Token Prompt
    Open Delele Prompt

Delete API Token (Cancel)
    Click Element    //button[@class='dc-btn dc-btn__effect dc-btn--secondary dc-btn__large dc-dialog__button']
    Wait Until Page Contains Element    ${api_token_card}    30
    Page Should Contain Element    ${api_token_card}

Delete API Token 
    Open Delele Prompt
    Click Element    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button']
    Wait Until Page Does Not Contain Element    ${api_token_card}    30
    Page Should Not Contain Element    ${api_token_card}

    

    
    
    