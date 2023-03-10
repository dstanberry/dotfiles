local c = require("ui.theme").colors
local icons = require "ui.icons"

local util = require "remote.lualine.util"
local highlighter = util.highlighter
local theme = require "remote.lualine.theme"
local filetypes = require "remote.lualine.filetypes"

local breadcrumbs = require "remote.lualine.components.breadcrumbs"
local git_branch = require "remote.lualine.components.git_branch"
local git_diff = require "remote.lualine.components.git_diff"
local indent = require "remote.lualine.components.indent"

local min_width = function(width) return vim.api.nvim_get_option "columns" >= width end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    require("lualine").setup {
      options = {
        theme = theme.palette,
        globalstatus = true,
        disabled_filetypes = { statusline = filetypes.stl_disabled, winbar = filetypes.wb_disabled },
        component_separators = " ",
        section_separators = " ",
      },
      sections = {
        lualine_a = {
          {
            function() return icons.misc.VerticalBarBold end,
            color = function() return { fg = theme.modes[vim.fn.mode()], bg = c.gray } end,
            padding = { left = 0, right = 0 },
          },
          {
            git_branch,
            color = function() return { fg = theme.modes[vim.fn.mode()], bg = c.gray } end,
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
              added = { fg = c.green },
              modified = { fg = c.yellow },
              removed = { fg = c.red },
            },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              error = pad(icons.status.Error, "right"),
              warn = pad(icons.status.Warn, "right"),
              info = pad(icons.status.Info, "right"),
              hint = pad(icons.status.Hint, "right"),
            },
          },
          {
            "vim.b.gitsigns_blame_line",
            padding = { left = 5, right = 5 },
            cond = function() return min_width(120) end,
          },
        },
        lualine_x = {
          {
            function()
              local text = require("noice").api.status.search.get()
              local query = vim.F.if_nil(text:match "%/(.-)%s", text:match "%?(.-)%s")
              local counter = text:match "%d+%/%d+"
              return string.format("%s %s %s",icons.misc.Magnify, query, counter)
            end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() and min_width(80) end,
            color = { fg = c.gray_lighter, bold = true },
          },
        },
        lualine_y = {
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
          { breadcrumbs, color = "Winbar" },
          {
            function() return require("nvim-navic").get_location() end,
            separator = { left = highlighter.sanitize "Winbar" .. pad(icons.misc.ChevronRight, "right") },
            padding = { left = 0 },
            color = "Winbar",
            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() and min_width(120) end,
          },
        },
      },
    }
  end,
}
