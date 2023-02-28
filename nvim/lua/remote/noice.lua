local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("NoiceFormatProgressDone", { link = "LspReferenceRead" })

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    {
      "<c-d>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-d>"
        end
      end,
      mode = "n",
      expr = true,
      desc = "noice: scroll down documentation",
    },
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-f>"
        end
      end,
      mode = "n",
      expr = true,
      desc = "noice: scroll up documentation",
    },
  },
  opts = {
    cmdline = {
      format = {
        cmdline = { title = "" },
        lua = { title = "" },
        search_down = { title = "" },
        search_up = { title = "" },
        filter = { title = "" },
        help = { title = "" },
        input = { title = "" },
        IncRename = { title = "" },
        substitute = { pattern = "^:%%?s/", icon = icons.misc.ArrowSwap, ft = "regex", kind = "search", title = "" },
      },
    },
    lsp = {
      override = {
        ["cmp.entry.get_documentation"] = true,
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    popupmenu = {
      backend = "cmp",
    },
    routes = {
      {
        filter = {
          any = {
            { event = "msg_show", kind = "", find = "written" },
            { event = "msg_show", kind = "", find = "%d+ lines, %d+ bytes" },
          },
        },
        opts = { skip = true },
      },
      {
        filter = { event = "msg_show", kind = "search_count" },
        opts = { skip = true },
      },
      {
        view = "mini",
        filter = { event = "msg_show", max_height = 2 },
      },
      {
        view = "mini",
        filter = {
          any = {
            { event = "msg_show", find = "^E486:" },
          },
        },
      },
      {
        view = "vsplit",
        filter = { event = "notify", min_height = 10 },
      },
    },
    commands = {
      history = { view = "vsplit" },
    },
    views = {
      cmdline_popup = {
        border = { style = "single", padding = { 0, 1 } },
        position = { row = 10, col = "50%" },
        filter_options = {},
        win_options = {
          winhighlight = { NormalFloat = "Normal", FloatBorder = "Macro" },
        },
      },
      popupmenu = {
        relative = "editor",
        border = { style = "single", padding = { 0, 1 } },
        position = { row = 8, col = "50%" },
        size = { width = 60, height = 10 },
        win_options = {
          -- winhighlight = { NormalFloat = "Normal", FloatBorder = "Macro" },
        },
      },
    },
    presets = {
      inc_rename = true,
      long_message_to_split = true,
    },
  },
}
