*** Settings ***
Documentation       Page object for homepage elements and verifications.

Library             Collections
Library             Browser


*** Variables ***
${HOMEPAGE_IMAGE}               id=header >> img
${CAROUSEL}                     id=slider-carousel >> .carousel-inner
${NAVIGATION_MENUS}             css=#header .shop-menu li
@{NAVIGATION_MENU_LABELS}       Home    Products    Cart    Signup / Login    Test Cases    API Testing
...                             Video Tutorials    Contact us
${FOOTER}                       id=footer >> .footer-widget
${SUBSCRIPTION_HEADER}          ${FOOTER} >> h2
${SUBSCRIPTION_EMAIL}           ${FOOTER} >> id=susbscribe_email
${SUBSCRIPTION_BUTTON}          ${FOOTER} >> id=subscribe
${SUBSCRIPTION_MESSAGE}         ${FOOTER} >> id=success-subscribe


*** Keywords ***
Homepage Image Is Visible
    [Documentation]    Verify that the homepage image is visible and has the correct alt text
    ${img} =    Get Element    ${HOMEPAGE_IMAGE}
    Get Element States    ${img}    contains    visible
    Get Attribute    ${img}    alt    should be    Website for automation practice

Carousel Is Visible
    [Documentation]    Verify that the homepage carousel is visible and contains the correct text
    ${carousel} =    Get Element    ${CAROUSEL}
    Get Element States    ${carousel}    contains    visible
    Get Text    ${carousel}    contains    AutomationExercise

Navigation Menu Is Visible
    [Documentation]    Verify that the homepage menu is visible
    ${menus} =    Get Elements    ${NAVIGATION_MENUS}
    Length Should Be    ${menus}    8

    # Check for each menu item
    FOR    ${index}    ${menu}    IN ENUMERATE    @{menus}
        Get Element States    ${menu}    contains    visible
        Get Text    ${menu}    contains    ${NAVIGATION_MENU_LABELS}[${index}]
    END

Home Menu Is Active
    [Documentation]    Get the home menu item and verify it's visible and highlighted
    ${menus} =    Get Elements    ${NAVIGATION_MENUS}
    ${home_menu} =    Get From List    ${menus}    0
    Get Element States    ${home_menu}    contains    visible
    Get Text    ${home_menu}    contains    Home
    Get Attribute    ${home_menu} >> a    style    should be    color: orange;

Click Menu Item
    [Documentation]    Click on a specified menu item by its name
    [Arguments]    ${menu_name}
    Click    ${NAVIGATION_MENUS} >> a >> text=${menu_name}
    Wait For Load State    domcontentloaded    timeout=10s

Scroll To Bottom Of Home Page
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

Verify User Is Logged In
    [Documentation]    Verify that the user is logged in
    [Arguments]    ${username}
    ${menus} =    Get Elements    ${NAVIGATION_MENUS}
    Length Should Be    ${menus}    10
    ${logged_in_user} =    Get Element    ${NAVIGATION_MENUS} >> a >> text=Logged in as ${username}
    Get Element States    ${logged_in_user}    contains    visible
    ${logout} =    Get Element    ${NAVIGATION_MENUS} >> a >> text=Logout
    Get Element States    ${logout}    contains    visible
    ${delete_account} =    Get Element    ${NAVIGATION_MENUS} >> a >> text=Delete Account
    Get Element States    ${delete_account}    contains    visible
