# Create pivot table
library(pivottabler)
pt <- PivotTable$new()
pt$addData(bhmtrains)
pt$addColumnDataGroups("TrainCategory")
pt$addColumnDataGroups("PowerType")
pt$addRowDataGroups("TOC")
pt$defineCalculation(calculationName="TotalTrains", summariseExpression="n()")
pt$evaluatePivot()

# Export result into Excel (http://www.pivottabler.org.uk/articles/v13-excelexport.html)
library(openxlsx)
wb <- createWorkbook(creator = Sys.getenv("USERNAME"))
addWorksheet(wb, "Data")
pt$writeToExcelWorksheet(wb=wb, wsName="Data", 
                         topRowNumber=1, leftMostColumnNumber=1,
                         applyStyles=TRUE, mapStylesFromCSS=TRUE,
                         outputValuesAs="rawValue"|"formattedValueAsNumber")
saveWorkbook(wb, file="C:\\test.xlsx", overwrite = TRUE)
