*** Settings ***
Documentation       Page object for Products List page elements and verifications

Library             OperatingSystem
Library             Browser


*** Variables ***
${PRODUCTS_SECTION}             section >> nth=1 >> .container
${ALL_PRODUCTS}                 ${PRODUCTS_SECTION} >> .features_items
${ALL_PRODUCTS_HEADER}          ${ALL_PRODUCTS} >> h2.title
${PRODUCT_ITEM}                 ${ALL_PRODUCTS} >> .product-image-wrapper
${PRODUCT_ITEM_VIEW_BUTTON}     ${PRODUCT_ITEM} >> .choose >> a


*** Keywords ***
Verify In All Products Page
    [Documentation]    Verify that the page is the Test cases page
    Get Url    contains    products
    Get Text    ${ALL_PRODUCTS_HEADER}    ==    ALL PRODUCTS
    ${products} =    Get Elements    ${PRODUCT_ITEM}
    Length Should Be    ${products}    34

Open A Product Detail Page By Index
    [Documentation]    Click the View Product button of a product given its index
    [Arguments]    ${index: int}
    Get Element    ${PRODUCT_ITEM_VIEW_BUTTON} >> nth=${index - 1}
    ${button} =    Get Element    ${PRODUCT_ITEM_VIEW_BUTTON} >> nth=${index - 1}
    Click    ${button}
    Wait For Load State    domcontentloaded
