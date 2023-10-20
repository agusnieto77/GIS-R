library(readr)
library(tidygeocoder)
library(dplyr)
library(ggplot2)
library(sf)

plantas_2007_mdp <- read_delim("data/plantas_2007_mdp.csv", 
                               delim = ";", escape_double = FALSE, trim_ws = TRUE)

plantas_2007_mdp 

tidygeocoder::geo(city = "Mar del Plata", method = "osm")

tidygeocoder::geo(
  street = "Mitre 1300", city = "Mar del Plata",
  state = "Buenos Aires", method = "osm"
)

geo(address = c("Tokyo, Japón", "Lima, Perú", "Nairobi, Kenya"),
    method = 'osm')

count(plantas_2007_mdp, DOMICILIO) |> arrange(desc(n))

plantas_2007_mdp_geocoor <-
  geo(
    street  = plantas_2007_mdp$DOMICILIO,
    city    = plantas_2007_mdp$LOCALIDAD,
    state   = plantas_2007_mdp$PROVINCIA,
    country = rep('Argentina', length(plantas_2007_mdp$PROVINCIA)),
    method  = 'osm'
  )

plantas_2007_mdp_geocoor

plantas_2007_mdp_geocoor <- filter(plantas_2007_mdp_geocoor, !is.na(lat))

ggplot(plantas_2007_mdp_geocoor) +
  geom_point(aes(x = long, y = lat))

pueyrredon <- read_sf("shapes/pueyrredon.shp")
radios <- read_sf("shapes/radios.shp")
barrios <- read_sf("shapes/barrios.shp")

st_crs(radios) <- 4326
st_crs(pueyrredon) <- 22186

ggplot(radios) +
  geom_sf(fill = alpha("white",0.2), data = pueyrredon) +
  geom_sf(fill = alpha("white",0.8),data = barrios) +
  geom_point(aes(x = long, y = lat), data = plantas_2007_mdp_geocoor)

ggplot(radios) +
  geom_sf(fill = alpha("white",0.2), data = pueyrredon) +
  geom_sf(fill = alpha("white",0.8),data = barrios) +
  geom_point(aes(x = long, y = lat), data = plantas_2007_mdp_geocoor) + 
  coord_sf(xlim = c(-57.7, -57.5), ylim = c(-38.1, -37.9), expand = FALSE)
