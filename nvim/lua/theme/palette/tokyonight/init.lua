-- stylua: ignore
---@type util.theme.palette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0         = "#1a1b26",
  bg1         = "#16161e",
  bg2         = "#16161e",
  bg3         = "#1c1d29",
  bg4         = "#202330",

  fg0         = "#787c99",
  fg1         = "#a9b1d6",
  fg2         = "#c0caf5",

  gray0       = "#363b54",
  gray1       = "#515670",
  gray2       = "#545c7e",

  rose0       = "#bb616b",
  rose1       = "#f7768e",

  red0        = "#914c54",
  red1        = "#db4b4b",
  red2        = "#f7768e",
  red3        = "#bb616b",

  orange0     = "#ff9e64",
  orange1     = "#e0af68",

  yellow0     = "#c49a5a",
  yellow1     = "#e0af68",
  yellow2     = "#e0af68",

  green0      = "#41a6b5",
  green1      = "#73daca",
  green2      = "#9ece6a",

  cyan0       = "#7dcfff",
  cyan1       = "#7dcfff",
  cyan2       = "#41a6b5",

  aqua0       = "#7aa2f7",
  aqua1       = "#7aa2f7",
  aqua2       = "#7dcfff",

  blue0       = "#7aa2f7",
  blue1       = "#7aa2f7",
  blue2       = "#6183bb",
  blue3       = "#3d59a1",
  blue4       = "#7dcfff",

  purple0     = "#bb9af7",
  purple1     = "#9d7cd8",

  magenta0    = "#bb9af7",
  magenta1    = "#c0caf5",
  magenta2    = "#bb9af7",

  overlay0    = "#515670",
  overlay1    = "#787c99",

  diff_add    = "#23343a",
  diff_delete = "#3a2326",
  diff_text   = "#7aa2f7"
}

-- stylua: ignore start
c.black       = ds.color.darken(c.bg2, 50)
c.white       = ds.color.darken(c.fg1, 10)

c.bgX         = ds.color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual   = "#23243a"

c.fg_conceal  = ds.color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment  = "#51597d"

c.grayX       = ds.color.darken(c.gray1, 25)

c.diff_change = ds.color.blend(c.diff_text, c.bg3, 0.2)
-- stylua: ignore end

return c
