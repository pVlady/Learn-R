# Некоторые функции базового R

### `scale()`
> *Масштабирует значения в векторе, матрице или датафрейме.*\
> Нормализация позволяет корректоно сравнивать данные, измеренные в разных единицах измерений.

```r
scale(x, center = TRUE, scale = TRUE)  ; center – вычитать среднее, scale – делить на станд. отклюнения.
```
$$
xscaled = \frac{x – x̄}{s}
$$

В качетсве `x` может выступать числовой вектор, матрица или датафрейм.
Результат, кроме нормализованных данных, содержит два атрибута: `"scaled:center"` и `"scaled:scale"`.


