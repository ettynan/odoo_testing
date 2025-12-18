*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
Select Lunch Item Test
    Open Browser And Login
    Open Lunch App
    Select Random Lunch Item
    Sleep   3 s
    [Teardown]    Close Browser
