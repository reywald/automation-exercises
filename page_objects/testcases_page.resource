*** Settings ***
Documentation       Page object for Test Cases page elements and verifications

Library             OperatingSystem
Library             Browser


*** Variables ***
${TEST_CASE_HEADER}     id=form >> .container >> h2
${TEST_CASES}           h4.panel-title >> text=Test Case


*** Keywords ***
Verify In Test Cases Page
    [Documentation]    Verify that the page is the Test cases page
    Get Url    contains    test_cases
    Get Text    ${TEST_CASE_HEADER}    ==    TEST CASES
    ${test_cases} =    Get Elements    ${TEST_CASES}
    Length Should Be    ${test_cases}    26
