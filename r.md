## Общие замечания по стилистике
* код разделяется на блоки, размещенным на одной строке комментарием вида `# Load data ----`
* `&` и `|` никогда не следует использовать внутри предложения `if`, потому что они могут возвращать векторы.  
Вместо этого всегда используйте `&&` и `||`.
* 

##  Замечания по пакетам R
Неоторые пакет R содержат дополнительные справочные материалы, список которых можно вывести командой вида `vignette(package = "data.table")`.
Чтобы посмотреть конкретную виньетку пакета, нужно выполнить `vignette("datatable-sd-usage", package = "data.table")`.

## References
* [TOP 100 R TUTORIALS : STEP BY STEP GUIDE](https://www.listendata.com/p/r-programming-tutorials.html)
* [List of R Commands & Functions](https://statisticsglobe.com/r-functions-list/)
