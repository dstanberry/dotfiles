-- stylua: ignore
---@type util.theme.palette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0         = "#181926", --crust
  bg1         = "#1e2030", --mantle
  bg2         = "#24273a", --base
  bg3         = "#303446",
  bg4         = "#3e4255",

  fg0         = "#a5adcb", --subtext0
  fg1         = "#b8c0e0", --subtext1
  fg2         = "#cad3f5", --text

  gray0       = "#363a4f", --surface0
  gray1       = "#494d64", --surface1
  gray2       = "#5b6078", --surface2

  rose0       = "#f0c6c6", --flamingo
  rose1       = "#f4dbd6", --rosewater
  rose2       = "#f4dbd6",

  red0        = "#ee99a0", --maroon
  red1        = "#ed8796", --red
  red2        = "#d87888",
  red3        = "#a55a63",

  orange0     = "#f5a97f", --peach
  orange1     = "#e89d73",
  orange2     = "#e89d73",

  yellow0     = "#f1d89b",
  yellow1     = "#eed49f", --yellow
  yellow2     = "#d1ba8c",
  yellow3     = "#d1ba8c",

  green0      = "#b3e79b",
  green1      = "#a6da95", --green
  green2      = "#b0f8af",
  green3      = "#b0f8af",

  cyan0       = "#8bd5ca",
  cyan1       = "#8bd5ca", --teal
  cyan2       = "#a0e2d7",

  aqua0       = "#7dc4e4", --sapphire
  aqua1       = "#91d7e3", --sky
  aqua2       = "#94e7ff",

  blue0       = "#6d8fc6",
  blue1       = "#8aadf4", --blue
  blue2       = "#93b4ff",
  blue3       = "#afc1f1",
  blue4       = "#b3c9f6",

  purple0     = "#b7bdf8", --lavender
  purple1     = "#c6a0f6", --mauve
  purple2     = "#c6a0f6",

  magenta0    = "#c299b6",
  magenta1    = "#ddb9d7",
  magenta2    = "#f5bde6", --pink

  overlay0    = "#6e738d",
  overlay1    = "#8087a2",
  overlay2    = "#939ab7",
}

-- stylua: ignore start
c.black       = ds.color.darken(c.bg2, 50)
c.white       = ds.color.darken(c.fg1, 10)

c.bgX         = ds.color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual   = "#585b70"

c.fg_conceal  = ds.color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment  = "#9399b2"

c.grayX       = ds.color.darken(c.gray1, 25)

c.diff_add    = ds.color.blend(c.green1, c.bg2, 0.18)
c.diff_delete = ds.color.blend(c.red1, c.bg2, 0.18)
c.diff_text   = ds.color.blend(c.blue1, c.bg2, 0.30)
c.diff_change = ds.color.blend(c.blue1, c.bg2, 0.07)
-- stylua: ignore end

return c
