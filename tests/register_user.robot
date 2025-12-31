*** Settings ***
Documentation       Test case for registering a new user

Library             Collections
Library             Browser
Library             FakerLibrary
Resource            ../resources/generate_data.resource
Resource            ../resources/reusables.resource

Suite Setup         Create User For Login
Test Setup          browsing.Open Website
Test Teardown       browsing.Close Browser Session


*** Variables ***
${USER_ACCOUNT}     ${EMPTY}


*** Test Cases ***
Register New User
    [Documentation]    Test the user registration functionality
    reusables.Verify Homepage Is Visible
    reusables.Navigate To Login Page
    Register New User
    reusables.Verify In Signup Page
    Fill Account Details
    Fill Address Details
    reusables.Verify Account Created Page Is Visible
    reusables.Verify User Is Logged In    ${USER_ACCOUNT['name']}
    reusables.Delete User Account


*** Keywords ***
Register New User
    [Documentation]    Register a new user with name and email
    login_page.Fill Signup Form    ${USER_ACCOUNT['name']}    ${USER_ACCOUNT['email']}

Fill Account Details
    [Documentation]    Fill the Account Information form with details
    signup_page.Fill Account Information Form    ${USER_ACCOUNT}

Fill Address Details
    [Documentation]    Fill the Address Information form with details
    signup_page.Fill Address Information Form    ${USER_ACCOUNT}

Create User For Login
    [Documentation]    Create a user to use for testing
    ${user_details} =    generate_data.Generate Valid User Account
    VAR    ${USER_ACCOUNT} =    ${user_details}    scope=SUITE
