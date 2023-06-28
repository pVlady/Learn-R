# Заметки по коду на R

### [Номер календарного месяца с ведущим нулем](https://stackoverflow.com/questions/14409084/pad-with-leading-zeros-to-common-width)
В датафрейме `df` имеем столбец `Month` – календарные месяцы года как числа от 1 до 12.\
Преобразовать `1...9` в значения с ведущим нулем `01...09` можно такими способами:
```r
library(stringr)
ZMonth <- sprintf("%02d", df$Month)                                 ; самый быстрый способ                          
ZMonth <- formatC(df$Month, width = 2, flag = 0)                    ; ~ в 18 раз медленее sprintf()
ZMonth <- str_pad(df$Month, width = 2, side = "left", pad = "0")    ; ~ в 4 раза медленее sprinf()
```

