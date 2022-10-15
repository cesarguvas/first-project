install.packages("httr")
install.packages("jsonlite")
library(rvest)
library(httr)
library(jsonlite)
library(tidyr)

# guardamos la consulta api en 'url', luego extraemos la informacion de la
# consulta con GET y lo asignamos a 'datos'

url <- "https://opensky-network.org/api/states/all"
datos <- GET(url)
datos

# la respuesta es un formato json, utilizo la funcion content para extraer como 
# texto ya que la respuesta es una respuesta de servidor, y la funcion fromJSON 
# para convertirlo en un objeto de R 

datos <- fromJSON(content(datos, type = "text"))

# ahora tenemos una lista de 2 elementos, la que nos interesa es 'states'

datos <- datos[["states"]]

# ahora tenemos una matriz que es lo que queremos, solo nos falta asignar los
# nombres a nuestras columnas. Los nombres correspondientes a cada columna estan 
# en la pagina de documentacion de la api, podemos asignarlo manualmente.

# O podemos extraer las tablas de la pagina donde se encuentra la informacion y 
# asignarlo haciendo web scraping basico, para esto guardamos el documento html
# en la variable 'url2'

url2 <- read_html("https://openskynetwork.github.io/opensky-api/rest.html")

# luego extraemos las tablas de la variable 'url2' y lo asignamos a la variable 'tablas'

tablas <- url2 %>% html_table()

# en la tabla 5 esta la referencia a los nombres de a las columnas de nuestra 
# tabla 'datos'

tablas[[5]]

# asignamos la tabla 5 a la variable 'coltablas' y eliminamos el ultimo registro
# ya que tiene 18 registros, y nuestra tabla 'datos' tiene 17 columnas

coltablas <- tablas[[5]]

coltablas <- coltablas[-18, ]

# la columna Property es la que contiene los nombres de las columnas de la tabla
# datos, por los tanto lo asigno: 

colnames(datos) <- coltablas$Property

# convertimos 'datos' en un dataframe

datos <- as.data.frame(datos, stringsAsFactors = FALSE)

# para visualizarlo en un mapa cargamos el paquete leaflet

install.packages("leaflet")
library(leaflet)

# convertimos a numero la columna longitude y latityde porque estan con caracter

class(datos$longitude)
class(datos$latitude)

datos$longitude <- as.numeric(datos$longitude)
datos$latitude <- as.numeric(datos$latitude)

# creamos nuestra visualizacion

leaflet() %>% 
  addTiles() %>% 
  addCircles(lng=datos$longitude, lat=datos$latitude, color = "#e63946", opacity = 0.2)