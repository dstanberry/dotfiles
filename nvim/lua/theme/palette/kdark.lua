-- stylua: ignore
---@type util.theme_palette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0      = "#1f2021",
  bg1      = "#323233",
  bg2      = "#373737",
  bg3      = "#3d3e40",
  bg4      = "#3a3c3d",

  fg0      = "#b8bec9",
  fg1      = "#c9d1d9",
  fg2      = "#d8dee9",

  gray0    = "#414145",
  gray1    = "#59595e",
  gray2    = "#97979f",

  rose0    = "#cd8d88",
  rose1    = "#e4c1be",

  red0     = "#a76369",
  red1     = "#bf616a",
  red2     = "#e5747f",
  red3     = "#f7768e",

  orange0  = "#d08770",
  orange1  = "#ffab87",

  yellow0  = "#d3b67d",
  yellow1  = "#e0af68",
  yellow2  = "#ebcb8b",

  green0   = "#7f966d",
  green1   = "#97b182",
  green2   = "#a3be8c",

  cyan0    = "#5a8d83",
  cyan1    = "#79bdaf",
  cyan2    = "#8fbcbb",

  aqua0    = "#5f8f9d",
  aqua1    = "#77b3c5",
  aqua2    = "#8ed6ec",

  blue0    = "#516882",
  blue1    = "#6f8fb4",
  blue2    = "#81a1c1",
  blue3    = "#90b4d9",
  blue4    = "#97b6e5",

  purple0  = "#94628a",
  purple1  = "#ac72a0",

  magenta0 = "#90718a",
  magenta1 = "#b48ead",
  magenta2 = "#eab8e0",

  overlay0 = "#6c7086",
  overlay1 = "#7f849c",
}
-- stylua: ignore start
c.black       = ds.color.darken(c.bg2, 50)
c.white       = ds.color.darken(c.fg1, 10)

c.bgX         = ds.color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual   = ds.color.blend(c.blue1, c.bg2, 0.31)

c.fg_conceal  = ds.color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment  = ds.color.blend(c.blue0, c.gray1, 0.31)

c.grayX       = ds.color.darken(c.gray1, 25)

c.diff_add    = "#132e1f"
c.diff_delete = "#361f21"
c.diff_text   = "#1b3956"
c.diff_change = ds.color.blend(c.diff_text, c.bg3, 0.2)
-- stylua: ignore end

return c
