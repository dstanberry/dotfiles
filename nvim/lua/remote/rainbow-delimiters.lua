local groups = require "ui.theme.groups"

local CYAN = "#73c1b9"
local CYAN_LIGHT = "#80d3dd"
local PINK = "#dec7d0"
local ORANGE = "#e09696"
local YELLOW = "#ffdca8"
local MAGENTA = "#9086a4"
local MAGENTA_LIGHT = "#bfafc4"

groups.new("TSRainbow1", { fg = CYAN })
groups.new("TSRainbow2", { fg = ORANGE })
groups.new("TSRainbow3", { fg = MAGENTA })
groups.new("TSRainbow4", { fg = CYAN_LIGHT })
groups.new("TSRainbow5", { fg = PINK })
groups.new("TSRainbow6", { fg = MAGENTA_LIGHT })
groups.new("TSRainbow7", { fg = YELLOW })

return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  config = function()
    local rainbow_delimiters = require "rainbow-delimiters"

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
      },
      query = {
        [""] = "rainbow-delimiters",
      },
      highlight = {
        "TSRainbow1",
        "TSRainbow2",
        "TSRainbow3",
        "TSRainbow4",
        "TSRainbow5",
        "TSRainbow6",
        "TSRainbow7",
      },
    }
  end,
}
