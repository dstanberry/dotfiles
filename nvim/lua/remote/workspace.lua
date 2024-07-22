return {
  { "tiagovla/scope.nvim", lazy = true },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bg", ":BufferLineGroupToggle ", desc = "bufferline: toggle group" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "bufferline: toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "bufferline: delete all non-pinned buffers" },
    },
    init = function() ds.hl.new("PanelHeading", { link = "Title" }) end,
    config = function()
      local bufferline_groups = require "bufferline.groups"
      local bufferline = require "bufferline"
      bufferline.setup {
        highlights = function(defaults)
          local hl = ds.reduce(defaults.highlights, function(highlight, attrs, name)
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
          middle_mouse_command = function(buf) ds.buffer.delete_buffer(buf) end,
          close_command = function(buf) ds.buffer.delete_buffer(buf) end,
          buffer_close_icon = ds.icons.misc.Close,
          close_icon = ds.icons.misc.CloseBold,
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
            icon = ds.pad(ds.icons.misc.VerticalBarThin, "right"),
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
              filetype = "dbee",
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
              text = ds.pad(ds.icons.misc.Magnify, "right") .. "Find | Replace",
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
                name = "SQL",
                -- icon =ds.icons.groups.Sql,
                auto_close = true,
                highlight = { fg = vim.g.ds_colors.orange0 },
                matcher = function(buf) return buf.name:match "%.sql$" end,
                separator = {
                  style = bufferline_groups.separator.pill,
                },
              },
              {
                name = "Unit Tests",
                -- icon =ds.icons.groups.Lab,
                highlight = { fg = vim.g.ds_colors.yellow0 },
                auto_close = true,
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
              {
                name = "Notes",
                -- icon =ds.icons.groups.Book,
                highlight = { fg = vim.g.ds_colors.overlay1 },
                auto_close = true,
                matcher = function(buf)
                  return vim.startswith(buf.path, vim.env.ZK_NOTEBOOK_DIR) or buf.path:match "zettelkasten"
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
      local has_telescope, telescope = pcall(require, "telescope.pickers")
      local telescope_picker
      if has_telescope then
        telescope_picker = function(files)
          local file_paths = {}
          for _, item in ipairs(files.items) do
            table.insert(file_paths, item.value)
          end
          telescope
            .new(require("telescope.themes").get_ivy {}, {
              prompt_title = "Harpoon (marks)",
              finder = require("telescope.finders").new_table { results = file_paths },
              previewer = require("telescope.config").values.file_previewer {},
              sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
              layout_config = { height = 30, prompt_position = "top" },
            })
            :find()
        end
      end

      local keys = {
        { "<leader>h", desc = "+harpoon" },
        { "<leader>ha", function() require("harpoon"):list():add() end, desc = "harpoon: mark file" },
        {
          "<leader>hf",
          function()
            local harpoon = require "harpoon"
            if has_telescope then
              telescope_picker(harpoon:list())
            else
              harpoon.ui:toggle_quick_menu(harpoon:list())
            end
          end,
          desc = "harpoon: find marks",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>h" .. i,
          function() require("harpoon"):list():select(i) end,
          desc = "harpoon: goto " .. i,
        })
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
        ["<c-h>"] = false,
        ["<c-t>"] = { "actions.select", opts = { tab = true }, desc = "oil: open in a new tab" },
        ["<c-s>"] = { "actions.select", opts = { vertical = true }, desc = "oil: open in a vertical split" },
        ["-"] = "actions.parent",
        ["q"] = "actions.close",
      },
      float = {
        border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.floor(vim.o.lines * 0.4),
        win_options = {
          winblend = 0,
          cursorline = false,
          number = false,
          relativenumber = false,
        },
      },
      keymaps_help = { border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end) },
      preview = { border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end) },
      ssh = { border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end) },
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
      {
        "<leader>ql",
        function() require("persistence").load { last = true } end,
        desc = "persistence: restore last session",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = function()
      local _far = function()
        local grug = require "grug-far"
        local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
        grug.grug_far {
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        }
      end
      return {
        { "<leader>sr", mode = { "n", "v" }, _far, desc = "gruf-far: search/replace in files" },
      }
    end,
    init = function()
      local GREEN = ds.color.blend(vim.g.ds_colors.green1, vim.g.ds_colors.bg2, 0.66)
      ds.hl.new("GrugFarInputLabel", { link = "DiagnosticInfo" })
      ds.hl.new("GrugFarInputPlaceholder", { link = "LspCodeLens" })
      ds.hl.new("GrugFarResultsHeader", { link = "DiagnosticUnnecessary" })
      ds.hl.new("GrugFarResultsStats", { link = "DiagnosticUnnecessary" })
      ds.hl.new("GrugFarResultsLineColumn", { link = "LineNr" })
      ds.hl.new("GrugFarResultsLineNo", { link = "LineNr" })
      ds.hl.new("GrugFarResultsMatch", { fg = vim.g.ds_colors.bgX, bg = GREEN, bold = true })
      ds.hl.new("GrugFarResultsPath", { fg = vim.g.ds_colors.gray2, italic = true })
      ds.hl.new("GrugFarResultsChangeIndicator", { fg = vim.g.ds_colors.green0 })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    opts = {
      direction = "float",
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.5
        end
      end,
      hide_numbers = true,
      autochdir = true,
      highlights = {
        Normal = { link = "Normal" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
      },
      float_opts = {
        border = "single",
        winblend = 0,
      },
      winbar = {
        enabled = false,
      },
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      close_on_exit = true,
      shell = ds.has "win32" and "pwsh -NoLogo" or vim.o.shell,
    },
    keys = function()
      local terminal = function() return require("toggleterm.terminal").Terminal end
      local float, tab, lazygit
      float = terminal():new {
        direction = "float",
        on_open = function(term)
          vim.wo.sidescrolloff = 0
          vim.keymap.set(
            { "i", "n", "t" },
            "<a-w><a-f>",
            function() float:toggle() end,
            { buffer = term.bufnr, desc = "toggleterm: toggle float" }
          )
        end,
      }
      tab = terminal():new {
        direction = "tab",
        on_open = function(term)
          vim.keymap.set(
            { "i", "n", "t" },
            "<a-w><a-t>",
            function() tab:toggle() end,
            { buffer = term.bufnr, desc = "toggleterm: toggle tab" }
          )
        end,
      }
      lazygit = terminal():new {
        cmd = "lazygit",
        dir = "git_dir",
        hidden = true,
        direction = "tab",
        on_open = function(term)
          vim.wo.sidescrolloff = 0
          vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr })
          vim.keymap.set("t", "<esc><esc>", "<esc>", { buffer = term.bufnr })
          vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = term.bufnr })
          vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = term.bufnr })
          vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = term.bufnr })
          vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = term.bufnr })
          vim.keymap.set(
            { "i", "n", "t" },
            "<a-w><a-g>",
            function() lazygit:toggle() end,
            { buffer = term.bufnr, desc = "toggleterm: toggle lazygit" }
          )
        end,
      }
      local lazygit_with_args = function(git_args)
        terminal()
          :new({
            cmd = git_args and ("lazygit %s"):format(table.concat(git_args, " ")) or "lazygit",
            dir = "git_dir",
            hidden = true,
            direction = "tab",
            on_open = function() vim.wo.sidescrolloff = 0 end,
          })
          :open()
      end
      return {
        { "<a-w><a-f>", function() float:toggle() end, desc = "toggleterm: toggle float" },
        { "<a-w><a-t>", function() tab:toggle() end, desc = "toggleterm: toggle tab" },
        { "<a-w><a-g>", function() lazygit:toggle() end, desc = "toggleterm: toggle lazygit" },
        -- lazygit extras
        {
          "<leader>gl",
          function() lazygit_with_args { "-f", vim.trim(vim.api.nvim_buf_get_name(0)) } end,
          desc = "git: show log for current file",
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    event = "LazyFile",
    cmd = { "Trouble" },
    keys = {
      {
        "gD",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_def", "toggle" } } end,
        desc = "trouble: lsp definitions",
      },
      {
        "gI",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_impl", "toggle" } } end,
        desc = "trouble: lsp implementations",
      },
      {
        "gR",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_ref", "toggle" } } end,
        desc = "trouble: lsp references",
      },
      {
        "gS",
        function() vim.cmd { cmd = "Trouble", args = { "symbols", "toggle" } } end,
        desc = "trouble: lsp document symbols",
      },
      {
        "gT",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_type_def", "toggle" } } end,
        desc = "trouble: lsp type definitions",
      },
      {
        "gW",
        function() vim.cmd { cmd = "Trouble", args = { "lsp_diag", "toggle" } } end,
        desc = "trouble: workspace diagnostics",
      },
      {
        "<localleader>ql",
        function() vim.cmd { cmd = "Trouble", args = { "loclist", "toggle" } } end,
        desc = "trouble: location list",
      },
      {
        "<localleader>qq",
        function() vim.cmd { cmd = "Trouble", args = { "qflist", "toggle" } } end,
        desc = "trouble: quickfix list",
      },
      {
        "<c-up>",
        function()
          if require("trouble").is_open() then
            ---@diagnostic disable-next-line: missing-fields
            require("trouble").prev { skip_groups = true, jump = true }
          else
            pcall(vim.cmd.cprevious)
          end
        end,
        desc = "trouble: previous item",
      },
      {
        "<c-down>",
        function()
          if require("trouble").is_open() then
            ---@diagnostic disable-next-line: missing-fields
            require("trouble").next { skip_groups = true, jump = true }
          else
            pcall(vim.cmd.cnext)
          end
        end,
        desc = "trouble: next item",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        callback = function() vim.cmd "Trouble qflist open" end,
      })
    end,
    opts = function()
      local preview_opts = {
        type = "float",
        relative = "editor",
        border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
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
        },
      }
    end,
  },
}
