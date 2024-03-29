# Environment

## Анализ переменных
Функция `get()` возвращает объект, имя которого задано аргументом этой функции.\
Поиск объекта осуществляется иерархически, начиная с текущего окружения и заканчивая глобальным.\
Чтобы заставить функцию начинать искать объект в окружении на ступень выше, необходимо задать аргумент `pos = 1`.\
Вызов функции без присвоения результата эквивалентен вызову функции `print()` на объекте.


Функция `get0()` эквивалентна функции `get()`, но имеет дополнительный аргумент `ifnotfound`, задающий возвращаемый функцией объект, если искомый объект не найден. Кроме того в аргументе `mode` можно задать тип обоъекта.\

Функция `mget()` аналогична функции `get0()` и имеет те же аргументы, но позволяет искать _несколько_ объектов, названия которых заданы символьным вектором. Результат возвращается в виде списка, названия элементов которого соответствуют аргументу поиска. По умолчанию в функции `mget()` отключен иерархический поиск. Чтобы задать его, нужно указать аргумент `inherits = TRUE`.

Чтобы получить объект, имя которого задано переменной `c_name` нужно выполнить `eval(base::as.name(c_name)`, либо `eval(rlang::sym(c_name))`.
```r
x2 <- c("abc", "cde", "def")  
get("x2")                                      ; эквивалентно print(x2)
get0("x2", ifnotfound = "not found")
mget(c("x1", "x2"), ifnotfound = "not found")  ; вернет список с именами элементов "x1" и "x2"
```
Функция `exists()`, возвращающая `TRUE`|`FALSE`, позволяет проверить доступность объекта с указанным именем (включая предопределенные объекты).

Функция `apropos(“x”, ignore.case, simple.word)` выводит доступные объекты, имена которых удовлетворяют шаблону поиска. Аргумент `simple.word = TRUE` заставляет искать только те переменные, для которых шаблон соответствет целому слову (по умолчанию = `FALSE`).

Функция `find(“x”, ignore.case, simple.word)` возвращает названия пакетов, где существует объект с указанным именем.

Функция `which()` возвращает индексы объектов, которые вернут `TRUE` в логическом выражении, заданном в аргументе функции. Аргумент `arr.ind = TRUE` добавляет имена к столбцам возвращаемого результата (напр., `row` и `col` при анализе матричного выражения).
