#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 6                    #
#=======================================================#

# install.packages("sf")
# install.packages("scatterpie")
library(dplyr)
library(ggplot2)
library(forcats)
library(maps)
library(mapdata)
library(sf) # pakiet do danych kartograficznych w plikach .shp
library(scatterpie) # pakiet do kartodiagramu (mapa + wykres kołowy)
library(ggnewscale)
library(scales)
library(stringr)

# 0. Zadania rozgrzewkowe -------------------------------------------------

## Zadanie 0.1 ------------------------------------------------------------
# Wczytaj ramkę danych data_forest zawierającą informacje o powierzchni lasów 
# przypadającą na 1 mieszkańca (w hektarach = ha). Połącz te dane z ramką
# w1_europa i narysuj mapę, na której kolor wypełnienia 
# poszczególnych krajów zależy od liczby hektarów na mieszkańca

kraje_europy <- c("Germany", "Poland", "Czech Republic", 
                  "Slovakia", "Ukraine", "Belarus", 
                  "Lithuania", "Russia")

w1_europa <- map_data("world") %>%
  filter(region %in% kraje_europy)



## Zadanie 0.2 ------------------------------------------------------------
# Pobierz dane dotyczące granic Polski ze strony
# https://www.geoportal.gov.pl/pl/dane/panstwowy-rejestr-granic-prg/

# Pobrane dane należy rozpakować z .zip. Folder zawiera granice dla państwa/
# województw/powiatów .. w różnych rozszerzeniach. Interesującym plikiem do 
# rysowania granic w pakiecie ggplot2 jest tak zwany plik shapefile (.shp). 
# Wszystkie pliki powinny być w jednym folderze, mimo korzystania w kodzie 
# tylko z pliku (.shp), to są też zaczytywane pozostałe.




## Zadanie 0.3 ------------------------------------------------------------
# Mapa "szczęścia" w Europie
# Przygotuj mapę Europy na której zaznaczysz poziom szczęścia wśród osób poniżej 
# 30 roku życia (dane z 2021-2023). Ramka danych (happiness_data) zawiera informację
# o wybranych krajach Europy, dla reszty Państw przyjmij brak danych.
# Narysuj mapę, gdzie kolor wypełnienia zależy od wartości poziomu szczęścia, 
# dla braku danych przyjmij kolor szary.
# Zadbaj o czytelność wykresów, dodaj tytuł, podtytuł.

# Dokładny raport na temat "szczęścia" możesz znaleźć tutaj 
# https://files.worldhappiness.report/WHR24.pdf


# ramka danych zawierająca informacje o krajach i poziomie szczęścia
happiness_data <- data.frame(
  kraj = c("Poland", "Germany", "France", "Spain", "Italy", "Norway", "Sweden", "Finland"),
  score = c(6.605, 6.578, 6.561, 6.453, 6.618, 6.995, 7.026, 7.300)
)







# 1. Mapa Polski ----------------------------------------------------------

# Pierwszym elementem przygotowania mapy Polski jest pobranie danych opisujących 
# granice państwa, granice województw, granice powiatów lub gmin. Pliki te 
# dostępne są pod adresem 
# https://www.geoportal.gov.pl/pl/dane/panstwowy-rejestr-granic-prg/. 
# Korzystając z www.geoportal.gov.pl można wybrać tylko potrzebny podzbiór danych, 
# natomiast ze strony Państwowy Rejestr Granic (PRG) na końcu strony są 
# gotowe do pobrania pliki spakowane w .zip.


## a) Mapa województw -----------------------------------------------------

### I. Kartogram ----------------------------------------------------------

# wczytanie danych, funkcja st_read z pakietu sf
wojewodztwa <- st_read("A01_Granice_wojewodztw.shp")

# Dane z GUS https://bdl.stat.gov.pl/bdl/start
# Dane "KULT_1688_CTAB_woj.csv" dotyczą czytelnictwa w Polsce w roku 2024 
# w podziale na 16 województw i ogółem dla PL.

dane <- read.csv2("KULT_1688_CTAB_woj.csv")  





### II. Punkty ------------------------------------------------------------

# ramka danych z miastami wojewódzkimi
miasta <- read.csv("miasta.csv")
# zmiana nazw kolumn
names(miasta) <- c("Województwo", "Stolica", "Szer", "Dł")







## b) Mapa powiatów ------------------------------------------------------

powiaty <-  st_read("A02_Granice_powiatow.shp")

powiaty$JPT_NAZWA_ <- tolower(powiaty$JPT_NAZWA_)


## Zadanie 1.1 ------------------------------------------------------------
# Przygotuj mapę czytelnictwa w Polsce w podziale na powiaty. Wypełnij powiaty 
# kolorem, który będzie oznaczał ile procent czytelników jest w danym powiecie.
# Wykorzystaj załączone dane z GUS - KULT_1699_CTAB_pow.csv.

# Dane "KULT_1688_CTAB_pow.csv" dotyczą czytelnictwa w Polsce w roku 2024 
# w podziale na powiaty i ogółem dla PL.

dane <- read.csv2("KULT_1688_CTAB_pow.csv")







## c) Kartodiagram --------------------------------------------------------

wojewodztwa <- st_read("A01_Granice_wojewodztw.shp", quiet = TRUE)

# Domyślny układ: ETRS89 (EPSG:4258) - European Terrestrial Reference System 1989
# do zwykłych map jest ok, ale jak chcemy dodać wykresy kołowe o zadanym promieniu
# to ze względu na układ będą one elipsami, układ ETRS89 jest w stopniach.

# Przejście na układ 1992 (EPSG:2180) - jest w metrach, pozwala na zachowanie 
# formatu koła.

wojewodztwa <- st_transform(wojewodztwa, 2180)

dane_zdawalnosc <-  read.csv2("SZKO_3193_CTAB_woj.csv")



