# data.table

### Общие функции
```r
nrow(dt)     ; число строк в таблице
ncol(dt)     ; число столбцов в таблице
names(dt)    ; названия столбцов таблицы
setDT(df)    ; inplace-преобразование датафрейма в объект data.table
```
### Параметры по умолчанию оператора `[`
```r
[(dt, i, j, by, keyby,
  with = TRUE,
  nomatch = NA,
  mult = "all",
  roll = FALSE,
  rollends = if (roll == "nearest") c(TRUE, TRUE) else if (roll >= 0) c(FALSE, TRUE) else c(TRUE, FALSE),
  which = FALSE,
  .SDcols,
  verbose = getOption("datatable.verbose"),                   ; default: FALSE
  allow.cartesian = getOption("datatable.allow.cartesian"),   ; default: FALSE
  drop = NULL, on = NULL, env = NULL)
```
Кроме `i`, `j`, `by` в выражении `dt[i, j, by]` могут использоваться:
* `with`, `which` — `with = FALSE` использовать синтаксис *data.frame* при обращении к *data.,table*
* `allow.cartesian`
* `roll`, `rollends` — для скользящих соединений таблиц
* `.SD`, `.SDcols` — для указания столбцов, с которыми должны производиться операции (*Subset of Data.Table*)
* `on` — для указания столбцов, по которым производиться соединение
* `mult` = `"first"`|`"last"` — позволяет выбрать первую|последнюю запись в группе
* `nomatch` — для выбора типа соединения таблиц (`nomatch = NA|NULL` : `outer join`|`inner join`)
* `.EACHI` — 

### Удаление дубликатов
* Если для таблицы `dt` установлен ключ, то вызов `unique(dt)` вернет уникальные значения ключа.
* Если ключ отсутствует, то `unique(dt)` вернет уникальные строки таблицы.

### Выборка строк
```r
dt[x %between% c(7,9)]
dt[!x %in% c("JFK", "LGA")]
; или так
setkey(dt, x)
dt[c("JFK", "LGA")]
;
setkey(dt, x, y)
dt[.("JFK", "MIA")]7
```

### Выборка столбцов
```r
dt[, col1]                                ; вернет один столбец как вектор
dt[, .(x, y, z)]                          ; вернет несколько столбцов как новый data.table
dt[, 1:3, with = FALSE]                   ; первые три столбца (синтаксис data.frame)
dt[, c("x","y","z"), with = FALSE]        ; вернуть указанные столбцы (синтаксис data.frame)
dt[, cols, with = FALSE)                  ; вернуть столбцы, названия которых заданы переменной cols
dt[, !c("x, "y"), with = FALSE]           ; вернуть все столбцы кроме столбцов x и y
dt[, names(dt) %like% "dep", with=FALSE]  ; вернуть столбцы, названия которых удовлетваряют образцу
```
* `.SD` : *Subset of the Data.table* – ссылается на все столбцы, за исключением столбцов группировки. Может быть переопределено аргументом `SDcols`.
* Группирующая переменная, если используется в выражении `j`, всегда имеет размерность 1 и содержит значение группы.
* Чтобы вывести нужное количесво строк функцией `print()` можно использовать `print(dt, topn = 20)`.
 
>*Для получения некоторого набора элементов из массива в виде вектора необходимо использовать синтаксис* `dt[mx]`*, где* `mx` *это матрица с количеством столбцов равным количеству индексов в массиве, а каждая строка матрицы представляет собой индексы извлекаемых элементов. Вместо числовых индексов также можно использовать имена для строк и столбцов матрицы.*

### Создание, переименование и изменение порядка столбцов
```r
dt[, col4 := ifelse(col2 < 50, 0, 1)]               ; inplace-создание одного столбца
dt[, `:=`(col4 = sqrt(col2), col5 = col1 + col2]    ; inplace-создание нескольких столбцов
dt[, c("col4","col5"):=.(sqrt(col2), col1 + col2)]  ; то же самое

setnames(dt, c("col1", "col2"), c("new1", "new2"))  ; inplace переименование столбцов
setcolorder(dt, c("col3", "col2", "col1")           ; inplace изменение порядка столбцов (могут быть указаны только несколько первых, остальные не меняются)
```
### Сортировка таблицы
```r
setorder(dt, -x, y)
```

### Группировка
```r
dt[, lapply(.SD, mean)]                            ; вычисление среднего для всех столбцов
dt[, lapply(.SD, mean), .SDcols = c("x", "y")]     ; вычисление среднего для указанных столбцов
dt[, .SD[1:3], by = x]                             ; первые три строки в сгруппированных по x данных
dt[, .SD[.N], by = x]                              ; последняя строка в сгруппированных по x данных
dt[, rank:=frank(-y,ties.method = "min"), by = x]  ; ранжирование в обратном порядке y внутри групп x
```

### Сдвиг данных в таблице
```r
dt[ , x2 := shift(x, 1, type="lag")]
dt[ , x3 := shift(x, 1, type="lead")]
```

### Соединения таблиц
У соединяемых таблиц должен быть установлен ключ по столбцам, которые участвуют в соединении. В противном случае столбцы соединения должны быть указаны аргументом `on`.
```r
merge(dt1, dt2, by = "x")                ; INNER JOIN        ; dt1[dt2, nomatch = NULL]
merge(dt1, dt2, by = "x", all.x = TRUE)  ; LEFT JOIN         ; dt2[dt1]
merge(dt1, dt2, by = "x", all.y = TRUE)  ; RIGHT JOIN        ; dt1[dt2]
merge(dt1, dt2, all = TRUE)              ; FULL OUTER JOIN   ; dt1[dt2, nomatch = NA]

dt[x, on="id"]               ; right join    : SELECT DT RIGHT JOIN X (одноименные столбцы x переименовываются с добавлением `i.`)
x[dt, on="id"]               ; left join     : SELECT X RIGHT JOIN DT ON DT$id != X$id
dt[x, on="id", nomatch = 0]  ; inner join    : SELECT DT INNER JOIN X ON DT$id != X$id
dt[!x, on="id"]              ; not join      : SELECT DT LEFT JOIN X ON DT$x != X$x
dt[x, on=.(id <= foo)]       ; non-equi join : SELECT DT RIGHT JOIN X ON DT$id <= X$foo
dt[x, on = "y <= foo"]       ; same as above
dt[x, on = c("y <= foo")]    ; same as above
dt[x, .(id, v, i.id, i.foo), ; указать, какие столбцы нужно вернуть
      on=.(id, y >= foo)]
dt[x, on=.(id, y <= foo)]    ; non-equi join : SELECT DT RIGHT JOIN X ON DT$id = X$id AND DT$y <= x$foo
dt[x, on=.(x, v >= v),       ; non-equi join with by=.EACHI
      sum(y) * foo,
      by = .EACHI]
```
* При соединении таблиц в синтаксисе dt[x, on='id'] дополнительный аргумент:
  * `nomatch = NA`          реализует *outer join*
  * `nomatch = NULL`        реализует *inner join*
  * `mult = "first"|"last"` выберет из каждой группы первую|последнюю запись
  
[How to do joins with data.table](https://gist.github.com/nacnudus/ef3b22b79164bbf9c0ebafbf558f22a0)

## Дополнительные замечания
* Синтаксис `dt[ ][ ][ ]` позволяет строить последовательные подзапросы для получения данных.
* Обращение к элементам data.table, как правило, возвращает объект data.table
* Обращение к столбцам по их номерам (как при работе с data.frame) не рекомендуется — следует указывать имена столбцов.
* `dt[2]` вернет *data.table*, содержащий вторую строку (`df[2]` вернет второй столбец как *data.frame*).
* `dt[2, 2]` вернет *data.table*, содержащий одно значение второй строки второго столбца (`df[2, 2]` вернет вектор размера 1).
* `dt[["Col2"]]` или `dt[[2]]` : самый быстрый способ вернуть вектор-столбец из объекта data.table.
* `dt[, X + Y]` вернет вектор (т.к. названия столбцов трактуются как обычные переменные), тогда как `dt[, .(X + Y)]` вернет *data.table*.
* Чтобы вернуть столбцы, названия которых заданы значениями переменной `x` для data.frame достаточно указать `df[, x]`. Для data.table необходимо использовать `dt[, x, with = FALSE]` (иначе будет осуществлен поиск столбца с названием `x`). Чтобы вернуть столбец, название которого задано переменной `x` можно использовать синтаксис `dt[[x]]`.

Опция `options(datatable.WhenJisSymbolThenCallingScope=TRUE)` изменяет поведение по умолчанию для data.table на поведение, аналогичное поведению data.frame.
* `X[Y, sum(foo*bar), by = .EACHI]` : группирует результат соединения по каждому значения ключа

* `dt[NA]` вернет одну строку со значениями `NA` для всех столбцов. То же самое вернет `dt[i]`, если значение `i` превышает число строк в таблице.
* `dt[0]` или `dt[FALSE]` вернут пустую таблицу той же структуры, что и `dt`.
* Чтобы получить вывод таблицы, содержащей операцию `:=` нужно добавть в конце `[]`.
* Создание индекса в таблице не увеличивает потребность в RAM, поскольку при этом производится только пересортировка строк и помечаются столбцы, входящие в индекс (все аналогично clustered index в SQL). Вторичные индексы занимают дополнительные `4*nrow` байт в памяти. Как правило, они создаются автомитически при задании логических условий в `i`, использующих операторы `==` и `%in%`.
* Для таблицы, загруженной с помощью `readRDS()` или `load()`, рекомендуется вызввать функцию `setalloccol()`, т.к. сохранение таблицы в бинарном формате нарушает оптимизацию ее размещения в RAM.



## Examples
```r
; вычисляет число записей по месяцам и сортирует результат по убыванию
dt[, .N, by = month] [order(-N)]

; найти три месяца с наибольшим средним значением x
dt[, .(mean_x = mean(x, na.rm = TRUE)), by = month][order(-mean_x)][1:3]
```

## References
* [Enhanced data.frame](https://rdatatable.gitlab.io/data.table/reference/data.table.html)
* [Frequently Asked Questions about data.table](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-faq.html#why-does-xy-return-all-the-columns-from-y-too-shouldnt-it-return-a-subset-of-x)
* [data.table | Documentation on GitHub](https://github.com/Rdatatable/data.table/wiki)
* [R – Data.Table Rolling Joins](https://www.gormanalysis.com/blog/r-data-table-rolling-joins/)
* [Data manipulations | Филипп Управителев](https://webinars.rintro.ru/data-manipulations.html#dt1dt2-merge)

