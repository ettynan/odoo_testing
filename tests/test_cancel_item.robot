*** Settings ***
Resource    resources/lunch_keywords.resource

*** Test Cases ***
Cancel Item Test
    Open Browser And Login
    Open Lunch App
    Select Lunch Item
    Add Item To Cart
    Place Order Now
    Open My Orders
    Cancel Item
    [Teardown]    Close Browser