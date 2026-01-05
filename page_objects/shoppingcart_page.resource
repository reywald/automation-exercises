*** Settings ***
Documentation       Page object for Cart Modal elements and verifications

Library             Collections
Library             String
Library             Browser


*** Variables ***
${CART_SECTION}                     id=cart_items
${BREADCRUMB_SECTION}               ${CART_SECTION} >> .breadcrumb
${BACK_HOME}                        ${BREADCRUMB_SECTION} >> a
${CART_HEADING}                     ${BREADCRUMB_SECTION} >> li.active
${ACTION_SECTION}                   id=do_action
${PROCEED_TO_CHECKOUT_BUTTON}       ${ACTION_SECTION} >> a.check_out
${CART_INFO_SECTION}                id=cart_info
${CART_INFO_TABLE}                  id=cart_info_table
${CART_INFO_TABLE_HEADER}           ${CART_INFO_TABLE} >> tr.cart_menu


*** Keywords ***
Verify In Shopping Cart Page
    [Documentation]    Verify that the user is in the Shopping Cart Page
    Get Url    contains    view_cart
    Get Element States    ${BACK_HOME}    contains    visible
    Get Text    ${BACK_HOME}    ==    Home
    Get Element States    ${CART_HEADING}    contains    visible
    Get Text    ${CART_HEADING}    ==    Shopping Cart
    Get Element States    ${PROCEED_TO_CHECKOUT_BUTTON}    contains    visible
    Get Text    ${PROCEED_TO_CHECKOUT_BUTTON}    ==    Proceed To Checkout

Verify Cart Items Are Added To Cart
    [Documentation]    Check that the items added to cart are displayed in the order they were added
    [Arguments]    ${added_products: list}
    Verify Cart Table Is Displayed
    FOR    ${idx}    ${product}    IN ENUMERATE    @{added_products}
        Get Table Row Index    ${CART_INFO_TABLE} >> "${product['description']}"    ==    ${idx+1}
        Verify Cart Item Details    product_details=${product}
        Log To Console    Product ${idx+1}: ${product}
    END

Verify Cart Table Is Displayed
    [Documentation]    Verify that the table headers are visible
    Get Element States    ${CART_INFO_TABLE_HEADER}    contains    visible
    ${headers} =    Get Text    ${CART_INFO_TABLE_HEADER}
    ${headers} =    Split String    ${headers}    \t
    List Should Contain Sub List    ${headers}    ${{["Item", "Description", "Price", "Quantity", "Total"]}}

Verify Cart Item Details
    [Documentation]    Verify that a cart item's price, quantity and total price matches
    [Arguments]    ${product_details: dict}
    ${idx} =    Get Table Row Index    ${CART_INFO_TABLE} >> "${product_details['description']}"
    Verify Cart Item Description    ${product_details['description']}    ${idx}
    Verify Cart Item Price    ${product_details['price']}    ${idx}
    Verify Cart Item Quantity    ${product_details['quantity']}    ${idx}
    Verify Cart Item Total    ${product_details['total']}    ${idx}

Verify Cart Item Description
    [Documentation]    Verify that the cart item's description matches
    [Arguments]    ${description: str}    ${idx: int}
    ${item_description} =    Get Table Cell Element    ${CART_INFO_TABLE}    "Description"    ${idx}
    Get Text    ${item_description}    contains    ${description}

Verify Cart Item Price
    [Documentation]    Verify that the cart item's price matches
    [Arguments]    ${price: str}    ${idx: int}
    ${item_price} =    Get Table Cell Element    ${CART_INFO_TABLE}    "Price"    ${idx}
    Get Text    ${item_price}    ==    ${price}

Verify Cart Item Quantity
    [Documentation]    Verify that the cart item's quantity matches
    [Arguments]    ${quantity: str}    ${idx: int}
    ${item_quantity} =    Get Table Cell Element    ${CART_INFO_TABLE}    "Quantity"    ${idx}
    Get Text    ${item_quantity}    ==    ${quantity}

Verify Cart Item Total
    [Documentation]    Verify that the cart item's total matches
    [Arguments]    ${total: str}    ${idx: int}
    ${item_total} =    Get Table Cell Element    ${CART_INFO_TABLE}    "Total"    ${idx}
    Get Text    ${item_total}    ==    ${total}
