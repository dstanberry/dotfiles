local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local excludes = require "ui.excludes"
local util = require "util"

local theme = require "remote.lualine.theme"
local stl_util = require "remote.lualine.util"

return {
  "dstanberry/lualine.nvim",
  event = { "LazyFile", "VeryLazy" },
  init = function()
    groups.new("NoiceSymbolNormal", { fg = color.lighten(c.gray1, 15) })
    groups.new("NoiceSymbolSeparator", { fg = color.blend(c.purple1, c.bg2, 0.38) })

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
    local breadcrumbs = require "remote.lualine.components.breadcrumbs"
    local languageservers = require "remote.lualine.components.languageservers"
    local filediff = require "remote.lualine.components.filediff"
    local git_branch = require "remote.lualine.components.git_branch"
    local git_diff = require "remote.lualine.components.git_diff"
    local indent = require "remote.lualine.components.indent"
    local merge_conflicts = require "remote.lualine.components.merge_conflicts"

    local available_width = function(width) return vim.api.nvim_get_option_value("columns", {}) >= width end

    local lsp_symbols = require("trouble").statusline {
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = string.format(
        "%s%s{kind_icon}{symbol.name:NoiceSymbolNormal}",
        stl_util.highlighter.sanitize "NoiceSymbolSeparator",
        pad(icons.misc.FoldClosed, "right", 2)
      ),
    }

    local lsp_symbols_section = function()
      local calculate_data = function(symbols)
        symbols = symbols:gsub("%%#StatusLine#", ""):gsub("%%%%", "%%")
        local bc = breadcrumbs():gsub("%%#.-#", "")
        local sep = pad(icons.misc.FoldClosed, "right", 2)
        local parts = vim.split(symbols, sep)
        local raw_symbols = symbols:gsub("%%#.-#", ""):gsub("%%*", ""):gsub("*", "")
        local margin = 10
        if available_width(#bc + #raw_symbols + margin) then return symbols end
        local raw_parts = vim.split(raw_symbols, sep)
        local trimmed_parts = util.reduce(raw_parts, function(acc, part)
          table.insert(acc, part)
          local new_s = table.concat(acc, sep)
          if not available_width(#bc + #new_s + margin) then
            if acc[#acc] == part then table.remove(acc, #acc) end
          end
          return acc
        end)
        local result = vim.list_slice(parts, 1, #trimmed_parts)
        if parts[#result + 1] then
          local etc = string.format("%s...", stl_util.highlighter.sanitize "Winbar")
          table.insert(trimmed_parts, etc)
          if available_width(#bc + #table.concat(trimmed_parts, sep) + margin) then
            table.insert(result, etc)
          else
            result[#result] = etc
          end
        end
        return table.concat(result, sep)
      end

      local default = string.format("%s%s", stl_util.highlighter.sanitize "Winbar", "%=")
      local data = lsp_symbols.get()
      return data ~= "%#StatusLine#" and calculate_data(data) or default
    end

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
            padding = { left = 0, right = 0 },
          },
          {
            git_branch,
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
            lsp_symbols_section,
            cond = lsp_symbols.has,
            padding = { left = 0 },
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
