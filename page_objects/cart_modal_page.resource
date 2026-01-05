*** Settings ***
Documentation       Page object for Cart Modal elements and verifications

Library             Browser


*** Variables ***
${CART_MODAL}                       id=cartModal
${CART_HEADER}                      ${CART_MODAL} >> h4
${CART_VIEW_CART_LINK}              ${CART_MODAL} >> .modal-body >> a[href="/view_cart"]
${CART_CONTINUE_SHOPPING_BUTTON}    ${CART_MODAL} >> .modal-footer >> button.close-modal


*** Keywords ***
Verify Cart Modal Is Displayed
    [Documentation]    Verify that the modal header, View Cart link and Continue Shopping is displayed
    Get Classes    ${CART_MODAL}    contains    show
    Get Element States    ${CART_HEADER}    contains    visible
    Get Text    ${CART_HEADER}    ==    Added!
    Get Element States    ${CART_VIEW_CART_LINK}    contains    visible
    Get Text    ${CART_VIEW_CART_LINK}    ==    View Cart
    Get Element States    ${CART_CONTINUE_SHOPPING_BUTTON}    contains    visible
    Get Text    ${CART_CONTINUE_SHOPPING_BUTTON}    ==    Continue Shopping

Verify Cart Modal Is Not Displayed
    [Documentation]    Verify that the cart modal is displayed
    # Get Element States    ${CART_MODAL}    not contains    visible
    Get Classes    ${CART_MODAL}    contains    fade

Continue Shopping
    [Documentation]    Click the Continue Shopping button of the Added dialog
    Click    ${CART_CONTINUE_SHOPPING_BUTTON}

View Cart Page
    [Documentation]    Click the View Cart button to load the Cart page
    Click    ${CART_VIEW_CART_LINK}
    Wait For Load State    domcontentloaded
