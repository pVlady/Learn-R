## Установка пакетов
После установки пакета `torch` установка не завершается полностью и требудется запуск функции `install_torch()`.  
Кроме самого пакета `torch` устанавливаем следующие пакеты: `torchvision` для работы с изображениями; `torchaudio` звуком и пакет `luz`, который предоставляет удобную обертку для выполнения операций по обучению нейросетей.
```r
install.packages("torch")
install_torch()
install.packages(c("torchvision", "torchaudio", "luz"))
```
