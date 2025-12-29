*** Settings ***
Documentation       Page object for account created page elements and verifications.

Library             Browser


*** Variables ***
${ACCOUNT_CREATED_HEADER}       id=form >> h2
${CONTINUE_BUTTON}              id=form >> a.btn-primary


*** Keywords ***
Verify Account Created Page Is Visible
    [Documentation]    Verify that the account created page is visible
    Get Url    contains    account_created
    Get Text    ${ACCOUNT_CREATED_HEADER}    ==    ACCOUNT CREATED!
    ${continue} =    Get Element    ${CONTINUE_BUTTON}
    Get Element States    ${continue}    contains    visible
    Get Text    ${continue}    ==    Continue

Click Continue Button
    [Documentation]    Click the continue button on the account created page
    Click    ${CONTINUE_BUTTON}
    Wait For Load State    domcontentloaded    timeout=10s
