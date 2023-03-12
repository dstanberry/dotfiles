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
        if not require("noice.lsp").scroll(4) then return "<c-d>" end
      end,
      mode = "n",
      expr = true,
      desc = "noice: scroll down",
    },
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(-4) then return "<c-f>" end
      end,
      mode = "n",
      expr = true,
      desc = "noice: scroll up",
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
      documentation = { enabled = true },
      hover = { enabled = true },
      signature = { enabled = true },
      override = {
        ["cmp.entry.get_documentation"] = true,
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    routes = {
      {
        filter = {
          any = {
            { event = "msg_show", find = "%d+ lines, %d+ bytes" },
            { event = "msg_show", find = "%d+L, %d+B" },
            { event = "msg_show", find = "search hit" },
            { event = "msg_show", find = "written" },
            { event = "msg_show", kind = "search_count" },
          },
        },
        opts = { skip = true },
      },
      {
        view = "mini",
        filter = {
          any = {
            { event = "msg_show", find = "^E486:" },
            { event = "msg_show", find = "^Hunk %d+ of %d" },
          },
        },
      },
      {
        view = "notify",
        opts = { title = "", merge = true },
        filter = {
          any = {
            { event = "msg_showmode" },
            { kind = { "emsg", "echo", "echomsg" } },
          },
        },
      },
      {
        view = "notify",
        opts = { title = "Warning", level = vim.log.levels.WARN, merge = true, replace = true },
        filter = {
          any = {
            { warning = true },
            { event = "msg_show", find = "^Warn" },
            { event = "msg_show", find = "^W%d+:" },
            { event = "msg_show", find = "^No hunks$" },
          },
        },
      },
      {
        view = "notify",
        opts = { title = "Error", level = vim.log.levels.ERROR, merge = true, replace = true },
        filter = {
          any = {
            { error = true },
            { event = "msg_show", find = "^E%d+:" },
            { event = "msg_show", find = "^Error" },
          },
        },
      },
      {
        view = "split",
        filter = {
          any = {
            filter = { event = "notify", min_height = 5 },
          },
        },
      },
    },
    commands = {
      history = { view = "split" },
    },
    views = {
      cmdline_popup = {
        border = { style = "single", padding = { 0, 1 } },
        position = { row = 10, col = "50%" },
        size = { width = 70, height = "auto" },
        filter_options = {},
        win_options = {
          winhighlight = { NormalFloat = "Normal", FloatBorder = "Macro" },
        },
      },
      popupmenu = {
        relative = "editor",
        border = { style = "single", padding = { 0, 1 } },
        position = { row = 12, col = "50%" },
        size = { width = 70, height = 10 },
        win_options = {
          winhighlight = { NormalFloat = "Normal", FloatBorder = "Macro" },
        },
      },
      split = {
        win_options = {
          winhighlight = { Normal = "NormalSB" },
        },
      },
    },
    presets = {
      inc_rename = true,
      long_message_to_split = true,
    },
  },
}
