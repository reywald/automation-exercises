*** Settings ***
Documentation       Page object for Product Detail page elements and verifications

Library             Collections
Library             OperatingSystem
Library             String
Library             Browser


*** Variables ***
${PRODUCT_DETAIL_SECTION}           .container >> .product-details
${PRODUCT_DETAIL_INFORMATION}       ${PRODUCT_DETAIL_SECTION} >> .product-information
${PRODUCT_DETAIL_NAME}              ${PRODUCT_DETAIL_SECTION} >> h2
${PRODUCT_DETAIL_CATEGORY}          ${PRODUCT_DETAIL_SECTION} >> p >> text=Category
${PRODUCT_DETAIL_PRICE}             ${PRODUCT_DETAIL_SECTION} >> span >> text=Rs.
${PRODUCT_DETAIL_AVAILABILITY}      ${PRODUCT_DETAIL_SECTION} >> p >> nth=1
${PRODUCT_DETAIL_CONDITION}         ${PRODUCT_DETAIL_SECTION} >> p >> nth=2
${PRODUCT_DETAIL_BRAND}             ${PRODUCT_DETAIL_SECTION} >> p >> nth=3
${PRODUCT_DETAIL_QUANTITY}          id=quantity
${CART_BUTTON}                      ${PRODUCT_DETAIL_SECTION} >> button.cart

&{PRODUCT_DETAIL_INFO}              &{EMPTY}


*** Keywords ***
Verify In Product Detail Page
    [Documentation]    Verify that the page is the Product Detail page
    Get Url    contains    product_details
    Get Element States    ${PRODUCT_DETAIL_SECTION}    contains    visible
    Get Element States    ${PRODUCT_DETAIL_NAME}    contains    visible
    Get Element States    ${PRODUCT_DETAIL_CATEGORY}    contains    visible
    Get Element States    ${PRODUCT_DETAIL_PRICE}    contains    visible
    Get Element States    ${PRODUCT_DETAIL_AVAILABILITY}    contains    visible
    Get Text    ${PRODUCT_DETAIL_AVAILABILITY}
    Get Element States    ${PRODUCT_DETAIL_CONDITION}    contains    visible
    Get Element States    ${PRODUCT_DETAIL_BRAND}    contains    visible

Verify Product Details Are Correct
    [Documentation]    Verify that the product details are correct
    [Arguments]    ${product_details: dict}
    Get Text    ${PRODUCT_DETAIL_NAME}    ==    ${product_details['description']}
    Get Text    ${PRODUCT_DETAIL_CATEGORY}    contains    ${product_details['category']}
    Get Text    ${PRODUCT_DETAIL_PRICE}    ==    Rs. ${product_details['price']}
    Get Text    ${PRODUCT_DETAIL_AVAILABILITY}    contains    ${product_details['availability']}
    Get Text    ${PRODUCT_DETAIL_CONDITION}    contains    ${product_details['condition']}
    Get Text    ${PRODUCT_DETAIL_BRAND}    contains    ${product_details['brand']}

Ammend Quantity
    [Documentation]    Increase/reduce the product's quantity
    [Arguments]    ${quantity: str}
    Fill Text    ${PRODUCT_DETAIL_QUANTITY}    ${quantity}

Add To Cart
    [Documentation]    Add the product to the cart
    Click    ${CART_BUTTON}
    Set Added Product Details

Set Added Product Details
    [Documentation]    Create a dictionary of the product details
    ${name} =    Get Text    ${PRODUCT_DETAIL_NAME}
    ${price} =    Get Text    ${PRODUCT_DETAIL_PRICE}
    ${price_num} =    Fetch From Right    ${price}    Rs.${SPACE}
    ${quantity} =    Get Text    ${PRODUCT_DETAIL_QUANTITY}
    VAR    ${total} =    Rs. ${{int(${quantity}) * int(${price_num})}}
    Set To Dictionary    ${PRODUCT_DETAIL_INFO}
    ...    description=${name}
    ...    price=${price}
    ...    quantity=${quantity}
    ...    total=${total}
