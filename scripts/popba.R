require(tidyverse)
require(sf)
require(rayshader)
require(RColorBrewer)

download.file(url = 'https://catalogo.datos.gba.gob.ar/dataset/33b080d2-e369-4076-acd4-511db0e9bffb/resource/a8bed3ca-2746-4ab1-a390-56f1788431b1/download/radios_censales.zip',
              destfile = './shapes/popba.zip', mode = 'wb')

unzip(zipfile = './shapes/popba.zip', exdir='./shapes/')

popba <- read_sf('./shapes/radios_censales/radios_censales.shp')

colores <- colorRampPalette(rev(brewer.pal(11, "Spectral")))

mapa <- ggplot() +
  geom_sf(data = popba, aes(fill = log10(totalpobl)), show.legend = F) +
  scale_fill_gradientn(colours=colores(8)) 

plot_gg(mapa, multicore = TRUE, width = 7, height = 10)
render_snapshot()
render_movie("./mapas/mapa.mp4", frames = 720, fps = 30, zoom = 0.6, fov = 30)
