# Визуализация данных с помощью библиотеки ggplot2
## Случаи использования разных типов диаграмм
* *Гистограмма* используется для отображения непрерывной числовой переменной. По сути это *barplot*, построенный на результатах факторизации числовой переменной разбиением ее области значений на интервалы. Выводится либо частотность заполнения интервалов, либо количество наблюдений в каждом из них.


## Функция `qplot()`
```r
qplot(x, y = NULL, data, geom = "auto", 
      xlim = c(NA, NA), ylim =c(NA, NA),   ; диапазоны шкал
      xlab = NA, ylab = NA,                ; подписи осей
      log = NA,                            ; признак логарифмической шкалы (допустимые значения 'x', 'y', 'xy')
      color = NULL,                        ; переменная цвета обводки (для факторной переменный используются цвета палитры, на непрерывной — цветовая шкала)
      fill = NULL,                         ; переменная для цвета заполнения, напр., столбиков гистограммы или областей под кривыми для geom = 'density'
      size = NULL,                         ; переменная размера точек (факторная или непрерывная)
      shape = NULL,                        ; переменная формы точек (факторная переменная)
      linetype = NULL,                     ; переменная типи линии (или фиксированное значение)
      label = NA, hjust=0, vjust=0         ; подписи точек и координаты их размещения (должен быть указан geom=c("point", "text"))
      main = NA)                           ; название диаграммы
      
```
* Обязательным аргументом является только `x`.
* Если аргумент `y` не задан, по умолчанию будет построена гистограмма (*histogram*); в противншом случае — диаграмма рассеяния (*point*). Аргумент `geom` может принимать вектор, напр., `c('point', 'smppth')` для отображения на диаграмме нескольких элементов. 
* Если аргументы `x` и `y` являются столбцами датафрейма, то он должен быть указан в аргументе `data`.
* Для каждого типа диаграмм могут быть указаны специфичные аргументы, напр., `bins` для гистограмм или `group` для столбчатой диаграммы (`geom = 'col'`)

```r
library(ggplot2)
library(dplyr)
library(readr)
library(forcats)

# продажи по месяцам, столбчатая диаграмма
data %>%
  mutate(month = as.Date(date, "%d.%m.%Y") %>%   ; преобразовать текст к типу даты
  mutate(month = format(date, "%Y-%m"))    %>%   ; отформатировать дату как yyyy-mm
  group_by(month, shop) %>%                      ; сгруппировать данные помесячно
  count()               %>%                      ; подсчитать число операций в каждой группе
  qplot(data = .,                                ; quick plot
        x = month,
        y = n,
        fill = shop,                             ; разные магазины раскрасить своим цветом
        geom = "col",                            ; столбчатая диаграмма (col|line|point|boxplot|histogram - можно комбинировать с('line', 'point'))
        group = shop,                            ; сделать столбец составным для отображения вклада каждого магазина
        main = "Число операций по месяцам",
        xlab = "Месяц",
        ylab = "Число операций")
```
Для изменения порядка значений категориальной переменной по оси x используют функцию
``` r
x = forcats::fct_reorder(.f = brand,              ; ось, которую нужно пересортировать
                         .x = price - discount    ; значения для сортировки
                         .fun = median,           ; функция для получения значений, используемых при сортировке
                         .desc = FALSE)
```

Построение гистограммы (в последнем аргументе, если указать `~shop`, графики будут расположены горизонтально;
вместо `shop~.` можно анализировать влияние одной категориальной переменной на другую, напр., `manager~shop`)
``` r
df %>%
  qplot(data = .,
        x = sum,
        geom = histogram,
        fill = "darkcyan",
        bins = 50,           ; число столбиков гистограммы
        facets = shop~.)     ; для кадого магазина простроить свою диаграмму (разбиение по категориальной переменной)
```
  
### Функция ggplot  
``` r
  ggplot( aes(x = month, y = transactions) ) +    ; основной слой
    geom_col( aes( fill = transactions ),         ; слой столбцатой диаграммы
              show.legend = FALSE) +
    labs(title = "Количество продаж за 2019 год", ; заголовок
         subtitle = "по месяцам")  +              ; подзаголовок
    xlab("Месяц") +                               ; подпись X
    ylab("Количество продаж") +                   ; подпись y
  scale_fill_gradient2(low = "red",               ; цвет заливки, минимального значения
                       mid = "gray",              ;   средние значения                       
                       high = "limegreen",        ;   максимальные значения
                       midpoint = 81.5)           ;   что считать средним значением
```

#### Виды диаграмм
``` r
geom_bar(stat="identity"|"count", position=position_dodge(), colour="black") 
geom_line(size = 0.1) + 
  expand_limits(y=0) +                       # set y range to include 0
  scale_colour_hue(name="Sex of payer",      # set legend title
                   l=30)  +  ...             # use darker colors (lightness=30)
geom_point(size = 1)
geom_col()
geom_histogram()
coord_flip()           ; поворачивает диаграмму на 90 градусов
facet_grid(~shop)      ; разбиение графиков по категориальной переменной
```
#### Дополнительные настройки диаграммы
``` r
annotate("text",              ; добавляем текстовый блок
         x = "BMW", y = 110,  ; координаты вывода
         label = "Top",       ; содержимое надписи
         colour = "red",      ; цвет текста
         size = 4,            ; размер шрифта
         fontface = "bold")   ; жирный шрифт
```
### Темы
``` r
devtools:install_github('cttobin/ggthemr')
library(ggthemes)
library(ggthemr)
plot <- ggplot(...)

# готовые темы
plot + theme_stata()
plot + theme_excel()
plot + theme_economist()
plot + theme_calc()

# темы из пакета ggthemr настраиваются глобально для всего последующего вывода и требуют сброса в конце работы
ggthemr('flat dark')
plot
ggthemr('flat')
plot
ggthemr('camoflauge')
plot
ggthemr('solarized')
plot
ggthemr_reset()   ; сброс темы
```
#### Модификация тем
Модифицируем текущую тему; сохраняем ее в переменную, а затем применяем к графикам:
``` r
theme_custom_blue <- 
  theme(
    legend.position = 'none',                           # убираем легенду
    title = element_text(colour = 'royalblue4',         # определяем свойства заголовка
                         face = 'bold'), 
    plot.subtitle = element_text(colour = 'royalblue3', # редактируем подзаголовок
                                 face = 'italic', ),
    axis.title = element_text(colour = 'gray28',        # названия осей
                              face = 'bold.italic'), 
    axis.text.y = element_text(face = 'italic',         # метки оси Y
                               size = 7), 
    axis.text.x = element_text(angle = 90,              # поворачиваем подпись оси X
                               hjust = 1, 
                               vjust = 0.5, 
                               size = 9), 
    panel.background = element_rect(fill = 'skyblue1'), # фон области построения
    panel.border = element_rect(colour = 'dodgerblue4', # рамка области построения
                                fill = NA),
    panel.grid = element_line(color = "skyblue4",       # сетка области построения
                              size = 0.1, 
                              linetype = 'dotted'), 
    plot.background = element_rect(fill = 'powderblue') # общий фон диаграммы
  )

# применяем созданную тему
plot + theme_custom_blue
```

## References
[ggplot2 - Essentials | Примеры диаграмм](http://www.sthda.com/english/wiki/ggplot2-essentials)

