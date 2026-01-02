*** Settings ***
Documentation       Page object for Products List page elements and verifications

Library             OperatingSystem
Library             Browser


*** Variables ***
${PRODUCTS_SECTION}             section >> nth=1 >> .container
${ALL_PRODUCTS}                 ${PRODUCTS_SECTION} >> .features_items
${ALL_PRODUCTS_HEADER}          ${ALL_PRODUCTS} >> h2.title
${PRODUCT_ITEM}                 ${ALL_PRODUCTS} >> .product-image-wrapper
${PRODUCT_NAME}                 ${PRODUCT_ITEM} >> .productinfo >> p
${PRODUCT_ITEM_VIEW_BUTTON}     ${PRODUCT_ITEM} >> .choose >> a
${SEARCH_INPUT}                 id=search_product
${SEARCH_BUTTON}                id=submit_search


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

Search For A Product
    [Documentation]    Search for a product using the search input
    [Arguments]    ${product_name: str}
    Fill Text    ${SEARCH_INPUT}    ${product_name}
    Click    ${SEARCH_BUTTON}
    Wait For Load State    domcontentloaded

Verify Search Returns Matched Products
    [Documentation]    Verify that there are searched product and their titles contain the search term
    [Arguments]    ${search_str}
    Get Url    contains    products?search=${search_str}
    Get Text    ${ALL_PRODUCTS_HEADER}    ==    SEARCHED PRODUCTS
    ${search_products} =    Get Elements    ${PRODUCT_NAME}
    ${products_count} =    Get Length    ${search_products}
    Should Be Equal As Integers    ${products_count}    ${14}
    FOR    ${title}    IN    @{search_products}
        Get Element States    ${title}    contains    visible
        Get Text    ${title}
    END
