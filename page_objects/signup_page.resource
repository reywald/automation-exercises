*** Settings ***
Documentation       Page object for signup / login page elements and verifications.

Library             Browser


*** Variables ***
${ACCOUNT_SIGNUP_FORM}                      id=form >> css=.login-form
${ACCOUNT_HEADER}                           ${ACCOUNT_SIGNUP_FORM} >> h2 >> nth=0
${ADDRESS_HEADER}                           ${ACCOUNT_SIGNUP_FORM} >> h2 >> nth=1
${ACCOUNT_MR_RADIO_BUTTON}                  ${ACCOUNT_SIGNUP_FORM} >> input\#id_gender1
${ACCOUNT_MRS_RADIO_BUTTON}                 ${ACCOUNT_SIGNUP_FORM} >> input\#id_gender2
${ACCOUNT_SIGNUP_NAME_FIELD}                ${ACCOUNT_SIGNUP_FORM} >> input\#name
${ACCOUNT_SIGNUP_EMAIL_FIELD}               ${ACCOUNT_SIGNUP_FORM} >> input\#email
${ACCOUNT_SIGNUP_PASSWORD_FIELD}            ${ACCOUNT_SIGNUP_FORM} >> input\#password
${ACCOUNT_SIGNUP_DOB_DAY_FIELD}             ${ACCOUNT_SIGNUP_FORM} >> \#days
${ACCOUNT_SIGNUP_DOB_MONTH_FIELD}           ${ACCOUNT_SIGNUP_FORM} >> \#months
${ACCOUNT_SIGNUP_DOB_YEAR_FIELD}            ${ACCOUNT_SIGNUP_FORM} >> \#years
${ACCOUNT_SIGNUP_NEWSLETTER_CHECKBOX}       ${ACCOUNT_SIGNUP_FORM} >> \#newsletter
${ACCOUNT_SIGNUP_OFFERS_CHECKBOX}           ${ACCOUNT_SIGNUP_FORM} >> \#optin
${ADDRESS_FIRST_NAME_FIELD}                 ${ACCOUNT_SIGNUP_FORM} >> input\#first_name
${ADDRESS_LAST_NAME_FIELD}                  ${ACCOUNT_SIGNUP_FORM} >> input\#last_name
${ADDRESS_COMPANY_FIELD}                    ${ACCOUNT_SIGNUP_FORM} >> input\#company
${ADDRESS_ADDRESS1_FIELD}                   ${ACCOUNT_SIGNUP_FORM} >> input\#address1
${ADDRESS_ADDRESS2_FIELD}                   ${ACCOUNT_SIGNUP_FORM} >> input\#address2
${ADDRESS_COUNTRY_DROPDOWN}                 ${ACCOUNT_SIGNUP_FORM} >> select\#country
${ADDRESS_STATE_FIELD}                      ${ACCOUNT_SIGNUP_FORM} >> input\#state
${ADDRESS_CITY_FIELD}                       ${ACCOUNT_SIGNUP_FORM} >> input\#city
${ADDRESS_ZIPCODE_FIELD}                    ${ACCOUNT_SIGNUP_FORM} >> input\#zipcode
${ADDRESS_MOBILE_NUMBER_FIELD}              ${ACCOUNT_SIGNUP_FORM} >> input\#mobile_number
${CREATE_ACCOUNT_BUTTON}                    ${ACCOUNT_SIGNUP_FORM} >> button


*** Keywords ***
Verify In Signup Page
    [Documentation]    Verify that the page is the Signup page
    Get Url    contains    signup
    Get Text    ${ACCOUNT_HEADER}    ==    ENTER ACCOUNT INFORMATION
    Get Text    ${ADDRESS_HEADER}    ==    ADDRESS INFORMATION

Fill Account Information Form
    [Documentation]    Fill in the account information form with provided name, email, and other details
    [Arguments]    ${account_details: dict}
    IF    "${account_details['title']} == Mr."
        Check Checkbox    ${ACCOUNT_MR_RADIO_BUTTON}
    ELSE IF    "${account_details['title']} == Mrs."
        Check Checkbox    ${ACCOUNT_MRS_RADIO_BUTTON}
    END
    Fill Text    ${ACCOUNT_SIGNUP_PASSWORD_FIELD}    ${account_details['password']}
    ${day} =    Evaluate    ${account_details['dob_day']} - 1
    Select Options By    ${ACCOUNT_SIGNUP_DOB_DAY_FIELD}    index    ${day}
    Select Options By    ${ACCOUNT_SIGNUP_DOB_MONTH_FIELD}    label    ${account_details['dob_month']}
    Select Options By    ${ACCOUNT_SIGNUP_DOB_YEAR_FIELD}    label    ${account_details['dob_year']}
    IF    ${account_details['newsletter']}
        Check Checkbox    ${ACCOUNT_SIGNUP_NEWSLETTER_CHECKBOX}
    END
    IF    ${account_details['offers']}
        Check Checkbox    ${ACCOUNT_SIGNUP_OFFERS_CHECKBOX}
    END

Fill Address Information Form
    [Documentation]    Fill in the address information form with provided details
    [Arguments]    ${address_details: dict}
    Fill Text    ${ADDRESS_FIRST_NAME_FIELD}    ${address_details['first_name']}
    Fill Text    ${ADDRESS_LAST_NAME_FIELD}    ${address_details['last_name']}
    Fill Text    ${ADDRESS_COMPANY_FIELD}    ${address_details['company']}
    Fill Text    ${ADDRESS_ADDRESS1_FIELD}    ${address_details['address1']}
    Fill Text    ${ADDRESS_ADDRESS2_FIELD}    ${address_details['address2']}
    Select Options By    ${ADDRESS_COUNTRY_DROPDOWN}    index    ${address_details['country']}
    Fill Text    ${ADDRESS_STATE_FIELD}    ${address_details['state']}
    Fill Text    ${ADDRESS_CITY_FIELD}    ${address_details['city']}
    Fill Text    ${ADDRESS_ZIPCODE_FIELD}    ${address_details['zipcode']}
    Fill Text    ${ADDRESS_MOBILE_NUMBER_FIELD}    ${address_details['mobile_number']}
    Click    ${CREATE_ACCOUNT_BUTTON}
    Wait For Load State    domcontentloaded    timeout=10s
