-- verify noice is available
local ok, noice = pcall(require, "noice")
local DISABLED = false
if not ok or DISABLED then
  return
end

local telescope = require "telescope"
local icons = require "ui.icons"

noice.setup {
  cmdline = {
    view = "cmdline_popup",
    opts = {
      buf_options = { filetype = "vim" },
    },
    icons = {
      ["/"] = { icon = icons.misc.ChevronRight, hl_group = "String" },
      ["?"] = { icon = icons.misc.ChevronRight, hl_group = "String" },
      [":"] = { icon = icons.misc.ChevronRight, hl_group = "String", firstc = false },
    },
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  popupmenu = {
    backend = "cmp",
  },
  routes = {
    {
      filter = { event = "msg_show", kind = "", find = "written" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", kind = "search_count" },
      opts = { skip = true },
    },
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
}

pcall(telescope.load_extension "noice")
