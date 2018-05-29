library(rgl)
library(ggplot2)
library(htmlwidgets)

setwd("C:/Users/Wenyao/Desktop/R/Globe")


#== texture
world <- map_data('world')

# world$region[world$region=="Taiwan"] <- "China"

world_map <- ggplot(world, aes(x = long, y = lat, group = group, fill = region)) +
  geom_polygon() +
  coord_cartesian(xlim = range(world$long), ylim = c(min(world$lat) + 2, max(world$lat))) +
  scale_x_continuous(breaks = seq(from = min(world$long), to = max(world$long), by = 10), expand = c(0, 0)) +
  scale_y_continuous(breaks = seq(from = min(world$lat), to = max(world$lat), by = 10), expand = c(0, 0)) +
  theme(
    legend.position = "none",
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    plot.margin = margin(t = 0, r = -2, b = -2, l = -2, unit = "pt")
  )
world_map

png("./Output/world_ggplot.png", height = 2000, width = 4000)
print(world_map)
dev.off()


#== plot globe
# see ?persp3d
lat <- matrix(
  seq(from = 90, to = -90, length.out = 50) * pi / 180, 
  nrow = 50, 
  ncol = 50, 
  byrow = TRUE
)
long <- matrix(
  seq(from = -180, to = 180, length.out = 50) * pi / 180, 
  nrow = 50, 
  ncol = 50
)

# radius of Earth in km
r <- 6378.1
# convert polar coordinates to Cartisian coordinates
x <- r * cos(lat) * cos(long)
y <- r * cos(lat) * sin(long)
z <- r * sin(lat)

setwd("./Output")
open3d()
persp3d(
  x, y, z, col = "white", 
  texture = "world_ggplot.png", 
  specular = "black", axes = FALSE, box = FALSE, xlab = "", ylab = "", zlab = "",
  normal_x = x, normal_y = y, normal_z = z
)

# set camera angle
rgl.viewpoint(theta = 180 - 23.44, phi = 90)


#== ouput
rglwidget(
  width = 300,
  height = 300,
) %>%
  playwidget(
    par3dinterpControl(spin3d(), from = 0, to = 12, steps = 15),
    step = 0.01,
    start = 0,
    stop = 0,
    loop = TRUE,
    components = "Play"
  ) %>% 
  saveWidget(
    file="globe.html",
    selfcontained = FALSE, 
    libdir = "files",
    title = "Globe"
  )
