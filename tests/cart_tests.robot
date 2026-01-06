*** Settings ***
Documentation       Tests for Products, Search, Subscription

Resource            reusables.resource
Resource            ../page_objects/products_page.resource
Resource            ../page_objects/product_detail_page.resource
Resource            ../page_objects/cart_modal_page.resource
Resource            ../page_objects/shoppingcart_page.resource

Test Setup          browsing.Open Website
Test Teardown       browsing.Close Browser Session


*** Test Cases ***
Add Products In Cart
    [Documentation]    Add some products to cart and view them in the Cart page
    reusables.Verify Homepage Is Visible
    homepage.Click Menu Item    Products
    products_page.Add Product To Cart    Blue Top
    cart_modal_page.Verify Cart Modal Is Displayed
    cart_modal_page.Continue Shopping
    cart_modal_page.Verify Cart Modal Is Not Displayed
    products_page.Add Product To Cart    Men Tshirt
    cart_modal_page.Verify Cart Modal Is Displayed
    cart_modal_page.View Cart Page
    shoppingcart_page.Verify In Shopping Cart Page
    shoppingcart_page.Verify Cart Items Are Added To Cart    added_products=${ADDED_CART_PRODUCTS}

Verify Product Quantity In Cart
    [Documentation]    Add a new product, increase its quantity and check if it reflects in the cart
    reusables.Verify Homepage Is Visible
    Click View Product For Any Product On Home Page
    product_detail_page.Verify In Product Detail Page
    product_detail_page.Ammend Quantity    4
    product_detail_page.Add To Cart
    cart_modal_page.Verify Cart Modal Is Displayed
    cart_modal_page.View Cart Page
    shoppingcart_page.Verify In Shopping Cart Page
    shoppingcart_page.Verify Cart Items Are Added To Cart    added_products=[${PRODUCT_DETAIL_INFO}]

Remove Products From Cart
    [Documentation]    Add some products and test removing one product from the cart
    reusables.Verify Homepage Is Visible
    Add Products To Cart
    homepage.Click Menu Item    Cart
    shoppingcart_page.Verify In Shopping Cart Page
    shoppingcart_page.Verify Cart Items Are Added To Cart    added_products=${ADDED_CART_PRODUCTS}
    Remove Products From The Cart


*** Keywords ***
Click View Product For Any Product On Home Page
    [Documentation]    Pick any product on the home page and open its detail page
    ${idx} =    products_page.Randomly Select A Product By Index
    products_page.Open A Product Detail Page By Index    index=${idx}

Add Products To Cart
    [Documentation]    Simulate adding multiple products to a cart
    ${items_num} =    Random Digit Not Null
    FOR    ${_}    IN RANGE    ${items_num}
        ${text} =    products_page.Randomly Select A Product By Name
        products_page.Add Product To Cart    ${text}
        cart_modal_page.Verify Cart Modal Is Displayed
        cart_modal_page.Continue Shopping
    END

Remove A Product From The Cart
    [Documentation]    Pick a product randomly and remove it
    Variable Should Exist    ${ADDED_CART_PRODUCTS}
    Should Not Be Empty    ${ADDED_CART_PRODUCTS}

    ${size} =    Get Length    ${ADDED_CART_PRODUCTS}
    ${num} =    FakerLibrary.Random Int    min=0    max=${size-1}
    VAR    ${name} =    ${ADDED_CART_PRODUCTS}[${num}][description]
    shoppingcart_page.Remove Cart Item    ${num}
    shoppingcart_page.Verify Cart Item Is Removed    ${name}

Remove Products From The Cart
    [Documentation]    Randomly select some products and remove them
    Variable Should Exist    ${ADDED_CART_PRODUCTS}
    Should Not Be Empty    ${ADDED_CART_PRODUCTS}

    ${size} =    Get Length    ${ADDED_CART_PRODUCTS}
    ${sample} =    generate_data.Generate A Random Sample Of Ints    ${size}
    FOR    ${num}    IN    @{sample}
        VAR    ${name} =    ${ADDED_CART_PRODUCTS}[${num}][description]
        shoppingcart_page.Remove Cart Item    ${num}
        shoppingcart_page.Verify Cart Item Is Removed    ${name}
    END
