##########################################
###  Новые функции пакета dplyr 1.0.0  ###
##########################################

#devtools::install_github("tidyverse/dplyr")   # установка пакетв в GitHub
library(dplyr, warn.conflicts = FALSE)

# Функция rename() позволяет переименовать столбцы для устранения дублирования
# их имён, используя позиционные индексы столбцов
df1 <- tibble(a = 1:5, a = 5:1, .name_repair = "minimal")
df1
df1 %>% rename(b = 2)

# Функция select() позволяет теперь выбрать столбцы по типу
df2 <- tibble(x1 = 1, x2 = "a", x3 = 2, y1 = "b", y2 = 3, y3 = "c", y4 = 4)
df2 %>% select(is.numeric)        # выбрать числовые столбцы
df2 %>% select(!is.character)     # выбрать НЕ текстовые столбцы
df2 %>% select(starts_with("x")   # числовые стобцы, начинающиеся на X
               & is.numeric)

# Функция any_of выбирает из dataframe столбцы, названия которых есть в указанном векторе
# Функция all_of вернет ошибку, если в датафрейме нет столбца, указанного символьным вектором
vars <- c("x1", "x2", "y1", "z")
df2 %>% select(any_of(vars))      # вернет столбцы x1", "x2", "y1"
df2 %>% select(all_of(vars))      # ОШИБКА! в df2 отсутствует столбец "z"


# Функция rename_with() позволяет с помощью функции, указанной первым аргументом,
# переименовать столбцы датафрейма
df2 %>% rename_with(to_upper)
df2 %>% rename_with(to_upper, starts_with("x")) # переименовать только столбцы, начинеющиеся с "x"
df2 %>% rename_with(to_upper, is.numeric)        # преобразовать тольно названия числовых столбцов


# Функци relocate() позволяет изменить порядок столбцов датафрейма
df3 <- tibble(w = 0, x = 1, y = "a", z = "b")
df3 %>% relocate(y, z)                    # переместить столбцы y, z в начало
df3 %>% relocate(is.character)            # переместить текстовые столбцы вначало
df3 %>% relocate(w, .after = y)           # поместить столбец w после y
df3 %>% relocate(w, .before = y)          # поместить столбец w перед y
df3 %>% relocate(w, .after = last_col())  # переместить w в конец

#-------------------------------------------------------------------------------
### Функция across() служит заменой использованию функций *_if(),*_at(), *_all().
Первый аргумент функции определяет список столбцов, второй - применяемую к ним
фунуцию (в эту фунвкцию передаются оставльные аргументы acroos())
## .cols - выбор столбцов по позиции, имени, функцией, типу данных, или комбинируя любые перечисленные способы
## .fns - функция, или список функций которые необходимо применить к каждому столбцу

# тестовый дата фрейм
df <- tibble(g1 = as.factor(sample(letters[1:4],size = 10, replace = T )),
             g2 = as.factor(sample(LETTERS[1:3],size = 10, replace = T )),
             a  = runif(10, 1, 10),
             b  = runif(10, 10, 20),
             c  = runif(10, 15, 30),
             d  = runif(10, 1, 50))

# старый спостоб
df %>%
  group_by(g1, g2) %>%
  summarise(a = mean(a), b = mean(b), c = mean(c), d = mean(c))

# новый способ
df %>%
  group_by(g1, g2) %>%
  summarise(across(a:d, mean))

# можно отбирать сторбцы для обработки по типу
df %>%
  group_by(g1, g2) %>%
  summarise(across(is.numeric, mean))          # отбор числовых столбцов
  summarise(across(is.character, n_distinct))  # подсчет уникальных значений в текстовых столбцах
  summarise(across(c(sex, gender, homeworld), n_distinct))  # столбцы можно указать вектором
  summarise(across(is.numeric, mean,           # можно далее добавлять другие функции
                   na.rm = TRUE),
            n = n())
  summarise(across(is.character, n_distinct), # можно применять набор функций across()
            across(is.numeric, mean),
            across(is.list, length)
  )

#-------------------------------------------------------------------------------
### Перебор строк функцией rowwise()

# test data
df <- tibble(student_id = 1:4,
             test1 = 10:13,
             test2 = 20:23,
             test3 = 30:33,
             test4 = 40:43)
# неудачная попытка посчитать среднюю оценку по студету
df %>% mutate(avg = mean(c(test1, test2, test3, test4)))

# используем rowwise для преобразования фрейма
rf <- rowwise(df, student_id)
rf

rf %>% mutate(avg = mean(c(test1, test2, test3, test4)))

# тоже самое с использованием c_across
rf %>% mutate(avg = mean(c_across(starts_with("test"))))

# некоторые арифметические операции векторизированы по умолчанию
df %>% mutate(total = test1 + test2 + test3 + test4)

# этот подход можно использовать для вычисления среднего
df %>% mutate(avg = (test1 + test2 + test3 + test4) / 4)

# так же вы можете использовать некоторые специальные функции
# для вычисления некоторых статистик
df %>% mutate(
  min = pmin(test1, test2, test3, test4),
  max = pmax(test1, test2, test3, test4),
  string = paste(test1, test2, test3, test4, sep = "-")
)
# все векторизированные функции будут работать быстрее чем rowwise
# но rowwise позволяет векторизировать любую функцию

# ##################################
# работа со столбцами списками
df <- tibble(
  x = list(1, 2:3, 4:6),
  y = list(TRUE, 1, "a"),
  z = list(sum, mean, sd)
)

# мы можем перебором обработать каждый список
df %>%
  rowwise() %>%
  summarise(
    x_length = length(x),
    y_type = typeof(y),
    z_call = z(1:5)
  )

# ##################################
# симуляция случайных данных
df <- tribble(
  ~id, ~ n, ~ min, ~ max,
  1,   3,     0,     1,
  2,   2,    10,   100,
  3,   2,   100,  1000,
)

# используем rowwise для симуляции данных
df %>%
  rowwise(id) %>%
  mutate(data = list(runif(n, min, max)))

df %>%
  rowwise(id) %>%
  summarise(x = runif(n, min, max))

# ##################################
# функция nest_by позволяет создавать столбцы списки
by_cyl <- mtcars %>% nest_by(cyl)
by_cyl

# такой подход удобно использовать при построении линейной модели
# используем mutate для подгонки моели под каждую группа данных
by_cyl <- by_cyl %>% mutate(model = list(lm(mpg ~ wt, data = data)))
by_cyl
# теперь с помощью summarise
# можно извлекать сводки или коэфициенты построенной модели
by_cyl %>% summarise(broom::glance(model))
by_cyl %>% summarise(broom::tidy(model))

#------------------------------------------------------------------------------
# Функция summarise()
#------------------------------------------------------------------------------

# в summarise() добавлен аргумент .groups:
# .groups = "drop_last" удалит последнюю группу
# .groups = "drop" удалит всю группировку
# .groups = "keep" созранит всю группировку
# .groups = "rowwise" разобъёт фрейм на группы как rowwise()

#------------------------------------------------------------------------------
# Функции rows_*()
#------------------------------------------------------------------------------

# Функции работают аналогично join, соединяя две указанные таблицы по ключу,
# указанному аргументом by=, который по умолчанию использует первый столбец
# датафреймов
# rows_update(x, y) обновляет совпадающие строки в x значениями из y
# rows_patch(x, y)  аналогична rows_update() но заменяет только значения NA
# rows_insert(x, y) добавляет строки в x из y, которых там нет
# rows_upsert(x, y) обновляет совпадающие и добавляет отсутствующие строки в x значениями из y
# rows_delete(x, y) удаляет из x совпадающие с y строки

# Создаём тестовые данные
df <- tibble(a = 1:3, b = letters[c(1:2, NA)], c = 0.5 + 0:2)
new <- tibble(a = c(4, 5), b = c("d", "e"), c = c(3.5, 4.5))
df %>% rows_insert(new)                     # добавляет новые строки
df %>% rows_insert(tibble(a = 3, b = "c"))  # ОШИБКА! : ключ уже существует
df %>% rows_update(tibble(a = 3, b = "c"))  # обновление существующих значений
df %>% rows_update(tibble(a = 4, b = "d"))  # ОШИБКА! : ключ не существует
df %>% rows_patch(tibble(a = 2:3, b = "B")) # заполнит только пропущенные значения
df %>%
  rows_upsert(tibble(a = 3, b = "c")) %>%   # обновляет значения и добавляет новые строки
  rows_upsert(tibble(a = 4, b = "d"))

# ################################
# ПРАКТИЧЕСКИЙ ПРИМЕР
# ################################
set.seed(555)

managers <- c("Paul", "Alex", "Tim", "Bill", "John")      # менеджеры
products <- tibble(name  = paste0("product_", LETTERS),   # товары
                   price = round(runif(n = length(LETTERS), 100, 400), 0))
# функция генерации купленных товаров
prod_list <- function(prod_list, size_min, size_max) {
  prod <- tibble(product = sample(prod_list,
                                  size = round(runif(1, size_min, size_max), 0) ,
                                  replace = F))
    return(prod)
}
# генерируем продажи
sales <- tibble(id         = 1:200,
                manager_id = sample(managers, size = 200, replace = T),
                refund     = FALSE,
                refund_sum = 0)
# генерируем списки купленных товаров
sale_proucts <-
    sales %>%
      rowwise(id) %>%
      summarise(prod_list(products$name, 1, 6)) %>%
      left_join(products, by = c("product" = "name"))
# объединяем продажи с товарами
sales <- left_join(sales, sale_proucts, by = "id")

# возвраты
refund <- sample_n(sales, 25) %>%
          mutate( refund = TRUE,
                  refund_sum = price * 0.9) %>%
          select(-price, -manager_id)

# добавляем в таблицу продаж данные по возвратам
sales %>%  rows_update(refund)  # ОШИБКА! : первый столбец не является ключом
result <-  sales %>% rows_update(refund, by = c("id", "product"))  # исполльзуем составной ключ
