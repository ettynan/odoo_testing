*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
Place Order Test
    Open Browser And Login
    Open Lunch App
    Select Random Lunch Item
    Add Item To Cart
    Select Random Lunch Item
    Add Item To Cart
    Place Order Now
    Sleep   3 s
    [Teardown]    Close Browser
