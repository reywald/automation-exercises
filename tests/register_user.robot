*** Settings ***
Documentation       Test case for registering a new user

Library             Collections
Library             Browser
Library             FakerLibrary
Resource            ../resources/browsing.resource
Resource            ../resources/generate_data.resource
Resource            ../page_objects/homepage.resource
Resource            ../page_objects/login_page.resource
Resource            ../page_objects/signup_page.resource
Resource            ../page_objects/account_created_page.resource
Resource            ../page_objects/account_deleted_page.resource

Test Setup          browsing.Open Website
Test Teardown       browsing.Close Browser Session


*** Test Cases ***
Register New User
    [Documentation]    Test the user registration functionality
    Verify Homepage Is Visible
    Navigate To Login Page
    ${ACCOUNT_DETAILS} =    generate_data.Generate Account Details
    Register New User    ${ACCOUNT_DETAILS}
    Verify In Signup Page
    Fill Account Details    ${ACCOUNT_DETAILS}
    ${ADDRESS_DETAILS} =    generate_data.Generate Address Details
    Fill Address Details    ${ADDRESS_DETAILS}
    Verify Account Created Page Is Visible
    Verify User Is Logged In    ${ACCOUNT_DETAILS['name']}
    Delete User Account


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

Register New User
    [Documentation]    Register a new user with name and email
    [Arguments]    ${ACCOUNT_DETAILS: dict}
    login_page.Fill Signup Form    ${ACCOUNT_DETAILS['name']}    ${ACCOUNT_DETAILS['email']}

Verify In Signup Page
    [Documentation]    Verify that the page is the Signup page
    signup_page.Verify In Signup Page

Fill Account Details
    [Documentation]    Fill the Account Information form with details
    [Arguments]    ${ACCOUNT_DETAILS: dict}
    signup_page.Fill Account Information Form    ${ACCOUNT_DETAILS}

Fill Address Details
    [Documentation]    Fill the Address Information form with details
    [Arguments]    ${ADDRESS_DETAILS: dict}
    signup_page.Fill Address Information Form    ${ADDRESS_DETAILS}

Verify Account Created Page Is Visible
    [Documentation]    Verify that the account created page is visible and continue
    account_created_page.Verify Account Created Page Is Visible
    account_created_page.Click Continue Button

Verify User Is Logged In
    [Documentation]    Verify that the user is logged in
    [Arguments]    ${username}
    homepage.Verify User Is Logged In    ${username}

Delete User Account
    [Documentation]    Delete the logged in user account
    homepage.Click Menu Item    Delete Account
    account_deleted_page.Verify Account Deleted Page Is Visible
    account_deleted_page.Click Continue Button
    homepage.Navigation Menu Is Visible
