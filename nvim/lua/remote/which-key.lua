local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"

local BLUE_DARK = color.blend(c.blue, c.bg_dark, "15")

groups.new("WhichKeyFloat", { bg = BLUE_DARK })
groups.new("WhichKeySeparator", { fg = c.lsp_gray })

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    layout = {
      align = "center",
    },
    plugins = {
      spelling = {
        enabled = true,
      },
    },
    window = {
      border = "none",
    },
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    wk.register {
      ["<leader>"] = {
        mode = "n",
        d = { name = "+debug" },
        f = { name = "+file/find" },
        g = { name = "+git" },
        h = { name = "+marks" },
        m = { name = "+notes (markdown)" },
        s = { name = "+search" },
      },
      ["<leader>m"] = {
        mode = "v",
        name = "+notes (markdown)",
      },
      ["<localleader>"] = {
        mode = "n",
        ["<localleader>"] = { name = "+command" },
        d = { name = "+database" },
        f = { name = "+file/find" },
        g = { name = "+git" },
        m = { name = "+notes (markdown)" },
      },
      ["<localleader>m"] = {
        mode = "v",
        name = "+notes (markdown)",
      },
    }
  end,
}