# Простая двуслойная сеть
```r
library(torch)

d_in <- 3                                                 ; размерность входных параметров (число входных переменных)
n <- 100                                                  ; число наблюдений в training set
x <- torch_randn(n, d_in)                                 ; случайная генерация входных параметров
coefs <- c(0.2, -1.3, -0.5)                               ; коэффициенты линейного преобразования
y <- x$matmul(coefs)$unsqueeze(2) + torch_randn(n, 1)     ; целевые значения

; создание сети
d_hidden <- 32                                            ; число нейронов (размерность) скрытого слоя
d_out <- 1                                                ; размерность выхода сети

w1 <- torch_randn(d_in, d_hidden, requires_grad = TRUE)   ; веса передачи входных сигналов скрытому слою
w2 <- torch_randn(d_hidden, d_out, requires_grad = TRUE)  ; веса передачи сигналов скрытого слоя на выход сети
b1 <- torch_zeros(1, d_hidden, requires_grad = TRUE)      ; смещение для скрытого слоя
b2 <- torch_zeros(1, d_out, requires_grad = TRUE)         ; смещение для выхода сети

; training loop ---------------------------------------
for (t in 1:200) {  
  ; forward pass --------------------------------------  
  y_pred <- x$mm(w1)$add(b1)$relu()$mm(w2)$add(b2)
  
  ; расчет функции потерь ----------------------------- 
  loss <- (y_pred - y)$pow(2)$mean()
  if (t %% 10 == 0)
    cat("Epoch: ", t, "   Loss: ", loss$item(), "\n")
  
  ; backpropagation -----------------------------------  
  loss$backward()   ; расчет градиента функции потерь по всем тензорам, где requires_grad = TRUE
    
  with_no_grad({
  ; обновление весов ----------------------------------
     w1 <- w1$sub_(learning_rate * w1$grad)
     w2 <- w2$sub_(learning_rate * w2$grad)
     b1 <- b1$sub_(learning_rate * b1$grad)
     b2 <- b2$sub_(learning_rate * b2$grad)  
     
  ; обнуление градиентов ------------------------------ 
     # accumulate otherwise
     w1$grad$zero_()
     w2$grad$zero_()
     b1$grad$zero_()
     b2$grad$zero_()  
  })
}
```
## Оптимизаторы
На практике логику достижения минимума инкапсулируют в объектах-оптимизаторах, которые рассчитывают каждый следующий шаг процесса оптимизации, возможно изменяя  пр этом скорость обучения. Оптимизатор всегда принимает тензоры, которые нужно оптимизировать и, опционально, скорость обучения. Фактически оптимизатор значительно упрощает код, сводя его всего к нескольким функциям:
```r
model <- nn_linear(10, 2)
optimizer <- optim_sgd(model$parameters, lr = 0.1)  ; простой градиентный спуск (simple gradient descent)
...
loss$backward()                                     ; рассчитать градиент функции потерь   
optimizer$zero_grad()                               ; обнулить градиенты с предыдущего шага перед обратным проходом
optimizer$step()                                    ; обновить параметры модели, используя оптимизатор
```
### Доступные оптимизаторы в _torch_
```r
optim_sgd(model$parameters, lr = 0.1)               ; стандартный градиентный спуск с заданной скоросью обучения
optim_adam(net$parameters)                          ; ADAM
optim_lbfgs(x)                                      ; L-BFGS – оптимизирует скорость обучения, учитывая крутизну второй производной; x – оптимизируемый тензор
```

Используя оптимизаторы код обучения сети можно уростить
```r
; создание исходных данных останется без изменений
d_in <- 3
# number of observations in training set
n <- 100
x <- torch_randn(n, d_in)
coefs <- c(0.2, -1.3, -0.5)
y <- x$matmul(coefs)$unsqueeze(2) + torch_randn(n, 1)

; построение сети
d_hidden <- 32
# output dimensionality (number of predicted features)
d_out <- 1
net <- nn_sequential(
  nn_linear(d_in, d_hidden),
  nn_relu(),
  nn_linear(d_hidden, d_out)
)

; цикл обучения
opt <- optim_adam(net$parameters)
for (t in 1:200) {
  y_pred <- net(x)                    ; прямой проход
  loss <- nnf_mse_loss(y_pred, y)     ; расчет функции потерь
  if (t %% 10 == 0)
    cat("Epoch: ", t, "   Loss: ", loss$item(), "\n")
   
  opt$zero_grad()                     ; обнуление градиентов
  loss$backward()                     ; расчет градиентов
  opt$step()                          ; обновление весов
}
```
