#'
#' @description 
#' 
#' @param 
#' @param 
#' 
#' @return 
#' 
plot_globe <- function(planet, texture, rpm, axial_tilt, file_name){
  
  # set working directory to where the texture file is
  root_dir %>% paste0("./Texture") %>% setwd()
  
  open3d()
  
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
  
  root_dir %>% paste0("./Output") %>% setwd()
  
  rglwidget(
    width = 300,
    height = 300
  ) %>%
    playwidget(
      controls = par3dinterpControl(
        spin3d(
          axis = c(0, 0, sign(rpm)),
          rpm = abs(rpm * 0.5 + 1 * 0.5)
        ),
        from = 0,
        to = 60 / abs(rpm * 0.5 + 1 * 0.5),
        steps = 15
      ),
      step = 0.01,
      start = 0,
      loop = TRUE,
      components = "Play"
    ) %>% 
    # let the rglwidget autoplay
    onRender(
      jsCode ="
        function(el, x) {
          document.getElementsByTagName('input').item(0).style.display='none';
          document.getElementsByTagName('input').item(0).click();
        }"
    ) %>%
    saveWidget(
      file = file_name,
      selfcontained = FALSE, 
      libdir = "files",
      background = "black",
      title = planet
    )
  
  rgl.close()
}