local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require("ui.icons")

local BLUE_DARK = color.blend(c.blue2, c.bg0, 0.08)

groups.new("WhichKeyFloat", { bg = BLUE_DARK })
groups.new("WhichKeyBorder", { fg = c.gray0, bg = BLUE_DARK })
groups.new("WhichKeySeparator", { fg = color.lighten(c.gray1, 20) })
groups.new("WhichKeyDesc", { link = "Constant" })
groups.new("WhichKeyGroup", { link = "Identifier" })

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
      border = icons.border.ThinBlock,
    },
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    wk.register {
      ["]"] = { name = "+next" },
      ["["] = { name = "+previous" },
      ["<leader>"] = {
        mode = "n",
        d = { name = "+debug" },
        f = { name = "+file/find" },
        g = { name = "+git" },
        h = { name = "+marks" },
        m = { name = "+notes (markdown)" },
        s = { name = "+search" },
        q = { name = "+session" },
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
        q = { name = "+quickfix (trouble)" },
      },
      ["<localleader>g"] = {
        mode = "v",
        name = "+git",
      },
      ["<localleader>m"] = {
        mode = "v",
        name = "+notes (markdown)",
      },
    }
  end,
}
