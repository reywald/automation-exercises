*** Settings ***
Documentation       Page object for Products List page elements and verifications

Library             Collections
Library             OperatingSystem
Library             Browser


*** Variables ***
${PRODUCTS_SECTION}             section >> nth=1 >> .container
${ALL_PRODUCTS}                 ${PRODUCTS_SECTION} >> .features_items
${ALL_PRODUCTS_HEADER}          ${ALL_PRODUCTS} >> h2.title
${PRODUCT_ITEM}                 ${ALL_PRODUCTS} >> .product-image-wrapper
${PRODUCT_NAME}                 .productinfo >> p
${PRODUCT_PRICE}                .productinfo >> h2
${PRODUCT_ITEM_VIEW_BUTTON}     ${PRODUCT_ITEM} >> .choose >> a
${PRODUCT_CART_BUTTON}          .product-overlay >> a
${SEARCH_INPUT}                 id=search_product
${SEARCH_BUTTON}                id=submit_search

@{ADDED_CART_PRODUCTS}          @{EMPTY}


*** Keywords ***
Verify In All Products Page
    [Documentation]    Verify that the user is the All Products page
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

Search For A Product
    [Documentation]    Search for a product using the search input
    [Arguments]    ${product_name: str}
    Fill Text    ${SEARCH_INPUT}    ${product_name}
    Click    ${SEARCH_BUTTON}
    Wait For Load State    domcontentloaded

Verify Search Returns Matched Products
    [Documentation]    Verify that there are searched product and their titles contain the search term
    [Arguments]    ${search_str: str}
    Get Url    contains    products?search=${search_str}
    Get Text    ${ALL_PRODUCTS_HEADER}    ==    SEARCHED PRODUCTS
    ${search_products} =    Get Elements    ${PRODUCT_ITEM} >> ${PRODUCT_NAME}
    ${products_count} =    Get Length    ${search_products}
    Should Be Equal As Integers    ${products_count}    ${14}
    FOR    ${title}    IN    @{search_products}
        Get Element States    ${title}    contains    visible
        Get Text    ${title}
    END

Add Product To Cart
    [Documentation]    Hover over a product and click its Add to Cart button
    [Arguments]    ${name: str}
    # Search for the product from the list of products on display
    ${found_locator} =    Get Product Locator By Name    name=${name}
    IF    '${found_locator}' == '${None}'
        Fail    *HTML* Product <strong>${name}</strong> not found. Exiting test...
    END

    Hover    ${found_locator}
    Click    ${found_locator} >> ${PRODUCT_CART_BUTTON}
    ${added_product} =    Get Added Product Details    ${found_locator}
    Append To List    ${ADDED_CART_PRODUCTS}    ${added_product}

Get Product Locator By Name
    [Documentation]    Search for a product in the products' list by its name and return the match's locator
    [Arguments]    ${name: str}
    ${products_list} =    Get Elements    ${PRODUCT_ITEM}

    # Check each product item's text content for the product's name
    FOR    ${product}    IN    @{products_list}
        ${text_content} =    Get Text    ${product}
        IF    ${{"""${text_content}""".find('${name}') > -1}}
            RETURN    ${product}
        END
    END
    RETURN    ${None}

Get Added Product Details By API
    [Documentation]    Use an API request to get a product's details
    [Arguments]    ${product_name: str}
    ${form} =    Evaluate    "search_product=${product_name}"
    ${headers} =    Evaluate    {"content-type": "application/x-www-form-urlencoded"}
    ${response} =    Http
    ...    url=/api/searchProduct
    ...    method=POST
    ...    body=${form}
    ...    headers=&{headers}
    Should Be Equal    ${response.status}    ${200}
    Should Be Equal    ${response.body.responseCode}    ${200}
    Dictionary Should Contain Key    ${response.body}    products
    RETURN    ${response.body.products}

Get Added Product Details
    [Documentation]    Use a product locator to get the product info
    [Arguments]    ${locator}
    ${name} =    Get Text    ${locator} >> ${PRODUCT_NAME}
    ${price} =    Get Text    ${locator} >> ${PRODUCT_PRICE}
    VAR    &{product_info} =    description=${name}    price=${price}    quantity=${1}    total=${price}
    RETURN    ${product_info}
