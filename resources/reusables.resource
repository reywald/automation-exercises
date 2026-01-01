*** Settings ***
Documentation       Resource file for reusable keywords across multiple test suites.

Library             Browser
Resource            ../resources/browsing.resource
Resource            ../resources/generate_data.resource
Resource            ../api/apis.resource
Resource            ../page_objects/homepage.resource
Resource            ../page_objects/login_page.resource
Resource            ../page_objects/signup_page.resource
Resource            ../page_objects/account_created_page.resource
Resource            ../page_objects/account_deleted_page.resource


*** Keywords ***
Verify Homepage Is Visible
    [Documentation]    Check that the user is on the home page.
    Get Url    should be    ${BASE_URL}
    homepage.Homepage Image Is Visible
    homepage.Navigation Menu Is Visible
    homepage.Home Menu Is Active
    homepage.Carousel Is Visible

Navigate To Login Page
    [Documentation]    Navigate to the signup / login page
    homepage.Click Menu Item    Signup / Login
    login_page.Verify In Login Page

Verify In Login Page
    [Documentation]    Verify that the page is the Signup / Login page
    login_page.Verify In Login Page
    login_page.Verify Login Form Is Visible

Verify In Signup Page
    [Documentation]    Verify that the page is the Signup page
    signup_page.Verify In Signup Page

Verify Account Created Page Is Visible
    [Documentation]    Verify that the account created page is visible and continue
    account_created_page.Verify Account Created Page Is Visible
    account_created_page.Click Continue Button

Verify User Is Logged In
    [Documentation]    Verify that the user is logged in
    [Arguments]    ${username}
    homepage.Verify User Is Logged In    ${username}

Create User For Login
    [Documentation]    Generate and store a user account for login tests
    ${user_details} =    generate_data.Generate Valid User Account
    VAR    ${USER_ACCOUNT} =    ${user_details}    scope=SUITE

Create User Account
    [Documentation]    Generate and register a user account for testing using the API
    ${user_details} =    generate_data.Generate Valid User Account
    ${response} =    apis.Create User Account    user_account=${user_details}
    Dictionary Should Contain Item    ${response.json()}    responseCode    ${201}
    Dictionary Should Contain Item    ${response.json()}    message    User created!
    VAR    ${USER_ACCOUNT} =    ${user_details}    scope=SUITE

Delete User Account
    [Documentation]    Delete the logged in user account via the UI
    homepage.Click Menu Item    Delete Account
    account_deleted_page.Verify Account Deleted Page Is Visible
    account_deleted_page.Click Continue Button
    homepage.Navigation Menu Is Visible
