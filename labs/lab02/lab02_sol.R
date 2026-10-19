#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 2                    #
#=======================================================#

library(dplyr)
library(ggplot2)

# 0. Zadania rozgrzewkowe -------------------------------------------------

?diamonds
diamonds

# Zadanie 0.1 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr, wybierz wszystkie diamenty, 
# których szlif (cut) to "Ideal", a ich cena (price) 
# jest niższa niż 500 dolarów.

diamonds %>%
  filter(cut == "Ideal", price < 500)

# Zadanie 0.2 -------------------------------------------------------------
# W zbiorze danych wymiary x, y oraz z nie powinny wynosić 0. 
# Wybierz te rekordy, które mają wartość 0 w kolumnie x, y lub z.

diamonds %>%
  filter(x == 0 | y == 0 | z == 0)


# Zadanie 0.3 -------------------------------------------------------------
# Używając funkcji z pakietu dplyr, wybierz diament o największej liczbie 
# karatów (carat). Jeśli jest ich kilka, wyświetl wszystkie.

diamonds %>% 
  slice_max(carat)

# 1. dplyr ----------------------------------------------------------------

# "ściągawka"
# https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf

?starwars

# a) kolejność kolumn ---> relocate()

starwars %>%
  relocate(sex:homeworld, .before = height)

starwars %>%
  relocate(sex:homeworld, .after = height)

starwars %>%
  relocate(where(is.numeric), .after = where(is.character)) %>%
  View()


# b) dyskretyzacja ---> ifelse(), case_when()

starwars %>%
  mutate(species_new = ifelse(species == "Human", "Human", "Other")) %>%
  select(name, species, species_new) %>%
  tail()

starwars %>%
  mutate(species_new = case_when(
    species == "Human" ~ "Human",
    species == "Droid" ~ "Droid",
    TRUE ~ "Other"
  )) %>%
  select(name, species, species_new) %>%
  tail()

# c) funkcje agregujące ---> summarise(), n(), mean, median, min, 
# max, sum, sd, quantile

summary(starwars$height)

starwars %>%
  summarise(
    mean_height = mean(height, na.rm = TRUE),
    var = var(height, na.rm = TRUE),
    IQR = IQR(height, na.rm = TRUE),
    q_35 = quantile(height, 0.35, na.rm = TRUE)
  )


starwars %>%
  filter(hair_color == "blond") %>%
  summarise(n = n())


# d) grupowanie ---> group_by() + summarise()

starwars %>%
  group_by(species, eye_color) %>%
  summarise(mediana = median(mass, na.rm = TRUE))
# na.rm = TREU - usuwa braki danych w zmiennej i wtedy liczy statystykę

# Zadanie 1.1 -------------------------------------------------------------
# Pogrupuj postacie według gatunku (species) i policz, ile z nich należy 
# do kategorii "Short", "Average" lub "Tall".
# "Short" - poniżej 100 cm
# "Average" - między 100 a 200 cm
# "Tall" powyżej 200 cm

# I sposób
starwars %>%
  filter(!is.na(height)) %>%
  mutate(height_cat = ifelse(height > 200, 
                             "Tall", 
                             ifelse(height < 100, 
                                    "Short", 
                                    "Average"))) %>%
  group_by(height_cat, species) %>%
  summarise(n = n())

# II sposób
starwars %>%
  filter(!is.na(height)) %>%
  mutate(
    height_cat = case_when(
      height < 100 ~ "Short",
      height >= 100 & height <= 200 ~ "Average",
      height > 200 ~ "Tall"
    )
  ) %>%
  group_by(height_cat, species) %>%
  summarise(n = n())


# 2. tidyr ----------------------------------------------------------------

library(tidyr) # https://tidyr.tidyverse.org

# a) pivot_longer()

?relig_income

relig_income %>% 
  pivot_longer(!religion, names_to = "income", values_to = "count")

# b) pivot_wider()

?fish_encounters

fish_encounters %>% 
  pivot_wider(names_from = station, values_from = seen, values_fill = 0)


# Zadanie 2.1 -------------------------------------------------------------
# Wybierz pierwsze 10 postaci z tabeli starwars i kolumny name, height, mass.
# Wygeneruj dla każdej postaci nowe kolumny bazujące na wzroście i masie
# Before height = wzrost - 2
# Before mass = spadek masy o 5%
# After height = wzrost + zm. losowa z rozkładu jednostajnego [1, 5]
# After mass = masa + zm. losowa z rozkładu jednostajnego [1.01, 1.10]
# Wykorzystując pivot_longer utwórz kolumnę "moment", która niesie informację
# before, after.

# losowanie z rozkładu jednostajnego
runif(n(), min = 1, max = 5)

starwars %>% 
  slice(1:10) %>% 
  select(name, height, mass) %>% 
  mutate(h_before = height - 2,
         m_before = mass * 0.95,
         h_after = height + runif(n(), 1, 5),
         m_after = mass + runif(n(), 1.01, 1.10)) %>% 
  select(-height, -mass) %>% 
  pivot_longer(!name, names_to = c(".value", "moment"), names_sep = "_")

# !Note: ze względu na to, że losujemy wartości z rozkładu jednostajnego to
# możemy za każdym razem uzyskać inne wyniki

# 3. ggplot2 --------------------------------------------------------------

install.packages("SmarterPoland")
library(SmarterPoland)

?countries

View(countries)


# Zadanie 3.1 -------------------------------------------------------------
# Określ typy zmiennych:
# country - jakośiowa, nominalna
# birth.rate - ilościowa, ilorazowa
# death.rate - ilościowa, ilorazowa
# population - ilościowa, ilorazowa
# continent - jakośiowa, nominalna

# ggplot2
install.packages("ggplot2")
library(ggplot2)

## 1. Główna funkcja ggplot2 ----> ggplot()

ggplot()

ggplot(data = countries)

## 2. Mapowania ----> aes()

ggplot(data = countries, 
       mapping = aes(x = birth.rate,
                     y = death.rate))

## 3. Operator '+'
ggplot(data = countries, 
       mapping = aes(x = birth.rate,
                     y = death.rate)) +
  geom_point()

# Stosujemy podobne formatowanie jak w dplyr

# Łączenie przez pipes %>% (skrót Ctrl + Shift + m)

countries %>%
  ggplot(mapping = aes(x = birth.rate, y = death.rate)) +
  geom_point()

countries %>%
  ggplot(mapping = aes(x = birth.rate, 
                       y = death.rate,
                       color = continent)) +
  geom_point() + 
  labs(title = "Zależoność wskaźnika śmiertelności 
       od wskaźnika urodzeń",
       x = "wskaźnik urodzeń",
       y = "wskaźnik śmiertelności",
       color = "kontynent") +
  theme_minimal()




