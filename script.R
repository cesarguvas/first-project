install.packages("httr")
install.packages("jsonlite")
library(rvest)
library(httr)
library(jsonlite)

# guardamos la consulta a la api en 'url' y luego extaemos con GET 

url <- "https://opensky-network.org/api/states/all"
datos <- GET(url)
datos


# extraemos el contenido

datos <- fromJSON(content(datos, type = "text"))
datos <- datos[["states"]]

# extraemos las tablas de la pagina donde se encuentra la informacion

url2 <- read_html("https://openskynetwork.github.io/opensky-api/rest.html")

tablas <- url2 %>% html_table()

# en la tabla 5 esta la propiedad de los estados de nuestro dataframe 'datos'

tablas[[5]]

# eliminamos el ultimo registro ya que tiene 18, y el dataframe tiene 17

coltablas <- tablas[[5]]

coltablas <- coltablas[-18, ]

# asignamos los nombres al dataframe datos

colnames(datos) <- coltablas$Property


