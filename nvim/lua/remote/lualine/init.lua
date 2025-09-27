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

    local bold = { gui = "bold" }
    local c_fg_conceal = { fg = vim.g.ds_colors.fg_conceal }
    local c_fg_conceal_bold = { fg = vim.g.ds_colors.fg_conceal, gui = "bold" }
    local c_gray2_italic = { fg = vim.g.ds_colors.gray2, gui = "italic" }
    local c_overlay1 = { fg = vim.g.ds_colors.overlay1 }
    local winbar_fname = { fg = ds.color.get_color "WinbarFilename", gui = "italic" }

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
        return kind == "symbols" and { fg = ds.color.get_color(diag_type) }
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
          local colors = vim.g.ds_colors
          local color_map = { added = "green2", modified = "yellow2", removed = "red1" }
          result[type] = { fg = ds.color.blend(colors[color_map[type]], colors.white, 0.6) }
        end
      end
      return result
    end

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
          { util.git.branch.get },
          sep "left",
        },
        lualine_b = {
          -- stylua: ignore
          { util.metadata.root_dir.get, color = c_overlay1, cond = util.metadata.root_dir.cond, padding = { right = 1 } },
          sep("left", nil, util.metadata.root_dir.cond),
          -- stylua: ignore
          { util.metadata.plugin_info.get, color = c_overlay1, cond = util.metadata.plugin_info.cond, padding = { right = 1 } },
          sep("left", nil, util.metadata.plugin_info.cond),
          -- stylua: ignore
          { util.status.codecompanion.adapter.get, color = winbar_fname, cond = util.status.codecompanion.adapter.cond },
          { "vim.b.gitsigns_blame_line", color = winbar_fname, padding = { right = 1 } },
        },
        lualine_c = {
          { "diff", source = util.git.diff.get, symbols = get_diff "symbols", diff_color = get_diff "colors" },
        },
        lualine_x = {
          { util.message.noice.get, color = c_gray2_italic, cond = util.message.noice.cond },
          sep("right", { right = 1 }, util.message.noice.cond),
          { util.status.codecompanion.ctx.get, color = c_fg_conceal_bold, cond = util.status.codecompanion.ctx.cond },
          sep("right", { right = 1 }, util.status.codecompanion.ctx.cond),
        },
        lualine_y = {
          -- stylua: ignore
          { "diagnostics", sources = { "nvim_diagnostic" }, symbols = get_diag "symbols", diagnostics_color = get_diag "colors" },
          sep("right", { left = 0, right = 1 }, function() return #vim.diagnostic.count() > 0 end),
          { util.lsp.clients.get, color = c_fg_conceal, padding = { right = 0 }, cond = util.lsp.clients.cond },
          { util.lsp.copilot.get, color = c_fg_conceal, padding = { right = 1 }, cond = util.lsp.copilot.cond },
          -- stylua: ignore
          sep("right", { left = 1, right = 0 }, function() return util.lsp.clients.cond() or util.lsp.copilot.cond() end),
          { "location" },
          sep("right", { left = 0, right = 0 }),
          { util.metadata.indentation.get, cond = function() return vim.bo.shiftwidth > 0 end },
          sep("right", { left = 0, right = 0 }, function() return vim.bo.shiftwidth > 0 end),
          { "encoding" },
          sep("right", { left = 0, right = 0 }, function() return vim.bo.fileencoding ~= "" end),
          { "fileformat", icons_enabled = true, symbols = { unix = "lf", dos = "crlf", mac = "cr" } },
          sep("right", { left = 0, right = 0 }, function() return vim.bo.fileformat ~= "" end),
          { "filetype", color = bold, cond = function() return vim.bo.filetype ~= "" end },
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
