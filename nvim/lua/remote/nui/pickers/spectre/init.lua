local n = require "nui-components"

local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local util = require "util"

local engine = require "remote.nui.pickers.spectre.engine"
local search_tree = require "remote.nui.pickers.spectre.search_tree"

groups.new("NuiComponentsTreeSpectreCodeLine", { fg = c.gray2 })
groups.new("NuiComponentsTreeSpectreIcon", { bold = true })
groups.new("NuiComponentsTreeSpectreFileName", { bold = true })
groups.new("NuiComponentsTreeSpectreSearchOldValue", { fg = c.bg0, bg = c.orange1, strikethrough = true })
groups.new("NuiComponentsTreeSpectreSearchValue", { fg = c.bg0, bg = c.rose0, bold = true })
groups.new("NuiComponentsTreeSpectreSearchNewValue", { fg = c.bg0, bg = c.green1, bold = true })
groups.new("NuiComponentsTreeSpectreReplaceSuccess", { fg = c.bg0, bg = c.green0, bold = true })

local M = {}

function M.toggle()
  if M.renderer then return M.renderer:focus() end

  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)
  local width = math.min(math.max(50, win_width / 3), win_width / 2)
  local height = win_height - 2

  local renderer = n.create_renderer {
    width = width,
    height = height,
    relative = "editor",
    position = {
      row = 0,
      col = win_width - width - 1,
    },
  }

  local signal = n.create_signal {
    search_query = "",
    replace_query = "",
    search_paths = {},
    is_replace_field_visible = false,
    is_case_insensitive_checked = false,
    search_info = "",
    search_results = {},
  }

  local subscription = signal:observe(function(prev, curr)
    local diff = util.any(
      { "search_query", "is_case_insensitive_checked", "search_paths" },
      function(key) return not vim.deep_equal(prev[key], curr[key]) end
    )

    if diff then
      if #curr.search_query > 2 then
        engine.search(curr, signal)
      else
        signal.search_info = ""
        signal.search_results = {}
      end
    end

    if not (prev.replace_query == curr.replace_query) and #curr.search_query > 2 then
      signal.search_results = engine.process(curr)
    end
  end)

  renderer:add_mappings {
    {
      mode = { "n" },
      key = "<bs>q",
      handler = function() renderer:close() end,
    },
    {
      mode = { "i" },
      key = "<bs>q",
      handler = function() renderer:close() end,
    },
  }

  renderer:on_unmount(function()
    subscription:unsubscribe()
    M.renderer = nil
  end)

  M.renderer = renderer

  local body = n.rows(n.columns(
    n.checkbox {
      default_sign = icons.misc.RightArrow,
      checked_sign = icons.misc.DownArrow,
      padding = {
        top = 1,
        left = 1,
      },
      value = signal.is_replace_field_visible,
      on_change = function(is_checked)
        signal.is_replace_field_visible = is_checked

        if is_checked then
          local replace_component = renderer:get_component_by_id "replace_query"

          renderer:schedule(function() replace_component:focus() end)
        end
      end,
      window = {
        highlight = {
          CursorLine = "NuiCursorLine",
          FloatBorder = "NuiFloatBorder",
          NormalFloat = "NuiNormalFloat",
        },
      },
    },
    n.rows(
      n.columns(
        { size = 3 },
        n.text_input {
          autofocus = true,
          flex = 1,
          max_lines = 1,
          border_label = "Search",
          on_change = util.debounce(function(value) signal.search_query = value end, 400),
          window = {
            highlight = {
              CursorLine = "NuiCursorLine",
              FloatBorder = "NuiFloatBorder",
              NormalFloat = "NuiNormalFloat",
              FloatTitle = "NuiLabel",
            },
          },
        },
        n.checkbox {
          label = "Aa",
          default_sign = "",
          checked_sign = "",
          border_style = "rounded",
          value = signal.is_case_insensitive_checked,
          on_change = function(is_checked) signal.is_case_insensitive_checked = is_checked end,
          window = {
            highlight = {
              CursorLine = "NuiCursorLine",
              FloatBorder = "NuiFloatBorder",
              NormalFloat = "NuiNormalFloat",
              FloatTitle = "NuiLabel",
            },
          },
        }
      ),
      n.text_input {
        size = 1,
        max_lines = 1,
        id = "replace_query",
        border_label = "Replace",
        on_change = util.debounce(function(value) signal.replace_query = value end, 400),
        hidden = signal.is_replace_field_visible:map(function(value) return not value end),
        window = {
          highlight = {
            CursorLine = "NuiCursorLine",
            FloatBorder = "NuiFloatBorder",
            NormalFloat = "NuiNormalFloat",
            FloatTitle = "NuiLabel",
          },
        },
      },
      n.text_input {
        size = 1,
        max_lines = 1,
        border_label = "Files to include",
        value = signal.search_paths:map(function(paths) return table.concat(paths, ",") end),
        on_change = util.debounce(function(value)
          signal.search_paths = vim.tbl_filter(
            function(path) return path ~= "" end,
            util.map(vim.split(value, ","), vim.trim)
          )
        end, 400),
        window = {
          highlight = {
            CursorLine = "NuiCursorLine",
            FloatBorder = "NuiFloatBorder",
            NormalFloat = "NuiNormalFloat",
            FloatTitle = "NuiLabel",
          },
        },
      },
      n.rows(
        { flex = 0, hidden = signal.search_info:map(function(value) return value == "" end) },
        n.gap { size = 1, window = { highlight = { NormalFloat = "NuiGapFloat" } } },
        n.paragraph {
          lines = signal.search_info,
          padding = { left = 1, right = 1 },
          window = { highlight = { NormalFloat = "NuiGapFloat" } },
        }
      ),
      n.gap { size = 1, window = { highlight = { NormalFloat = "NuiGapFloat" } } },
      search_tree {
        search_query = signal.search_query,
        replace_query = signal.replace_query,
        data = signal.search_results,
        origin_winid = renderer:get_origin_winid(),
        hidden = signal.search_results:map(function(value) return #value == 0 end),
      }
    )
  ))

  renderer:render(body)
end

return M
