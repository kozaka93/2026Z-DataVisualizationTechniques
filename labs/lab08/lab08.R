#=======================================================#
#              TECHNIKI WIZUALIZACJI DANYCH             # 
#                     LABORATORIUM 8                    #
#=======================================================#

library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)
library(maps)
#install.packages("geojsonio")
library(geojsonio)

# 0. Zadanie rozgrzewkowe -------------------------------------------------

## Zadanie 0.1 ------------------------------------------------------------
# Rozważmy samochody z ramki danych mpg (z pakietu ggplot2). Wybierz samochody
# klasy c("compact", "midsize", "subcompact", "suv"). Przygotuj wykres pokazujący 
# rozkład splania na autostradzie (hwy) względem rodzaju napędu (drv) i klasy auta.




# 1. plotly ---------------------------------------------------------------

library(plotly)

## a) funkcja ggplotly



## b) struktura wykresów w plotly & interaktywność 

# Plotly w R działa inaczej niż standardowy plot(). W rzeczywistości jest to 
# wrapper na bibliotekę JavaScriptową. Wywołanie str(fig$x) pokazuje listę, 
# która jest wysyłana do przeglądarki jako obiekt JSON.

# Podobnie jak w ggplot2 dodajemy warstwy plusem, tutaj używamy pipe'a (%>%) , 
# co świetnie integruje się z dplyr.


x <- c("a", "b", "c")
y <- c(1, 3, 2)



# obiekt jak w ggplot2




df_raw <- read.csv("Pokemon.csv")

df_raw <- df_raw[,-1]

df <- df_raw %>%
  filter(Type.1 %in% c("Fire", "Water", "Grass", "Poison", "Electric")) %>%
  mutate(Type.1 = factor(Type.1, levels = c("Fire", "Water", "Grass", "Poison",  "Electric")))

plot_ly(
  data = df, 
  x = ~Attack, 
  y = ~Defense, 
  color = ~Type.1,
  colors = "Set1"
)

## 3D
plot_ly(
  data = df, 
  x = ~Attack, 
  y = ~Defense, 
  z = ~HP,
  color = ~Type.1, 
  colors = "Set1",
  type = "scatter3d",
  mode = "markers"
)

plot_ly(
  data = df, 
  x = ~Attack, 
  y = ~Defense, 
  z = ~Speed,
  color = ~Type.1, 
  colors = "Set1",
  symbol = ~Type.1, 
  symbols = c('circle', 'cross', 'diamond', 'square', 'circle'),
  marker = list(size = 5, line = list(color = 'black', width = 1)),
  type = "scatter3d",
  mode = "markers"
)

# b) Hover Tooltips
# Możliwość definiowania własnego tekstu w dymku (text = paste(...)) i formatowania 
# go za pomocą HTML (tagi <br>, <b>).

## tooltip https://plotly.com/r/hover-text-and-formatting
## legend https://plotly.com/r/legend

plot_ly(
  data = df, 
  x = ~Attack, 
  y = ~Defense, 
  color = ~Legendary,
  colors = c("black", "red"),
  text = paste0("Name: ", df$Name, "<br>Stage: ", df$Stage),
  hovertemplate = paste('<b>%{text}</b><br><b>X</b>: %{x}<br><b>Y</b>: %{y} <extra>tooltip</extra>')
) %>% 
  layout(
    legend = list(
      x = 0.1, y = 0.9, 
      title = list(text = "Legendary"), 
      bgcolor = "#E2E2E2"
    )
  )


## Zadanie 1.1 ------------------------------------------------------------
# Przedstaw rozkład punktów życia (HP). Zmień liczbę kubełków na 30.




## Zadanie 1.2 ------------------------------------------------------------
# Przedstaw liczbę Pokemonów dla każdego typu (Type.1). Zadbaj o posortowanie
# słupków od najbardziej licznego typu do najmniej.





## Zadanie 1.3 ------------------------------------------------------------
# Przygotuj wykres radarowy dla wybranego Pokemona. Wykorzystaj wykres 
# scatterpolar. Spróbuj porównać Pikachu i Raichu na jednym wykresie.





# 2. plotly + maps --------------------------------------------------------
## https://plotly.com/r/maps/

# prosta mapa świata
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv")





# wykres z dostosowanymi parametrami + hover
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")
df$hover <- with(df, paste(state, '<br>', "Beef", beef, "Dairy", dairy, "<br>",
                           "Fruits", total.fruits, "Veggies", total.veggies,
                           "<br>", "Wheat", wheat, "Corn", corn))
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

fig <- plot_geo(df, locationmode = 'USA-states')
fig <- fig %>% add_trace(
  z = ~total.exports, text = ~hover, locations = ~code,
  color = ~total.exports, colors = 'Purples', marker = list(line = l)
)
fig <- fig %>% colorbar(title = "Millions USD")
fig <- fig %>% layout(
  title = '2011 US Agriculture Exports by State<br>(Hover for breakdown)',
  geo = g
)

fig


# 3. leaflet --------------------------------------------------------------

## https://rstudio.github.io/leaflet/
## install.packages("leaflet")

# Obszar rysowania

leaflet()

# Mapa świata

leaflet() %>% 
  addTiles()

# Zaznaczony punkt
leaflet() %>%
  addTiles() %>% 
  addMarkers(lng = 21.007135613409062, lat = 52.22217811913538, popup = "Wydział MiNI")

# Punkty na mapie (Seattle)
df <- read.csv("https://raw.githubusercontent.com/MI2-Education/2023Z-DataVisualizationTechniques/main/homeworks/hw1/house_data.csv")
sam <- sample(1:nrow(df), 0.01 * nrow(df))
leaflet(df[sam,]) %>% 
  addTiles() %>% 
  addMarkers(lng = ~long, lat = ~lat)

# Połączenie leaflet i maps


mapStates = map("state", fill = TRUE, plot = FALSE)

leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL))

leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# Punkty 

m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles()

m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)

m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))

# Obszary

states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")
class(states)

m <- leaflet(states) %>%
  setView(-96, 37.8, 4) %>%
  addTiles()
m

m %>% addPolygons()

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin("YlOrRd", domain = states$density, bins = bins)

m %>% addPolygons(
  fillColor = ~pal(density),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7)

# Dodanie interakcji

m %>% addPolygons(
  fillColor = ~pal(density),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE))

# Dodanie informacji, które będą się wyświetlać po najechaniu na stan.

labels <- sprintf(
  "<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
  states$name, states$density
) %>% lapply(htmltools::HTML)

m <- m %>% addPolygons(
  fillColor = ~pal(density),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))
m

# Dodanie legendy 

m %>% addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")


## Zadanie 3.1 ------------------------------------------------------------
# Przygotuj mapę Polski, na której zaznaczysz wszystkie województwa jednolitym 
# kolorem wypełnienia. Następnie wyróżnij jedno wybrane województwo innym kolorem 
# oraz pogrubionym obrysem. Dodaj do tego województwa dymek.

polska <- geojsonio::geojson_read("https://raw.githubusercontent.com/ppatrzyk/polska-geojson/master/wojewodztwa/wojewodztwa-medium.geojson", what = "sp")




