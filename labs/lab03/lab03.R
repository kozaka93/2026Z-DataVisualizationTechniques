#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 3                    #
#=======================================================#

library(dplyr)
library(ggplot2)

# 0. Zadania rozgrzewkowe -------------------------------------------------

?msleep
# Note: dane z pakietu ggplot2, dane na temat snu ssaków

?diamonds
# Note: dane z pakietu ggplot2, dane na temat diamentów

## Zadanie 0.1 -------------------------------------------------------------
# Używając zbioru danych msleep wykonaj następujące kroki:

# 1) Wybierz zwierzęta, które ważą powyżej 100 kg (bodywt)

# 2) Stwórz nową kolumnę sleep_total_min, która
# przeliczy całkowity czas snu (sleep_total) na minuty.

# 3) Oblicz średni czas snu w minutach dla każdej grupy (order).

# Która grupa ssaków śpi najdłużej a która najkrócej?









## Zadanie 0.2 -------------------------------------------------------------
# Używając zbioru danych diamonds stwórz wykres punktowy, gdzie na osi X 
# znajdzie się liczba karatów (carat), a na osi Y cena (price).

# Nadaj punktom kolory w zależności od szlifu diamentu (cut).

# Dodaj do wykresu odpowiednie etykiety: tytuł "Zależność ceny od masy diamentu"
# oraz polskie nazwy osi.












# 1. ggplot2 --------------------------------------------------------------


## Badanie rozkładu jednej zmiennej - zmienna jakościowa ------------------


## a) wykres słupkowy - geom_bar(), geom_col() ----------------------------






# !Note: W przypadku funkcji geom_col() trzeba przygotować
# tabelę ze zliczeniami.



# Zadanie 1.1 -------------------------------------------------------------
# Zbadaj rozkład zmiennej kolor diamentu (kolumna "color").
# Zadbaj o czytelność wykresu.



## Badanie rozkładu jednej zmiennej - zmienna ilościowa -------------------


## a) histogram - geom_histogram() ----------------------------------------









# !Note: część wykresu możemy przypisywać do zmiennej.






## b) wykres pudełkowy - geom_boxplot() -----------------------------------



## c) wykres gęstości - geom_density() -----------------------------------



# Zadanie 1.2 -------------------------------------------------------------
# Zbadaj rozkład zmiennej cena (price).
# Zadbaj o czytelność wykresu.








## Badanie rozkładu dwóch zmiennych - zmienne ilościowe -------------------


# a) wykres punktowy ------------------------------------------------------


## Badanie rozkładu dwóch zmiennych - zmienna jakościowa i ilościowa ------

# a) wykres punktowy ------------------------------------------------------



# b) wykres skrzypcowy ----------------------------------------------------



# c) wykres gęstości z podziałem na kolory --------------------------------



# !Note: notacja naukowa 
options(scipen = 6)




# Zadanie 1.3 -------------------------------------------------------------
# Stwórz wykres rozproszenia, który pokaże zależność między masą diamentu (carat)
# a jego ceną (price). Zadbaj o czytelność wykresu.





# Zadanie 1.4 -------------------------------------------------------------
# Założmy, że objętość diamentów wyliczamy jako iloczyn x, y i z. Wybierzmy
# diamenty o objętości mniejszej niż 50, ale większej niż 0. 
# Zaprezentuj rozkład ceny diamentów w zależności od jakości szlifu (cut).
# Zadbaj o czytelność wykresu.


