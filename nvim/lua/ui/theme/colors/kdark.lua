local color = require "util.color"

local c = {
  bg = "#373737",
  bg_dark = "#212121",
  bg_light = "#404040",
  gray = "#434345",
  gray_light = "#5f5f5f",
  fg = "#c9d1d9",
  fg_dark = "#b8bec9",
  fg_light = "#d8dee9",
  cyan = "#8fbcbb",
  red = "#bf616a",
  orange = "#d08770",
  yellow = "#ebcb8b",
  green = "#a3be8c",
  blue = "#81a1c1",
  blue_light = "#77b3c5",
  blue_dark = "#6f8fb4",
  magenta = "#b48ead",
  rose = "#cd8d88",
}

c.white = color.darken(c.fg, 10)

c.gray_alt = color.darken(c.gray_light, 25)
c.gray_darker = color.darken(c.gray, 40)
c.gray_dark = color.darken(c.gray, 25)
c.gray_lighter = color.lighten(c.gray_light, 70)

c.red_light = color.lighten(c.red, 20)
c.yellow_dark = color.darken(c.yellow, 10)
c.blue_lightest = color.lighten(c.blue_light, 20)
c.blue_alt = color.darken(c.blue_light, 20)
c.magenta_dark = color.darken(c.magenta, 20)
c.magenta_light = color.lighten(c.magenta, 30)

c.cyan_lsp = color.darken(c.cyan, 40)
c.gray_lsp = color.lighten(c.gray_light, 20)

return c
