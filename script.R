install.packages("httr")
install.packages("jsonlite")
library(rvest)
library(httr)
library(jsonlite)

# guardamos la consulta api en 'url, luego extraemos la informacion de la
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
# nombres a nuestras columnas.Los nombres correspondientes a cada columna estan 
# en la pagina de documentacion de la api, podemos asignarlo manualmente.

# O podemos extraer las tablas de la pagina donde se encuentra la informacion y 
# asignarlo haciendo algo de web scraping basico:

url2 <- read_html("https://openskynetwork.github.io/opensky-api/rest.html")

tablas <- url2 %>% html_table()

# en la tabla 5 esta la propiedad de los estados de nuestro dataframe 'datos'

tablas[[5]]

# eliminamos el ultimo registro ya que tiene 18, y el dataframe tiene 17

coltablas <- tablas[[5]]

coltablas <- coltablas[-18, ]

# asignamos los nombres al dataframe datos

colnames(datos) <- coltablas$Property


