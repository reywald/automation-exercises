*** Settings ***
Documentation       Page object for account deleted page elements and verifications.

Library             Browser


*** Variables ***
${ACCOUNT_DELETED_HEADER}       id=form >> h2
${CONTINUE_BUTTON}              id=form >> a.btn-primary


*** Keywords ***
Verify Account Deleted Page Is Visible
    [Documentation]    Verify that the account deleted page is visible
    Get Url    contains    delete_account
    Get Text    ${ACCOUNT_DELETED_HEADER}    ==    ACCOUNT DELETED!
    ${continue} =    Get Element    ${CONTINUE_BUTTON}
    Get Element States    ${continue}    contains    visible
    Get Text    ${continue}    ==    Continue

Click Continue Button
    [Documentation]    Click the continue button on the account created page
    Click    ${CONTINUE_BUTTON}
    Wait For Load State    domcontentloaded    timeout=10s
