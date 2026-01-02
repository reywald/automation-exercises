*** Settings ***
Documentation       Page object for Product Detail page elements and verifications

Library             OperatingSystem
Library             Browser


*** Variables ***
${PRODUCT_SECTION}          .container >> .product-details
${PRODUCT_INFORMATION}      ${PRODUCT_SECTION} >> .product-information
${PRODUCT_NAME}             ${PRODUCT_SECTION} >> h2
${PRODUCT_CATEGORY}         ${PRODUCT_SECTION} >> p >> text=Category
${PRODUCT_PRICE}            ${PRODUCT_SECTION} >> span >> text=Rs.
${PRODUCT_AVAILABILITY}     ${PRODUCT_SECTION} >> p >> nth=1
${PRODUCT_CONDITION}        ${PRODUCT_SECTION} >> p >> nth=2
${PRODUCT_BRAND}            ${PRODUCT_SECTION} >> p >> nth=3


*** Keywords ***
Verify In Product Detail Page
    [Documentation]    Verify that the page is the Product Detail page
    Get Url    contains    product_details
    Get Element States    ${PRODUCT_SECTION}    contains    visible
    Get Element States    ${PRODUCT_NAME}    contains    visible
    Get Element States    ${PRODUCT_CATEGORY}    contains    visible
    Get Element States    ${PRODUCT_PRICE}    contains    visible
    Get Element States    ${PRODUCT_AVAILABILITY}    contains    visible
    Get Text    ${PRODUCT_AVAILABILITY}
    Get Element States    ${PRODUCT_CONDITION}    contains    visible
    Get Element States    ${PRODUCT_BRAND}    contains    visible

Verify Product Details Are Correct
    [Documentation]    Verify that the product details are correct
    [Arguments]    ${product_details: dict}
    Get Text    ${PRODUCT_NAME}    ==    ${product_details['name']}
    Get Text    ${PRODUCT_CATEGORY}    contains    ${product_details['category']}
    Get Text    ${PRODUCT_PRICE}    ==    Rs. ${product_details['price']}
    Get Text    ${PRODUCT_AVAILABILITY}    contains    ${product_details['availability']}
    Get Text    ${PRODUCT_CONDITION}    contains    ${product_details['condition']}
    Get Text    ${PRODUCT_BRAND}    contains    ${product_details['brand']}
