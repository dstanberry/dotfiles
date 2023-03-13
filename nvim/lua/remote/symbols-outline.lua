local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

return {
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.g.symbols_outline = {
        auto_close = false,
        auto_preview = false,
        border = "none",
        highlight_hovered_item = true,
        position = "right",
        preview_bg_highlight = "Pmenu",
        relative_width = true,
        show_guides = true,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = false,
        width = 25,
        winblend = 0,
        keymaps = {
          close = { "<esc>", "q" },
          code_actions = "a",
          focus_location = "o",
          goto_location = "<cr>",
          hover_symbol = "<c-space>",
          rename_symbol = "r",
          show_help = "?",
          toggle_preview = "K",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
          File = { icon = icons.documents.File },
          Module = { icon = icons.kind.Module },
          Namespace = { icon = icons.type.Object },
          Package = { icon = icons.type.Object },
          Class = { icon = icons.kind.Class },
          Method = { icon = icons.kind.Method },
          Property = { icon = icons.kind.Property },
          Field = { icon = icons.kind.Field },
          Constructor = { icon = icons.kind.Constructor },
          Enum = { icon = icons.kind.Enum },
          Interface = { icon = icons.kind.Interface },
          Function = { icon = icons.kind.Function },
          Variable = { icon = icons.kind.Variable },
          Constant = { icon = icons.kind.Constant },
          String = { icon = icons.type.String },
          Number = { icon = icons.type.Number },
          Boolean = { icon = icons.type.Boolean },
          Array = { icon = icons.type.Array },
          Object = { icon = icons.type.Object },
          Key = { icon = icons.misc.Key },
          Null = { icon = icons.type.Boolean },
          EnumMember = { icon = icons.kind.EnumMember },
          Struct = { icon = icons.kind.Struct },
          Event = { icon = icons.kind.Event },
          Operator = { icon = icons.kind.Operator },
          TypeParameter = { icon = icons.kind.TypeParameter },
        },
      }
      groups.new("FocusedSymbol", { fg = c.bg3, bg = c.yellow2, bold = true })
      groups.new("SymbolsOutlineConnector", { fg = c.grayX })
    end,
  },
}
