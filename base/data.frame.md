## Базовый тип data.frame

### Переименование столбцов
```r
names(df) <- c("COL1", "COL2", "COL3")        ; переименование трех первых столбцов
names(df)[names(df) == "Col4"] <- "COL4"      ; переименование конкретного столбца (Col4)
names(df)[] <- "COL4"                         ; переименование четвертого столбца
dplyr::rename(df, new_col1 = old_col1,        ; переименование с использованием пакета dplyr
                  new_col2 = old_col2, ...)
data.table::setnames(df,                      ; переименование с использованием пакета data.table
                     old = c("col1","col2"),
                     new = c("COL!", "COL2"))
```
