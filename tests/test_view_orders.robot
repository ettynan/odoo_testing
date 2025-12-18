*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
View My Orders Test
    Open Browser And Login
    Open Lunch App
    Select Random Lunch Item
    Add Item To Cart
    Place Order Now
    Open My Orders
    Expand Today Orders
    Sleep   3 s
    [Teardown]    Close Browser