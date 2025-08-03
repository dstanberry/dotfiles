return {
  {
    "akinsho/bufferline.nvim",
    event = { "LazyFile", { event = "BufReadCmd", pattern = "octo://*" } },
    lazy = vim.fn.argc(-1) == 0,
    keys = {
      { "<left>", "<cmd>BufferLineCyclePrev<cr>", desc = "bufferline: goto next buffer" },
      { "<right>", "<cmd>BufferLineCycleNext<cr>", desc = "bufferline: goto previous buffer" },
      { "<leader>bg", ":BufferLineGroupToggle ", desc = "bufferline: toggle group" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "bufferline: toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "bufferline: delete all non-pinned buffers" },
    },
    config = function()
      local bufferline_groups = require "bufferline.groups"
      local bufferline = require "bufferline"
      bufferline.setup {
        highlights = function(defaults)
          local hl = ds.tbl_reduce(defaults.highlights, function(highlight, attrs, name)
            local formatted = name:lower()
            local is_group = formatted:match "group"
            local is_offset = formatted:match "offset"
            local is_separator = formatted:match "separator"
            if not is_group or (is_group and is_separator) then attrs.bg = vim.g.ds_colors.bg2 end
            if is_separator and not (is_group or is_offset) then attrs.fg = vim.g.ds_colors.bg2 end
            highlight[name] = attrs
            return highlight
          end)
          hl.buffer_selected.italic = false
          hl.buffer_visible.bold = true
          hl.buffer_visible.italic = false
          hl.buffer_visible.fg = vim.g.ds_colors.gray1
          hl.tab_selected.bold = true
          hl.tab_selected.fg = vim.g.ds_colors.red1
          return hl
        end,
        options = {
          style_preset = { bufferline.style_preset.minimal },
          mode = "buffers",
          numbers = "none",
          left_mouse_command = "buffer %d",
          ---@diagnostic disable-next-line: assign-type-mismatch
          right_mouse_command = nil,
          middle_mouse_command = function(buf) ds.buffer.delete(buf) end,
          close_command = function(buf) ds.buffer.delete(buf) end,
          buffer_close_icon = ds.icons.misc.Close .. ds.icons.misc.BrailleBlank,
          close_icon = ds.icons.misc.CloseBold .. ds.icons.misc.BrailleBlank,
          hover = { enabled = true, reveal = { "close" } },
          left_trunc_marker = ds.icons.misc.LeftArrowCircled,
          right_trunc_marker = ds.icons.misc.RightArrowCircled,
          max_name_length = 20,
          color_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = "thin",
          always_show_bufferline = true,
          sort_by = "insert_after_current",
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, _, ctx)
            if ctx.buffer:current() then return "" end
            return ds.pad(ds.icons.diagnostics.Warn, "left")
          end,
          indicator = {
            icon = ds.pad(ds.icons.misc.VerticalBarMiddle, "right"),
            style = "none",
          },
          get_element_icon = function(element)
            if element.filetype == "octo" or element.path:match "^octo:" then
              ---@diagnostic disable-next-line: return-type-mismatch
              return require("mini.icons").get("extension", element.filetype)
            end
            ---@diagnostic disable-next-line: return-type-mismatch
            return require("mini.icons").get(element.directory and "directory" or "file", element.path)
          end,
          offsets = {
            {
              text = ds.pad(ds.icons.groups.StackFrame, "right") .. "DEBUGGER",
              filetype = "dapui_scopes",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Sql, "right") .. "DATABASE VIEWER",
              filetype = "dbui",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Diff, "right") .. "DIFF VIEW",
              filetype = "DiffviewFiles",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Tree, "right") .. "EXPLORER",
              filetype = "snacks_layout_box",
              highlight = "PanelHeading",
              separator = true,
            },
            {
              text = ds.pad(ds.icons.misc.Magnify, "right") .. "FIND / REPLACE",
              filetype = "grug-far",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
            {
              text = ds.pad(ds.icons.groups.Tree, "right") .. "SYMBOLS",
              filetype = "trouble",
              highlight = "PanelHeading",
              separator = true,
              text_align = "center",
            },
          },
          groups = {
            items = {
              {
                name = "Notes",
                -- icon =ds.icons.groups.Book,
                highlight = { fg = vim.g.ds_colors.overlay1 },
                auto_close = false,
                matcher = function(buf)
                  return (vim.env.ZK_NOTEBOOK_DIR and vim.env.ZK_NOTEBOOK_DIR ~= "")
                      and vim.startswith(buf.path, vim.env.ZK_NOTEBOOK_DIR)
                    or buf.path:match "zettelkasten"
                end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "SQL",
                -- icon =ds.icons.groups.Sql,
                auto_close = false,
                highlight = { fg = vim.g.ds_colors.orange0 },
                matcher = function(buf) return buf.name:match "%.sql$" end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "Unit Tests",
                -- icon =ds.icons.groups.Lab,
                highlight = { fg = vim.g.ds_colors.rose1 },
                auto_close = false,
                matcher = function(buf)
                  return buf.name:match "_spec%."
                    or buf.name:match "%.spec"
                    or buf.name:match "_test%."
                    or buf.name:match "%.test"
                end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              bufferline_groups.builtin.pinned:with { icon = ds.icons.groups.Pinned },
              bufferline_groups.builtin.ungrouped,
            },
          },
        },
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = function()
      local toggle_menu = function()
        local harpoon = require "harpoon"
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end

      local keys = {
        { "<leader>h", desc = "+harpoon" },
        { "<leader>ha", function() require("harpoon"):list():add() end, desc = "harpoon: mark file" },
        { "<leader>hf", function() toggle_menu() end, desc = "harpoon: find marks" },
      }
      for i = 1, 5 do
        -- stylua: ignore
        table.insert(keys, { "<leader>h" .. i, function() require("harpoon"):list():select(i) end, desc = "harpoon: goto " .. i })
      end
      return keys
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
      autosave_changes = false,
      delete_to_trash = false,
      skip_confirm_for_simple_edits = true,
      columns = { "icon" },
      keymaps = {
        ["<a-h>"] = { "actions.toggle_hidden", mode = "n" },
        ["<c-h>"] = false,
        ["<c-t>"] = { "actions.select", opts = { tab = true }, desc = "oil: open in a new tab" },
        ["<c-s>"] = { "actions.select", opts = { vertical = true }, desc = "oil: open in a vertical split" },
        ["-"] = "actions.parent",
        ["g."] = false,
        ["q"] = "actions.close",
      },
      float = {
        border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.floor(vim.o.lines * 0.4),
        win_options = {
          cursorline = false,
          number = false,
          relativenumber = false,
          winblend = vim.o.pumblend,
          winhighlight = "Title:OilFloatTitle",
        },
      },
      keymaps_help = {
        border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
      },
      preview = { border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default) },
      ssh = { border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default) },
    },
    keys = function()
      local _open = function() require("oil").open(ds.root.get()) end
      local _float = function() require("oil").toggle_float() end

      return {
        { "-", _open, desc = "oil: browse project" },
        { "<leader>-", _float, desc = "oil: browse parent directory" },
      }
    end,
  },
  {
    "folke/persistence.nvim",
    event = "LazyFile",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").save() end, desc = "persistence: save session" },
      { "<leader>qS", function() require("persistence").stop() end, desc = "persistence: untrack session" },
      { "<leader>qr", function() require("persistence").load() end, desc = "persistence: restore session" },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = function()
      local _finder = function()
        local grug = require "grug-far"
        local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
        grug.open { transient = true, prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } }
      end

      return {
        { "<leader>s/", mode = { "n", "v" }, _finder, desc = "gruf-far: search/replace in files" },
      }
    end,
    opts = {
      headerMaxWidth = 80,
    },
  },
  {
    "folke/trouble.nvim",
    event = "LazyFile",
    cmd = { "Trouble" },
    keys = function()
      local _definitions = function() vim.cmd { cmd = "Trouble", args = { "lsp_def", "toggle" } } end
      local _implementation = function() vim.cmd { cmd = "Trouble", args = { "lsp_impl", "toggle" } } end
      local _references = function() vim.cmd { cmd = "Trouble", args = { "lsp_ref", "toggle" } } end
      local _symbols = function() vim.cmd { cmd = "Trouble", args = { "symbols", "toggle" } } end
      local _type_definitions = function() vim.cmd { cmd = "Trouble", args = { "lsp_type_def", "toggle" } } end
      local _diagnostics = function() vim.cmd { cmd = "Trouble", args = { "lsp_diag", "toggle" } } end
      local _diagnostics_cascade = function() vim.cmd { cmd = "Trouble", args = { "lsp_diag_cascade", "toggle" } } end
      local _location_list = function() vim.cmd { cmd = "Trouble", args = { "loclist", "toggle" } } end
      local _quickfix_list = function() vim.cmd { cmd = "Trouble", args = { "qflist", "toggle" } } end
      local _next = function()
        if require("trouble").is_open() then
          require("trouble").next { skip_groups = true, jump = true }
        else
          pcall(vim.cmd.cnext)
        end
      end
      local _previous = function()
        if require("trouble").is_open() then
          require("trouble").prev { skip_groups = true, jump = true }
        else
          pcall(vim.cmd.cprevious)
        end
      end

      return {
        { "gD", _definitions, desc = "trouble: lsp definitions" },
        { "gI", _implementation, desc = "trouble: lsp implementations" },
        { "gR", _references, desc = "trouble: lsp references" },
        { "gS", _symbols, desc = "trouble: lsp document symbols" },
        { "gT", _type_definitions, desc = "trouble: lsp type definitions" },
        { "gWa", _diagnostics, desc = "trouble: workspace diagnostics" },
        { "gWf", _diagnostics_cascade, desc = "trouble: filtered diagnostics" },
        { "<localleader>ql", _location_list, desc = "trouble: location list" },
        { "<localleader>qq", _quickfix_list, desc = "trouble: quickfix list" },
        { "<c-up>", _previous, desc = "trouble: previous item" },
        { "<c-down>", _next, desc = "trouble: next item" },
      }
    end,
    opts = function()
      local preview_opts = {
        type = "float",
        relative = "editor",
        border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
        position = { 0.5, 0.5 },
        size = { width = 0.6, height = 0.5 },
        zindex = 200,
      }
      return {
        icons = {
          kinds = vim.tbl_extend(
            "keep",
            vim.tbl_map(function(kind) return ds.pad(kind, "right") end, ds.icons.kind),
            vim.tbl_map(function(kind) return ds.pad(kind, "right") end, ds.icons.type)
          ),
        },
        modes = {
          lsp_def = { mode = "lsp_definitions", preview = preview_opts },
          lsp_impl = { mode = "lsp_implementations", preview = preview_opts },
          lsp_ref = { mode = "lsp_references", preview = preview_opts },
          lsp_type_def = { mode = "lsp_type_definitions", preview = preview_opts },
          lsp_diag = {
            mode = "diagnostics",
            filter = {
              any = {
                buf = 0,
                {
                  severity = vim.diagnostic.severity.WARN,
                  function(item) return item.filename:find(ds.root.get(), 1, true) end,
                },
              },
            },
          },
          lsp_diag_cascade = {
            mode = "diagnostics",
            filter = function(items)
              local severity = vim.diagnostic.severity.HINT
              for _, item in ipairs(items) do
                severity = math.min(severity, item.severity)
              end
              return vim.tbl_filter(function(item) return item.severity == severity end, items)
            end,
          },
        },
      }
    end,
  },
}
