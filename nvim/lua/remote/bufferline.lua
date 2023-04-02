local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"
local util = require "util"

groups.new("PanelHeading", { link = "Title" })

return {
  "akinsho/bufferline.nvim",
  dependencies = { "tiagovla/scope.nvim", config = true },
  event = "VimEnter",
  keys = {
    { "<leader>bg", ":BufferLineGroupToggle ", desc = "bufferline: toggle group" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "bufferline: toggle pin" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "bufferline: delete all non-pinned buffers" },
  },
  config = function()
    local bufferline_groups = require "bufferline.groups"
    require("bufferline").setup {
      ---@diagnostic disable-next-line: assign-type-mismatch
      highlights = function(defaults)
        local hl = util.map(function(hl, attrs, name)
          local formatted = name:lower()
          local is_group = formatted:match "group"
          local is_offset = formatted:match "offset"
          local is_separator = formatted:match "separator"
          if not is_group or (is_group and is_separator) then attrs.bg = c.bg2 end
          if is_separator and not (is_group or is_offset) then attrs.fg = c.bg2 end
          hl[name] = attrs
          return hl
        end, defaults.highlights)
        hl.buffer_selected.italic = false
        hl.buffer_visible.bold = true
        hl.buffer_visible.italic = false
        hl.buffer_visible.fg = c.gray1
        hl.tab_selected.bold = true
        hl.tab_selected.fg = c.red1
        return hl
      end,
      options = {
        mode = "buffers",
        numbers = "none",
        left_mouse_command = "buffer %d",
        ---@diagnostic disable-next-line: assign-type-mismatch
        right_mouse_command = nil,
        middle_mouse_command = "bdelete! %d",
        close_command = "bdelete! %d",
        buffer_close_icon = icons.misc.Close,
        close_icon = icons.misc.CloseBold,
        hover = { enabled = true, reveal = { "close" } },
        left_trunc_marker = icons.misc.LeftArrowCircled,
        right_trunc_marker = icons.misc.RightArrowCircled,
        max_name_length = 20,
        color_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_buffer_default_icon = true,
        show_tab_indicators = true,
        separator_style = "thin",
        always_show_bufferline = true,
        sort_by = "insert_after_current",
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(_, _, _, ctx)
          if ctx.buffer:current() then return "" end
          return pad(icons.diagnostics.Warn, "left")
        end,
        indicator = {
          icon = pad(icons.misc.VerticalBarThin, "right"),
          style = "none",
        },
        offsets = {
          {
            text = pad(icons.documents.FolderClosed, "right") .. "EXPLORER",
            filetype = "neo-tree",
            highlight = "PanelHeading",
            separator = true,
            text_align = "center",
          },
          {
            text = pad(icons.groups.Sql, "right") .. "DATABASE VIEWER",
            filetype = "dbui",
            highlight = "PanelHeading",
            separator = true,
            text_align = "center",
          },
          {
            text = pad(icons.groups.Diff, "right") .. "DIFF VIEW",
            filetype = "DiffviewFiles",
            highlight = "PanelHeading",
            separator = true,
            text_align = "center",
          },
        },
        groups = {
          items = {
            {
              name = "SQL",
              -- icon = icons.groups.Sql,
              auto_close = true,
              highlight = { fg = c.orange0 },
              ---@diagnostic disable-next-line: undefined-field
              matcher = function(buf) return buf.filename:match "%.sql$" end,
              separator = {
                style = bufferline_groups.separator.pill,
              },
            },
            {
              name = "Unit Tests",
              -- icon = icons.groups.Lab,
              highlight = { fg = c.yellow0 },
              auto_close = true,
              matcher = function(buf)
                ---@diagnostic disable-next-line: undefined-field
                local name = buf.filename
                return name:match "_spec" or name:match ".spec" or name:match "_test" or name:match ".test"
              end,
              separator = {
                style = bufferline_groups.separator.pill,
              },
            },
            {
              name = "Zettelkasten Notes",
              -- icon = icons.groups.Book,
              highlight = { fg = c.cyan1 },
              auto_close = true,
              matcher = function(buf) return vim.startswith(buf.path, vim.env.ZK_NOTEBOOK_DIR) or buf.path:match "zettelkasten" end,
              separator = {
                style = bufferline_groups.separator.pill,
              },
            },
            bufferline_groups.builtin.pinned:with { icon = icons.groups.Pinned },
            bufferline_groups.builtin.ungrouped,
          },
        },
      },
    }
  end,
}
