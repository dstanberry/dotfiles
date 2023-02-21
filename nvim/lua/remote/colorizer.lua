local icons = require "ui.icons"

return {
  "NvChad/nvim-colorizer.lua",
  enabled = false,
  opts = {
    filetypes = {
      "*",
      css = { rgb_fn = true },
    },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = false,
      AARRGGBB = false,
      rgb_fn = false,
      hsl_fn = false,
      css = false,
      css_fn = false,
      mode = "virtualtext",
      virtualtext = icons.misc.Square,
    },
    buftypes = {},
  },
}
