local c = require("ui.theme").colors
local color = require "util.color"
local icons = require "ui.icons"

local theme = require "remote.lualine.theme"
local excludes = require "ui.excludes"

local breadcrumbs = require "remote.lualine.components.breadcrumbs"
local languageservers = require "remote.lualine.components.languageservers"
local filediff = require "remote.lualine.components.filediff"
local git_branch = require "remote.lualine.components.git_branch"
local git_diff = require "remote.lualine.components.git_diff"
local indent = require "remote.lualine.components.indent"
local merge_conflicts = require "remote.lualine.components.merge_conflicts"

local available_width = function(width) return vim.api.nvim_get_option_value("columns", {}) >= width end

return {
  "dstanberry/lualine.nvim",
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
    -- PERF: disable lualine require
    local lualine_require = require "lualine_require"
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = theme.palette,
        globalstatus = true,
        disabled_filetypes = { statusline = excludes.ft.stl_disabled, winbar = excludes.ft.wb_disabled },
        component_separators = " ",
        section_separators = " ",
      },
      sections = {
        lualine_a = {
          {
            function() return icons.misc.VerticalBarBold end,
            -- color = function() return { fg = theme.modes[vim.api.nvim_get_mode().mode], bg = c.gray0 } end,
            padding = { left = 0, right = 0 },
          },
          {
            git_branch,
            -- color = function() return { fg = theme.modes[vim.api.nvim_get_mode().mode], bg = c.gray0 } end,
            padding = { right = 3 },
          },
        },
        lualine_b = {
          {
            "diff",
            source = git_diff,
            symbols = {
              added = pad(icons.git.TextAdded, "right"),
              modified = pad(icons.git.TextChanged, "right"),
              removed = pad(icons.git.TextRemoved, "right"),
            },
            diff_color = {
              added = { fg = color.blend(c.green2, c.white, 0.6) },
              modified = { fg = color.blend(c.yellow2, c.white, 0.6) },
              removed = { fg = color.blend(c.red1, c.white, 0.6) },
            },
          },
        },
        lualine_c = {
          {
            "vim.b.gitsigns_blame_line",
            padding = { left = 2, right = 2 },
            cond = function() return available_width(120) end,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = pad(icons.status.Error, "right"),
              warn = pad(icons.status.Warn, "right"),
              info = pad(icons.status.Info, "right"),
              hint = pad(icons.status.Hint, "right"),
            },
            diagnostics_color = {
              error = { fg = color.blend(c.red1, c.white, 0.4) },
              warn = { fg = color.blend(c.yellow2, c.white, 0.4) },
              info = { fg = color.blend(c.aqua1, c.white, 0.4) },
              hint = { fg = color.blend(c.magenta1, c.white, 0.4) },
            },
          },
          {
            languageservers,
          },
        },
        lualine_y = {
          {
            function()
              local text = require("noice").api.status.search.get()
              local query = vim.F.if_nil(text:match "%/(.-)%s", text:match "%?(.-)%s")
              local counter = text:match "%d+%/%d+"
              return string.format("%s %s [%s]", icons.misc.Magnify, query, counter)
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.search.has() and available_width(80)
            end,
            color = { fg = c.gray2, bold = true },
          },
          { "location" },
          { indent },
          { "encoding" },
          { "fileformat", icons_enabled = true, symbols = { unix = "lf", dos = "crlf", mac = "cr" } },
          { "filetype", padding = { right = 2 } },
        },
        lualine_z = {},
      },
      winbar = {
        lualine_a = {
          {
            filediff,
            color = "Winbar",
            cond = function() return package.loaded["diffview"] and require("diffview.lib").get_current_view() ~= nil end,
          },
          {
            breadcrumbs,
            color = "Winbar",
            padding = { right = 0 },
          },
          {
            "aerial",
            padding = { left = 0 },
            sep_prefix = icons.misc.FoldClosed,
            sep = pad(icons.misc.FoldClosed, "both"),
            sep_highlight = "AerialSeparator",
            sep_icon = "",
            depth = 5,
            dense = false,
            dense_sep = "...",
            colored = true,
            color = "Winbar",
          },
        },
        lualine_x = {
          {
            merge_conflicts,
            color = "Winbar",
            cond = function() return package.loaded["diffview"] and require("diffview.lib").get_current_view() ~= nil end,
          },
        },
      },
      inactive_winbar = {
        lualine_a = {
          {
            filediff,
            color = "Winbar",
            cond = function() return package.loaded["diffview"] and require("diffview.lib").get_current_view() ~= nil end,
          },
          {
            breadcrumbs,
            color = "Winbar",
            padding = { right = 0 },
          },
        },
        lualine_x = {
          {
            merge_conflicts,
            color = "Winbar",
            cond = function() return package.loaded["diffview"] and require("diffview.lib").get_current_view() ~= nil end,
          },
        },
      },
    }
  end,
}
