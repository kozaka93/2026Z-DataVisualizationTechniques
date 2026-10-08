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
#install.packages("dplyr")

# Dane
starwars
starwars_new <- starwars[, c(1, 2, 3, 4, 5, 7, 8)]

# Informacje o zbiorze danych
dim(starwars_new)
names(starwars_new)
str(starwars_new)

# Podgląd tabeli
View(starwars_new)

# Określamy typy zmiennych:
# name - jakościowa, nominalna
# height - ilościowa, ilorazowa 
# mass - ilościowa, ilorazowa
# hair_color - jakościowa, nominalna 
# skin_color - jakościowa, nominalna
# birth_year - ilościowa, przedziałowa
# sex - jakościowa, binarna/nominalna

# 1) Wybór wierszy i kolumn w dplyr


# a) wybór kolumn ---> select()


select(starwars, name)
select(starwars, name, gender, mass)

select(starwars, -name)
select(starwars, -name, -skin_color, -species)

select(starwars, 1, 2, 3)

# b) wybór wierszy ---> filter()

# bazowy R
starwars[starwars$eye_color == "blue",]

# Note:
# Komentarz Ctrl + Shift + c
# Formatowanie Ctrl + Shift + a

filter(starwars, eye_color == "blue")
filter(starwars, eye_color == "blue", hair_color == "blond")
filter(starwars, eye_color == "blue" & hair_color == "blond")
filter(starwars, eye_color == "blue" | hair_color == "blond")

# 2) pipes %>% (skrót Ctrl + Shift + m)

starwars %>% 
  filter(eye_color == "blue") %>% 
  select(name) %>% 
  head(3)
# tail(3)

# Zadanie 4.1 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz te postacie, których gatunek 
# to Droid, a ich wysokość jest większa niż 100.

starwars %>% 
  filter(species == "Droid", height > 100) %>% 
  select(name)


# Zadanie 4.2 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz te postacie, które nie mają 
# określonego koloru włosów.

starwars$hair_color

starwars %>% 
  filter(is.na(hair_color)) %>% 
  select(name)

# c) sortowanie wierszy ---> arrange()


starwars %>% 
  filter(is.na(hair_color)) %>% 
  arrange(height)

starwars %>% 
  filter(is.na(hair_color)) %>% 
  arrange(desc(height))

starwars %>% 
  filter(is.na(hair_color)) %>% 
  arrange(-height)

starwars %>% 
  filter(is.na(hair_color)) %>% 
  slice_max(height, n = 1)

starwars %>% 
  filter(is.na(hair_color)) %>% 
  slice_min(height, n = 1)

?top_n

# Zadanie 4.3 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz postać o największej masie.

starwars %>% 
  slice_max(mass, n = 1)


# d) transformacja zmiennych ---> mutate()

starwars %>% 
  mutate(height_m = height/100,
         height_cm = height_m * 100) %>% 
  View()


# e) transformacja zmiennych ---> transmute()

starwars %>% 
  transmute(height_m = height/100) %>% 
  View()


# Zadanie 4.4 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wylicz wskaźnik BMI (kg/m^2) i wskaż 
# postać, która ma największy wskaźnik.

starwars %>% 
  mutate(height_m = height/100,
         BMI = mass/height_m^2) %>% 
  slice_max(BMI, n = 1) %>% 
  select(name, BMI)
