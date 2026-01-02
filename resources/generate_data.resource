*** Settings ***
Documentation       Used to generate random account & address details for user registration.

Library             Collections
Library             FakerLibrary


*** Keywords ***
Generate Account Details
    [Documentation]    Generate random account details for user registration
    ${name}=    FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${title}=    FakerLibrary.Prefix
    ${password}=    FakerLibrary.Password    length=10    special_chars=True    digits=True
    ...    upper_case=True
    ...    lower_case=True
    ${dob_day: int}=    FakerLibrary.Day Of Month
    ${dob_month}=    FakerLibrary.Month Name
    ${dob_year}=    FakerLibrary.Year
    ${newsletter}=    FakerLibrary.Boolean    ${100}
    ${offers}=    FakerLibrary.Boolean    ${100}
    VAR    &{ACCOUNT_DETAILS}=    name=${name}    email=${email}    title=${title}    password=${password}
    ...    dob_day=${dob_day}    dob_month=${dob_month}    dob_year=${dob_year}
    ...    newsletter=${newsletter}    offers=${offers}
    RETURN    ${ACCOUNT_DETAILS}

Generate Address Details
    [Documentation]    Generate random address details for user registration
    ${first_name}=    FakerLibrary.First Name
    ${last_name}=    FakerLibrary.Last Name
    ${company}=    FakerLibrary.Company
    ${address1}=    FakerLibrary.Street Address
    ${address2}=    FakerLibrary.Secondary Address
    ${country}=    FakerLibrary.Random Int    min=0    max=6
    ${state}=    FakerLibrary.State
    ${city}=    FakerLibrary.City
    ${zipcode}=    FakerLibrary.Postal Code
    ${mobile_number}=    FakerLibrary.Phone Number
    VAR    &{ADDRESS_DETAILS}=    firstname=${first_name}    lastname=${last_name}
    ...    company=${company}    address1=${address1}    address2=${address2}
    ...    country=${country}    state=${state}    city=${city}    zipcode=${zipcode}    mobile_number=${mobile_number}
    RETURN    ${ADDRESS_DETAILS}

Generate Login Details
    [Documentation]    Generate login email and password
    ${email}=    FakerLibrary.Email
    ${password}=    FakerLibrary.Password
    VAR    &{LOGIN_CREDENTIALS}=    email=${email}    password=${password}
    RETURN    ${LOGIN_CREDENTIALS}

Generate Valid User Account
    [Documentation]    Create a new user account by generating user details and address information
    ${user_details}=    Generate Account Details
    ${user_address}=    Generate Address Details
    VAR    &{USER_ACCOUNT}=    &{user_details}    &{user_address}
    RETURN    ${USER_ACCOUNT}

Generate Contact Us Details
    [Documentation]    Create contact us form details
    ${name}=    FakerLibrary.Name
    ${email}=    FakerLibrary.Email
    ${subject}=    FakerLibrary.Catch Phrase
    ${message}=    FakerLibrary.Sentences    10
    ${message}=    Catenate    @{message}
    VAR    &{CONTACT_US_DETAILS}=    name=${name}    email=${email}    subject=${subject}    message=${message}
    RETURN    ${CONTACT_US_DETAILS}
