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
# w1_europa (z Zadania 2.3) i narysuj mapę, na której kolor wypełnienia 
# poszczególnych krajów zależy od liczby hektarów na mieszkańca

data_forest <- read.csv(
  "data_forest.csv"
)

kraje_europy <- c("Germany", "Poland", "Czech Republic", 
                  "Slovakia", "Ukraine", "Belarus", 
                  "Lithuania", "Russia")

w1_europa <- map_data("world") %>%
  filter(region %in% kraje_europy)

data_forest$country <- tolower(data_forest$country)
w1_europa$region <- tolower(w1_europa$region)

w1_eur_forest <- w1_europa %>%
  left_join(data_forest, by = join_by(region == country))

ggplot(w1_eur_forest, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = forest), color = "black") +
  scale_fill_gradient(low = "#e5f5e0", high = "#006d2c") +
  coord_map("orthographic", orientation = c(52, 20, 0)) +
  theme_minimal() +
  labs(title = "Powierzchnia lasów na 1 mieszkańca",
       subtitle = "Europa Środkowo-Wschodnia",
       fill = "ha / os.")



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

# wczytanie konturów dla wszystkich państw
world_map <- map_data("world")

# dołączenie do danych o konturach informacji o poziomie szczęścia 
# left_join(), odpowiadające kolumny to region i kraj
europe_map <- world_map %>%
  left_join(happiness_data, by = join_by("region" == "kraj"))

# wykres
ggplot(europe_map, aes(x = long, y = lat, group = group)) + # kontury państw
  geom_polygon(fill = "grey80",
               color = "white",
               linewidth = 0.1) + # wypełnienie wszystkich państw kolorem szarym
  geom_polygon(aes(fill = score),
               color = "white",
               linewidth = 0.1) + # wypełnienie państw z zadania kolorem, który oznacza wskaźnik szczęścia
  geom_point(aes(color = "Brak danych"), alpha = 0) +   # "niewidzialna" warstwa tylko po to, żeby wymusić legendę "Brak danych"
  coord_quickmap(xlim = c(-10, 35), ylim = c(37, 65)) + # ograniczenie zakresu mapy
  scale_fill_viridis_c(option = "magma",
                       name = "Wskaźnik\nszczęścia",
                       na.value = "grey80") + # zastosowanie skali kolorów innej niż domyślna, wypełnienie braków danych zadanym kolorem
  scale_color_manual(
    name = NULL,
    values = c("Brak danych" = "grey80"), # skala dla legendy "brak danych"
    guide = guide_legend(override.aes = list(
      shape = 15,
      size = 7,
      alpha = 1
    )) #ustawienia kwadracika, kształt, wielkość
  ) +
  labs(
    title = "Wskaźnik szczęścia w Europie",
    subtitle = "Wśród osób poniżej 30 roku życia (dane z 2021-2023)",
    x = NULL,
    y = NULL,
    caption = "Źródło danych: World Happiness Report 2024"
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "aliceblue", color = NA), # wypełnienie tła
    panel.grid = element_blank(),
    axis.text = element_blank(),
    legend.spacing.y = unit(-0.2, "cm") # zmniejsza odstęp między legendami
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

dane <- read.csv2("../KULT_1688_CTAB_woj.csv") # read.csv2 - wczytuje ramki danych 
# rozdzielane średnikiem

# sprowadzamy dane do ładniejszej postaci
dane <-  dane[, -4]
dane$Nazwa <- tolower(dane$Nazwa) # zmiana na małe litery
names(dane) <- c("Kod", "Nazwa", "Czytelnicy")

# !Note: dane na wykresach typu kartogram muszą być wskaźnikami/indeksami a nie 
# wartościami bezwzględnymi!

# chcemy wyliczyć jaki procent czytelników mieszka w danym województwie
dane_pl <-  dane %>%  
  filter(Nazwa == "polska") # wartość dla PL

# wyliczamy procent per województwo
dane <- dane %>%  
  filter(Nazwa != "polska") %>%
  mutate(
    procent = (Czytelnicy / dane_pl$Czytelnicy) * 100
  )

# wykres
wojewodztwa %>% 
  left_join(dane, by = join_by(JPT_NAZWA_ == Nazwa)) %>% 
  ggplot() +
  geom_sf(aes(fill = procent)) +
  theme_void() +
  scale_fill_gradient(low = "white", high = "lightblue") +
  labs(title = "Czytelnictwo w roku 2024",
         fill = "%",
       caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024")


### II. Punkty ------------------------------------------------------------

# ramka danych z miastami wojewódzkimi
miasta <- read.csv("../miasta.csv")
# zmiana nazw kolumn
names(miasta) <- c("Województwo", "Stolica", "Szer", "Dł")

# wykres
wojewodztwa %>% 
  ggplot() +
  geom_sf(fill = "lightyellow") + # granice województw i wypełnienie kolorem
  geom_point(data = miasta, aes(y = Szer,
                                x = Dł)) + # punkty
  geom_text(data = miasta, aes(y = Szer,
                                x = Dł,
                               label = Stolica), # tekst
            vjust = -0.5) +
  theme_void() +
  labs(title = "Mapa - stolice województw")


# Czasami nie mamy dostępu do ramki danych ze współrzędnymi miast, a chcielibyśmy
# w jakimś punkcie umieścić wartość dla każdego wojewódźtwa - możemy skorzystać 
# z funkcji z pakietu sf, która wylicza środek zadanego obszaru

# wyliczamy "środki" województw
centroidy <-  st_point_on_surface(wojewodztwa)

# ze względu na złożoną formę wyliczonych współrzędnych przekształcamy je do
# typowej ramki danych
centroidy_xy <-  st_coordinates(centroidy) %>% as.data.frame()

# wykres
wojewodztwa %>% 
  left_join(dane, by = join_by(JPT_NAZWA_ == Nazwa)) %>% 
  ggplot() +
  geom_sf(aes(fill = procent)) +
  geom_point(data = centroidy_xy, aes(y = Y,
                                x = X)) + # punkty "środki" wyznaczone przez funkcję
  theme_void() +
  scale_fill_gradient(low = "white", high = "lightblue") +
  labs(title = "Czytelnictwo w roku 2024",
       fill = "%",
       caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024")

# w miejsce punktów wstawmy wartości procentów dla każdego województwa

centroidy <- centroidy %>% 
  left_join(dane, by = join_by(JPT_NAZWA_ == Nazwa)) # dodaję informację o czytelnictwie

dane_punkty <- centroidy %>%
  st_drop_geometry() %>% # usuwamy informację o kształcie województw, teraz to nie jest potrzebne
  transmute(
    JPT_NAZWA_, # wybieramy kolumnę z info o nazwie województwa, procent czytelników
    procent) %>%
  bind_cols(centroidy_xy)  # doklejamy kolumny ze współrzędnymi

# wykres
wojewodztwa %>%
  left_join(dane, by = join_by(JPT_NAZWA_ == Nazwa)) %>%
  ggplot() +
  geom_sf(aes(fill = procent), color = "black") +
  theme_void() +
  scale_fill_gradient(low = "white", high = "lightblue") +
  labs(title = "Czytelnictwo w roku 2024",
       fill = "%",
       caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024") +
  geom_text(
    data = dane_punkty, # ramka danych ze środkami województw
    aes(
      x = X,
      y = Y,
      label = paste0(round(procent, 2), "%") # procent
    ),
    size = 4,
    fontface = "bold"
  )

# wykres z zastosowaną skalą przedziałową

wojewodztwa %>%
  left_join(dane, by = join_by(JPT_NAZWA_ == Nazwa)) %>%
  ggplot() +
  geom_sf(aes(fill = procent), color = "black", size = 0.2) +
  scale_fill_fermenter( # skala przedziałowa
    palette = "Greens", # wybrana paleta kolorów
    direction = 1, # kierunek rosnący
    name = "Czytelnictwo (%)",
    breaks = seq(2, 17, by = 3), # zakres przedziałów i ich długość
    limits = c(2, 17),           # sztywne ramy skali
    oob = scales::squish,        # wartości <2 lub >17 dostaną kolor skrajny
    guide = guide_colorsteps(    # ustawienia paska z kolorami
      barwidth = 15,
      barheight = 0.5,
      title.position = "top",
      label.hjust = 0.5
    )
  ) +
  geom_text(
    data = dane_punkty, 
    aes(x = X, y = Y, label = paste0(round(procent, 2), "%")),
    size = 3.5,
    fontface = "bold",
    color = "black" 
  ) +
  theme_void() +
  theme(legend.position = "bottom") + 
  labs(
    title = "Czytelnictwo w roku 2024",
    caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024"
  )


## b) Mapa powiatów ------------------------------------------------------

powiaty <-  st_read("A02_Granice_powiatow.shp")

powiaty$JPT_NAZWA_ <- tolower(powiaty$JPT_NAZWA_)


## Zadanie 1.1 ------------------------------------------------------------
# Przygotuj mapę czytelnictwa w Polsce w podziale na powiaty. Wypełnij powiaty 
# kolorem, który będzie oznaczał ile procent czytelników jest w danym powiecie.
# Wykorzystaj załączone dane z GUS - KULT_1699_CTAB_pow.csv.

# Dane "KULT_1688_CTAB_pow.csv" dotyczą czytelnictwa w Polsce w roku 2024 
# w podziale na powiaty i ogółem dla PL.

dane <- read.csv2("../KULT_1688_CTAB_pow.csv") # read.csv2 - wczytuje ramki danych 
# rozdzielane średnikiem

# sprowadzamy dane do ładniejszej postaci
dane <-  dane[, -4]
dane$Nazwa <- tolower(dane$Nazwa) # zmiana na małe litery
names(dane) <- c("Kod", "Nazwa", "Czytelnicy")

# !Note: dane na wykresach typu kartogram muszą być wskaźnikami/indeksami a nie 
# wartościami bezwzględnymi!

# chcemy wyliczyć jaki procent czytelników mieszka w danym województwie
dane_pl <-  dane %>%  
  filter(Nazwa == "polska") # wartość dla PL

# wyliczamy procent per województwo
dane <- dane %>%  
  filter(Nazwa != "polska") %>%
  mutate(
    procent = (Czytelnicy / dane_pl$Czytelnicy) * 100
  )

# ponieważ nazwy powiatów nie są takie same w zbiorach danych nanosimy
# poprawki, usuwamy "m." (skrót od miast powiatowych), "st." (skrót od stolicy),
# "od \\d{4}|\\d+" (liczby w nazwach, np. od 2013 dla powiatu wałbrzych)
df_poprawiony <- dane %>%
  mutate(nazwa = Nazwa %>% 
           str_remove_all("m\\. |st\\. | od \\d{4}|\\d+") %>% 
           str_squish()) # usuwa spacje z początku i końca tekstu, zamienia podwójne 
# lub potrójne spacje w środku (powstałe po usunięciu słów) na jedną pojedynczą spację

powiaty %>%
  left_join(df_poprawiony, by = join_by(JPT_NAZWA_ == nazwa)) %>% 
  ggplot() +
  geom_sf(aes(fill = procent), color = "black", size = 0.2) +
  scale_fill_fermenter( # skala przedziałowa
    palette = "Greens", # wybrana paleta kolorów
    direction = 1, # kierunek rosnący
    name = "Czytelnictwo (%)",
    breaks = seq(0, 10, by = 2), # zakres przedziałów i ich długość
    limits = c(0, 10),           # sztywne ramy skali
    oob = scales::squish,        # wartości <2 lub >9 dostaną kolor skrajny
    guide = guide_colorsteps(    # ustawienia paska z kolorami
      barwidth = 15,
      barheight = 0.5,
      title.position = "top",
      label.hjust = 0.5
    )
  ) +
  theme_void() +
  theme(legend.position = "bottom") + 
  labs(
    title = "Czytelnictwo w roku 2024",
    caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024"
  )


## c) Kartodiagram --------------------------------------------------------

wojewodztwa <- st_read("A01_Granice_wojewodztw.shp", quiet = TRUE)

# Domyślny układ: ETRS89 (EPSG:4258) - European Terrestrial Reference System 1989
# do zwykłych map jest ok, ale jak chcemy dodać wykresy kołowe o zadanym promieniu
# to ze względu na układ będą one elipsami, układ ETRS89 jest w stopniach.

# Przejście na układ 1992 (EPSG:2180) - jest w metrach, pozwala na zachowanie 
# formatu koła.

wojewodztwa <- st_transform(wojewodztwa, 2180)

dane_zdawalnosc <-  read.csv2("../SZKO_3193_CTAB_woj.csv")

# dane sprowadzamy do czytelniejszej formy
dane_zdawalnosc <- dane_zdawalnosc[, -4]
dane_zdawalnosc$Nazwa <-  tolower(dane_zdawalnosc$Nazwa)
names(dane_zdawalnosc) <-  c("Kod", "Nazwa", "Wartosc")

# dane na temat podziału zdawalności na typ szkoły są wylosowane
dane_szkoly <- dane_zdawalnosc %>%
  mutate(
    proporcja_LO = runif(n(), 0.6, 0.7),
    # np. licea to 60-70% zdawalności w danym woj
    Liceum = Wartosc * proporcja_LO,
    Technikum = Wartosc * (1 - proporcja_LO)
  ) %>%
  select(-proporcja_LO)

# łączenie danych
wojewodztwa <- wojewodztwa %>%
  left_join(dane_szkoly, by = join_by("JPT_NAZWA_" == "Nazwa"))

# środki województw
centroidy <-  st_point_on_surface(wojewodztwa)

# przekształcenie do formatu ramki danych
centroidu_xy <-  st_coordinates(centroidy) %>% as.data.frame()

# dane na potrzeby wykresu kołowego, wartości kolejnych wycinków podajemy
# jako kolumny
kola <- centroidy %>%
  st_drop_geometry() %>%
  transmute(JPT_NAZWA_, Liceum, Technikum) %>%
  bind_cols(centroidu_xy) # dokładamy współrzędne środków woj

# wykres kartodiagram
ggplot() +
  geom_sf(
    data = wojewodztwa,
    aes(fill = Wartosc),
    color = "white",
    size = 0.25
  ) + # obrys woj i wypełnienie kolorem
  scale_fill_gradient(low = "#f7fcb9",
                      high = "#31a354",
                      name = "Zdawalność (%)") + # wybór kolorów
  ggnewscale::new_scale_fill() + # konieczne dodanie nowej skali wypełnienia dla wykresów kołowych
  geom_scatterpie(
    data = kola,
    aes(x = X, y = Y),
    # współrzędne środków, gdzie zostanie umieszczony wykres kołowy
    cols = c("Liceum", "Technikum"),
    # dane z których kolumn mają się znajdować na wykresie kołowym
    color = NA,
    pie_scale = 2.4 # wykres kołowy
  ) +
  scale_fill_manual(
    # kolory wykresu kołowego
    values = c(Liceum = "#88419d", Technikum = "#feb24c"),
    name = "Typ szkoły"
  ) +
  theme_void() +
  labs(title = "Zdawalność matur w 2024",
       subtitle = "Gradient: przedziały zdawalności | Koła: struktura zdających",
       caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024")

# wykres z zastosowaną skalą przedziałową
ggplot() +
  geom_sf(
    data = wojewodztwa,
    aes(fill = Wartosc),
    color = "white",
    size = 0.25
  ) +
  scale_fill_fermenter( # skala przedziałowa
    palette = "YlGn",
    direction = 1,
    name = "Zdawalność (%)",
    breaks = seq(81, 87, by = 1)
  ) +
  ggnewscale::new_scale_fill() +
  geom_scatterpie(
    data = kola,
    aes(x = X, y = Y),
    cols = c("Liceum", "Technikum"),
    color = NA,
    pie_scale = 2.4
  ) +
  scale_fill_manual(values = c(Liceum = "#88419d", Technikum = "#feb24c"),
                    name = "Typ szkoły") +
  theme_void() +
  labs(title = "Zdawalność matur w 2024",
       subtitle = "Gradient: przedziały zdawalności | Koła: struktura zdających",
       caption = "Źródło: GUS - Bank Danych Lokalnych, dane z 2024")
theme_minimal(base_size = 12)
