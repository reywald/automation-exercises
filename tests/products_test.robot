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
Verify All Products And Product Detail Page
    [Documentation]    Test to verify all products are visible and product details can be viewed
    reusables.Verify Homepage Is Visible
    homepage.Click Menu Item    Products
    products_page.Verify In All Products Page
    products_page.Open A Product Detail Page By Index    index=${1}
    product_detail_page.Verify In Product Detail Page
    VAR    &{expected_product_details} =    name=Blue Top    category=Women
    ...    price=500
    ...    availability=In Stock
    ...    condition=New
    ...    brand=Polo
    product_detail_page.Verify Product Details Are Correct    ${expected_product_details}

Search For A Product And Verify Results
    [Documentation]    Test to search for a product and verify the search results
    reusables.Verify Homepage Is Visible
    homepage.Click Menu Item    Products
    products_page.Verify In All Products Page
    products_page.Search For A Product    product_name=Top
    products_page.Verify Search Returns Matched Products    search_str=Top

Verify Subscription In Home Page
    [Documentation]    Test to make a subscription
    reusables.Verify Homepage Is Visible
    homepage.Scroll To Bottom Of Home Page
    homepage.Verify Subscription Form Is Visible
    ${email} =    FakerLibrary.Company Email
    homepage.Subscribe To Updates    ${email}
    homepage.Verify Subscription Is Successful

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
