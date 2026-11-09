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

mpg_task <- mpg %>%
  group_by(manufacturer) %>%
  summarise(avg_hwy = mean(hwy)) %>%
  mutate(manufacturer = fct_reorder(manufacturer, avg_hwy))

ggplot(mpg_task, aes(x = avg_hwy, y = manufacturer)) +
  geom_col() +
  labs(
    title = "Średnie zużycie paliwa na autostradzie",
    x = "Średnie hwy",
    y = "Producent"
  ) +
  theme_minimal()


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

msleep_task <- msleep %>%
  mutate(vore_grouped = fct_lump(vore, n = 3, other_level = "Inne"))

ggplot(msleep_task, aes(x = bodywt, y = sleep_total, color = vore_grouped)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_x_log10(labels = scales::label_number()) + 
  labs(
    title = "Relacja masy ciała do czasu snu",
    subtitle = "Skala logarytmiczna dla masy ciała",
    x = "Masa ciała (log10 kg)",
    y = "Łączny sen (h)",
    color = "Rodzaj pożywienia"
  ) +
  theme_minimal() +
  theme(legend.position = "top")


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


msleep %>%
  filter(vore == "herbi", !is.na(sleep_rem)) %>%
  slice_max(order_by = sleep_rem, n = 10) %>%
  mutate(name = fct_reorder(name, sleep_rem)) %>%
  ggplot(aes(x = name, y = sleep_rem, fill = sleep_total)) +
  geom_col() +
  labs(title = "Top 10 roślinożerców pod kątem snu REM",
       x = "Czas snu REM [h]",
       y = "Nazwa zwierzęcia",
       fill = "Całkowity sen [h]") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  theme(axis.text.x = element_text(size = 9, angle = 90))


## Zadanie 0.4 -------------------------------------------------------------
# Oceń jak zmienia się wydajność paliwowa (hwy) w zależności od pojemności
# silnika (displ), ale z podziałem na rok produkcji (year) oraz rodzaj napędu (drv).
#
# Wymagania:
# Stwórz wykres punktowy, oś OX to displ, oś OY to hwy, kolor punktów to rodzaj
# napędu, kształt punktów to zmienna rok.
# Przenieś legendę na górę.


ggplot(mpg, aes(x = displ, y = hwy, color = drv, shape = factor(year))) +
  geom_point() +
  labs(title = "Zależność między wydajnością paliwową a pojemnością silnika",
       x = "Pojemność silnika [l]",
       y = "Wydajność paliwowa [mil na galon]",
       color = "Rodzaj napędu",
       shape = "Rok") +
  theme_minimal() +
  theme(legend.position = "top")


# 1. Panele - facet_wrap(), facet_grid() ----------------------------------

ggplot(mpg, aes(x = displ, y = hwy, shape = factor(year))) + # dodać zmiane shape na color
  geom_point() +
  labs(title = "Zależność między wydajnością paliwową a pojemnością silnika",
       x = "Pojemność silnika [l]",
       y = "Wydajność paliwowa [mil na galon]",
       shape = "Rok") +
  theme_minimal() +
  theme(legend.position = "top") +
  facet_wrap(~drv)

ggplot(mpg, aes(x = displ, y = hwy, shape = factor(year))) + # dodać zmiane shape na color
  geom_point() +
  labs(title = "Zależność między wydajnością paliwową a pojemnością silnika",
       x = "Pojemność silnika [l]",
       y = "Wydajność paliwowa [mil na galon]") +
  theme_minimal() +
  theme(legend.position = "top") +
  facet_wrap(year~drv) # zawija stworzone pary (year, drv)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(title = "Zależność między wydajnością paliwową a pojemnością silnika",
       x = "Pojemność silnika [l]",
       y = "Wydajność paliwowa [mil na galon]") +
  theme_minimal() +
  facet_grid(drv~year, scales = "free_x") # uwolniona oś x

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(title = "Zależność między wydajnością paliwową a pojemnością silnika",
       x = "Pojemność silnika [l]",
       y = "Wydajność paliwowa [mil na galon]") +
  theme_minimal() +
  facet_grid(drv~year, scales = "free_y") # uwolniona oś y

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(title = "Zależność między wydajnością paliwową a pojemnością silnika",
       x = "Pojemność silnika [l]",
       y = "Wydajność paliwowa [mil na galon]") +
  theme_minimal() +
  facet_grid(drv~year, scales = "free") # uwolniona oś x i y


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

us <- ggplot() +
  geom_polygon(data = usa, aes(x = long, y = lat, group = group))
us

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

ggplot() +
  geom_polygon(
    data = usa,
    aes(x = long, y = lat, group = group),
    color = "red",
    fill = NA
  ) +
  coord_map()

# Obrys i wypełnienie -----------------------------------------------------

us_fill <- ggplot() +
  geom_polygon(
    data = usa,
    aes(x = long, y = lat, group = group),
    fill = "violet",
    color = "blue"
  ) +
  coord_map()
us_fill


## Zadanie 2.1 ------------------------------------------------------------
# Z danych dla mapy świata (world) wyfiltruj tylko region "UK".
# Narysuj mapę, w której wypełnienie będzie jasnoszare, a granice (kontury) 
# będą przerywane i niebieskie.

w1 %>%
  filter(region == "UK") %>%
  ggplot() +
  geom_polygon(
    aes(x = long, y = lat, group = group),
    fill = "lightgrey",
    color = "blue",
    linetype = "dashed"
  ) +
  coord_quickmap() +
  theme_void()


# Dodanie punktów do mapy -------------------------------------------------

points <- data.frame(
  long = c(-122.064873, -122.306417),
  lat = c(36.951968, 47.644855),
  names = c("A", "B"),
  stringsAsFactors = FALSE
) 

us + 
  geom_point(data = points, aes(x = long, y = lat), color = "red", size = 7) + 
  coord_quickmap()


# Podpisy punktów ---------------------------------------------------------

us +
  geom_point(
    data = points,
    aes(x = long, y = lat),
    color = "red",
    size = 7
  ) +
  coord_quickmap() +
  geom_text(data = points,
            aes(x = long, y = lat, label = names),
            color = "yellow")



## Zadanie 2.2 -------------------------------------------------------------
# "Trójkąt Bermudzki"
# Narysuj mapę świata z fokusem na okolice Karaibów (użyj coord_quickmap()
# z ograniczonymi xlim i ylim). Stwórz małą ramkę danych z trzema wierzchołkami 
# Trójkąta: Miami, Bermudy, Puerto Rico.
# Dodaj te punkty na mapę oraz ich nazwy, używając geom_text().

w1 <- map_data("world")

miejsca <- data.frame(
  miejsce = c("Miami", "Bermudy", "Puerto Rico"),
  lat = c(25.7617, 32.3000, 18.2208),
  long = c(-80.1918, -64.7500, -66.5901)
)
ggplot() +
  geom_polygon(
    data = w1,
    aes(x = long, y = lat, group = group),
    fill = "antiquewhite",
    color = "gray40"
  ) +
  geom_point(
    data = miejsca,
    aes(x = long, y = lat),
    color = "violet",
    size = 4
  ) +
  coord_quickmap(xlim = c(-100, -50), ylim = c(0, 50)) +
  geom_text(
    data = miejsca,
    aes(x = long, y = lat, label = miejsce),
    vjust = -1,
    fontface = "bold"
  ) +
  theme_light() +
  labs(title = "Lokalizacja wierzchołków Trójkąta Bermudzkiego", 
       x = "Długość geogr.", 
       y = "Szerokość geogr.")

## wersja z połączonymi punktami

ggplot() +
  geom_polygon(
    data = w1,
    aes(x = long, y = lat, group = group),
    fill = "antiquewhite",
    color = "gray40"
  ) +
  geom_polygon(
    data = miejsca,
    aes(x = long, y = lat),
    color = "violet",
    fill = NA,
    linewidth = 1
  ) +
  geom_point(
    data = miejsca,
    aes(x = long, y = lat),
    color = "violet",
    size = 4
  ) +
  coord_quickmap(xlim = c(-100, -50), ylim = c(0, 50)) +
  geom_text(
    data = miejsca,
    aes(x = long, y = lat, label = miejsce),
    vjust = -1,
    fontface = "bold"
  ) +
  theme_light() +
  labs(title = "Obszar Trójkąta Bermudzkiego", 
       x = "Długość geogr.", 
       y = "Szerokość geogr.")



