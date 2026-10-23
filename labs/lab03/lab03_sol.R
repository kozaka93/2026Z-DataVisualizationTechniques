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

msleep %>% 
  filter(bodywt > 100) %>% 
  mutate(sleep_total_min = sleep_total*60) %>% 
  group_by(order) %>% 
  summarise(sen = mean(sleep_total_min)) %>% 
  arrange(-sen)

## Zadanie 0.2 -------------------------------------------------------------
# Używając zbioru danych diamonds stwórz wykres punktowy, gdzie na osi X 
# znajdzie się liczba karatów (carat), a na osi Y cena (price).

# Nadaj punktom kolory w zależności od szlifu diamentu (cut).

# Dodaj do wykresu odpowiednie etykiety: tytuł "Zależność ceny od masy diamentu"
# oraz polskie nazwy osi.


ggplot(diamonds, aes(x = carat,
                     y = price,
                     color = cut)) +
  geom_point() + 
  labs(title = "Zależność ceny od masy diamentu",
       x = "Liczba karatów",
       y = "Cena",
       color = "Szlif")


# 1. ggplot2 --------------------------------------------------------------


## Badanie rozkładu jednej zmiennej - zmienna jakościowa ------------------


## a) wykres słupkowy - geom_bar(), geom_col() ----------------------------

ggplot(diamonds, aes(x = cut)) +
  geom_bar()

ggplot(diamonds, aes(x = cut)) +
  geom_bar(color = "red", fill = "#8af1bd") +
  labs(x = "Cięcie",
       y = "Liczność",
       title = "Liczność diamentów ze względu na rodzaj cięcia") +
  theme_bw() # styl wykresu


# !Note: W przypadku funkcji geom_col() trzeba przygotować
# tabelę ze zliczeniami.

# !Note: ggplot2 używa data.frame.
tmp <- data.frame(table(diamonds$cut)) # zliczamy występowanie elementów

ggplot(tmp, aes(x = Var1, y = Freq)) + 
  geom_col() +
  coord_flip() + # zamienia x z y
  labs(x = "Cięcie",
       y = "Liczność",
       title = "Liczność diamentów ze względu na rodzaj cięcia") +
  theme_bw()

ggplot(tmp, aes(y = Var1, x = Freq)) +
  geom_col() +
  labs(y = "Cięcie",
       x = "Liczność",
       title = "Liczność diamentów ze względu na rodzaj cięcia") +
  theme_bw()


## b) wykres kołowy --------------------------------------------------------

# !Note: W ggplot2 nie ma funkcji pozwalającej na rysowanie wykresu kołowego.
# Należy wykorzystać wykres słupkowy i zamienić na współrzędne biegunowe.
ggplot(tmp, aes(x = "", y = Freq, fill = Var1)) +
  geom_col(width = 1) +
  coord_polar("y")


# Zadanie 1.1 -------------------------------------------------------------
# Zbadaj rozkład zmiennej kolor diamentu (kolumna "color").
# Zadbaj o czytelność wykresu.

ggplot(diamonds, aes(x = color)) + 
  geom_bar(fill = "#43ae03") + 
  theme_minimal() + 
  labs(x = "Kolor",
       y = "Liczność",
       title = "Liczność diamentów ze względu na kolor")


## Badanie rozkładu jednej zmiennej - zmienna ilościowa -------------------


#### Przykład z tablicy --------------------------------------------------

# 1. Przygotowanie danych (nasze 10 pensji w tys. zł)
zarobki_df <- data.frame(
  pensja = c(4.0, 4.5, 5.0, 5.2, 5.5, 6.0, 6.5, 7.0, 8.5, 12.0)
)

# 2. WYKRES SKRZYNKOWY (Boxplot)
p1 <- ggplot(zarobki_df, aes(x = "", y = pensja)) +
  geom_boxplot(fill = "skyblue", color = "darkblue", alpha = 0.7, outlier.color = "red", outlier.size = 3) +
  theme_minimal() +
  labs(
    title = "Wykres skrzynkowy (Boxplot)",
    subtitle = "Widać medianę, pudełko 50% danych i pojedynczą wartość odstającą",
    x = "", 
    y = "Pensja (tys. zł)"
  ) +
  theme(axis.text.y = element_blank(), axis.ticks.y= element_blank()) +
  coord_flip()

# 3. HISTOGRAM
p2 <- ggplot(zarobki_df, aes(x = pensja)) +
  geom_histogram(binwidth = 2, fill = "lightgreen", color = "darkgreen", boundary = 4) +
  theme_minimal() +
  labs(
    title = "Histogram",
    subtitle = "Zliczanie obserwacji w przedziałach (binwidth = 2)",
    x = "Pensja (tys. zł)", 
    y = "Liczba osób"
  )

# 4. WYKRES GĘSTOŚCI (Density Plot)
p3 <- ggplot(zarobki_df, aes(x = pensja)) +
  geom_density(fill = "orange", color = "darkorange", alpha = 0.5, linewidth = 1) +
  geom_rug(color = "darkred") + # Dodaje małe "paski" na osi X pokazujące dokładne pozycje obserwacji
  theme_minimal() +
  labs(
    title = "Wykres gęstości (Density Plot)",
    subtitle = "Wygładzona intuicja rozkładu (paski na dole to konkretne dane)",
    x = "Pensja (tys. zł)", 
    y = "Gęstość"
  )

library(patchwork)

p1 / p2 / p3

## a) histogram - geom_histogram() ----------------------------------------

ggplot(diamonds, aes(x = carat)) +
  geom_histogram()

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 1, color = "red") +
  labs(x = "Liczba karatów",
       y = "Częstość",
       title = "Histogram dla zmiennej liczba karatów")

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(bins = 30, color = "red") +
  labs(x = "Liczba karatów",
       y = "Częstość",
       title = "Histogram dla zmiennej liczba karatów",
       subtitle = "1 karat = 0,2g",
       caption = "Author: JA")

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(bins = 30, color = "red") +
  labs(x = "Liczba karatów",
       y = "Częstość",
       title = "Histogram dla zmiennej liczba karatów",
       subtitle = "1 karat = 0,2g",
       caption = Sys.Date())


# !Note: część wykresu możemy przypisywać do zmiennej.

p <- ggplot(diamonds, aes(x = carat))

p + geom_histogram()


## b) wykres pudełkowy - geom_boxplot() -----------------------------------

p + 
  geom_boxplot()

p + 
  geom_boxplot(outlier.color = "violet") +
  coord_flip()

## c) wykres gęstości - geom_density() -----------------------------------

p + 
  geom_density() 

p + 
  geom_density(adjust = 1/2)

p + 
  geom_density(adjust = 5)

p + 
  geom_density(adjust = 5) +
  xlim(0, 3)


# Zadanie 1.2 -------------------------------------------------------------
# Zbadaj rozkład zmiennej cena (price).
# Zadbaj o czytelność wykresu.

ggplot(diamonds, aes(x = price)) + 
  geom_boxplot() +
  labs(x = "Cena",
       y = "",
       title = "Rozkład zmiennej cena")

# !Note: Zadanie można rozwiązać na kilka sposobów.
ggplot(diamonds, aes(x = price)) + 
  geom_histogram() +
  labs(x = "Cena",
       y = "",
       title = "Rozkład zmiennej cena")

ggplot(diamonds, aes(x = price)) + 
  geom_density() +
  labs(x = "Cena",
       y = "",
       title = "Rozkład zmiennej cena")


## Badanie rozkładu dwóch zmiennych - zmienne ilościowe -------------------

# a) wykres punktowy ------------------------------------------------------

ggplot(diamonds, aes(x = x, y = y)) + 
  geom_point()


## Badanie rozkładu dwóch zmiennych - zmienna jakościowa i ilościowa ------

# a) wykres punktowy ------------------------------------------------------

ggplot(diamonds, aes(x = price, y = color)) + 
  geom_jitter()

# !Note: Nie jest to preferowany rodzaj wykresu.

# b) wykres skrzypcowy/pudełkowy-------------------------------------------

ggplot(diamonds, aes(x = price, y = color)) + 
  geom_violin() 

ggplot(diamonds, aes(x = price, y = color)) + 
  geom_boxplot()

# c) wykres gęstości z podziałem na kolory --------------------------------

ggplot(diamonds, aes(x = price, color = color)) + 
  geom_density()

# !Note: notacja naukowa 
options(scipen = 6)

ggplot(diamonds, aes(x = price, fill = color)) + 
  geom_density(alpha=0.25) + 
  labs(x = "Cena",
       y = "Gęstość", 
       title = "Rozkład zmiennej cena względem zmiennej color",
       fill = "Kolor")



# Zadanie 1.3 -------------------------------------------------------------
# Stwórz wykres rozproszenia, który pokaże zależność między masą diamentu (carat)
# a jego ceną (price). Zadbaj o czytelność wykresu.

ggplot(diamonds, aes(x = carat, 
                     y = price)) + 
  geom_point() +
  labs(title= "Zależność między masą diamentu (carat) a jego ceną (price)",
       x = "Karaty",
       y = "Cena")



# Zadanie 1.4 -------------------------------------------------------------
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
