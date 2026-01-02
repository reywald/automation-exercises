*** Settings ***
Documentation       Test suite for user login functionality

Library             Browser
Resource            browsing.resource
Resource            ../api/apis.resource
Resource            reusables.resource

Suite Setup         apis.Setup Session
Suite Teardown      apis.Close Session
Test Setup          reusables.Create User Account


*** Variables ***
${USER_ACCOUNT}     ${EMPTY}


*** Test Cases ***
Login User With Correct Email And Password
    [Documentation]    Test user login with valid email and password
    Login With Browser    ${USER_ACCOUNT['email']}    ${USER_ACCOUNT['password']}
    reusables.Verify User Is Logged In    username=${USER_ACCOUNT['name']}
    reusables.Delete User Account
    browsing.Close Browser Session

Login User With Incorrect Email And Password
    [Documentation]    Test user login with incorrect email and password
    ${email} =    FakerLibrary.Free Email
    ${password} =    FakerLibrary.Password
    Login With Browser    ${email}    ${password}
    reusables.Verify In Login Page
    login_page.Verify Incorrect Credentials Error
    browsing.Close Browser Session
    [Teardown]    apis.Delete User Account    ${USER_ACCOUNT['email']}    ${USER_ACCOUNT['password']}

Logout User
    [Documentation]    Test logging out a valid user
    Login With Browser    ${USER_ACCOUNT['email']}    ${USER_ACCOUNT['password']}
    reusables.Verify User Is Logged In    username=${USER_ACCOUNT['name']}
    homepage.Click Menu Item    Logout
    reusables.Verify In Login Page
    browsing.Close Browser Session
    [Teardown]    apis.Delete User Account    ${USER_ACCOUNT['email']}    ${USER_ACCOUNT['password']}



*** Keywords ***
Login With Browser
    [Documentation]    Steps to login as a user with the browser
    [Arguments]    ${email}    ${password}
    browsing.Open Website
    reusables.Verify Homepage Is Visible
    reusables.Navigate To Login Page
    reusables.Verify In Login Page
    login_page.Fill Login Form    email=${email}    password=${password}
