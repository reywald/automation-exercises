*** Settings ***
Documentation       Tests for Contact Us Form, Test Cases, Products, Search, Subscription

Resource            reusables.resource
Resource            ../page_objects/contact_us_page.resource

Test Setup          browsing.Open Website
Test Teardown       browsing.Close Browser Session


*** Test Cases ***
Submit The Contact Us Form Successfully
    [Documentation]    Test to enter information in the Contact Us Form and submit successfully
    reusables.Verify Homepage Is Visible
    homepage.Click Menu Item    Contact Us
    contact_us_page.Verify In Contact Us Page
    ${contact_us_details} =    generate_data.Generate Contact Us Details
    contact_us_page.Fill Contact Us Form    contact_info=${contact_us_details}
    contact_us_page.Verify Contact Form Submitted
    contact_us_page.Navigate To Home Page
    reusables.Verify Homepage Is Visible
