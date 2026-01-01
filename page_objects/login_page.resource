*** Settings ***
Documentation       Page object for signup / login page elements and verifications.

Library             Browser


*** Variables ***
${LOGIN_FORM}               id=form >> css=.login-form
${LOGIN_HEADER}             ${LOGIN_FORM} >> h2
${LOGIN_EMAIL_FIELD}        ${LOGIN_FORM} >> input[name=email]
${LOGIN_PASSWORD_FIELD}     ${LOGIN_FORM} >> input[name=password]
${LOGIN_BUTTON}             ${LOGIN_FORM} >> button
${SIGNUP_FORM}              id=form >> css=.signup-form
${SIGNUP_HEADER}            ${SIGNUP_FORM} >> h2
${SIGNUP_NAME_FIELD}        ${SIGNUP_FORM} >> input[name=name]
${SIGNUP_EMAIL_FIELD}       ${SIGNUP_FORM} >> input[name=email]
${SIGNUP_BUTTON}            ${SIGNUP_FORM} >> button


*** Keywords ***
Verify In Login Page
    [Documentation]    Verify that the page is the Signup / Login page
    Get Url    contains    login
    Get Text    ${SIGNUP_HEADER}    ==    New User Signup!
    Verify Signup Form Is Visible
    Get Text    ${LOGIN_HEADER}    ==    Login to your account
    Verify Login Form Is Visible

Verify Signup Form Is Visible
    [Documentation]    Verify that the signup form controls are visible
    ${name} =    Get Element    ${SIGNUP_NAME_FIELD}
    Get Element States    ${name}    contains    visible
    Get Property    ${name}    placeholder    ==    Name

    ${email} =    Get Element    ${SIGNUP_EMAIL_FIELD}
    Get Element States    ${email}    contains    visible
    Get Property    ${email}    placeholder    ==    Email Address

    ${signup} =    Get Element    ${SIGNUP_BUTTON}
    Get Element States    ${signup}    contains    visible
    Get Property    ${signup}    innerText    ==    Signup

Verify Login Form Is Visible
    [Documentation]    Verify that the login form controls are visible
    ${name} =    Get Element    ${LOGIN_EMAIL_FIELD}
    Get Element States    ${name}    contains    visible
    Get Property    ${name}    placeholder    ==    Email Address

    ${email} =    Get Element    ${LOGIN_PASSWORD_FIELD}
    Get Element States    ${email}    contains    visible
    Get Property    ${email}    placeholder    ==    Password

    ${login} =    Get Element    ${LOGIN_BUTTON}
    Get Element States    ${login}    contains    visible
    Get Property    ${login}    innerText    ==    Login

Fill Signup Form
    [Documentation]    Fill in the signup form with provided name and email
    [Arguments]    ${name}    ${email}
    Fill Text    ${SIGNUP_NAME_FIELD}    ${name}
    Fill Text    ${SIGNUP_EMAIL_FIELD}    ${email}
    Click    ${SIGNUP_BUTTON}
    Wait For Load State    domcontentloaded    timeout=10s

Fill Login Form
    [Documentation]    Fill in the login form with provided email and password
    [Arguments]    ${email}    ${password}
    Fill Text    ${LOGIN_EMAIL_FIELD}    ${email}
    Fill Text    ${LOGIN_PASSWORD_FIELD}    ${password}
    Click    ${LOGIN_BUTTON}
    Wait For Load State    domcontentloaded    timeout=10s

Verify Incorrect Credentials Error
    [Documentation]    Check for the message Your email or password is incorrect!
    ${error_message} =    Get Element    ${LOGIN_FORM} >> p[style='color: red;']
    Get Element States    ${error_message}    contains    visible
    Get Text    ${error_message}    ==    Your email or password is incorrect!

Verify Existing Email Error
    [Documentation]    Check for the message Email Address aleady exist!
    ${error_message} =    Get Element    ${SIGNUP_FORM} >> p[style='color: red;']
    Get Element States    ${error_message}    contains    visible
    Get Text    ${error_message}    ==    Email Address already exist!
