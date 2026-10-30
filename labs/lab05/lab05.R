#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 5                    #
#=======================================================#

library(dplyr)
library(ggplot2)
library(forcats)
library(maps)
library(mapdata)
# install.packages("map")
# install.packages("mapdata")

# 0. Zadania rozgrzewkowe -------------------------------------------------

?mpg
# Note: dane z pakietu ggplot2, dane na temat samochodów

## Zadanie 0.1 -------------------------------------------------------------
# Wykorzystując zbiór danych mpg, przygotuj wykres słupkowy przedstawiający 
# średnie zużycie paliwa na autostradzie (hwy) dla poszczególnych 
# producentów (manufacturer).
#
# Wymagania:
# - Słupki na wykresie muszą być posortowane według średniego zużycia 
# paliwa (od największego do najmniejszego).
# - Oś pionowa (OY) powinna reprezentować producentów, 
# - Oś pozioma (OX) średnie zużycie.






?msleep
# Note: dane z pakietu ggplot2, dane na temat snu ssaków

# Zadanie 0.2 -------------------------------------------------------------
# Wykorzystując zbiór danych msleep, stwórz wykres punktowy, który pokaże 
# relację między masą ciała (bodywt) na osi OX, a łącznym czasem 
# snu (sleep_total) na osi OY.

# Wymagania:
# - Zmienną vore (rodzaj pożywienia) ogranicz do 3 najliczniejszych kategorii, 
# a pozostałe zgrupuj jako "Inne".
# - Ponieważ masa ciała ma duże rozpiętości (outliery), 
# zastosuj transformację logarytmiczną dla skali osi OX.
# - Punkty na wykresie powinny mieć kolor zależny od nowej, 
# pogrupowanej zmiennej vore.
# - Przenieś legendę na górę wykresu.







?msleep
# Note: dane z pakietu ggplot2, dane na temat snu ssaków

## Zadanie 0.3 -------------------------------------------------------------
# Stwórz wykres słupkowy dla wszystkich roślinożerców (vore == "herbi"), 
# których czas snu fazy REM (sleep_rem) nie jest wartością brakującą.
# 
# Wymagania:
# Posortuj nazwy zwierząt (name) na osi pionowej według 
# czasu snu REM.
# Jeśli gatunków jest zbyt dużo, ogranicz wykres do 10 zwierząt 
# o najdłuższym śnie REM.
# Słupki powinny mieć kolor zależny od całkowitego czasu snu (sleep_total).
# # Dodaj tytuł: "Top 10 roślinożerców pod kątem snu REM".










## Zadanie 0.4 -------------------------------------------------------------
# Oceń jak zmienia się wydajność paliwowa (hwy) w zależności od pojemności
# silnika (displ), ale z podziałem na rok produkcji (year) oraz rodzaj napędu (drv).
#
# Wymagania:
# Stwórz wykres punktowy, oś OX to displ, oś OY to hwy, kolor punktów to rodzaj
# napędu, kształt punktów to zmienna rok.
# Przenieś legendę na górę.








# 1. Panele - facet_wrap(), facet_grid() ----------------------------------





# 2. Mapy -----------------------------------------------------------------

# Pakiet maps -------------------------------------------------------------

# Pakiet maps zawiera wiele zarysów kontynentów, krajów, państw i hrabstw.
# Na przykład: usa, nz, state, world

usa <- map_data("usa")

dim(usa)
head(usa)

w1 <- map_data("world")

## Struktura ramki danych zawierającej dane o mapie:
## long - długość geograficzna, na zachód od południka zerowego wartości są ujemne
## lat - szerokość geograficzna
## order - wyznacza w jakiej kolejności ggplot powinien "połączyć punkty"
## region i subregion - mówią, jaki region lub subregion otacza zbiór punktów
## group - Funkcje ggplot2 mogą przyjąć argument group, który kontroluje (między innymi) czy sąsiadujące punkty powinny być połączone liniami. 
# Jeśli są w tej samej grupie, to zostaną połączone, ale jeśli są w różnych grupach, to nie.
# Zasadniczo, posiadanie punktów w różnych grupach oznacza, że ggplot "podnosi pióro" kiedy przechodzi między nimi.


# Prosta mapa -------------------------------------------------------------

# Gdy zmienimy rozmiar okna to wykres jest rozszerzany lub zwężany - tak nie powinno się dziać 




## coord_fixed()
# Naprawia relację między jedną jednostką w kierunku y i jedną jednostką w kierunku x.
# Nawet jeśli zmienisz zewnętrzne wymiary wykresu (np. zmieniając rozmiar okna lub rozmiar pliku pdf, do którego ją zapisujesz (na przykład w ggsave)), proporcje pozostają niezmienione.
# Przy ustaleniu parametów 1.3 daje dobre rezultaty, bliżej biegunów mogą być potrzebne inne wartości.
us + coord_fixed()
us + coord_fixed(1.3)

## coord_map()
# Zastąpiona przez nową funkcję, ale starsza jest prostsza w obsłudze. 
?coord_map 
?coord_sf 
us + coord_map()
us + coord_map("mercator")

us + coord_map("mollweide")


# Obrys mapy --------------------------------------------------------------




# Obrys i wypełnienie -----------------------------------------------------




## Zadanie 2.1 ------------------------------------------------------------
# Z danych dla mapy świata (world) wyfiltruj tylko region "UK".
# Narysuj mapę, w której wypełnienie będzie jasnoszare, a granice (kontury) 
# będą przerywane i niebieskie.








# Dodanie punktów do mapy -------------------------------------------------

points <- data.frame(
  long = c(-122.064873, -122.306417),
  lat = c(36.951968, 47.644855),
  names = c("A", "B"),
  stringsAsFactors = FALSE
) 

us_fill + 
  geom_point(data = points, aes(x = long, y = lat), color = "black", size = 5) 


# Podpisy punktów ---------------------------------------------------------



## Zadanie 2.2 -------------------------------------------------------------
# "Trójkąt Bermudzki"
# Narysuj mapę świata z fokusem na okolice Karaibów (użyj coord_quickmap()
# z ograniczonymi xlim i ylim). Stwórz małą ramkę danych z trzema wierzchołkami 
# Trójkąta: Miami, Bermudy, Puerto Rico.
# Dodaj te punkty na mapę oraz ich nazwy, używając geom_text().








## Zadanie 2.3 -------------------------------------------------------------
# Narysuj mapę Europy Środkowo-Wschodniej (regiony: Germany, Poland, 
# Czech Republic, Slovakia, Ukraine, Belarus, Lithuania, Russia) - w1_europa.
# Dla wszystkich krajów zastosuj czarny kontur. Polskę wypełniamy na 
# kolor czerowny, pozostałe kraje na kolor biały.

kraje_europy <- c("Germany", "Poland", "Czech Republic", 
                  "Slovakia", "Ukraine", "Belarus", 
                  "Lithuania", "Russia")



ggplot() +
  ###
  ###
  ###
  theme_minimal() +
  labs(title = "Polska na tle Europy Środkowo-Wschodniej")



## Zadanie 2.4 ------------------------------------------------------------
# Wczytaj ramkę danych data_forest zawierającą informacje o powierzchni lasów 
# przypadającą na 1 mieszkańca (w hektarach = ha). Połącz te dane z ramką
# w1_europa (z Zadania 2.3) i narysuj mapę, na której kolor wypełnienia 
# poszczególnych krajów zależy od liczby hektarów na mieszkańca

data_forest <- read.csv("data_forest.csv")







