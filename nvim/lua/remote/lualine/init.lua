return {
  "nvim-lualine/lualine.nvim",
  url = "https://github.com/dstanberry/lualine.nvim",
  event = "VeryLazy",
  init = function()
    ds.hl.new("NoiceSymbolNormal", { fg = ds.color.get_color "WinbarContext" })
    ds.hl.new("NoiceSymbolSeparator", { fg = ds.color.blend(vim.g.ds_colors.purple1, vim.g.ds_colors.bg2, 0.38) })

    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local util = require "remote.lualine.util"

    -- PERF: disable lualine require
    local lualine_require = require "lualine_require"
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = util.theme,
        globalstatus = true,
        disabled_filetypes = { statusline = ds.excludes.ft.stl_disabled, winbar = ds.excludes.ft.wb_disabled },
        component_separators = " ",
        section_separators = " ",
      },
      sections = {
        lualine_a = {
          {
            function() return ds.icons.misc.VerticalBarBold end,
            padding = { left = 0, right = 0 },
          },
          {
            util.git.branch.get,
            padding = { right = 2 },
          },
        },
        lualine_b = {
          {
            util.metadata.root_dir.get,
            padding = { right = 1 },
            color = { fg = vim.g.ds_colors.overlay1 },
            cond = function() return type(util.metadata.root_dir.get()) == "string" end,
          },
          {
            "vim.b.gitsigns_blame_line",
            padding = { right = 1 },
            color = { fg = ds.color.get_color "WinbarFilename", gui = "italic" },
            cond = function() return util.available_width(120) end,
          },
        },
        lualine_c = {
          {
            "diff",
            source = util.git.diff.get,
            symbols = {
              added = ds.pad(ds.icons.git.TextAdded, "right"),
              modified = ds.pad(ds.icons.git.TextChanged, "right"),
              removed = ds.pad(ds.icons.git.TextRemoved, "right"),
            },
            diff_color = {
              added = { fg = ds.color.blend(vim.g.ds_colors.green2, vim.g.ds_colors.white, 0.6) },
              modified = { fg = ds.color.blend(vim.g.ds_colors.yellow2, vim.g.ds_colors.white, 0.6) },
              removed = { fg = ds.color.blend(vim.g.ds_colors.red1, vim.g.ds_colors.white, 0.6) },
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = ds.pad(ds.icons.status.Error, "right"),
              warn = ds.pad(ds.icons.status.Warn, "right"),
              info = ds.pad(ds.icons.status.Info, "right"),
              hint = ds.pad(ds.icons.status.Hint, "right"),
            },
            diagnostics_color = {
              error = { fg = ds.color.get_color "DiagnosticVirtualTextError" },
              warn = { fg = ds.color.get_color "DiagnosticVirtualTextWarn" },
              info = { fg = ds.color.get_color "DiagnosticVirtualTextInfo" },
              hint = { fg = ds.color.get_color "DiagnosticVirtualTextHint" },
            },
          },
          {
            util.lsp.clients.get,
            color = { fg = ds.color.lighten(vim.g.ds_colors.overlay1, 10), gui = "bold" },
          },
          {
            "filetype",
            color = { gui = "bold" },
          },
        },
        lualine_y = {
          {
            util.message.noice.get,
            color = { fg = vim.g.ds_colors.gray2, gui = "italic" },
            cond = util.message.noice.cond,
          },
          {
            "location",
            color = { fg = ds.color.get_color "WinbarContext", gui = "bold,italic" },
          },
          {
            util.metadata.indentation.get,
            color = { fg = ds.color.get_color "WinbarContext", gui = "bold,italic" },
          },
          {
            "encoding",
            color = { fg = ds.color.get_color "WinbarContext", gui = "bold,italic" },
          },
          {
            "fileformat",
            icons_enabled = true,
            symbols = { unix = "lf", dos = "crlf", mac = "cr" },
            color = { fg = ds.color.get_color "WinbarContext" },
            padding = { right = 2 },
          },
        },
        lualine_z = {},
      },
      winbar = {
        lualine_a = {
          {
            util.git.diffview.get,
            color = "Winbar",
            cond = util.git.diffview.cond,
          },
          {
            util.metadata.breadcrumbs.get,
            color = "Winbar",
            padding = { right = 0 },
          },
          {
            util.lsp.symbols.get,
            cond = util.lsp.symbols.cond,
            padding = { left = 0 },
            color = "Winbar",
          },
        },
        lualine_x = {
          {
            util.git.merge_conflicts.get,
            color = "Winbar",
            cond = util.git.diffview.cond,
          },
        },
      },
      inactive_winbar = {
        lualine_a = {
          {
            util.git.diffview.get,
            color = "Winbar",
            cond = util.git.diffview.cond,
          },
          {
            util.metadata.breadcrumbs.get,
            color = "Winbar",
            padding = { right = 0 },
          },
        },
        lualine_x = {
          {
            util.git.merge_conflicts.get,
            color = "Winbar",
            cond = util.git.diffview.cond,
          },
        },
      },
    }
  end,
}
