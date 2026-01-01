*** Settings ***
Documentation       Test case for registering a new user

Library             Collections
Library             Browser
Library             FakerLibrary
Resource            ../resources/generate_data.resource
Resource            ../resources/reusables.resource

Suite Setup         reusables.Create User For Login
Test Setup          browsing.Open Website
Test Teardown       browsing.Close Browser Session


*** Variables ***
${USER_ACCOUNT}     ${EMPTY}


*** Test Cases ***
Register New User
    [Documentation]    Test the user registration functionality
    reusables.Verify Homepage Is Visible
    reusables.Navigate To Login Page
    login_page.Fill Signup Form    ${USER_ACCOUNT['name']}    ${USER_ACCOUNT['email']}
    reusables.Verify In Signup Page
    signup_page.Fill Account Information Form    ${USER_ACCOUNT}
    signup_page.Fill Address Information Form    ${USER_ACCOUNT}
    reusables.Verify Account Created Page Is Visible
    reusables.Verify User Is Logged In    ${USER_ACCOUNT['name']}
    reusables.Delete User Account

Register User With Existing Email
    [Documentation]    Test when a new user is being registered with an existing email address
    reusables.Verify Homepage Is Visible
    reusables.Navigate To Login Page
    login_page.Fill Signup Form    ${USER_ACCOUNT['name']}    john.doe@example.com
    login_page.Verify Existing Email Error
