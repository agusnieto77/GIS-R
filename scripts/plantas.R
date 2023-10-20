require(readr)
require(readxl)
require(sf)
require(dplyr)
require(stringr)
require(leaflet)
require(leaflet.extras)
require(RColorBrewer)
require(ggspatial)

plantas96 <- read_excel("data/plantas96.xlsx")
plantas18 <- read_excel("data/plantas18.xlsx")

plantas96$ORGANIZACION <- str_to_upper(plantas96$ORGANIZACION, locale = "es")

plantas96$DIRECCION <- str_to_upper(plantas96$DIRECCION, locale = "es")

plantas96 <- filter(plantas96, !is.na(lon), !is.na(Rubro))

plantas96$Descripcion <- paste(
  '<b>Nombre: </b>', plantas96$ORGANIZACION, '<br>',
  '<b>Dirección: </b>', plantas96$DIRECCION, '<br>',
  sep = '')

plantas96 <- plantas96 %>% mutate(lon = str_replace_all(lon,',','.'),
                                  lat = str_replace_all(lat,',','.'),
                                  lon = str_replace_all(lon, '–', '-'),
                                  lat = str_remove_all(lat, '\\.$'))

plantas96 <- plantas96 |> mutate(lon = as.numeric(lon),
                                 lat = as.numeric(lat))


leaflet(plantas96) %>%
  addProviderTiles(providers$Stadia.StamenTonerLite) %>%
  addHeatmap(lng =~lon, lat=~lat,
             blur = 20, max = 0.05, radius = 15 )

ggplot(plantas96, aes(x=lon, y=lat) ) +
  geom_density_2d()

ggplot(plantas96, aes(x=lon, y=lat) ) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon")

ggplot(plantas96, aes(x=lon, y=lat) ) + 
  stat_density_2d(
    aes(
      x = lon,
      y = lat,
      fill = after_stat(level)
    ),
    alpha = .5,
    bins = 25,
    geom = "polygon"
  ) +
  scale_fill_gradientn(colors = brewer.pal(7, "YlOrRd"))

####------MAPAS-------

pueyrredon <- read_sf("shapes/pueyrredon.shp")
radios <- read_sf("shapes/radios.shp")
barrios <- read_sf("shapes/barrios.shp")



st_crs(radios) <- 4326  # WGS84 (usado en GPS para el mundo)
st_crs(pueyrredon) <- 22186


#mapa1996
ggplot(radios) +
  geom_sf(fill = alpha("white",0.2), data = pueyrredon) +
  geom_sf(fill = alpha("white",0.8),data = barrios) +
  coord_sf(xlim = c(-57.7, -57.5), ylim = c(-38.1, -37.9), expand = FALSE) +
  stat_density_2d(
    aes(
      x = lon,
      y = lat,
      fill = stat(level)
    ),
    alpha = .5,
    bins = 50,
    geom = "polygon",
    n = 100,
    show.legend = F,
    data = distinct(plantas96, DIRECCION, .keep_all = TRUE)
  ) +
  scale_fill_gradientn(colours=rev(brewer.pal(6,"RdYlBu")),
                       name="",
                       na.value = "grey100") +
  annotation_scale(location = "bl", width_hint = 0.2) +
  annotation_scale(location = "bl", width_hint = 0.2) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.1, "in"), 
                         pad_y = unit(0.25, "in"),
                         style = north_arrow_fancy_orienteering) +
  labs(caption = "Fuente: Censo Pesquero 1996 | n: 127") +
  xlab(NULL) +
  ylab(NULL) +
  theme_bw() +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        text = element_text(size = 16))

#mapa2018
ggplot(radios) +
  geom_sf(fill = alpha("white",0.2), data = pueyrredon) +
  geom_sf(fill = alpha("white",0.8),data = barrios) +
  coord_sf(xlim = c(-57.7, -57.5), ylim = c(-38.1, -37.9), expand = FALSE) +
  stat_density_2d(
    aes(
      x = lon,
      y = lat,
      fill = stat(level)
    ),
    alpha = .5,
    bins = 50,
    geom = "polygon",
    n = 100,
    show.legend = F,
    data = plantas18
  ) +
  scale_fill_gradientn(colours=rev(brewer.pal(6,"RdYlBu")),
                       name="",
                       na.value = "grey100") +
  annotation_scale(location = "bl", width_hint = 0.2) +
  annotation_scale(location = "bl", width_hint = 0.2) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.1, "in"), 
                         pad_y = unit(0.25, "in"),
                         style = north_arrow_fancy_orienteering) +
  labs(caption = "Fuente: MGP 2018 | n: 166") +
  xlab(NULL) +
  ylab(NULL) +
  theme_bw() +
  theme(legend.position = 'bottom',
        legend.title = element_blank(),
        text = element_text(size = 16))
