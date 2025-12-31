*** Settings ***
Documentation       Test suite for user login functionality

Library             Browser
Resource            ../resources/browsing.resource
Resource            ../resources/reusables.resource
Resource            ../api/register.resource

Suite Setup         Create User For Login
# Suite Teardown    Delete User


*** Variables ***
${USER_DETAILS}     ${EMPTY}


*** Test Cases ***
Login User With Correct Email And Password
    [Documentation]    Test user login with valid email and password
    browsing.Open Website
    reusables.Verify Homepage Is Visible
    reusables.Navigate To Login Page
    reusables.Verify In Login Page
    login_page.Fill Login Form    ${USER_DETAILS['email']}    ${USER_DETAILS['password']}
    reusables.Verify User Is Logged In    username=${USER_DETAILS['name']}
    reusables.Delete User Account
    browsing.Close Browser Session


*** Keywords ***
Create User For Login
    [Documentation]    Create a user to use for testing
    register.Setup Session
    ${details} =    register.Register User Account
    VAR    ${USER_DETAILS} =    ${details}    scope=SUITE

Delete User
    [Documentation]    Delete the created user after testing concludes
    register.Delete User Account    ${USER_DETAILS['email']}    ${USER_DETAILS['password']}
