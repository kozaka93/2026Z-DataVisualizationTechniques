#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 4                    #
#=======================================================#
library(dplyr)
library(ggplot2)
library(forcats)

# 0. Zadania rozgrzewkowe -------------------------------------------------

?diamonds
# Note: dane z pakietu ggplot2, dane na temat diamentów

# Zadanie 0.1 -------------------------------------------------------------
# Stwórz wykres rozproszenia, który pokaże zależność między masą diamentu (carat)
# a jego ceną (price). Zadbaj o czytelność wykresu.

ggplot(diamonds, aes(x = carat, 
                     y = price)) + 
  geom_point() +
  labs(title= "Zależność między masą diamentu (carat) a jego ceną (price)",
       x = "Karaty",
       y = "Cena")



# Zadanie 0.2 -------------------------------------------------------------
# Założmy, że objętość diamentów wyliczamy jako iloczyn x, y i z. Wybierzmy
# diamenty o objętości mniejszej niż 50, ale większej niż 0. 
# Zaprezentuj rozkład ceny diamentów w zależności od jakości szlifu (cut).
# Zadbaj o czytelność wykresu.

diamonds %>% 
  mutate(vol = x*y*z) %>% 
  filter(vol < 50, vol > 0) %>% 
  ggplot(aes(x = cut, y = price)) + 
  geom_boxplot() +
  labs(title = "Rozkład ceny diamentów w zależności od jakości szlifu",
       subtitle = "Diamenty o objętości większej niż 0 i mniejszej niż 50",
       x = "Jakość szlifu",
       y = "Cena") +
  theme_bw()



?mpg
# Note: dane z pakietu ggplot2, dane na temat samochodów

## Zadanie 0.3 -------------------------------------------------------------
# Załóżmy, że interesują nas tylko samochody z lat 2000-2008 (kolumna year).
# Stwórz nową kolumną fuel_efficiency, która będzie średnią z zużycia paliwa
# w mieście (cty) i na autostradzie (hwy). 
# Narysuj rozkład tej nowej zmiennej w podziale na typ nadwozia (class).

mpg %>% 
  filter(year >= 2000, year <= 2008) %>% 
  mutate(fuel_efficiency = (cty + hwy)/2) %>% 
  ggplot(aes(x = fuel_efficiency, y = class)) +
  geom_boxplot(outlier.color = "blue") +
  labs(x = "Średnie zużycie paliwa",
       y = "Typ nadwozia",
       title = "Średnie zużycie paliwa w podziale na typ nadwozia",
       subtitle = "Samochody z lat 2000 - 2008")



?msleep
# Note: dane z pakietu ggplot2, dane na temat snu ssaków

## Zadanie 0.4 -------------------------------------------------------------
# Używając zbioru danych msleep wykonaj następujące kroki:

# 1) Wybierz tylko te zwierzęta, których masa ciała (bodywt)
# jest mniejsza niż 50 kg i które są roślinożercami (vore == "herbi").

# 2) Stwórz wykres słupkowy, który pokaże łączny czas snu (sleep_total)
# dla poszczególnych gatunków (name).

# 3) Chcemy, aby nazwy zwierząt były na osi pionowej.

msleep %>% 
  filter(bodywt < 50, vore == "herbi") %>% 
  ggplot(aes(x = sleep_total, y = name)) + 
  geom_col(fill = "blue") +
  labs(title = "Kto śpi najdłużej",
       subtitle = "Roślinożercy o masie < 50kg",
       x = "Czas snu [h]",
       y = "Gatunek") +
  theme_bw()


# !Note: Słupki bez sortowania ciężko się odczytuje, znacznie łatwiej 
# uzyskiwać informacji jeżeli słupki są posortowane. Oczywiście sortowanie 
# nie ma sensu gdy kolejne słupki to są na przykład lata.

# 1. forcats --------------------------------------------------------------

# !Note: Pakiet forcats jest pomocnikiem w sortowaniu wartości (w szczególności
# gdy są to zmienne factor).


# a) sortowanie według wartości - fct_reorder -----------------------------

# malejąco
msleep %>% 
  filter(bodywt < 50, vore == "herbi") %>% 
  mutate(name = fct_reorder(name, sleep_total)) %>% # Sortuje name według sleep_total 
  ggplot(aes(x = sleep_total, y = name)) + 
  geom_col() +
  labs(title = "Kto śpi najdłużej?",
       subtitle = "Roślinożercy o masie < 50kg, posortowani rosnąco",
       x = "Czas snu [h]", y = "Gatunek")

# rosnąco
msleep %>% 
  filter(bodywt < 50, vore == "herbi") %>% 
  mutate(name = fct_reorder(name, desc(sleep_total))) %>% # Sortuje name według sleep_total
  ggplot(aes(x = sleep_total, y = name)) + 
  geom_col() +
  labs(title = "Kto śpi najdłużej?",
       subtitle = "Roślinożercy o masie < 50kg, posortowani rosnąco",
       x = "Czas snu [h]", y = "Gatunek")



# b) zmiana nazw na bardziej czytelne - fct_recode ------------------------

msleep %>% 
  filter(bodywt < 50, vore == "herbi") %>% 
  mutate(name = fct_recode(name, 
                           "Królik domowy" = "Rabbit",
                           "Krowa" = "Cow",
                           "Koza" = "Goat")) %>% 
  ggplot(aes(x = sleep_total, y = name)) + 
  geom_col() +
  labs(title = "Kto śpi najdłużej?",
       subtitle = "Roślinożercy o masie < 50kg",
       x = "Czas snu [h]", y = "Gatunek")



# c) łączenie w grupy - fct_lump() ----------------------------------------

msleep_top_orders <- msleep %>%
  mutate(order_lumped = fct_lump(order, n = 3, other_level = "Pozostałe gatunki")) %>%
  group_by(order_lumped) %>%
  summarise(avg_sleep = mean(sleep_total), count = n())

ggplot(msleep_top_orders, aes(x = avg_sleep, y = fct_reorder(order_lumped, avg_sleep))) +
  geom_col() +
  geom_text(aes(label = paste("n =", count)), hjust = -0.2) + 
  labs(
    title = "Średni czas snu dla najliczniejszych rzędów zwierząt",
    x = "Średnia liczba godzin snu",
    y = "Gatunek"
  ) +
  xlim(0, 15) + 
  theme_minimal()

# 2. ggplot - kolory i skale ----------------------------------------------


# Zadanie 2.1 -------------------------------------------------------------
# Pogrupuj zwierzęta według gatunku (genus), wylicz dla każdego gatunku
# średni czas snu i średnią wagę ciała. Przygotuj wykres słupkowy,
# który na osi OX będzie przedstawiał średnią liczbę godzin snu,
# oś OY to gatunek a kolorem masę ciała.

p <- msleep %>%
  group_by(genus) %>% 
  summarise(
    avg_sleep = mean(sleep_total),
    avg_bodywt = mean(bodywt)
  ) %>%
  ggplot(aes(x = avg_sleep, y = fct_reorder(genus, avg_sleep))) +
  geom_col(aes(fill = avg_bodywt, width = 0.8)) + # width - szerokość słupka
  labs(
    title = "Średni sen i masa ciała wg gatunku zwierząt",
    subtitle = "Kolor reprezentuje średnią masę ciała",
    x = "Średnia liczba godzin snu",
    y = "Gatnek (Genus)",
    fill = "Masa ciała (kg)"
  ) +
  theme_minimal()

p

# Co jest do poprawy? -----------------------------------------------------
# a) nachodzące opisy osi
# b) skala kolorystyczna
# c) transformacja log?


# a) ----------------------------------------------------------------------

msleep %>%
  mutate(genus_lump = fct_lump_n(genus, n = 4, other_level = "Pozostałe gatunki")) %>% 
  group_by(genus_lump) %>% 
  summarise(
    avg_sleep = mean(sleep_total),
    avg_bodywt = mean(bodywt)
  ) %>%
  ggplot(aes(x = avg_sleep, y = fct_reorder(genus_lump, avg_sleep))) +
  geom_col(aes(fill = avg_bodywt), width = 0.8) +
  labs(
    title = "Średni sen i masa ciała wg gatunku zwierząt",
    subtitle = "Kolor reprezentuje średnią masę ciała",
    x = "Średnia liczba godzin snu",
    y = "Gatnek (Genus)",
    fill = "Masa ciała (kg)"
  ) +
  theme_minimal()

p + 
  theme(axis.text.y = element_text(size = 6, angle = 25)) # mniejsza czcionka i pod kątem

# osie (x & y) ------------------------------------------------------------

p + 
  scale_x_continuous(expand = c(0,0))

p + 
  scale_x_continuous(expand = expansion(mult = c(0, 0.1)))

p +
  scale_x_continuous(position = "top") 

p +
  scale_x_reverse()

p +
  scale_y_discrete(position = "right")


# b)  ---------------------------------------------------------------------

# install.packages("RColorBrewer")
library(RColorBrewer)
RColorBrewer::brewer.pal(n = 5, name = "Blues")
c("#EFF3FF", "#BDD7E7", "#6BAED6", "#3182BD", "#08519C")

p + 
  scale_fill_gradient(low ="lightblue", high="red")

msleep %>%
  group_by(genus) %>% 
  summarise(
    avg_sleep = mean(sleep_total),
    avg_bodywt = mean(bodywt)
  ) %>% 
  ungroup() %>% 
  summarise(q99 = quantile(avg_bodywt, 0.99),
            min = min(avg_bodywt),
            max = max(avg_bodywt))

p + 
  scale_fill_gradient2(
    low = "navyblue", high = "red", mid = "white",
    limits = c(0, 6700), midpoint = 3533
  )

# c) ----------------------------------------------------------------------

msleep %>%
  group_by(genus) %>% 
  summarise(
    avg_sleep = mean(sleep_total),
    avg_bodywt = mean(bodywt)
  ) %>%
  ggplot(aes(x = avg_sleep, y = fct_reorder(genus, avg_sleep))) +
  geom_col(aes(fill = avg_bodywt), width = 0.8) +
  labs(
    title = "Średni sen i masa ciała wg gatunku zwierząt",
    subtitle = "Kolor reprezentuje średnią masę ciała",
    x = "Średnia liczba godzin snu",
    y = "Gatnek (Genus)",
    fill = "Masa ciała (kg)"
  ) +
  theme_minimal() +
  scale_fill_viridis_c(
    trans = "log10", 
    labels = scales::label_number()
  )

# legenda  ----------------------------------------------------------------

p

p +
  theme(legend.position = "bottom")
p +
  theme(legend.position = "none")
p +
  theme(legend.title = element_blank())


p +
  theme(
    legend.title = element_text(color = "blue", size = 15),
    legend.text = element_text(color = "red", face = "bold")
  )

p +
  theme(
    legend.position = c(0.95, 0.2),
    legend.justification = c("right", "bottom"),
    legend.background = element_rect(fill = "white", color = "black")
  )

p +
  theme(legend.position = "top", legend.direction = "horizontal") +
  guides(fill = guide_colorbar(barwidth = 15, barheight = 0.5))

p +
  theme(legend.key = element_blank(),
        legend.key.size = unit(1.2, "cm"))

