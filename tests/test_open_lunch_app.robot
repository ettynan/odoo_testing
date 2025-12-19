*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
Open Lunch App Test
    Open Browser And Login
    Open Lunch App
    Sleep   3 s
    [Teardown]    Close Browser
