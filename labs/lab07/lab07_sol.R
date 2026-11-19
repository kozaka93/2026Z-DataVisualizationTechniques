#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 7                    #
#=======================================================#

library(dplyr)
library(ggplot2)
library(patchwork)
library(ggpubr)
library(ggrepel)


# 0. Zadania rozgrzewkowe -------------------------------------------------

## Zadanie 0.1 ------------------------------------------------------------
# Wykorzystując dane diamonds z pakietu ggplot2 sprawdź, jak rozkładają się 
# ceny diamentów w zależności od ich cięcia (cut).

p1 <- ggplot(diamonds, aes(x = price)) +
  geom_histogram(bins = 50, color = "white") +
  facet_wrap(~cut) + 
  labs(title = "Rozkład cen diamentów wg szlifu",
       x = "Cena ($)", y = "Liczba diamentów") +
  theme_minimal() +
  theme(legend.position = "none")

p1 <- ggplot(diamonds, aes(x = price, y =cut)) +
  geom_boxplot() + 
  labs(title = "Rozkład cen diamentów wg szlifu",
       x = "Cena ($)", y = "Rodzaj cięcia") +
  theme_minimal() +
  theme(legend.position = "none")

p1 <- ggplot(diamonds, aes(x = price, y =cut)) +
  geom_violin() + 
  labs(title = "Rozkład cen diamentów wg szlifu",
       x = "Cena ($)", y = "Rodzaj cięcia") +
  theme_minimal() +
  theme(legend.position = "none")


## Zadanie 0.2 ------------------------------------------------------------
# Wykorzystując zbiór danych economics z pakietu ggplot2 sprawdź jak 
# zmieniała się liczba bezrobotnych w USA na przestrzeni lat.
# Na osi X umieść datę (date), a na osi Y liczbę bezrobotnych (unemploy).
# Dodaj linię trendu (geom_smooth()).


p2 <- ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line(color = "royalblue", linewidth = 0.8) +
  geom_smooth(color = "red",
              se = FALSE,
              size = 1) +
  labs(
    title = "Trend bezrobocia w USA",
    subtitle = "Dane historyczne z bazy economics",
    x = "Rok",
    y = "Liczba bezrobotnych (w tys.)"
  ) +
  theme_bw()

p2



# 1. patchwork ------------------------------------------------------------

# Patchwork pozwala traktować wykresy jak liczby, używamy prostych symboli:
#  + lub |: umieszcza wykresy obok siebie (poziomo)
#  /: umieszcza wykresy jeden pod drugim (pionowo)
# (): pozwala na grupowanie wykresów w celu tworzenia złożonych podukładów 

p2 + p1
p2 | p1
p1 / p2

(p1 | p2 | p1) / p2
(p1 + p2)/(p2 +p1)

# Funkcja plot_layout() daje pełną kontrolę nad strukturą kompozycji
# ncol / nrow: określa liczbę kolumn i wierszy
# widths / heights: określa proporcję wielkości poszczególnych paneli 
# guides = 'collect': zbiera legendy ze wszystkich wykresów i umieszcza jedną wspólną 

# określenie liczby wierszy i kolumn
p1 + p2 + p1 + p2 + plot_layout(ncol = 2, nrow = 2)

# pierwszy wiersz jest dwa razy wyższy niż drugi
p1 + p2 + p1 + p2 + plot_layout(ncol = 2, nrow = 2,
                                widths = c(2, 1),
                                heights = c(2, 1))



# Funkcja plot_annotation() pozwala na dodanie jednego tytułu do wykresów
# tytuł, podtytuł i podpis: dodawanie metadanych dla całego zestawu wykresów.
# tagowanie: automatyczne dodawanie etykiet identyfikujących (np. A, B, C lub I, II, III) 
# do poszczególnych paneli za pomocą parametru tag_levels.


p1 + p2 + p2 + p1 + plot_layout(ncol = 2, nrow = 2) + plot_annotation(
  title = "Wykresy razem",
  subtitle = "2 x 2",
  caption = Sys.Date(),
  theme = theme(plot.title = element_text(size = 16)),
  tag_levels = 'A' # może być też 'a'
)

p1 + p2 + p2 + p1 + plot_layout(ncol = 2, nrow = 2) + plot_annotation(
  title = "Wykresy razem",
  subtitle = "2 x 2",
  caption = Sys.Date(),
  theme = theme(plot.title = element_text(size = 16, color = "navy")),
  tag_levels = 'I' # może być też 'i'
) 


# Patchwork pozwala na wstawianie do układu elementów, które nie są wykresami:
# plot_spacer(): wstawia pustą przestrzeń w miejsce, gdzie normalnie byłby wykres
# tabele i tekst: można wkomponować tabele lub bloki tekstu w strukturę raportu graficznego
# (dzięki integracji z innymi pakietami, np. ggpubr
# Operator & (np. p1 + p2 & theme_bw()) pozwala zmienić wygląd wszystkich składowych wykresów

# pusta przestrzeń
p1 + p2 + plot_spacer() + p1


# tabela ze zliczeniem diamentów względem rodzaju cięcia
tmp <- as.data.frame(table(diamonds$cut))
names(tmp) <- c("Rodzaj cięcia", "Liczba diamentów")

# obiekt tabeli (pakiet ggpubr)
tab <- ggtexttable(tmp, theme = ttheme("light"), rows = NULL) %>%
  tab_add_footnote(text = "*Tabela utworzona w pakiecie ggpubr", size = 10)

# łączenie w jeden obiekt 
p1 + tab

# zmiana stylu wszystkich wykresów

p1 + p2 + p2 + p1 + plot_layout(ncol = 2, nrow = 2) + plot_annotation(
  title = "Wykresy razem",
  subtitle = "2 x 2",
  caption = Sys.Date(),
  theme = theme(plot.title = element_text(size = 16, color = "navy")),
  tag_levels = 'I'
) & theme_dark()


## Zadanie 1.1 -------------------------------------------------------------
# Stwórz wykres gęstości brzegowych dla zbioru danych iris składający się z:
# a) wykresu punktowego (Sepal.Length ~ Sepal.Width)
# b) rozkład zmiennej Sepal.Length względem gatunku
# c) rozkład zmiennej Sepal.Width względem gatunku

# 1. Wykres główny (punktowy)
main_plot <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  theme_minimal() +
  theme(legend.position = "bottom")

# 2. Wykres górny (gęstość na osi X)
upper_density <- ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_density(alpha = 0.5) +
  theme_void() + # Usuwamy osie i tło
  theme(legend.position = "none")

# 3. Wykres boczny (gęstość na osi Y)
right_density <- ggplot(iris, aes(Sepal.Width, fill = Species)) +
  geom_density(alpha = 0.5) +
  coord_flip() + # Obracamy wykres
  theme_void() +
  theme(legend.position = "none")

(upper_density + plot_spacer() + 
    main_plot + right_density) + 
  plot_layout(
    ncol = 2, 
    nrow = 2, 
    widths = c(4, 1), 
    heights = c(1, 4)
  )

# Składanie wykresu z usunięciem marginesów
final_plot <- (upper_density + plot_spacer() + 
                 main_plot + right_density) + 
  plot_layout(ncol = 2, nrow = 2, 
              widths = c(4, 1), 
              heights = c(1, 4)) & 
  theme(plot.margin = margin(1, 1, 1, 1, "pt")) # Minimalny odstęp 1 punktu, tu pozwala na mniejsze odstępy

final_plot

# inset_element()
# pozwala umieścić mały wykres "wewnątrz" dużego, podając współrzędne od 0 do 1

main_plot + inset_element(upper_density, left = 0, bottom = 0.8, right = 1, top = 1)


# 2. ggrepel --------------------------------------------------------------

# geom_text_repel vs geom_label_repel
# Działają identycznie jak ich odpowiedniki w ggplot2, ale automatycznie 
# odpychają etykiety od siebie i od punktów danych.
#
# geom_text_repel(): wstawia sam tekst
# 
# geom_label_repel(): wstawia tekst w ramce
# 
# Kluczowe parametry
# - „siła odpychania”
# box.padding: określa, ile wolnego miejsca ma być wokół każdej etykiety
# point.padding: ustala dystans między etykietą a samym punktem
# force: siła odpychania

top_diamonds <- subset(diamonds, price > 18500 & carat > 2.5)

ggplot(top_diamonds, aes(x = carat, y = price, label = clarity)) +
  geom_point(color = "royalblue") +
  geom_text_repel(
    force = 20,              # Silne odpychanie
    box.padding = 0.5,       # Miejsce wokół etykiety
    point.padding = 0.3,     # Dystans od punktu
    color = "darkred"
  ) +
  labs(title = "Siła odpychania w geom_text_repel") +
  theme_minimal()


# Linie łączące
# min.segment.length: np. 0.5, linie pojawią się tylko wtedy, gdy etykieta jest oddalona o więcej niż 0.5 mm
# segment.color, segment.size, segment.alpha: pozwalają zmienić kolor, grubość i przezroczystość linii pomocniczych
# arrow: można dodać strzałkę na końcu linii 

ggplot(top_diamonds, aes(x = carat, y = price, label = cut)) +
  geom_point(color = "darkgreen") +
  geom_label_repel(
    min.segment.length = 0.1,    # Linie pojawią się prawie zawsze
    segment.color = "grey50",    # Kolor linii
    segment.size = 0.8,          # Grubość linii
    segment.alpha = 0.6,         # Przezroczystość
    arrow = arrow(length = unit(0.02, "npc")), # Dodanie strzałki
    fill = "white"
  ) +
  labs(title = "Etykiety w ramkach ze strzałkami") +
  theme_light()




# Ograniczanie ruchu
# direction: można wymusić ruch etykiet tylko w jednym kierunku: "x", "y" lub "both" (domyślnie).
# nudge_x / nudge_y: pozwala ręcznie przesunąć etykiety o konkretną wartość przed uruchomieniem algorytmu odpychania

ggplot(top_diamonds, aes(x = carat, y = price, label = color)) +
  geom_point(color = "orange") +
  geom_text_repel(
    direction = "y",         # Ruch tylko w pionie
    nudge_x = 0.2,           # Przesunięcie startowe w prawo
    angle = 90,              # Obrócenie tekstu o 90 stopni
    vjust = 0.5,
    segment.curvature = -0.1 # Lekkie zakrzywienie linii
  ) +
  labs(title = "Ruch ograniczony do osi Y z przesunięciem (nudge)") +
  theme_classic()



## Zadanie 2.1 ------------------------------------------------------------
# Przygotuj wykres zależności ceny od liczby karatów (ramka danych diamonds).
# Podpisz tylko diamenty o masie powyżej 3 karatów (zmienną cut).


# ogarniczenie danych do podpisu w funkcji geom_text_repel
ggplot(diamonds[diamonds$carat >2, ], aes(x = carat, y = price, label = cut)) + 
  geom_point() +
  geom_text_repel(
    data = subset(diamonds, carat > 3),
    max.overlaps = Inf
  )

# ogarniczenie danych do podpisu w funkcji mutate
diamonds %>%
  mutate(cut2 = ifelse(carat > 3, cut, NA)) %>%
  ggplot(aes(x = carat, y = price, label = cut2)) + 
  geom_point() +
  geom_text_repel(
    max.overlaps = Inf
  )
