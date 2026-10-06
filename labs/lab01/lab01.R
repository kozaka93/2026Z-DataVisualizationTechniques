#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 1                    #
#=======================================================#

# 0. Prowadzący  -------------------------------------------------------------

# Anna Kozak/Karolina Dunal/Mikołaj Rymajdo/Franciszek Saliński/Katarzyna Woźnica
# Kontakt: MS Teams lub mail


# 1. Sposób pracy na zajęciach laboratoryjnych -------------------------------

# a) pracujemy w R (większość semestru) i Python
# b) pracujemy na przygotowanych plikach, które będą na repozytorium przedmiotu
# c) podczas zajęć prowadzący będzie wprowadzał zagdanienia, a następnie będzie
#    rozwiązywanie zadań w celu utrwalenia wiadomości
# d) kolejna porcja materiału będzie omawiana jeżeli większość grupy wykona 
#    zadane zadanie 
# e) wszelkie pytania czy to związane z kodem, pracą domową czy kwestie 
#    teoretyczne proszę śmiało zgłaszać prowadzącemu 
# f) często na początku zajęć pojawią się zadania na rozrzewkę, 
#    powtórzeniowe z poprzednich lab




# 2. Materiały ------------------------------------------------------------

# Repozytorium na GitHub
# https://github.com/kozaka93/2026Z-DataVisualizationTechniques



# 3. Powtórka R base ------------------------------------------------------



# 4. dplyr -------------------------------------------------------------------


library(dplyr) # https://dplyr.tidyverse.org/

# Dane
starwars
starwars_new <- starwars[, c(1, 2, 3, 4, 5, 7, 8)]

# Informacje o zbiorze danych


# Podgląd tabeli


# Określamy typy zmiennych:
# name - 
# height - 
# mass -
# hair_color - 
# skin_color - 
# birth_year - 
# sex - 

# 1) Wybór wierszy i kolumn w dplyr


# a) wybór kolumn ---> select()


# b) wybór wierszy ---> filter()


# 2) pipes %>% (skrót Ctrl + Shift + m)



# Zadanie 4.1 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz te postacie, których gatunek 
# to Droid, a ich wysokość jest większa niż 100.



# Zadanie 4.2 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz te postacie, które nie mają 
# określonego koloru włosów.


# c) sortowanie wierszy ---> arrange()



# Zadanie 4.3 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz postać o największej masie.


# d) transformacja zmiennych ---> mutate()


# e) transformacja zmiennych ---> transmute()



