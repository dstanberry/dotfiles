local excludes = require "ui.excludes"
local icons = require "ui.icons"

vim.cmd.doautocmd "BufReadPost"

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      -- char = "",
      char = icons.misc.VerticalBarThin,
      -- tab_char = icons.misc.VerticalBarThin,
    },
    scope = {
      enabled = true,
      char = icons.misc.VerticalBar,
      highlight = {
        "TSRainbow1",
        "TSRainbow2",
        "TSRainbow3",
        "TSRainbow4",
        "TSRainbow5",
        "TSRainbow6",
        "TSRainbow7",
      },
    },
    exclude = {
      filetypes = vim.tbl_deep_extend(
        "keep",
        excludes.ft.stl_disabled,
        excludes.ft.wb_disabled,
        excludes.ft.wb_empty,
        { "checkhealth", "diff", "git" },
        { "log", "markdown", "txt" }
      ),
    },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
  end,
}
