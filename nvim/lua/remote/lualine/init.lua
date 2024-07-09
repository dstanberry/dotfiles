return {
  "nvim-lualine/lualine.nvim",
  url = "https://github.com/dstanberry/lualine.nvim",
  event = "VeryLazy",
  init = function()
    ds.hl.new("NoiceSymbolNormal", { fg = ds.color.lighten(vim.g.ds_colors.gray1, 15) })
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
    local highlighter = util.highlighter
    local breadcrumbs = util.metadata.breadcrumbs.get
    local root_dir = util.metadata.root_dir.get
    local languageservers = util.lsp.get
    local git_branch = util.git.branch.get
    local git_diff = util.git.diff.get
    local git_difflabel = util.git.diffview.get
    local merge_conflicts = util.git.merge_conflicts.get
    local indent = util.metadata.indentation.get

    local available_width = function(width) return vim.api.nvim_get_option_value("columns", {}) >= width end

    ---@diagnostic disable-next-line: inject-field
    ds.lsp_symbols = {
      has = function() return false end,
      get = function() return "" end,
    }

    ds.plugin.on_load("trouble.nvim", function()
      ---@diagnostic disable-next-line: inject-field
      ds.lsp_symbols = require("trouble").statusline {
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = string.format(
          "%s%s{kind_icon}{symbol.name:NoiceSymbolNormal}",
          highlighter.sanitize "NoiceSymbolSeparator",
          ds.pad(ds.icons.misc.FoldClosed, "right", 2)
        ),
      }
    end)

    local lsp_symbols_section = function()
      local calculate_data = function(symbols)
        symbols = symbols:gsub("%%#StatusLine#", ""):gsub("%%%%", "%%")
        local bc = breadcrumbs():gsub("%%#.-#", "")
        local sep = ds.pad(ds.icons.misc.FoldClosed, "right", 2)
        local parts = vim.split(symbols, sep)
        local raw_symbols = symbols:gsub("%%#.-#", ""):gsub("%%*", ""):gsub("*", "")
        local margin = 10
        if available_width(#bc + #raw_symbols + margin) then return symbols end
        local raw_parts = vim.split(raw_symbols, sep)
        local trimmed_parts = ds.reduce(raw_parts, function(acc, part)
          table.insert(acc, part)
          local new_s = table.concat(acc, sep)
          if not available_width(#bc + #new_s + margin) then
            if acc[#acc] == part then table.remove(acc, #acc) end
          end
          return acc
        end)
        local result = vim.list_slice(parts, 1, #trimmed_parts)
        if parts[#result + 1] then
          local etc = string.format("%s...", highlighter.sanitize "Winbar")
          table.insert(trimmed_parts, etc)
          if available_width(#bc + #table.concat(trimmed_parts, sep) + margin) then
            table.insert(result, etc)
          else
            result[#result] = etc
          end
        end
        return table.concat(result, sep)
      end

      local default = string.format("%s%s", highlighter.sanitize "Winbar", "%=")
      local data = ds.lsp_symbols.get()
      return data ~= "%#StatusLine#" and calculate_data(data) or default
    end

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
          { git_branch, padding = { right = 2 } },
        },
        lualine_b = {
          {
            root_dir,
            cond = function() return type(root_dir()) == "string" end,
            padding = { right = 1 },
          },
          {
            "vim.b.gitsigns_blame_line",
            padding = { left = 2, right = 2 },
            cond = function() return available_width(120) end,
          },
        },
        lualine_c = {
          {
            "diff",
            source = git_diff,
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
              error = { fg = ds.color.blend(vim.g.ds_colors.red1, vim.g.ds_colors.white, 0.4) },
              warn = { fg = ds.color.blend(vim.g.ds_colors.yellow2, vim.g.ds_colors.white, 0.4) },
              info = { fg = ds.color.blend(vim.g.ds_colors.aqua1, vim.g.ds_colors.white, 0.4) },
              hint = { fg = ds.color.blend(vim.g.ds_colors.magenta1, vim.g.ds_colors.white, 0.4) },
            },
          },
          { languageservers },
        },
        lualine_y = {
          {
            function()
              ---@diagnostic disable-next-line: undefined-field
              local text = require("noice").api.status.search.get()
              local query = vim.F.if_nil(text:match "%/(.-)%s", text:match "%?(.-)%s")
              local counter = text:match "%d+%/%d+"
              return string.format("%s %s [%s]", ds.icons.misc.Magnify, query, counter)
            end,
            cond = function()
              ---@diagnostic disable-next-line: undefined-field
              return package.loaded["noice"] and require("noice").api.status.search.has() and available_width(80)
            end,
            color = { fg = vim.g.ds_colors.gray2, bold = true },
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
            git_difflabel,
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
            cond = function()
              local buf = vim.api.nvim_get_current_buf()
              local fname = vim.api.nvim_buf_get_name(buf)
              return not (
                fname:match "%[Scratch%]$"
                or vim.bo[buf].ft:match "dapui_"
                or vim.tbl_contains(ds.excludes.ft.wb_empty, vim.bo[buf].ft)
                or vim.tbl_contains(ds.excludes.ft.wb_disabled, vim.bo[buf].ft)
              )
            end,
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
            git_difflabel,
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
