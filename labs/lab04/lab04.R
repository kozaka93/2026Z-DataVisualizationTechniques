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








# Zadanie 0.2 -------------------------------------------------------------
# Założmy, że objętość diamentów wyliczamy jako iloczyn x, y i z. Wybierzmy
# diamenty o objętości mniejszej niż 50, ale większej niż 0. 
# Zaprezentuj rozkład ceny diamentów w zależności od jakości szlifu (cut).
# Zadbaj o czytelność wykresu.








?mpg
# Note: dane z pakietu ggplot2, dane na temat samochodów

## Zadanie 0.3 -------------------------------------------------------------
# Załóżmy, że interesują nas tylko samochody z lat 2000-2008 (kolumna year).
# Stwórz nową kolumną fuel_efficiency, która będzie średnią z zużycia paliwa
# w mieście (cty) i na autostradzie (hwy). 
# Narysuj rozkład tej nowej zmiennej w podziale na typ nadwozia (class).






?msleep
# Note: dane z pakietu ggplot2, dane na temat snu ssaków

## Zadanie 0.4 -------------------------------------------------------------
# Używając zbioru danych msleep wykonaj następujące kroki:

# 1) Wybierz tylko te zwierzęta, których masa ciała (bodywt)
# jest mniejsza niż 50 kg i które są roślinożercami (vore == "herbi").

# 2) Stwórz wykres słupkowy, który pokaże łączny czas snu (sleep_total)
# dla poszczególnych gatunków (name).

# 3) Chcemy, aby nazwy zwierząt były na osi pionowej.







# !Note: Słupki bez sortowania ciężko się odczytuje, znacznie łatwiej 
# uzyskiwać informacji jeżeli słupki są posortowane. Oczywiście sortowanie 
# nie ma sensu gdy kolejne słupki to są na przykład lata.

# 1. forcats --------------------------------------------------------------

# !Note: Pakiet forcats jest pomocnikiem w sortowaniu wartości (w szczególności
# gdy są to zmienne factor).


# a) sortowanie według wartości - fct_reorder -----------------------------



# b) zmiana nazw na bardziej czytelne - fct_recode ------------------------



# c) łączenie w grupy - fct_lump() ----------------------------------------



# 2. ggplot - kolory i skale ----------------------------------------------


# Zadanie 2.1 -------------------------------------------------------------
# Pogrupuj zwierzęta według gatunku (genus), wylicz dla każdego gatunku
# średni czas snu i średnią wagę ciała. Przygotuj wykres słupkowy,
# który na osi OX będzie przedstawiał średnią liczbę godzin snu,
# oś OY to gatunek a kolorem masę ciała.




# Co jest do poprawy? -----------------------------------------------------
# a) 
# b) 
# c) 


# a) ----------------------------------------------------------------------



# osie (x & y) ------------------------------------------------------------






# b)  ---------------------------------------------------------------------

# install.packages("RColorBrewer")
library(RColorBrewer)
RColorBrewer::brewer.pal(n = 5, name = "Blues")



# c) ----------------------------------------------------------------------





# legenda  ----------------------------------------------------------------





# Zadanie 2.2 -------------------------------------------------------------
# Wykorzystując zbiór danych mpg, przygotuj wykres słupkowy przedstawiający 
# średnie zużycie paliwa na autostradzie (hwy) dla poszczególnych 
# producentów (manufacturer).
# Wymagania:
# - Słupki na wykresie muszą być posortowane według średniego zużycia 
# paliwa (od największego do najmniejszego).
# - Oś pionowa (OY) powinna reprezentować producentów, 
# - Oś pozioma (OX) średnie zużycie.






# Zadanie 2.3 -------------------------------------------------------------
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



