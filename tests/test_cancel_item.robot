*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
Cancel Item Test
    Open Browser And Login
    Open Lunch App
    Select Random Lunch Item
    Add Item To Cart
    Place Order Now
    Open My Orders
    Cancel Item
    Sleep   3 s
    [Teardown]    Close Browser