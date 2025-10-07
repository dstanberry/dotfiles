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

    local GIT, MSG, META = util.git, util.message, util.metadata

    local function sep(direction, padding_opts, condition)
      return {
        util.separator[direction],
        padding = padding_opts or { left = 0, right = 1 },
        cond = condition,
      }
    end

    ---@param kind "symbols"|"colors"
    local function get_diag(kind)
      return vim.tbl_map(function(type)
        local diag_type = "DiagnosticVirtualText" .. type:gsub("^%l", string.upper)
        return kind == "symbols" and { fg = ds.color.get(diag_type) }
          or ds.pad(ds.icons.status[type:gsub("^%l", string.upper)], "right")
      end, { "error", "warn", "info", "hint" })
    end

    ---@param kind "symbols"|"colors"
    local function get_diff(kind)
      local diff_types = { "added", "modified", "removed" }
      local result = {}
      for _, type in ipairs(diff_types) do
        if kind == "symbols" then
          local icon_map = { added = "TextAdded", modified = "TextChanged", removed = "TextRemoved" }
          result[type] = ds.pad(ds.icons.git[icon_map[type]], "right")
        else
          local color_map = { added = "green2", modified = "yellow2", removed = "red1" }
          result[type] = { fg = ds.color.blend(ds.color(color_map[type]), ds.color "white", 0.6) }
        end
      end
      return result
    end

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = util.theme,
        globalstatus = true,
        disabled_filetypes = { statusline = ds.ft.disabled.statusline, winbar = ds.ft.disabled.winbar },
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          { function() return ds.icons.misc.VerticalBarBold end, padding = { left = 0 } },
          { GIT.branch.get },
          sep "left",
        },
        lualine_b = {
          -- stylua: ignore
          { META.root_dir.get, color = { fg = ds.color "overlay1" }, cond = META.root_dir.cond, padding = { right = 1 } },
          sep("left", nil, META.root_dir.cond),

          { META.plugin.get, color = { fg = ds.color "overlay1" }, cond = META.plugin.cond, padding = { right = 1 } },
          sep("left", nil, META.plugin.cond),
        },
        lualine_c = {
          { "vim.b.gitsigns_blame_line", color = { fg = ds.color "gray2", gui = "italic" }, padding = { right = 1 } },
          { "diff", source = GIT.diff.get, symbols = get_diff "symbols", diff_color = get_diff "colors" },
          -- stylua: ignore
          { MSG.codecompanion.adapter.get, color = { fg = ds.color "gray2", gui = "italic" }, cond = MSG.codecompanion.adapter.cond },
        },
        lualine_x = {
          { MSG.noice.get, color = { fg = ds.color "gray2", gui = "italic" }, cond = MSG.noice.cond },
          sep("right", { right = 1 }, MSG.noice.cond),

          -- stylua: ignore
          { MSG.codecompanion.ctx.get, color = { fg = ds.color "fg_conceal", gui = "bold" }, cond = MSG.codecompanion.ctx.cond },
          sep("right", { right = 1 }, MSG.codecompanion.ctx.cond),
        },
        lualine_y = {
          -- stylua: ignore
          { "diagnostics", sources = { "nvim_diagnostic" }, symbols = get_diag "symbols", diagnostics_color = get_diag "colors" },

          sep("right", { left = 1, right = 1 }, function() return MSG.clients.cond() or MSG.sidekick.cond() end),
          { MSG.clients.get, color = MSG.clients.color, padding = { right = 0 }, cond = MSG.clients.cond },
          { MSG.sidekick.get, color = MSG.sidekick.color, padding = { right = 1 }, cond = MSG.sidekick.cond },

          sep("right", { left = 1, right = 0 }),
          { "location" },

          sep("right", { left = 0, right = 0 }, function() return vim.bo.shiftwidth > 0 end),
          { META.indentation.get, cond = function() return vim.bo.shiftwidth > 0 end },

          sep("right", { left = 0, right = 0 }, function() return vim.bo.fileencoding ~= "" end),
          { "encoding" },

          sep("right", { left = 0, right = 0 }, function() return vim.bo.fileformat ~= "" end),
          { "fileformat", icons_enabled = true, symbols = { unix = "lf", dos = "crlf", mac = "cr" } },

          sep("right", { left = 0, right = 0 }, function() return vim.bo.filetype ~= "" end),
          { "filetype", icon_only = true, cond = function() return vim.bo.filetype ~= "" end },
        },
        lualine_z = {},
      },
      winbar = {
        lualine_a = {
          { GIT.diffview.get, color = "WinbarContext", cond = GIT.diffview.cond },
          { META.breadcrumbs.get, color = "WinbarContext", padding = { right = 0 } },
          { MSG.symbols.get, color = "WinbarContext", cond = MSG.symbols.cond, padding = { left = 0 } },
        },
        lualine_b = {
          { function() return "%=" end, color = "WinbarContext" },
          { GIT.merge_conflicts.get, color = "WinbarContext", cond = GIT.diffview.cond },
        },
      },
      inactive_winbar = {
        lualine_a = {
          { GIT.diffview.get, color = "WinbarContext", cond = GIT.diffview.cond },
          { META.breadcrumbs.get, color = "WinbarContext", padding = { right = 0 } },
        },
        lualine_b = {
          { function() return "%=" end, color = "WinbarContext" },
          { GIT.merge_conflicts.get, color = "WinbarContext", cond = GIT.diffview.cond },
        },
      },
    }
  end,
}
