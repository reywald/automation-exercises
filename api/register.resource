*** Settings ***
Documentation       Resources and variables for creating a user account.

Library             Collections
Library             RequestsLibrary
Library             FakerLibrary
Resource            generate_data.resource


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
    ${user_details} =    generate_data.Generate Account Details
    ${user_address} =    generate_data.Generate Address Details
    Set To Dictionary    ${user_details}    &{user_address}

    ${response} =    POST On Session    ${SESSION_NAME}    api/createAccount    data=${user_details}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${201}
    Dictionary Should Contain Item    ${response.json()}    message    User created!
    RETURN    ${user_details}

Delete User Account
    [Documentation]    Delete a User account by sending a DELETE request
    [Arguments]    ${email}    ${password}
    VAR    &{data} =    email=${email}    password=${password}

    ${response} =    DELETE On Session    ${SESSION_NAME}    api/deleteAccount    data=${data}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Item    ${response.json()}    message    Account deleted!
