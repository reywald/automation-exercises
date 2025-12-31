*** Settings ***
Documentation       All API Endpoints for testing purposes

Library             Collections
Library             RequestsLibrary


*** Variables ***
${BASE_URL}         https://automationexercise.com
${SESSION_NAME}     automationapi


*** Keywords ***
Setup Session
    [Documentation]    Create a resuable HTTP session
    Create Session    ${SESSION_NAME}    url=${BASE_URL}    verify=True
    ${exists} =    Session Exists    ${SESSION_NAME}
    Should Be True    ${exists}

Close Session
    [Documentation]    Close the HTTP session
    ${exists} =    Session Exists    ${SESSION_NAME}
    IF    '${exists}' == '${True}'    Delete All Sessions

Create User Account
    [Documentation]    Create a User Account by sending a POST request to the api/createAccount endpoint
    [Arguments]    ${user_account}

    ${response} =    POST On Session
    ...    ${SESSION_NAME}
    ...    api/createAccount
    ...    data=${user_account}
    ...    expected_status=anything
    RETURN    ${response}

Delete User Account
    [Documentation]    Delete a User account by sending a DELETE request to the api/deleteAccount endpoint
    [Arguments]    ${email}    ${password}
    VAR    &{data} =    email=${email}    password=${password}

    ${response} =    DELETE On Session
    ...    ${SESSION_NAME}
    ...    api/deleteAccount
    ...    data=${data}
    ...    expected_status=anything
    RETURN    ${response}

Verify Login Credentials
    [Documentation]    Validate a user account by sending a POST request to the api/verifyLogin endpoint
    [Arguments]    ${credentials}

    ${response} =    POST On Session
    ...    ${SESSION_NAME}
    ...    api/verifyLogin
    ...    data=${credentials}
    ...    expected_status=anything
    RETURN    ${response}

Update User Account
    [Documentation]    Update a user account by sending a PUT request to the api/updateAccount endpoint
    [Arguments]    ${user_account}

    ${response} =    PUT On Session
    ...    ${SESSION_NAME}
    ...    api/verifyLogin
    ...    data=${user_account}
    ...    expected_status=anything
    RETURN    ${response}

Get User Account Details
    [Documentation]    Fetch a User account by sending a GET request to the api/getUserDetailByEmail endpoint
    [Arguments]    ${email}

    ${response} =    GET On Session
    ...    ${SESSION_NAME}
    ...    api/getUserDetailByEmail
    ...    data=email=${email}
    ...    expected_status=anything
    RETURN    ${response}

Get All Products
    [Documentation]    GET the list of products by calling the api/productsList endpoint
    ${response} =    GET On Session    ${SESSION_NAME}    api/productsList    expected_status=anything
    RETURN    ${response}

Get All Brands
    [Documentation]    GET the list of brands by calling the api/brandsList endpoint
    ${response} =    GET On Session    ${SESSION_NAME}    api/brandsList    expected_status=anything
    RETURN    ${response}

Search Product
    [Documentation]    Search a product by sending a POST request to the api/searchProduct endpoint
    [Arguments]    ${product}
    VAR    &{data} =    search_product=${product}
    ${response} =    POST On Session
    ...    ${SESSION_NAME}
    ...    api/searchProduct
    ...    data=${data}
    ...    expected_status=anything
    RETURN    ${response}

Search Product Without Search Word
    [Documentation]    Search a product without a search word by sending a POST request to the api/searchProduct endpoint
    ${response} =    POST On Session
    ...    ${SESSION_NAME}
    ...    api/searchProduct
    ...    expected_status=anything
    RETURN    ${response}
