*** Settings ***
Documentation       Tests for Products, Search, Subscription

Resource            reusables.resource
Resource            ../page_objects/products_page.resource
Resource            ../page_objects/product_detail_page.resource

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
