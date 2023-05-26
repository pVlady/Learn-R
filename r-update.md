# Обновление версии R
После установки новой версии R возникает необходимость обновления пакетов.

Это можно сделать обновлением пакетов, если скопировать их из библиотеки старой версии в новую и выполнить в консоли новой версии `update.packages(checkBuilt = TRUE, ask = FALSE)`.

Либо сделать чистую установку пакетов в новой версии R.\
Для этого сперва в старой версии сохраняем всю необходимую информацию об установленных пакетах:
```r
requery(tidyverse)

allmypackages <- as.data.frame(installed.packages())

allmypackages <- allmypackages %>%
  filter(Priority != "base" | is.na(Priority)) %>%
  select(-c(Enhances:MD5sum, LinkingTo:Suggests)) %>%
  droplevels()
str(allmypackages)

package_source <- function(pkg){
  x <- as.character(packageDescription(pkg)$Repository)
  if (length(x) == 0) {
    y <- as.character(packageDescription(pkg)$GithubRepo)
    z <- as.character(packageDescription(pkg)$GithubUsername)
    if (length(y) == 0) {
      return("Other")
    } else {
      return(str_c("GitHub repo = ", z, "/", y))
    }
  } else {
    return(x)
  }
}

# What's in your libraries?
allmypackages$whereat <- sapply(allmypackages$Package, package_source)
str(allmypackages)

table(allmypackages$whereat)

allmypackages %>% 
  filter(whereat == "Other") %>%
  select(Package, Version)

write.csv(allmypackages, "mypackagelist_2023_04.csv")
```
И затем, в новой версии производим чистую установку пакетов на основе сохраненной информации:
```r
requery(tidyverse)

oldpackages <- read.csv("mypackagelist_2023_04.csv")
allmypackages <- as.data.frame(installed.packages())
allmypackages <- allmypackages %>%
  filter(Priority != "base" | is.na(Priority)) %>%
  select(-c(Enhances:MD5sum, LinkingTo:Suggests))
thediff <- anti_join(oldpackages, allmypackages, by = "Package")

# Just do it!
thediff %>%
  filter(whereat == "CRAN") %>%
  pull(Package) %>%
  as.character %>%
  install.packages

# Что осталось за бортом?
thediff %>%
  filter(whereat != "CRAN") %>%
  select(Package, Version, NeedsCompilation, whereat)
```
Пакеты с Github доставляем с помощью `remotes::install_github("...")`.

----
[Upgrading to R 3.6.0 on a Mac – May 14, 2019](https://ibecav.github.io/update_libraries/)\
[R In Action](https://t.me/r_in_action/197)
