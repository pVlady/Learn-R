# Работа с файлами и директориями
```r
file.path(str1, str2, str3, ...)    ; конструирует os-независимый путь к файлу или каталогу из строковых констант
file.exist(file_name)               ; возвращает признак наличия указанного файла
file.edit(file_name)                ; открывает указанный файл во внутреннем редакторе
```
Добавление сообщения *msg* в файл *file.log*:
```r
file.log <- file(path_to_file, "a")
writeLines(msg, file.log)
close(file.log)
```
