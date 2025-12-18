*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
Open Lunch App Test
    Open Browser And Login
    Open Lunch App
    [Teardown]    Close Browser
