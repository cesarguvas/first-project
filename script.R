install.packages("httr")
install.packages("jsonlite")
library(rvest)
library(httr)
library(jsonlite)

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

# asignamos los nombres al dataframe datos

colnames(datos) <- coltablas$Property

