# rvest
```r
library(rvest)
url <- 'https://...'
page <- read_html(url)                                     ; чтение страницы
html_structure(page)                                       ; структура страницы
data <- htnl_nodes(page, css = "#update_date")             ; поиск элемента с указанным атрибутом-идентификатором id
data <- htnl_nodes(page, xpath = '//*[@id="update_date"])  ; тоже, ислопользуя xpath-локатор вместо css-селектора 
data <- htnl_nodes(page, css = ".simple_text")             ; поиск элемента по классу (атрибут class)
data <- htnl_nodes(page, css = "[title]")                  ; поиск элемента по наличию атрибута title
data <- htnl_nodes(page, css = "[title]='part1'")          ; поиск элемента по значению атрибута title
data <- htnl_nodes(page, css = "table")                    ; поиск элемента по тегу table
data <- htnl_nodes(page, css = "div p a")                  ; поиск по вложенным тегам (ссылка в параграфе в блоке div)
```
