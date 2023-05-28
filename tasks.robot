*** Settings ***
Documentation       robocorp exercices. first robot
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.HTTP
Library    RPA.Excel.Files
Library    RPA.PDF

*** Keywords ***
open web browser
    Open Available Browser    https://robotsparebinindustries.com/#/
    
enter data into form    
    Input Text    username    maria
    Input Password    password    thoushallnotpass
    Submit Form
    Wait Until Element Is Enabled    id:sales-form

Download excel file from URL
    Download    https://robotsparebinindustries.com/SalesData.xlsx

Fill data into webpage
    [Arguments]    ${element}
    Input Text    firstname    ${element}[First Name]
    Input Text    lastname    ${element}[Last Name]
    Select From List By Value    salestarget    ${element}[Sales Target]
    Input Text    salesresult    ${element}[Sales]
    Click Button    Submit
    
Take snapshot with every sales
    [Arguments]    ${element}
    Wait Until Element Is Enabled    css:div.alert.alert-dark.sales-summary
    Screenshot    css:div.alert.alert-dark.sales-summary    ${OUTPUT_DIR}${/}output${/}${element}[First Name]_${element}[Last Name].png

Read data from excel
    Open Workbook    SalesData.xlsx
    ${sales_data}=    Read Worksheet As Table     header=True

    FOR    ${element}    IN    @{sales_data}
        Fill data into webpage    ${element}
        Take snapshot with every sales    ${element}
               
    END

    Close Workbook

Export result table as pfd
    ${html_data_table}=    Get Element Attribute    id:root    outerHTML
    Log    ${html_data_table}
    Html To Pdf    ${html_data_table}    ${OUTPUT_DIR}${/}output${/}results.pdf

Logout and close browser
    Click Button    id:logout
    Close Browser

*** Tasks ***
robot tasks
    open web browser
    enter data into form
    Read data from excel
    Export result table as pfd
    [Teardown]    Logout and close browser
    
    
    


