*** Settings ***
Documentation       Page object for Contact Us page elements and verifications

Library             OperatingSystem
Library             Browser


*** Variables ***
${CONTACT_US_HEADER}            id=contact-page >> h2 >> nth=0
${CONTACT_US_FORM_HEADER}       id=contact-page >> .contact-form >> h2
${CONTACT_US_FORM}              id=form-section >> id=contact-us-form
${CONTACT_US_NAME}              ${CONTACT_US_FORM} >> input[name='name']
${CONTACT_US_EMAIL}             ${CONTACT_US_FORM} >> input[name='email']
${CONTACT_US_SUBJECT}           ${CONTACT_US_FORM} >> input[name='subject']
${CONTACT_US_MESSAGE}           ${CONTACT_US_FORM} >> id=message
${CONTACT_US_FILE_UPLOAD}       ${CONTACT_US_FORM} >> input[name='upload_file']
${SUBMIT_BUTTON}                ${CONTACT_US_FORM} >> input[name='submit']
${UPLOAD_FILE_PATH}             ${/}resources${/}upload${/}sunset.jpg
${SUCCESS_MESSAGE}              id=contact-page >> .contact-form >> .alert-success
${HOME_LINK}                    id=contact-page >> .contact-form >> id=form-section >> a.btn-success


*** Keywords ***
Verify In Contact Us Page
    [Documentation]    Verify that the page is the Contact Us page
    Get Url    contains    contact_us
    Get Text    ${CONTACT_US_HEADER}    ==    CONTACT US
    Get Text    ${CONTACT_US_FORM_HEADER}    ==    GET IN TOUCH

Fill Contact Us Form
    [Documentation]    Fill in the contact us form with a name, email, subject and message
    [Arguments]    ${contact_info}
    [Setup]    Create File    ${UPLOAD_FILE_PATH}    content=Hello Friend
    Fill Text    ${CONTACT_US_NAME}    ${contact_info['name']}
    Fill Text    ${CONTACT_US_EMAIL}    ${contact_info['email']}
    Fill Text    ${CONTACT_US_SUBJECT}    ${contact_info['subject']}
    Fill Text    ${CONTACT_US_MESSAGE}    ${contact_info['message']}

    # Attach the file in the filepath and upload
    Upload File By Selector    ${CONTACT_US_FILE_UPLOAD}    ${UPLOAD_FILE_PATH}
    Handle Future Dialogs    accept
    Click    ${SUBMIT_BUTTON}
    Wait For Load State    domcontentloaded
    [Teardown]    Remove File    ${UPLOAD_FILE_PATH}

Verify Contact Form Submitted
    [Documentation]    Verify the success message "Success!" is visible
    Get Element States    ${CONTACT_US_FORM}    contains    detached
    ${success} =    Get Element    ${SUCCESS_MESSAGE}
    Get Element States    ${success}    contains    visible
    Get Text    ${success}    ==    Success! Your details have been submitted successfully.
    Get Element States    ${HOME_LINK}    contains    visible

Navigate To Home Page
    [Documentation]    Click the Home button to return to the homepage
    ${home} =    Get Element    ${HOME_LINK}
    Click    ${home}
    Wait For Load State    domcontentloaded
