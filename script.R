install.packages("httr")
install.packages("jsonlite")
library(rvest)
library(httr)
library(jsonlite)

# guardamos la url en una variable

url <- "https://opensky-network.org/api/states/all"
datos <- GET(url)
datos

datos <- fromJSON(content(datos, type = "text"))
datos <- datos[["states"]]

# extraemos las tablas de la pagina donde se encuentra la informacion

url <- read_html("https://openskynetwork.github.io/opensky-api/rest.html")

tablas <- url %>% html_table()

# en la tabla 5 esta la propiedad de los estados de nuestro dataframe 'datos'

tablas[[5]]

# eliminamos el ultimo registro ya que tiene 18, y el dataframe tiene 17

coltablas <- tablas[[5]]

coltablas <- coltablas[-18, ]

# asignamos los nombres al dataframe datos

colnames(datos) <- coltablas$Property


