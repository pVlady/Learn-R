#------------------------------------------------------------------------------
# Scatter Plot: x - количественная переменная;
#               y - количественная переменная
#------------------------------------------------------------------------------
ggplot(data = iris, aes(x = Sepal.Length,
                        y = Sepal.Width)) +
  geom_point(aes(color = Species,
                 shape = Species)) +
  xlab("Sepal Length") +               # подпист оси X
  ylab("Sepal Width") +                # подпись оси Y
  theme_classic() +                    # классическая тема убирает сетку и делает фон белым
  ggtitle("Sepal Length-Width")        # подписть диаграммы


#------------------------------------------------------------------------------
# Density Plot: x - количественная переменная;
#               fill - факторная переменная для размещения на диаграмме нескольких графиков
#------------------------------------------------------------------------------
ggplot(iris) + 
  geom_density(aes(x = Sepal.Width,
                   fill = Species),
               alpha=0.25) +
  theme_classic()


#------------------------------------------------------------------------------
# Bar Plot: x - факторная переменная;
#           y - одно количественное значене для каждого фактора
#------------------------------------------------------------------------------
library(dplyr)
df <- data.frame(iris %>%
		     group_by(Species) %>%
                     summarise(Mean_Sepal.Length = round(mean(Sepal.Length), digits=2)))
ggplot(data = df2, aes(x = Species, y = Mean_Sepal.Length)) +
  geom_bar(stat = "identity",     # "stat = "count" для подсчета числа наблюдений
           fill="steelblue") + 
  guides(fill = FALSE) + 
  xlab("Species") +
  ylab("Mean Sepal Length") +
  coord_flip() +               # flip over the coordinators to 90 degree
  theme_classic() +            # remove the grid lines and grey background 
  geom_text(aes(label = Mean_Sepal.Length),
            vjust=0,           # вертикальное положение цифровых подписей столбиков
            hjust = -0.05,     # горизонтальное положение цифровых подписей столбиков
            size = 4) +        # размер текста для цифровых подписей столбиков
  theme(axis.text  = element_text(size = 12, face = "bold"),  # шрифт для подписей меток
        axis.title = element_text(size = 14, face = "bold"))  # шрифт для подписей осей


#------------------------------------------------------------------------------
# Box Plot: x - факторная переменная;
#           y - набор количественных значений для каждого фактора
#------------------------------------------------------------------------------
ggplot(iris, aes(x = Species,
                 y = Petal.Length,
                 fill = Species)) +
  geom_boxplot() + 
  xlab("Species") +
  ylab("Sepal Length (cm)") + 
  theme_classic() + 
  theme(axis.text = element_text(size = 12, face = "bold"),   # шрифт для меток осей
        axis.title = element_text(size = 14, face = "bold"))  # шрифт для подписей осей

#------------------------------------------------------------------------------
# Line Plot: горизонтальная, вертикальная линии и прямая y = ax + b
#------------------------------------------------------------------------------
ggplot(...) +
# горизонтальная линия
  geom_hline(yintercept=20, linetype="dashed", color = "red", size = 1.0) +
# вертикальная линия
  geom_vline(xintercept = 3, linetype="dotted", color = "blue", size=1.5) +
# прямая
  geom_abline(intercept = 37, slope = -5, color="red", linetype="dashed", size=1.5) +
# отрезок (вертикальный)
geom_segment(aes(x = 4, y = 15, xend = 4, yend = 27)) + 
# стрелка
geom_segment(aes(x = 5, y = 30, xend = 3.5, yend = 25), arrow = arrow(length = unit(0.5, "cm")))
