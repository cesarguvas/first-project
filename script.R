library(rvest)
library(httr)
library(jsonlite)
library(tidyverse)

# hago una solicitud de tipo get a la api y lo asigno a la variable 'datos'
# para esto utilizo la funcion GET de la libreria httr

datos <- GET("https://opensky-network.org/api/states/all")
datos

# la respuesta del servidor almacenada en la variable 'datos' esta en formato
# raw, utilizo la funcion rawToChart para convertir el contenido en vector de 
# caracteres y luego convertirlo en una lista usando fromJSON

datos <- fromJSON(rawToChar(datos$content))

# ahora tenemos una lista de 2 elementos, la que nos interesa es 'states'

datos <- datos[["states"]]

# ahora tenemos una matriz que es lo que queremos, solo nos falta asignar los
# nombres a nuestras columnas. Los nombres correspondientes a cada columna estan 
# en la pagina de documentacion de la api, podemos asignarlo manualmente.

# O podemos extraer las tablas de la pagina donde se encuentra la informacion y 
# asignarlo haciendo web scraping basico, para esto guardamos el documento html
# en la variable 'url'

url <- read_html("https://openskynetwork.github.io/opensky-api/rest.html")

# luego extraemos las tablas de la variable 'url' y lo asignamos a la variable 'tablas'

tablas <- url %>% html_table()

# en la tabla 5 esta la referencia a los nombres de a las columnas de nuestra 
# tabla 'datos'

tablas[[5]]

# asignamos la tabla 5 a la variable 'coltablas' y eliminamos el ultimo registro
# ya que tiene 18 registros, y nuestra tabla 'datos' tiene 17 columnas

coltablas <- tablas[[5]]

coltablas <- coltablas[-18, ]

# la columna Property es la que contiene los nombres de las columnas de la tabla
# 'datos', por lo tanto lo asigno: 

colnames(datos) <- coltablas$Property

# convertimos 'datos' en un dataframe

datos <- as.data.frame(datos, stringsAsFactors = FALSE)

# para visualizarlo en un mapa cargamos el paquete leaflet

install.packages("leaflet")
library(leaflet)

# convertimos a numero la columna longitude y latitude ya que estan como character

class(datos$longitude)
class(datos$latitude)

datos$longitude <- as.numeric(datos$longitude)
datos$latitude <- as.numeric(datos$latitude)

# creamos nuestra visualizacion

leaflet() %>% 
  addTiles() %>% 
  addCircles(lng=datos$longitude, lat=datos$latitude, color = "#e63946", opacity = 0.2)