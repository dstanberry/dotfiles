local c = require("ui.theme").colors
local groups = require "ui.theme.groups"

return {
  "windwp/nvim-spectre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "spectre: replace in files" },
  },
  config = function()
    require("spectre").setup()

    groups.new("SpectreSearch", { fg = c.bg0, bg = c.rose0, bold = true })
    groups.new("SpectreReplace", { fg = c.bg0, bg = c.green0, bold = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("cursorline", { clear = true }),
      pattern = "spectre_panel",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    })
  end,
}
