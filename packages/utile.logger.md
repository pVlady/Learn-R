# futile.logger
Пакет для логгирования событий. События могут иметь один из уровней: TRACE, DEBUG, INFO, WARN, ERROR, FATAL.
```r
library(futile.logger)
flog.info("The variance of the sample is %s", var(x))  ; поддерживается форматирование для вывода значений переменных
flog.warn("This statement has higher severity")
flog.fatal("This one is really scary")

flog.threshold(ERROR)   ; устанавливает порог логирования на указанном уровне и выше
```
* Можно использовать несколько логгеров, отличая их по именам. При этом явно создавать логгер не нужно, т.к. все логгеры наследуются от корневого логгера, доступного по умолчанию.
* Если в вызове функции пакета не указан аргумент `name` с именем логгера, то результат применяется к корневому логгеру и наследуется всеми остальными.
* По умолчанию устройством логгирования является стандартный ввод-вывод. Для добавления других каналов используется *appender*.
* Допускается создание пользоватлеьских *appender*, для чего необходимо определить лишь функцию со следующей сигнатурой `appender.fn <- function(line) {...}`.
* В пакете уже определены два *appenders*, которые можно использовать: `appender.console()` и `appender.file(имя файла)`.
* Для переопределения формата вывода используют *layout*, который необходимо определить функцией со следующей сигнатурой: `layout.fn <- function(level, message, ...) {...}`
```r
flog.info("Loading data.frame", name='data.io')    ; лог-сообщение для логгера data.io
flog.threshold(TRACE, name='data.io')              ; установка порогового уровня соощений для логгера data.io
flog.appender(appender.file("data.io.log"),        ; добавление вывода лолг-сообщений в файл для логгера data.io
              name="data.io")

flog.appender(appender.fn)                         ; присоединить appender, заданный указанной функцией к корневому логгеру
flog.appender(appender.fn, name='test.logger')     ; присоединить appender, заданный указанной функцией к логгеру test.logger
flog.layout(layout.fn)                             ; присоединить layout к корневому логгеру
flog.layout(layout.fn, name='test.logger')         ; присоединить layout к логгеру test.logger
```
Если какой-либо внешний пакет использует для вывода сообщений *futile.logger*, можно установить уровень выводимых этим пакетом сообщений:
```r
flog.threshold(WARN, name = 'tawny')    ; установка уровня сообщений для пакета tawny
```
