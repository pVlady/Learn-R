# rvest

### Чтение страницы и получение узла
```r
library(rvest)
url <- 'https://...'
page <- read_html(url, encoding = "cp1251")                ; чтение страницы
html_structure(page)                                       ; структура страницы
node <- htnl_nodes(page, css = "#update_date")             ; поиск элемента с указанным атрибутом-идентификатором id
node <- htnl_nodes(page, xpath = '//*[@id="update_date"])  ; тоже, ислопользуя xpath-локатор вместо css-селектора 
node <- htnl_nodes(page, css = ".simple_text")             ; поиск элемента по классу (атрибут class)
node <- htnl_nodes(page, css = "[title]")                  ; поиск элемента по наличию атрибута title
node <- htnl_nodes(page, css = "[title]='part1'")          ; поиск элемента по значению атрибута title
node <- htnl_nodes(page, css = "table")                    ; поиск элемента по тегу table
node <- htnl_nodes(page, css = "div p a")                  ; поиск по вложенным тегам (ссылка в параграфе в блоке div)
```

### Полученин данных из узла
```r
txt <- html_text(node)                                    ; извлечь текст из узла
attrs <- html_attrs(node)                                 ; получить все атрибуты из узла/списка узлов
val <- html_attr(node, name = "id")                       ; получить значение атрибута id
link_url <- html_nodes(page, css = "a") %>%               ; получить ссылку
              html_attr(name = "href")
link_url <- html_nodes(page, css = "a") %>% html_text()   ; получить текст, который ссылается на ссылку
tags <- html_names(node)                                  ; получить названия всех тегов
node <- htnl_nodes(page, css = "table") %>%               ; получить таблицу
          html_table(header=TRUE)
```

### Авторизация пользовательской сессии
```r
session <- html_session("https://rutracker.org/forum/index.php")
all_forms <- html_form(session)                           ; получить все формы на странице
login_form <- html_nodes(session, css = "#login-form-quick") %>% html_form() %>% .[[1]]
filled_form <- set_values(login_form,
                          "login_user_name" = "..."
                          "login_password" = "...")
submit_form(session, filled_form)                         ; отправляем заполненнцю форму
main <- jump_to(session, "http://rutracker.org")          ; переход на главную страницу
```
