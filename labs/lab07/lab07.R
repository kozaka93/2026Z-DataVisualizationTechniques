#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 7                    #
#=======================================================#

library(dplyr)
library(ggplot2)
library(patchwork)
library(ggpubr)
library(ggrepel)
# install.packages("patchwork")
# install.packages("ggpubr")
# install.packages("ggrepel")


# 0. Zadania rozgrzewkowe -------------------------------------------------

## Zadanie 0.1 ------------------------------------------------------------
# Wykorzystując dane diamonds z pakietu ggplot2 sprawdź, jak rozkładają się 
# ceny diamentów w zależności od ich cięcia (cut).







## Zadanie 0.2 ------------------------------------------------------------
# Wykorzystując zbiór danych economics z pakietu ggplot2 sprawdź jak 
# zmieniała się liczba bezrobotnych w USA na przestrzeni lat.
# Na osi X umieść datę (date), a na osi Y liczbę bezrobotnych (unemploy).
# Dodaj linię trendu (geom_smooth()).

?economics







# 1. patchwork ------------------------------------------------------------

# Patchwork pozwala traktować wykresy jak liczby, używamy prostych symboli:
#  + lub |: umieszcza wykresy obok siebie (poziomo)
#  /: umieszcza wykresy jeden pod drugim (pionowo)
# (): pozwala na grupowanie wykresów w celu tworzenia złożonych podukładów 






# Funkcja plot_layout() daje pełną kontrolę nad strukturą kompozycji
# ncol / nrow: określa liczbę kolumn i wierszy
# widths / heights: określa proporcję wielkości poszczególnych paneli 
# guides = 'collect': zbiera legendy ze wszystkich wykresów i umieszcza jedną wspólną 

# określenie liczby wierszy i kolumn


# pierwszy wiersz jest dwa razy wyższy niż drugi



# Funkcja plot_annotation() pozwala na dodanie jednego tytułu do wykresów
# tytuł, podtytuł i podpis: dodawanie metadanych dla całego zestawu wykresów.
# tagowanie: automatyczne dodawanie etykiet identyfikujących (np. A, B, C lub I, II, III) 
# do poszczególnych paneli za pomocą parametru tag_levels.






# Patchwork pozwala na wstawianie do układu elementów, które nie są wykresami:
# plot_spacer(): wstawia pustą przestrzeń w miejsce, gdzie normalnie byłby wykres
# tabele i tekst: można wkomponować tabele lub bloki tekstu w strukturę raportu graficznego
# (dzięki integracji z innymi pakietami, np. ggpubr
# Operator & (np. p1 + p2 & theme_bw()) pozwala zmienić wygląd wszystkich składowych wykresów

# pusta przestrzeń




# tabela ze zliczeniem diamentów względem rodzaju cięcia
tmp <- as.data.frame(table(diamonds$cut))
names(tmp) <- c("Rodzaj cięcia", "Liczba diamentów")

# obiekt tabeli (pakiet ggpubr)
tab <- ggtexttable(tmp, theme = ttheme("light"), rows = NULL) %>%
  tab_add_footnote(text = "*Tabela utworzona w pakiecie ggpubr", size = 10)

# łączenie w jeden obiekt 
p1 + tab

# zmiana stylu wszystkich wykresów




## Zadanie 1.1 -------------------------------------------------------------
# Stwórz wykres gęstości brzegowych dla zbioru danych iris składający się z:
# a) wykresu punktowego (Sepal.Length ~ Sepal.Width)
# b) rozkład zmiennej Sepal.Length względem gatunku
# c) rozkład zmiennej Sepal.Width względem gatunku








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




# Linie łączące
# min.segment.length: np. 0.5, linie pojawią się tylko wtedy, gdy etykieta jest oddalona o więcej niż 0.5 mm
# segment.color, segment.size, segment.alpha: pozwalają zmienić kolor, grubość i przezroczystość linii pomocniczych
# arrow: można dodać strzałkę na końcu linii 





# Ograniczanie ruchu
# direction: można wymusić ruch etykiet tylko w jednym kierunku: "x", "y" lub "both" (domyślnie).
# nudge_x / nudge_y: pozwala ręcznie przesunąć etykiety o konkretną wartość przed uruchomieniem algorytmu odpychania





## Zadanie 2.1 ------------------------------------------------------------
# Przygotuj wykres zależności ceny od liczby karatów (ramka danych diamonds).
# Podpisz tylko diamenty o masie powyżej 3 karatów (zmienną cut).





