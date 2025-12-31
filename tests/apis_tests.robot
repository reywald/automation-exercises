*** Settings ***
Documentation       Suite of tests for the Automation Exercise endpoints

Library             Collections
Library             RequestsLibrary
Library             FakerLibrary
Resource            generate_data.resource
Resource            ../api/apis.resource

Suite Setup         apis.Setup Session
Suite Teardown      apis.Close Session


*** Variables ***
${USER_ACCOUNT}     ${EMPTY}


*** Test Cases ***
Get All Products List
    [Documentation]    Get the list of all products on the website
    ${response} =    apis.Get All Products
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Key    ${response.json()}    products
    Length Should Be    ${response.json()}[products]    34
    VAR    @{props} =    brand    category    id    name    price
    VAR    ${products} =    ${response.json()}[products]
    Check Response Object Schema    ${products}    ${props}

Get All Brands List
    [Documentation]    Get the list of all brands on the website
    ${response} =    apis.Get All Brands
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Key    ${response.json()}    brands
    Length Should Be    ${response.json()}[brands]    34
    VAR    @{props} =    brand    id
    VAR    ${brands} =    ${response.json()}[brands]
    Check Response Object Schema    ${brands}    ${props}

Search For A Product
    [Documentation]    Get a list of products by providing a search string
    @{search_items} =    Evaluate
    ...    ["top", "shirt", "kids", "sleeves", "girls", "boys", "gown", "sleeveless", "dress"]
    ${item} =    FakerLibrary.Random Element    ${search_items}
    ${response} =    apis.Search Product    ${item}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Key    ${response.json()}    products
    VAR    @{props} =    brand    category    id    name    price
    VAR    ${products} =    ${response.json()}[products]
    Check Response Object Schema    ${products}    ${props}

Search For A Product Without Search Parameter
    [Documentation]    Get a list of products without providing a search string
    ${response} =    apis.Search Product Without Search Word
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${400}
    Dictionary Should Contain Key    ${response.json()}    message
    Should Contain    ${response.json()}[message]    search_product parameter is missing

Create/Register User Account
    [Documentation]    Verify that a user account can be created
    ${user_creds} =    generate_data.Generate Valid User Account

    ${response} =    apis.Create User Account    ${user_creds}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${201}
    Dictionary Should Contain Item    ${response.json()}    message    User created!
    VAR    ${USER_ACCOUNT} =    ${user_creds}    scope=SUITE

Delete User Account
    [Documentation]    Delete a User account by sending a DELETE request
    ${response} =    apis.Delete User Account    email=${USER_ACCOUNT['email']}    password=${USER_ACCOUNT['password']}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Item    ${response.json()}    message    Account deleted!

Verify Login With Valid Credentials
    [Documentation]    Verify that login is successful with valid credentials
    ${user_creds} =    generate_data.Generate Valid User Account
    apis.Create User Account    ${user_creds}

    VAR    &{credentials} =    email=${user_creds['email']}    password=${user_creds['password']}
    ${response} =    apis.Verify Login Credentials    credentials=${credentials}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${200}
    Dictionary Should Contain Item    ${response.json()}    message    User exists!
    VAR    ${USER_ACCOUNT} =    ${user_creds}    scope=SUITE

Verify Login Without Email Credential
    [Documentation]    Verify that the login fails if there is no email
    VAR    &{credentials} =    password=${USER_ACCOUNT['password']}
    ${response} =    apis.Verify Login Credentials    credentials=${credentials}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${400}
    Should Contain    ${response.json()}[message]    email or password parameter is missing

Verify Login With Invalid Credentials
    [Documentation]    Verify that the login fails if there is no email
    ${email} =    FakerLibrary.Email
    VAR    &{credentials} =    email=${email}    password=${USER_ACCOUNT['password']}
    ${response} =    apis.Verify Login Credentials    credentials=${credentials}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.reason}    OK
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${404}
    Dictionary Should Contain Item    ${response.json()}    message    User not found!


*** Keywords ***
Check Response Object Schema
    [Documentation]    Verify that each item's keys matches the expected schema
    [Arguments]    ${items}    ${schema}
    FOR    ${item}    IN    @{items}
        @{keys} =    Get Dictionary Keys    ${item}
        Lists Should Be Equal    ${schema}    ${keys}
    END
