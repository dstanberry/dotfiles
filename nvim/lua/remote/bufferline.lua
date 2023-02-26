local c = require("ui.theme").colors
local icons = require "ui.icons"
local util = require "util"

return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
  },
  config = function()
    local groups = require "bufferline.groups"
    require("bufferline").setup {
      highlights = function(defaults)
        local diagnostic = vim.regex [[\(error_selected\|warning_selected\|info_selected\|hint_selected\)]]
        local hl = util.map(function(agg, attrs, name)
          local formatted = name:lower()
          local is_group = formatted:match "group"
          local is_offset = formatted:match "offset"
          local is_separator = formatted:match "separator"
          local is_selected = formatted:match "selected"
          local is_visible = formatted:match "visible"
          if diagnostic and diagnostic:match_str(formatted) then
            attrs.fg = c.fg
          end
          if not is_group or (is_group and is_separator) then
            attrs.bg = c.bg
          end
          if not is_group and not is_offset and is_separator then
            attrs.fg = c.bg_alt
          end
          if is_group and not is_offset then
            attrs.bg = c.red
          end
          if is_selected or is_visible then
            attrs.bg = c.bg_alt
          end
          agg[name] = attrs
          return agg
        end, defaults.highlights)

        hl.buffer_selected.italic = false
        hl.buffer_visible.bold = true
        hl.buffer_visible.italic = false
        hl.buffer_visible.fg = c.gray_light
        hl.tab_selected.fg = c.fg
        hl.tab_separator_selected.bg = c.red
        return hl
      end,
      options = {
        mode = "buffers",
        numbers = "none",
        left_mouse_command = "buffer %d",
        right_mouse_command = nil,
        middle_mouse_command = "bdelete! %d",
        close_command = "bdelete! %d",
        buffer_close_icon = icons.misc.Close,
        close_icon = icons.misc.CloseBold,
        hover = { enabled = true, reveal = { "close" } },
        left_trunc_marker = icons.misc.LeftArrowCircled,
        right_trunc_marker = icons.misc.RightArrowCircled,
        max_name_length = 20,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(_, _, _, ctx)
          if ctx.buffer:current() then
            return ""
          end
          return pad(icons.diagnostics.Warn, "left")
        end,
        indicator = {
          icon = pad(icons.misc.VerticalBarThin, "right"),
          style = "none",
        },
        offsets = {
          {
            text = "Source Control",
            filetype = "DiffviewFiles",
            text_align = "center",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_buffer_default_icon = true,
        show_tab_indicators = true,
        separator_style = "thin",
        always_show_bufferline = true,
        sort_by = "insert_after_current",
        groups = {
          items = {
            {
              name = "SQL",
              icon = icons.groups.Sql,
              auto_close = true,
              highlight = { fg = c.orange },
              matcher = function(buf)
                return buf.filename:match "%.sql$"
              end,
              separator = {
                style = groups.separator.pill,
              },
            },
            {
              name = "Unit Tests",
              icon = icons.groups.Lab,
              highlight = { fg = c.yellow_darker },
              auto_close = true,
              matcher = function(buf)
                local name = buf.filename
                return name:match "_spec" or name:match ".spec" or name:match "_test" or name:match ".test"
              end,
              separator = {
                style = groups.separator.pill,
              },
            },
            {
              name = "Zettelkasten Notes",
              icon = icons.groups.Book,
              highlight = { fg = c.teal },
              auto_close = true,
              matcher = function(buf)
                return vim.startswith(buf.path, vim.env.ZK_NOTEBOOK_DIR) or buf.path:match "zettelkasten"
              end,
              separator = {
                style = groups.separator.pill,
              },
            },
          },
        },
      },
    }
  end,
}
