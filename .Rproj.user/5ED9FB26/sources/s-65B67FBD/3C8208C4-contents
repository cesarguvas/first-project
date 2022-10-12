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

# comentarios varios
