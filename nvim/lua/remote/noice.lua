return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["cmp.entry.get_documentation"] = true,
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      progres = { enabled = false },
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
        view = "vsplit",
        filter = { event = "msg_show", min_height = 20 },
      },
      {
        view = "mini",
        filter = { event = "msg_show", max_height = 2 },
      },
    },
    commands = {
      history = { view = "vsplit" },
    },
    views = {
      cmdline_popup = {
        border = { style = "none", padding = { 2, 3 } },
        filter_options = {},
        -- position = { row = 10, col = "50%" },
        win_options = {
          winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "NormalFloat" },
        },
      },
      popupmenu = {
        relative = "editor",
        position = { row = 13, col = "50%" },
        size = { width = 60, height = 10 },
      },
    },
    presets = {
      inc_rename = true,
      long_message_to_split = true,
    },
  },
}
