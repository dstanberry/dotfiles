return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
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
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          { function() return ds.icons.misc.VerticalBarBold end, padding = { left = 0 } },
          { util.git.branch.get },
          { util.separator.left, padding = { left = 0, right = 1 } },
        },
        lualine_b = {
          {
            util.metadata.root_dir.get,
            color = { fg = vim.g.ds_colors.overlay1 },
            cond = function() return type(util.metadata.root_dir.get()) == "string" end,
            padding = { right = 1 },
          },
          {
            util.separator.left,
            cond = function() return type(util.metadata.root_dir.get()) == "string" end,
            padding = { left = 0, right = 1 },
          },
          {
            "vim.b.gitsigns_blame_line",
            color = { fg = ds.color.get_color "WinbarFilename", gui = "italic" },
            cond = function() return util.available_width(120) end,
            padding = { right = 1 },
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
            util.message.noice.get,
            color = { fg = vim.g.ds_colors.gray2, gui = "italic" },
            cond = util.message.noice.cond,
          },
          { util.separator.right, cond = util.message.noice.cond, padding = { right = 1 } },
        },
        lualine_y = {
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
            util.separator.right,
            cond = function() return #vim.diagnostic.count() > 0 end,
            padding = { left = 0, right = 1 },
          },
          { util.lsp.clients.get, padding = { right = 0 } },
          { util.separator.right, padding = { left = 1, right = 0 } },
          { "location" },
          { util.separator.right, padding = { left = 0, right = 0 } },
          { util.metadata.indentation.get },
          { util.separator.right, padding = { left = 0, right = 0 } },
          { "encoding" },
          -- stylua: ignore
          { util.separator.right, padding = { left = 0, right = 0 }, cond = function() return vim.bo.filetype ~= "" end },
          { "fileformat", icons_enabled = true, symbols = { unix = "lf", dos = "crlf", mac = "cr" } },
          -- stylua: ignore
          { util.separator.right, padding = { left = 0, right = 0 }, cond = function() return vim.bo.filetype ~= "" end },
          { "filetype", color = { gui = "bold" } },
        },
        lualine_z = {},
      },
      winbar = {
        lualine_a = {
          { util.git.diffview.get, color = "WinbarContext", cond = util.git.diffview.cond },
          { util.metadata.breadcrumbs.get, color = "WinbarContext", padding = { right = 0 } },
          { util.lsp.symbols.get, color = "WinbarContext", cond = util.lsp.symbols.cond, padding = { left = 0 } },
        },
        lualine_b = {
          { function() return "%=" end, color = "WinbarContext" },
          { util.git.merge_conflicts.get, color = "WinbarContext", cond = util.git.diffview.cond },
        },
      },
      inactive_winbar = {
        lualine_a = {
          { util.git.diffview.get, color = "WinbarContext", cond = util.git.diffview.cond },
          { util.metadata.breadcrumbs.get, color = "WinbarContext", padding = { right = 0 } },
        },
        lualine_b = {
          { function() return "%=" end, color = "WinbarContext" },
          { util.git.merge_conflicts.get, color = "WinbarContext", cond = util.git.diffview.cond },
        },
      },
    }
  end,
}
