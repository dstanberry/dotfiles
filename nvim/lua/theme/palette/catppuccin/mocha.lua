-- stylua: ignore
---@type util.theme.palette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0         = "#11111b", --crust
  bg1         = "#181825", --mantle
  bg2         = "#1e1e2e", --base
  bg3         = "#24273a",
  bg4         = "#303446",

  fg0         = "#a6adc8", --subtext0
  fg1         = "#bac2de", --subtext1
  fg2         = "#cdd6f4", --text

  gray0       = "#313244", --surface2
  gray1       = "#45475a", --surface1
  gray2       = "#585b70", --surface0

  rose0       = "#f2cdcd", --flamingo
  rose1       = "#f5e0dc", --rosewater

  red0        = "#eba0ac", --maroon
  red1        = "#f38ba8", --red
  red2        = "#c06d84",
  red3        = "#8d5060",

  orange0     = "#fab387", --peach
  orange1     = "#ffab87",

  yellow0     = "#e4c78f",
  yellow1     = "#f9e2af", --yellow
  yellow2     = "#ffecb3",

  green0      = "#a6d189",
  green1      = "#a6e3a1", --green
  green2      = "#b0f8af",

  cyan0       = "#8bd5ca",
  cyan1       = "#94e2d5", --teal
  cyan2       = "#a0e2d7",

  aqua0       = "#74c7ec", --sapphire
  aqua1       = "#89dceb", --sky
  aqua2       = "#94e7ff",

  blue0       = "#6d8fc6",
  blue1       = "#89b4fa", --blue
  blue2       = "#93b4ff",
  blue3       = "#afc1f1",
  blue4       = "#b3c9f6",

  purple0     = "#b4befe", --lavender
  purple1     = "#cba6f7", --mauve

  magenta0    = "#c299b6",
  magenta1    = "#ddb9d7",
  magenta2    = "#f5c2e7", --pink

  overlay0    = "#6c7086",
  overlay1    = "#7f849c",

  diff_add    = "#a5e2a0",
  diff_delete = "#f38ba8",
  diff_text   = "#87b2f9"
}

-- stylua: ignore start
c.black       = ds.color.darken(c.bg2, 50)
c.white       = ds.color.darken(c.fg1, 10)

c.bgX         = ds.color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual   = "#585b70"

c.fg_conceal  = ds.color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment  = "#9399b2"

c.grayX       = ds.color.darken(c.gray1, 25)

c.diff_change = ds.color.blend(c.diff_text, c.bg3, 0.2)
-- stylua: ignore end

return c
