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


planet <- "Moon"
texture <-  paste0(planet, ".png")
rpm <- 0.25
axial_tilt <- 6.68


# set working directory to where the texture file is
root_dir %>% paste0("./Texture") %>% setwd()

open3d()

# plot the globe
persp3d(
  x, y, z, col = "white", 
  texture = texture, 
  specular = "black", axes = FALSE, box = FALSE, xlab = "", ylab = "", zlab = "",
  normal_x = x, normal_y = y, normal_z = z
)

# set background color
rgl.bg(color = "black")

# set camera angle
rgl.viewpoint(theta = 180 - axial_tilt, phi = 90)

# clear all lights
rgl.clear(type = "lights")

# initialize light source
period <- 30 / rpm
light3d(
  theta = ((period / 8) %% period) / period * 320 - 160,
  phi = 0,
  viewpoint.rel = TRUE
)

# the spining function
spin_moon <- spin3d(
  axis = c(0, 0, sign(rpm)),
  rpm = rpm
)

# the phase + spining function
frame <- function(time){
  # hold re-rendering until all updates are completed
  save <- par3d(skipRedraw = TRUE)
  
  # clear all lights
  rgl.clear(type = "lights")
  
  # set light source according to phase
  for(i in 1:3){
    light3d(
      theta = ((time + period / 8) %% period) / period * 320 - 160,
      phi = 0,
      viewpoint.rel = TRUE
    )
  }
  par3d(save)
  Sys.sleep(0.02)
  
  # rotate the scene
  spin_moon(time)
}

# play3d(frame)


root_dir %>% paste0("./Output") %>% setwd()
rglwidget(
  width = 300,
  height = 300
) %>%
  playwidget(
    controls = par3dinterpControl(
      frame,
      from = 0,
      to = 60 / rpm,
      steps = 15
    ),
    step = 0.01,
    start = 0,
    loop = TRUE,
    components = "Play"
  ) %>% 
  # let the rglwidget autoplay on load
  onRender(
    jsCode ="
        function(el, x) {
          document.getElementsByTagName('input').item(0).style.display='none';
          document.getElementsByTagName('input').item(0).click();
        }"
  ) %>%
  saveWidget(
    file = paste0(planet, ".html"),
    selfcontained = FALSE, 
    libdir = "files",
    background = "black",
    title = planet
  )

# rgl.close()
