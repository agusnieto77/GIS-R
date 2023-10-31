
require(cartogram)
require(tmap)
require(maptools)
require(sf)

data(wrld_simpl) # maptools

# Solo america del sur
am_sur <- wrld_simpl[wrld_simpl$SUBREGION == 5, ]

# definimos proyeccion del mapa
am_sur <- spTransform(am_sur, CRS("+init=epsg:3395"))

# Creamos un objeto sf
am_sur_sf <- st_as_sf(am_sur)

# Cartograma de area contigua
am_sur_sf_cont <- cartogram_cont(am_sur_sf, "POP2005", 15)

# Cartograma de area no contigua
am_sur_sf_ncont <- cartogram_ncont(am_sur_sf, "POP2005")

# Cartograma de area no contigua
am_sur_sf_dorling <- cartogram_dorling(am_sur_sf, "POP2005")

# Mapas

map0 <- tm_shape(am_sur) + tm_borders() +
  tm_polygons("POP2005", style="jenks", 
              palette = tmaptools::get_brewer_pal("PiYG", n = 5, contrast = c(0, 0.47), 
                                                  plot=FALSE), legend.show = FALSE) +
  tm_layout(frame = FALSE)

map1 <- tm_shape(am_sur_sf_cont) + 
  tm_polygons("POP2005", style="jenks", 
              palette = tmaptools::get_brewer_pal("PiYG", n = 5, contrast = c(0, 0.47), 
                                                  plot=FALSE), legend.show = FALSE) +
  tm_layout(frame = FALSE)

map2 <- tm_shape(am_sur_sf) + tm_borders() + 
  tm_shape(am_sur_sf_ncont) + 
  tm_polygons("POP2005", style="jenks", 
              palette = tmaptools::get_brewer_pal("PiYG", n = 5, contrast = c(0, 0.47), 
                                                  plot=FALSE), legend.show = FALSE) +
  tm_layout(frame = FALSE)

map3 <- tm_shape(am_sur_sf) + tm_borders() + 
  tm_shape(am_sur_sf_dorling) + 
  tm_polygons("POP2005", style="jenks", 
              palette = tmaptools::get_brewer_pal("PiYG", n = 5, contrast = c(0, 0.47), 
                                                  plot=FALSE)) +
  tm_layout(frame = FALSE, legend.position = c("left", "bottom"))

tmap_arrange(map0, map1, map2, map3, nrow = 2)

# FUENTE: https://cran.r-project.org/web/packages/cartogram/readme/README.html 