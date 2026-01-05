*** Settings ***
Documentation       Page object for subscription form elements and verifications.

Library             Collections
Library             Browser


*** Variables ***
${FOOTER}                   id=footer >> .footer-widget
${SUBSCRIPTION_HEADER}      ${FOOTER} >> h2
${SUBSCRIPTION_EMAIL}       ${FOOTER} >> id=susbscribe_email
${SUBSCRIPTION_BUTTON}      ${FOOTER} >> id=subscribe
${SUBSCRIPTION_MESSAGE}     ${FOOTER} >> id=success-subscribe


*** Keywords ***
Scroll To Bottom Of Page
    [Documentation]    Scroll down till the footer of the home page is reached
    Scroll To Element    ${FOOTER}

Verify Subscription Form Is Visible
    [Documentation]    Verify that the Subscription form and elements are visible
    Get Text    ${SUBSCRIPTION_HEADER}    ==    SUBSCRIPTION
    Get Element States    ${SUBSCRIPTION_EMAIL}    contains    visible
    Get Element States    ${SUBSCRIPTION_BUTTON}    contains    visible

Subscribe To Updates
    [Documentation]    Fill the Subscription form and submit
    [Arguments]    ${email}
    Fill Text    ${SUBSCRIPTION_EMAIL}    ${email}
    Click    ${SUBSCRIPTION_BUTTON}
    Wait For Load State    domcontentloaded

Verify Subscription Is Successful
    [Documentation]    Verify the subscription success message is visible for some seconds
    Get Element States    ${SUBSCRIPTION_MESSAGE}    contains    visible
    Get Classes    ${SUBSCRIPTION_MESSAGE}    validate    "hide" not in value
    Get Text    ${SUBSCRIPTION_MESSAGE}    ==    You have been successfully subscribed!
    Sleep    1.5 seconds
    Get Classes    ${SUBSCRIPTION_MESSAGE}    contains    hide
