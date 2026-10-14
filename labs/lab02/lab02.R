#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 2                    #
#=======================================================#

library(dplyr)
library(ggplot2)

# 0. Zadania rozgrzewkowe -------------------------------------------------

?diamonds


# Zadanie 0.1 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr, wybierz wszystkie diamenty, 
# których szlif (cut) to "Ideal", a ich cena (price) 
# jest niższa niż 500 dolarów.




# Zadanie 0.2 -------------------------------------------------------------
# W zbiorze danych wymiary x, y oraz z nie powinny wynosić 0. 
# Wybierz te rekordy, które mają wartość 0 w kolumnie x, y lub z.





# Zadanie 0.3 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr, wybierz diament o największej liczbie 
# karatów (carat). Jeśli jest ich kilka, wyświetl wszystkie.







# 1. dplyr ----------------------------------------------------------------

# "ściągawka"
# https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf

?starwars

# a) kolejność kolumn ---> relocate()





# b) dyskretyzacja ---> ifelse(), case_when()





# c) funkcje agregujące ---> summarise(), n(), mean, median, min, max, sum, sd, quantile





# d) grupowanie ---> group_by() + summarise()






# Zadanie 1.1 -------------------------------------------------------------
# Pogrupuj postacie według gatunku (species) i policz, ile z nich należy 
# do kategorii "Short", "Average" lub "Tall".
# "Short" - poniżej 100 cm
# "Average" - między 100 a 200 cm
# "Tall" powyżej 200 cm





# 2. tidyr ----------------------------------------------------------------

library(tidyr) # https://tidyr.tidyverse.org

# a) pivot_longer()

?relig_income


# b) pivot_wider()

?fish_encounters




# Zadanie 2.1 -------------------------------------------------------------
# Wybierz pierwsze 10 postaci z tabeli starwars i kolumny name, height, mass.
# Wygeneruj dla każdej postaci nowe kolumny bazujące na wzroście i masie
# Before height = wzrost - 2
# Before mass = spadek masy o 5%
# After height = wzrost + zm. losowa z rozkładu jednostajnego [1, 5]
# After mass = masa + zm. losowa z rozkładu jednostajnego [1.01, 1.10]
# Wykorzystując pivot_longer utwórz kolumnę "moment", która niesie informację
# before, after.






# 3. ggplot2 --------------------------------------------------------------

install.packages("SmarterPoland")
library(SmarterPoland)

?countries

View(countries)


# Zadanie 3.1 -------------------------------------------------------------
# Określ typy zmiennych:
# country - 
# birth.rate - 
# death.rate - 
# population - 
# continent - 

# ggplot2
install.packages("ggplot2")
library(ggplot2)

## 1. Główna funkcja ggplot2 ----> ggplot()

ggplot()


## 2. Mapowania ----> aes()



## 3. Operator '+'


# Stosujemy podobne formatowanie jak w dplyr

# Łączenie przez pipes %>% (skrót Ctrl + Shift + m)




