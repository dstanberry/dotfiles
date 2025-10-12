-- stylua: ignore
---@type util.theme.palette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0         = "#1f2021",
  bg1         = "#303031",
  bg2         = "#373737",
  bg3         = "#3d3e40",
  bg4         = "#3a3c3d",

  fg0         = "#b8bec9",
  fg1         = "#c9d1d9",
  fg2         = "#d8dee9",

  gray0       = "#414145",
  gray1       = "#59595e",
  gray2       = "#97979f",

  rose0       = "#8b6b68",
  rose1       = "#cd8d88",
  rose2       = "#e4c1be",

  red0        = "#9d6066",
  red1        = "#bf616a",
  red2        = "#c97470",
  red3        = "#d88085",

  orange0     = "#a86b5c",
  orange1     = "#d08770",
  orange2     = "#e29b7c",

  yellow0     = "#b59860",
  yellow1     = "#d3b67d",
  yellow2     = "#ddc380",
  yellow3     = "#ebcb8b",

  green0      = "#6b7c59",
  green1      = "#7f966d",
  green2      = "#97b182",
  green3      = "#a8c794",

  cyan0       = "#5d8a7f",
  cyan1       = "#7ab5a5",
  cyan2       = "#8bbaa8",

  aqua0       = "#5f8f9d",
  aqua1       = "#77b3c5",
  aqua2       = "#89b8c4",

  blue0       = "#516882",
  blue1       = "#6f8fb4",
  blue2       = "#81a1c1",
  blue3       = "#90b4d9",
  blue4       = "#95abd6",

  purple0     = "#7a5270",
  purple1     = "#94628a",
  purple2     = "#ac72a0",

  magenta0    = "#76627a",
  magenta1    = "#90718a",
  magenta2    = "#b48ead",
  magenta3    = "#c49fc0",

  overlay0    = "#6c7086",
  overlay1    = "#7f849c",

  diff_add    = "#1a2b1e",
  diff_delete = "#2b1e1f",
  diff_text   = "#1e2a39"
}
-- stylua: ignore start
c.black       = ds.color.darken(c.bg2, 50)
c.white       = ds.color.darken(c.fg1, 10)

c.bgX         = ds.color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual   = ds.color.blend(c.blue1, c.bg2, 0.31)

c.grayX       = ds.color.darken(c.gray1, 25)

c.fg_conceal  = ds.color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment  = ds.color.blend(c.blue0, c.gray1, 0.31)

c.diff_change = ds.color.blend(c.diff_text, c.bg3, 0.2)
-- stylua: ignore end

return c
