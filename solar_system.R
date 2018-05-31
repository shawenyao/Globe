library(rgl)
library(htmlwidgets)
library(tidyverse)

root_dir <- "C:/Users/Wenyao/Desktop/R/Globe"
setwd(root_dir)
source("./functions.R")

#== globe setup
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

# sample radius
r <- 10000
# convert polar coordinates to Cartisian coordinates
x <- r * cos(lat) * cos(long)
y <- r * cos(lat) * sin(long)
z <- r * sin(lat)


#== plot starts
setwd(paste0(root_dir, "./Output"))

planet <- c("Sun", "Mercury", "Venus", "Earth", "Moon", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")

list(
  planet = planet,
  texture = paste0(planet, ".png"),
  rpm = 1 / c(25.38, 58.65, 243.02, 1, 27.32, 1.03, 0.41, 0.43, -0.72, 0.67),
  axial_tilt = c(7.25, 0.03, 2.64, 23.44, 6.68, 25.19, 3.13, 26.73, 82.23, 28.32),
  file_name = paste0(str_pad(seq_along(planet), width = 2, pad = "0"), "_", planet, ".html")
) %>% 
  pmap(plot_globe)
