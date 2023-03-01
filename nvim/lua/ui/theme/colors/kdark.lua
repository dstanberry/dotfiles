local color = require "util.color"

local c = {
  bg = "#373737",
  bg_highlight = "#3d3e40",
  bg_dark = "#1f2021",
  bg_light = "#3d3e40",
  gray = "#414145",
  gray_light = "#59595e",
  fg = "#c9d1d9",
  fg_dark = "#b8bec9",
  fg_light = "#d8dee9",
  cyan = "#8fbcbb",
  teal = "#79bdaf",
  red = "#bf616a",
  pink = "#f7768e",
  red_dark = "#db4b4b",
  orange = "#d08770",
  yellow = "#ebcb8b",
  yellow_dark = "#e0af68",
  green = "#a3be8c",
  green_dark = "#9ece6a",
  blue = "#81a1c1",
  blue_light = "#77b3c5",
  blue_dark = "#6f8fb4",
  blue_darker = "#516882",
  magenta = "#b48ead",
  purple = "#9d7cd8",
  rose = "#cd8d88",
}

c.black = color.darken(c.bg, 50)
c.white = color.darken(c.fg, 10)

c.bg_alt = color.blend(c.bg_dark, c.bg, "50")
c.bg_search = color.blend(c.yellow, c.bg, "66")
c.bg_visual = color.blend(c.blue_dark, c.bg, "50")
c.fg_conceal = color.blend(c.blue, c.bg, "50")
c.gray_alt = color.darken(c.gray_light, 25)
c.gray_dark = color.darken(c.gray, 25)
c.gray_darker = color.darken(c.gray, 40)
c.gray_lighter = color.lighten(c.gray_light, 70)

c.red_light = color.lighten(c.red, 20)
c.yellow_darker = color.darken(c.yellow, 10)
c.blue_lighter = color.lighten(c.blue, 30)
c.blue_lightest = color.lighten(c.blue_light, 20)
c.blue_alt = color.darken(c.blue_light, 20)
c.magenta_dark = color.darken(c.magenta, 20)
c.magenta_light = color.lighten(c.magenta, 30)

c.diff_add = "#132e1f"
c.diff_delete = "#361f21"
c.diff_change = "#174061"
c.diff_text = "#1b3956"

c.lsp_gray = color.lighten(c.gray_light, 20)
c.lsp_read = color.blend(color.darken(c.cyan, 40), c.bg, "66")
c.lsp_text = color.blend(c.yellow_darker, c.bg, "66")
c.lsp_write = color.blend(c.orange, c.bg, "66")

return c
