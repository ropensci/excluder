library(hexSticker)
sticker(
  "inst/figures/herding.png",
  package = "excluder",
  p_size = 28,
  # p_color = "#4c566a",
  s_x = 1,
  s_y = 0.8,
  s_width = 0.8,
  h_fill = "#5e81ac",
  h_color = "#8fbcbb",
  filename = "inst/figures/logo.png"
)
file.copy("inst/figures/logo.png", "man/figures/logo.png", overwrite = TRUE)
