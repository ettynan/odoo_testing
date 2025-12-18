*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    DateTime

*** Variables ***
${URL}          http://146.190.122.200:8069/web/login?db=testdb
${USERNAME}     user1@yahoo.com
${PASSWORD}     user1

*** Keywords ***
Handle Password Popup
    ${clicked}=    Run Keyword And Return Status    Click Button    xpath=//button[normalize-space()='OK']
    IF    ${clicked}
        Sleep    0.3
    END

Open Browser And Login
    # Create ChromeOptions exactly the way SeleniumLibrary accepts them
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # The ONLY stable solution for the popup: disable leak detection via prefs
    ${prefs}=    Create Dictionary
    ...    profile.password_manager_enabled=${FALSE}
    ...    credentials_enable_service=${FALSE}
    ...    profile.password_manager_leak_detection=${FALSE}

    Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}

    Open Browser    ${URL}    chrome    chrome_options=${chrome options}
    Input Text      name=login      ${USERNAME}
    Input Text      name=password   ${PASSWORD}
    Click Button    xpath=//button[@type='submit']
    
    Handle Password Popup

    # Wait for login to finish (user menu appears)
    Wait For Element Stable     xpath=//span[contains(@class,'oe_topbar_name')]

Wait For Element Stable
    [Arguments]    ${locator}    ${retries}=20    ${delay}=0.5
    # Repeatedly check for an element until it stabilizes
    FOR    ${i}    IN RANGE    ${retries}
        ${found}=    Run Keyword And Return Status    Page Should Contain Element    ${locator}
        IF    ${found}
            Exit For Loop
        END
        Sleep    ${delay}
    END
    Page Should Contain Element    ${locator}

Open Lunch App
    # Open the Home Menu (grid icon)
    Click Element    xpath=//button[@title='Home Menu']

    # Wait until Lunch appears in dropdown (WAIT FOR DROPDOWN TO OPEN)
    Wait For Element Stable    xpath=//a[normalize-space()='Lunch']

    # Click the Lunch app item
    Click Element    xpath=//a[normalize-space()='Lunch']

    # Confirm the page actually reached "Order Your Lunch"
    Wait For Element Stable    xpath=//li[@class='breadcrumb-item active']/span[normalize-space()='Order Your Lunch']

Select Random Lunch Item
    # Pick a food item at random
    ${elements}=    Get WebElements    xpath=//div[contains(@class,'oe_kanban_global_click')]
    ${count}=    Get Length    ${elements}
    ${index}=    Evaluate    random.randint(1, ${count})    random
    Click Element    xpath=(//div[contains(@class,'oe_kanban_global_click')])[${index}]
    Wait For Element Stable    xpath=//div[contains(@class,'modal-dialog')]

Add Item To Cart
    # Click "Add to Cart"
    Click Element    xpath=//button[contains(@class,'btn-primary') and contains(.,'Add')]

    # Confirm modal closes
    Wait Until Page Does Not Contain Element    xpath=//div[contains(@class,'modal-dialog')]    timeout=10

    # Confirm the cart counter updates (any badge count)
    Wait For Element Stable    xpath=//span[contains(@class,'badge')]

Place Order Now
    # Wait until the Order Now button appears
    Wait For Element Stable    xpath=//button[contains(@class,'o_lunch_widget_order_button')]

    # Click the Order Now button
    Click Element    xpath=//button[contains(@class,'o_lunch_widget_order_button')]

    # Wait for ordered badge to appear
    Wait For Element Stable    xpath=//span[contains(@class,'o_lunch_ordered')]

Open My Orders
    # Click the My Lunch dropdown in the top nav
    Wait For Element Stable    xpath=//button[@data-menu-xmlid='lunch.menu_lunch_title']
    Click Element              xpath=//button[@data-menu-xmlid='lunch.menu_lunch_title']

    # Wait for dropdown to render and click “My Order History”
    Wait For Element Stable    xpath=//a[@data-section='301']
    Click Element              xpath=//a[@data-section='301']

    # Confirm navigation to My Orders page
    Wait For Element Stable    xpath=//div[contains(@class,'o_list_view') and contains(@class,'o_lunch_list')]

Expand Today Orders
    # Wait for ANY group header to appear
    Wait For Element Stable    xpath=//tr[contains(@class,'o_group_header')]

    # Expand the first collapsed group, if it's collapsed
    ${is_collapsed}=    Run Keyword And Return Status
    ...    Page Should Contain Element
    ...    xpath=(//tr[contains(@class,'o_group_header')]//span[contains(@class,'fa-caret-right')])[1]

    IF    ${is_collapsed}
        Click Element    xpath=(//tr[contains(@class,'o_group_header')]//span[contains(@class,'fa-caret-right')])[1]
        Sleep    0.5
    END

    # Now wait for the FIRST visible data row in the whole table
    Wait For Element Stable    xpath=//tr[contains(@class,'o_data_row')]

Cancel Item
    # Ensure the My Orders list has loaded
    Wait For Element Stable    xpath=//table[contains(@class,'o_list_table')]

    # Expand today’s date group if collapsed (the caret is the span.fa-caret-right)
    ${collapsed}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//tr[contains(@class,'o_group_header')]//span[contains(@class,'fa-caret-right')]
    IF    ${collapsed}
        Click Element    xpath=//tr[contains(@class,'o_group_header')]//span[contains(@class,'fa-caret-right')]
        Sleep    0.3
    END

    # Wait for rows to appear under the group
    Wait For Element Stable    xpath=//tr[contains(@class,'o_data_row')]

    # Click the first Cancel button visible in any order row
    Click Element    xpath=(//button[@name='action_cancel'])[1]

    # Confirm cancel succeeded by waiting for state to change to "Cancelled"
    Wait For Element Stable    xpath=//td[@name='state' and (contains(.,'Cancelled') or contains(.,'Canceled'))]
