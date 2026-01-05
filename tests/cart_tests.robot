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


*** Keywords ***
Click View Product For Any Product On Home Page
    [Documentation]    Pick any product on the home page and open its detail page
    ${idx} =    products_page.Randomly Select A Product By Index
    products_page.Open A Product Detail Page By Index    index=${idx}
