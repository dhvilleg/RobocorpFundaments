*** Settings ***
Documentation       robocorp exercices. first robot
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.HTTP
Library    RPA.Excel.Files

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
    
Read data from excel
    Open Workbook    SalesData.xlsx
    ${sales_data}=    Read Worksheet As Table     header=True

    FOR    ${element}    IN    @{sales_data}
        Fill data into webpage    ${element}
        Log    ${element}
        
    END

    Close Workbook

*** Tasks ***
robot tasks
    open web browser
    enter data into form
    Read data from excel
    


