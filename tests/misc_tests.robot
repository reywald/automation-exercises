*** Settings ***
Documentation       Tests for Contact Us Form, Test Cases

Resource            reusables.resource
Resource            ../page_objects/contact_us_page.resource
Resource            ../page_objects/testcases_page.resource
Resource            ../page_objects/api_testing_page.resource

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

Verify Test Cases Page
    [Documentation]    Test to navigate to the Test Cases Page
    reusables.Verify Homepage Is Visible
    homepage.Click Menu Item    Test Cases
    testcases_page.Verify In Test Cases Page

Verify API Testing Page
    [Documentation]    Test to navigate to the API List Page
    reusables.Verify Homepage Is Visible
    homepage.Click Menu Item    API Testing
    api_testing_page.Verify In API Testing Page
