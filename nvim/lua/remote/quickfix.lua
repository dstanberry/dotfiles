local groups = require "ui.theme.groups"

groups.new("qfPosition", { link = "@text.reference" })
groups.new("TroubleNormal", { link = "NormalSB" })

return {
  {
    "yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    config = true,
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<localleader>qw", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "trouble: document diagnostics" },
      { "<localleader>qW", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "trouble: workspace diagnostics" },
      { "<localleader>ql", "<cmd>TroubleToggle loclist<cr>", desc = "trouble: location list" },
      { "<localleader>qq", "<cmd>TroubleToggle quickfix<cr>", desc = "trouble: quickfix list" },
      {
        "<c-up>",
        function()
          if require("trouble").is_open() then
            require("trouble").previous { skip_groups = true, jump = true }
          else
            pcall(vim.cmd.cprevious)
          end
        end,
        desc = "trouble: previous item",
      },
      {
        "<c-down>",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            pcall(vim.cmd.cnext)
          end
        end,
        desc = "trouble: next item",
      },
    },
    opts = {
      position = "bottom",
      use_diagnostic_signs = true,
    },
  },
}
