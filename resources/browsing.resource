*** Settings ***
Documentation       Resources and variables to be used in testing.

Library             Browser


*** Variables ***
${BASE_URL}         https://automationexercise.com/
${CHROMIUM_PATH}    C:\\Users\\Ikechukwu Agbarakwe\\AppData\\Local\\ms-playwright\\chromium-1179\\chrome-win\\chrome.exe
${FIREFOX_PATH}     C:\\Users\\Ikechukwu Agbarakwe\\AppData\\Local\\ms-playwright\\firefox-1487\\firefox\\firefox.exe


*** Keywords ***
Open Website
    [Documentation]    Navigate to the testing site
    New Browser    browser=chromium    headless=False    executablePath=${CHROMIUM_PATH}
    New Context    viewport={"width": 1536, "height": 816}
    New Page    url=${BASE_URL}    wait_until=domcontentloaded

Close Browser Session
    [Documentation]    Close the browser after test completion
    Sleep    5 seconds
    Close Browser
