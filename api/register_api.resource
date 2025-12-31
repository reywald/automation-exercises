*** Settings ***
Documentation       Resources and variables for creating a user account.

Library             Collections
Library             RequestsLibrary
Resource            generate_data.resource
Resource            apis.resource


*** Variables ***
${BASE_URL}         https://automationexercise.com
${SESSION_NAME}     automationapi


*** Keywords ***
Setup Session
    [Documentation]    Create a resuable HTTP session
    Create Session    ${SESSION_NAME}    url=${BASE_URL}    verify=True
    ${exists} =    Session Exists    ${SESSION_NAME}
    Should Be True    ${exists}

Register User Account
    [Documentation]    Create a User Account by sending a POST request to the createAccount endpoint
    ${user_account} =    generate_data.Generate Valid User Account

    ${response} =    apis.Create User Account    ${user_account}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${201}
    Dictionary Should Contain Item    ${response.json()}    message    User created!
    RETURN    ${user_account}

Delete User Account
    [Documentation]    Delete a User account by sending a DELETE request
    [Arguments]    ${email}    ${password}

    ${response} =    apis.Delete User Account    email=${email}    password=${password}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Item    ${response.json()}    message    Account deleted!
