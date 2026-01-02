*** Settings ***
Documentation       Page object for API Testing page elements and verifications

Library             OperatingSystem
Library             Browser


*** Variables ***
${APIS_HEADER}      id=form >> .container >> h2
${APIS_LIST}        h4.panel-title >> text=API


*** Keywords ***
Verify In API Testing Page
    [Documentation]    Verify that the page is the API Testing page
    Get Url    contains    api_list
    Get Text    ${APIS_HEADER}    ==    APIS LIST FOR PRACTICE
    ${test_cases} =    Get Elements    ${APIS_LIST}
    Length Should Be    ${test_cases}    14
