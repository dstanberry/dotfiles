local c = require("ui.theme").colors
local color = require "util.color"
local util = require "util"

return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  keys = {
    {
      "<leader>sc",
      function()
        local _, range = util.buffer.get_visual_selection()
        local left = range[1][1] or 1
        local right = range[2][1] or 1
        vim.cmd { cmd = "Silicon", range = { left + 1, right + 1 } }
      end,
      mode = "v",
      desc = "silicon: screenshot selection",
    },
  },
  opts = {
    disable_defaults = false,
    debug = false,
    command = "silicon",
    font = "CartographCF Nerd Font=30",
    background = color.blend(c.purple1, c.bg2, 0.44),
    theme = "kdark",
    line_offset = function(args) return args.line1 end,
    window_title = function() return vim.fs.basename(vim.api.nvim_buf_get_name(0)) end,
  },
  config = function(_, opts) require("silicon").setup(opts) end,
}
