-- stylua: ignore
---@type util.theme.palette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0         = "#24283b", --bg
  bg1         = "#1f2335", --bg_dark
  bg2         = "#1f2335", --bg_dark
  bg3         = "#292e42", --bg_highlight
  bg4         = "#2c324a",

  fg0         = "#565f89", --comment
  fg1         = "#a9b1d6", --fg_dark
  fg2         = "#c0caf5", --fg

  gray0       = "#3b4261", --fg_gutter
  gray1       = "#545c7e", --dark3
  gray2       = "#737aa2", --dark5

  rose0       = "#bb6169",
  rose1       = "#d87580",
  rose2       = "#ff757f", --red (moon)
  rose3       = "#f2aebc",

  red0        = "#914c54", --git.delete
  red1        = "#c53b53", --red1 (moon)
  red2        = "#db4b4b", --red1
  red3        = "#f7768e", --red

  orange0     = "#d08770",
  orange1     = "#ff966c", --orange (moon)
  orange2     = "#ff9e64", --orange

  yellow0     = "#c49a5a",
  yellow1     = "#e0af68", --yellow
  yellow2     = "#f3c186",
  yellow3     = "#ffc777", --yellow (moon)

  green0      = "#6b8559",
  green1      = "#7f9668",
  green2      = "#9ece6a", --green
  green3      = "#c3e88d", --green (moon)

  cyan0       = "#41a6b5", --green2
  cyan1       = "#4fd6be", --green1/teal
  cyan2       = "#73daca", --green1

  aqua0       = "#0db9d7", --blue2
  aqua1       = "#65bcff", --blue1
  aqua2       = "#7dcfff", --cyan
  aqua3       = "#89ddff", --blue5

  blue0       = "#394b70", --blue7
  blue1       = "#3d59a1", --blue0
  blue2       = "#6183bb", --git.change
  blue3       = "#7aa2f7", --blue
  blue4       = "#82aaff", --blue (moon)

  purple0     = "#9d7cd8", --purple
  purple1     = "#bb9af7", --magenta
  purple2     = "#c099ff", --magenta (moon)

  magenta0    = "#ff007c", --magenta2
  magenta1    = "#ff5ca0",
  magenta2    = "#fca7ea", --purple (moon)

  overlay0    = "#5a6180",
  overlay1    = "#6c7594",
  overlay2    = "#828bb8",
}

-- stylua: ignore start
c.aqua4       = "#b4f9f8" --blue6

c.black       = ds.color.blend(c.bg0, "#000000", 0.8)
c.white       = ds.color.darken(c.fg1, 10)

c.bgX         = ds.color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual   = ds.color.blend(c.blue1, "#000000", 0.4)

c.fg_conceal  = ds.color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment  = "#5f6996"

c.grayX       = ds.color.darken(c.gray1, 25)

c.diff_add    = ds.color.blend(c.cyan0, "#000000", 0.25)
c.diff_delete = ds.color.blend(c.red2, "#000000", 0.25)
c.diff_change  = ds.color.blend(c.blue0, "#000000", 0.15)
c.diff_text = c.blue0
-- stylua: ignore end

return c
