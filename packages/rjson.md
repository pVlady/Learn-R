# rjson
```r
library("rjson")
result <- fromJSON(file = "J:/example.json")   ; считывает json-файл в список
jsonData <- toJSON(list1)                      ; создание данных из списка для записи в json-файл
write(jsonData, "result.json")                 ; сохранение в json-файл

# преобразование даннаых json-файла в data.frame
json_data_frame <- as.data.frame(fromJSON(file = "J:/example.json"))
```
