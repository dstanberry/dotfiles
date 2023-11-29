local excludes = require "ui.excludes"

return {
  {
    "luukvbaal/statuscol.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "mfussenegger/nvim-dap",
    },
    lazy = true,
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        -- ft_ignore = vim.tbl_deep_extend("keep", excludes.ft.stl_disabled, excludes.ft.wb_disabled),
        bt_ignore = excludes.bt.wb_disabled,
        relculright = true,
        segments = {
          {
            sign = {
              name = { "DapBreakpoint", "DapStopped" },
              namespace = { "gitsigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = true,
            },

            click = "v:lua.ScSa",
          },
          {
            text = { " ", builtin.lnumfunc },
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false, fillchars = "" },
            click = "v:lua.ScLa",
          },
          { text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      }
    end,
  },
}
